---
title: "2022-10-23-GAMES104现代游戏引擎-Lecture21-Dynamic Global Illumination and Lumen"
date: 2022-10-23T09:00:00+08:00
markup: pandoc
comments: false
tags: ["现代游戏引擎"]
categories: ["图形"]
series: ["笔记"]
math: true
---



## Lecture21 Dynamic Global Illumination and Lumen

### Part I Dynamic Global Illumination

#### Global Illumination - 略

#### Reflective Shadow Maps, RSM - 略

**低分辨率间接光照加速**：

+ 计算低分辨率间接光照
+ 对全分辨率图像的每个像素
  + 获得周围四个低分辨率采样
  + 通过法线和世界坐标位置判断，采样间差异过大时剔除
  + 双线性插值
+ 以全分辨率重新计算剔除的像素

#### Light Propagation Volumes, LPV - 略

#### Sparse Voxel Octree for Real-time Global Illumination, SVOGI

如何组织voxel的分布？

+ 硬件保守光栅化：对很小的三角形，保证其至少有一个voxel
+ 八叉树存储
+ **Shading with Cone Tracing in Voxel Tree**
  + 着色点根据BRDF发射Diffuse和Specular的Cone
  + 根据Cone尺寸查询树结构获取光照 - 非常适合Hierarchy结构存储的光照数据
+ NVIDIA的工作，GPU表达非常复杂

#### Voxelization Based Global Illumination, VXGI

+ 更关注相机视锥内的区域、更关注近处的区域
+ Clipmap，voxel版的Mipmap
  <img src="/images/games104/L21_Clipmap.jpg" alt="L21_Clipmap" style="zoom: 50%;" />
  利用Clipmaps存储voxel数据
  + 重心区域使用更高分辨率voxel
    <img src="/images/games104/L21_VXGI.jpg" alt="L21_VXGI" style="zoom: 67%;" />
  + 更适合Cone Tracing
+ 建构简单、读取简单、GPU Friendly...
+ **Voxel Update**：空间网格位置固定，只需要更新相机周围的Voxel
+ Voxel具有Opacity（透明度），表征Voxel内有多少Surface可以阻挡光线，需要计算三个方向
+ 对屏幕空间每个像素做Cone Tracing（Diffuse、Rough Specular、Fine Specular）
  <img src="/images/games104/L21_VXGIConeTracing.png" alt="L21_VXGIConeTracing" style="zoom: 25%;" />
+ 问题：
  + 错误的遮挡关系，简单使用Opacity来表示
  + **Light Leaking**：遮挡物薄于Voxel时

#### Screen Space Global Illumination, SSGI

+ Reuse screen space data <- Screen Space Reflection, SSR
+ SSR：单根光线，构建反射 -> 多方向多根光线，构建GI
+ 对Depth Buffer做Raymarching，Hierarchical Tracing 参考SSR笔记
+ Reuse近邻像素
  <img src="/images/games104/L21_SSGIReuseNeighbor.jpg" alt="L21_SSGIReuseNeighbor" style="zoom: 25%;" />
+ 做Cone Tracing，相当于对Tracing到的屏幕范围的像素做一次Filtering
+ 优势：快，质量高，没有遮挡问题
+ 问题：缺少屏外信息，重用近邻像素带来的错误Visibility
+ 独特优势：
  + 易于处理非常近的接近阴影
  + 准确的Hit点计算
  + 对场景复杂度不敏感
  + 可以处理动态物体

### Part II Lumen

Real-time Ray Tracing的问题：

+ 1/2 ray per pixel
+ Sampling

**Idea：低分辨率的屏幕空间的Probe，采样简介光照**

#### Phase 1 : Fast Ray Trace in Any Hardware

##### Signed Distance Function, SDF

+ Per-Mesh SDF 对每个Mesh构建SDF，所有SDF组合成场景
  + 对于薄于SDF分辨率的Mesh，将其加厚
+ Ray Tracing with SDF
  <img src="/images/games104/L21_SDFSphereTracing.jpg" alt="L21_SDFSphereTracing" style="zoom: 50%;" />
+ Cone Tracing with SDF (eg. SDF Soft Shadow)
  <img src="/images/games104/L21_SDFConeTracing1.jpg" alt="L21_SDFConeTracing1" style="zoom: 80%;" /><img src="/images/games104/L21_SDFConeTracing2.png" alt="L21_SDFConeTracing2" style="zoom: 25%;" />
