---
title: "2022-05-03-GAMES104现代游戏引擎-Lecture7-Rendering Pipeline, Post-Process and Everything"
date: 2021-05-03T11:00:00+08:00
markup: pandoc
comments: false
tags: ["现代游戏引擎"]
categories: ["图形"]
series: ["笔记"]
math: true
---



### Lecture07 Rendering Pipeline, Post-Process and Everything

#### Ambient Occlusion

接触阴影，满足渲染方程，但在渲染过程中直接渲染很难做到，因为计算尺度小（称为中尺度）。

> AO：单目视觉中形成3D感的重要元素

<img src="/images/games104/L07_AO.png" alt="L07_AO" style="zoom: 33%;" />

不考虑尺度差异，AO和BRDF中的Geometry项（Shadowing-Masking）非常相似。

##### Precomputed AO

使用Ray Tracing预计算成AO贴图。最为传统，但目前在角色等高精度需求中仍应用广泛。

效果好，计算复杂，且无法处理多物体之间的AO。

##### SSAO, Screen Space AO

@GAMES202 SSAO

##### HBAO, Horizon-based Ambient Occlusion

+ 在法线方向半球空间内积分
  $$
  A=1-\dfrac{1}{2\pi}\int_{\theta=-\pi}^\pi\int_{\alpha=t(\theta)}^h(\theta)W(\vec\omega)\cos\alpha\,\mathrm d\alpha\mathrm d\theta
  $$
  <img src="/images/games104/L07_HBAO2.jpg" alt="L07_HBAO2" style="zoom:30%;" /><img src="/images/games104/L07_HBAO1.jpg" alt="L07_HBAO1" style="zoom:23%;" />

+ 利用深度图做Ray Marching
  <img src="/images/games104/L07_HBAO3.png" alt="L07_HBAO3" style="zoom: 50%;" />

##### GTAO, Ground Truth - based AO

SSAO和HBAO假定了各方向射入的光贡献相同，因此物理上错误。(法线方向照射来的光贡献更多。)

+ <img src="/images/games104/L07_GTAO.jpg" alt="L07_GTAO" style="zoom: 50%;" />
  $$
  \hat A(x)=\dfrac{1}{\pi}\int_0^\pi\int_{\theta_1(\phi)}^{\theta_2(\phi)}\cos(\theta-\gamma)^+|\sin(\theta)|\,\mathrm d\theta\mathrm d\phi\\\gamma={\rm angle}(\vec n, \vec v)
  $$
  
+ 根据大量的AO数据，拟合了一个三阶多项式，实现了有颜色的AO

##### Ray-Tracing AO

@GAMES202 RTRT

#### Fog

##### Depth Fog

随着深度透明度下降

+ Linear fog:
  `factor = (end-z) / (end - start)`
+ Exp fog:
  `factor = exp(- density * z)`
+ Exp Squared fog:
  `factor = exp(- (density * z) ^ 2)`

<img src="/images/games104/L07_DepthFog.png" alt="L07_DepthFog" style="zoom: 50%;" />

##### Height Fog

设定某一高度阈值，阈值以下恒定Fog强度，阈值以上指数递减

+ 观察方向的Height Fog积分
  $$
  \begin{array}{c}D(h)=D_\max\cdot e^{-\sigma\cdot\max(h-H_s, 0)}\\
  \begin{aligned}{\rm FogDensityIntegration}=&\ D_\max\cdot d\int_0^1 e^{-\sigma\cdot\max(v_z+t\cdot d_z-H_s, 0)}\,\mathrm dt\\=&\ D_\max\cdot de^{-\sigma\cdot\max(v_z-H_s, 0)}\dfrac{1-e^{-\sigma\cdot d_z}}{\sigma\cdot d_z}
  \end{aligned}\end{array}
  $$
  <img src="/images/games104/L07_HeightFog.png" alt="L07_HeightFog" style="zoom: 33%;" />
  
+ Fog颜色
  $$
  {\rm FogInscatter}=1-\exp^{- \rm FogDensityIntegration}\\
  {\rm FinalColor} = {\rm FogColor}\cdot{\rm FogInscatter}
  $$

##### Voxel-based Volumetric Fog

现代的雾效，可以实现丁达尔效应

+ 对整个相机空间Voxelize，以不同大小的四棱台作Voxel
  <img src="/images/games104/L07_VoxelFog1.jpg" alt="L07_VoxelFog1" style="zoom: 67%;" />
+ 计算方法与Atmosphere计算相似
+ 用一个3D Texture存储，长宽尽量与屏幕成整数倍（eg. 160\*90）

#### Anti-aliasing

@GAMES202 AA

三种走样：Edge Sampling, Texture Sampling（MIPMAP可解决）, Specular Sampling

#### Post-process

##### Bloom 光晕

+ 检测提取高光区域（计算灰度，比较阈值）
+ 对高光区域作Gaussian Blur（横向/纵向各一轮减少计算）
  -> **Pyramid Gaussian Blur**
  <img src="/images/games104/L07_PyramidGuassianBlur.png" alt="L07_PyramidGuassianBlur" style="zoom: 33%;" />
+ 将模糊完的图像叠加到图像上

##### Tone Mapping

HDR to SDR

+ flimic s-curve
  <img src="/images/games104/L07_Filmic.png" alt="L07_Filmic" style="zoom: 33%;" />
+ ACES

##### Color Grading

+ LUT

> Tone Mapping and Color Grading is my area hhhhh (at DFTT of BFA)

#### Rendering Pipeline

##### Forward Rendering

+ Shadow Pass -> Shading -> Post-process
+ 逐物体绘制
+ 透明材质排序，由远及近绘制 -> 各种问题
+ 多光源绘制复杂

##### Deferred Rendering

+ Pass 1
  ```pseudocode
  for each object:
  	write G-Buffer;
  ```

+ Pass 2
  ```pseudocode
  for each pixel:
  	gbuffer = readGBuffer(G-Buffer);
  	for each light:
  		computeShading(gbuffer, light);
  ```

##### Tiled-based Rendering

+ 移动端读写能耗大

+ 切成小块，小块渲染、小块读写

+ 光源也可以被切割成Tile

+ 深度上也可对光源优化

+ ##### Tiled Deferred Rendering

+ ##### Forward+ (Tiled Forward) Rendering

##### Cluster-based Rendering

<img src="/images/games104/L07_ClusterBasedRendering.png" alt="L07_ClusterBasedRendering" style="zoom: 50%;" />

##### Visibility Buffer

+ V-Buffer
  + Depth
  + PrimitiveID
  + Barycentrics
+ <img src="/images/games104/L07_VisibilityBuffer.jpg" alt="L07_VisibilityBuffer" style="zoom: 67%;" />

> **Unreal Engine Rendering Pipeline**
> ![L07_UnrealRenderingPipeline](/images/games104/L07_UnrealRenderingPipeline.png)

##### V-Sync / FreeSync / VRR