---
title: "2022-04-17-GAMES104现代游戏引擎-Lecture5-Lighting, Materials and Shaders"
date: 2021-04-17T12:00:00+08:00
markup: pandoc
comments: false
tags: ["现代游戏引擎"]
categories: ["图形"]
series: ["笔记"]
math: true
---



### Lecture05 Lighting, Materials and Shaders

#### The Rendering Equation

$$
{\displaystyle L_{\text{o}}(\mathbf {x} ,\omega _{\text{o}},\lambda ,t)=L_{\text{e}}(\mathbf {x} ,\omega _{\text{o}},\lambda ,t)\ +\int _{\Omega }f_{\text{r}}(\mathbf {x} ,\omega _{\text{i}},\omega _{\text{o}},\lambda ,t)L_{\text{i}}(\mathbf {x} ,\omega _{\text{i}},\lambda ,t)(\omega _{\text{i}}\cdot \mathbf {n} )\operatorname {d} \omega _{\text{i}}}
$$

<img src="/images/games104/L05_Rendering.jpg" alt="L05_Rendering" style="zoom:50%;" />

多重挑战：

+ 如何得到入射光
  + Visibility to Lights, Shadow
  + Light Source Complexity, 尤其面光源
+ 如何快速地积分
+ 如何计算次级光源，全局光照，无限递归

#### 从简单开始

+ Ambient + Simple Light == Result

+ 环境光贴图反射

+ 相当于Rendering Equation特例化

+ **Blinn-Phong**
  $$
  \begin{aligned}L&=L_{\text{ambient}}+L_{\text{diffuse}}+L_{\text{specular}}\\
  &=k_{\text{ambient}}I_{\text{ambient}}+k_{\text{diffuse}}(I/r^2)\max(0,\mathbf n\cdot\mathbf l)+k_{\text{specular}}(I/r^2)\max(0,\mathbf n\cdot\mathbf l)^p
  \end{aligned}
  $$
  问题：
  + 能量不守恒/保守（离线渲染时能量会超出）
  + 质感太塑料

+ **Shadow Map**
  从灯光位置渲染深度Buffer

  问题：
  + 采样问题 -> 自遮挡
  + 加入阈值 -> 阴影与实体有距离

#### 预计算GI

+ @GAME202 PRT

+ 利用SH，用24bit就可以存储一个点的光场

##### SH Lightmap
+ UV Atlas
  <img src="/images/games104/L05_UVAtlas.jpg" alt="L05_UVAtlas" style="zoom:50%;" />
+ 烘焙光照
+ 优点：高效、细节
  缺点：预计算量大；只能处理静态（动态物体可以有Hack方法，但有问题）；GPU存储量大

##### Light Probe

+ 在空间中撒采样点（Probe）
+ 每个Probe计算其光照
+ 自动均匀撒采样点
+ 反射Probe 一种特殊的Probe
  + 采样精度高
  + 分布密度低
  + 提供非常好的反射效果
+ 优点：高效，静态动态均可用，可以处理diffuse和specular
  缺点：效果没有Lightmap好（采样稀疏）

#### Physical-Based Material

@GAME202 Physically-Based Material

+ Microfacet BRDF

+ Disney Principled BRDF

+ 主流应用：Specular Glossiness模型

  + Diffuse - RGB - sRGB
  + Specular - RGB - sRGB
  + Glossiness - Grayscale - Linear
  + 问题：过于灵活，Specular项易导致Fresnel项错乱

  <img src="/images/games104/L05_SG.png" alt="L05_SG" style="zoom: 33%;" />

+ 主流应用：Metallic Roughness模型

  + Base Color - RGB - sRGB
  + Roughness - Grayscale - Linear
  + Metallic - Grayscale - Linear
  + 在SG基础上封装，Metallic限制Specular的应用
  + 非金属和金属过渡时可能有白边

  <img src="/images/games104/L05_MR.png" alt="L05_MR" style="zoom: 33%;" />

#### Image-Based Lighting

@GAMES202 Environment Lighting

+ Diffuse Irradiance Map
+ Specular : Split Sum

#### Classic Shadow Solution

##### Cascaded Shadow Map

<img src="/images/games104/L05_CSM.png" alt="L05_CSM" style="zoom: 25%;" />

挑战：不同层级之间的Blend

缺点：计算开销大（4ms）

##### 软阴影

@GAMES202 Soft Shadow

+ PCF -> PCSS
+ Variance Soft Shadow Map

#### 上一世代的3A游戏渲染

+ Lightmap + Lightprobe
+ PBR + IBL
+ CSM + VSSM

#### 现代3A游戏渲染

@GAMES202 GI & RTRT

+ RTRT
+ Real-Time GI
  + SSGI
  + SDF GI
  + VXGI
  + RSM
  + RTXGI
  + ...
+ 更复杂的材质模型
  + BSDF 头发
  + BSSRDF
+ Virtual Shadow Maps
  把Shadow Maps放到一个巨大的Shadow Map上（类似Virtual Texture）

#### Shader管理

+ Uber Shader
  宏定义做分支，GPU不适合分支，再将Uber Shader编译成大量Shader。需要修改时，只需要修改Uber Shader，一次编译所有结果。
+ 跨平台的Shader编译
  + SPIR-V