+ 对SDF稀疏化存储，但可能导致Raymarch迭代步长变长
  <img src="/images/games104/L21_SDFSparse.jpg" alt="L21_SDFSparse" style="zoom: 67%;" />
+ 对SDF做LoD
+ SDF可导，导数为法线方向
+ 可以根据相机远近方便地切换SDF分辨率

##### 从Mesh SDF合成低分辨率的场景的Global SDF

+ 场景Tracing非常快
+ 精度相对低
+ 在Lumen中结合对Global SDF的Tracing和对Mesh SDF的Tracing
+ 4 Clipmaps Global SDF, 根据相机距离

#### Phase 2 : Radiance Injection and Caching

##### Mesh Card

+ 为场景中的Mesh“拍快照”，对六个面采样
  <img src="/images/games104/L21_MeshCard.png" alt="L21_MeshCard" style="zoom: 25%;" />
+ 对场景以AABB方式生成
  <img src="/images/games104/L21_MeshCardScene.jpg" alt="L21_MeshCardScene" style="zoom: 67%;" />
+ 对每个Card，存储其六个面的：
  + Albedo
  + Normal
  + Depth
  + Emissive
  + ...
+ 根据物体大小、相机远近，对Card应用不同的分辨率

##### Surface Cache

+ 从Mesh Card生成Surface Cache
  <img src="/images/games104/L21_SurfaceCache.jpg" alt="L21_SurfaceCache" style="zoom: 67%;" />
  + Pass 1 : Card capture
  + Pass 2 : Copy cards to Surface Cache and compress
  
+ "Freeze" lighting on Surface Cache
  + Surface Cache上的像素是否在阴影中？ 如何处理多次Bounce？
  + Lighting Cache Pipeline
    最终生成**Surface Cache Final Lighting**
    <img src="/images/games104/L21_LightingCachePipeline.png" alt="L21_LightingCachePipeline" style="zoom: 25%;" />
    计算当前帧的一次Bounce，利用前一帧的一次Bounce作为次级光源照亮场景，则相当于二次Bounce，依次累计，相当于同一场景下Bounce越积越多（Temporal思路）
  + **1. Direct Lighting**
       <img src="/images/games104/L21_DirectLighting.png" alt="L21_DirectLighting" style="zoom: 25%;" />
       + 直接累加多光源
       + 对近处物体，直接取得精确的Instance，从Surface Cache上计算光照
       + 对远处物体，因为Global SDF无法标记具体Instance，则对全场景光照做Voxelize表达，建构Clipmaps，对每个Voxel存储六个面的光照
  + **2. World Space Voxel Lighting**
       + 由Final Lighting照亮计算得到的Voxel光照存储，用于下一帧的间接光照计算
       + 与后面会提到的Light Probe区分：只存储Voxel六个面的亮度（被照亮的亮度）
  + **3. Surface Cache Indirect Lighting**
       + Light Probe
       + 用SH存储间接光照，方便做插值
  + **Combine Lighting**
       FinalLighting = (DirectLighting + InDirectLighting) * Diffuse_Lambert(Albedo) + Emissive
  + 光照更新策略，保障性能开销稳定
       + 固定的更新预算
       + 桶排序更新优先级

#### Phase 3 : Build a lot of Probes with Different Kinds

##### Screen Space Probe

+ 只在Screen Space分布Probe，每16\*16像素一个
+ Octahedron Mapping，使用8\*8的Texture存储Probe
  <img src="/images/games104/L21_OctahedronMapping.png" alt="L21_OctahedronMapping" style="zoom: 33%;" />
  <img src="/images/games104/L21_OctahedronMappingCode.jpg" alt="L21_OctahedronMappingCode" style="zoom: 33%;" />
+ 对于高频细节部分，进一步细化增加Probe，至8\*8或4\*4每个
  + 判定是否需要增加Probe
    + Probe之间很近、着色点之间实际距离较远时（深度差异过大）
    + 取一些着色点，邻近四个Probe作着色点法平面投影，投影距离的权重超出阈值时，判定为无效采样，增加Probe
  + Screen Probe Atlas
    <img src="/images/games104/L21_ScreenProbeAtlas.png" alt="L21_ScreenProbeAtlas" style="zoom: 25%;" />
    依次往下存储，因此不会造成过多额外开销

##### Importance Sampling
+ 蒙特卡罗采样：
  $$
  \lim_{N\to\infty}\dfrac{1}{N}\sum_{k=1}^{N}\dfrac{L_i(l)f_s(l\to v)\cos(\theta l)}{P_k}
  $$
  重要性采样即取 $P_k$ 使其尽可能符合分子分布

  + 对光源：尽可能符合 $L_i$ 分布
  + 对BRDF：尽可能符合 $f_s$ 分布

+ 对光源做重要性采样，如何估计光源

  + 利用前一帧的光照数据
  + 对前一帧邻近四个Probe的Radiance做插值
  + 若邻近Probe被遮挡则fallback到世界空间Probe
  + 得到插值后8\*8的光照分布，作为Light PDF

+ 对BRDF的法线分布做重要性采样

  + 法线分布不能用高频的着色点Normal指代
  + 在32\*32范围内取64点采样，保证深度权重的情况下，将每个Normal的SH累加得到法线分布，作为BRDF PDF

+ **Structured Importance Sampling**

  + 每个Probe采样64根ray
  + 将BRDF PDF与Lighting PDF卷积，得到重要的采样方向
  + 对重要的方向做Supersampling，对不重要的方向忽略
    <img src="/images/games104/L21_ImportanceSampling.png" alt="L21_ImportanceSampling" style="zoom: 25%;" />

##### Denoising and Spatial Probe Filtering

+ 取Probe周围3\*3，做filtering
+ 但不同Probe的ray方向不同时，差异过大
  -> 判断，若邻近Probe的ray着色点与当前Probe连线，与当前ray角度差大于阈值（10°）时则丢弃不用
  <img src="/images/games104/L21_ProbeFiltering1.png" alt="L21_ProbeFiltering1" style="zoom: 25%;" />
+ 邻近Probe的ray方向接近时，但Hit点差异过大
  -> Clamp ray深度
  <img src="/images/games104/L21_ProbeFiltering2.png" alt="L21_ProbeFiltering2" style="zoom: 25%;" />

##### World Space Radiance Cache

+ Screen Space Probe采样较近的物体
+ World Space预先放置Probe，记录远处光照，Screen Space在采样远处时直接读取World Space Probe
  <img src="/images/games104/L21_WorldSpaceRadianceCache.png" alt="L21_WorldSpaceRadianceCache" style="zoom: 25%;" />
+ Clipmaps存储，分布分辨率48\*48\*48，每个Probe Atlas分辨率32\*32
+ 连接Screen Space Probe和World Space Probe的ray
  + 取Screen Space Probe邻近8个World Space Probe，距离权重插值。
    <img src="/images/games104/L21_ConnectRays.png" alt="L21_ConnectRays" style="zoom: 25%;" />
    （Cube半径两倍范围内已采样，向更远处raycast时可以skip这段距离）
  + 插值后产生与原方向的偏差，跳过遮挡物，产生漏光
    <img src="/images/games104/L21_ConnectRaysLeaking1.png" alt="L21_ConnectRaysLeaking1" style="zoom: 25%;" />
    球面parallax，如图修改光线，导致光线转弯，但Hack可接受
    <img src="/images/games104/L21_ConnectRaysLeaking2.png" alt="L21_ConnectRaysLeaking2" style="zoom: 25%;" />
  + World Space Probe当且仅当有Screen Space Probe有采样需求时，才做Trace并更新光照

#### Phase 4 : Shading Full Pixels with Screen Space Probes

##### 将Probe Radiance转换为三阶SH

+ 相当于对Radiance做低通滤波，效果更柔和
+ SH积分更快速友好，质量也更高
+ 最后利用SH着色

#### Overall, Performance and Result

+ 核心思想：利用对不同数据结构、不同采样对象做Ray Tracing的硬件开销不一样
  <img src="/images/games104/L21_SpeedOfDifferentTracingMethods.jpg" alt="L21_SpeedOfDifferentTracingMethods" style="zoom: 67%;" />
+ 根据具体情况应用不同的方式
  <img src="/images/games104/L21_LumenOverall1.png" alt="L21_LumenOverall1" style="zoom: 25%;" />
+ Fallback过程
  <img src="/images/games104/L21_LumenOverall2.png" alt="L21_LumenOverall2" style="zoom: 50%;" />
