---
title: "2022-05-19-GAMES104现代游戏引擎-Lecture9-Animation System - Advanced"
date: 2022-05-19T17:00:00+08:00
markup: pandoc
comments: false
tags: ["现代游戏引擎"]
categories: ["图形"]
series: ["笔记"]
math: true
---



### Lecture09 Animation System - Advanced

#### Animation Blending

##### LERP

+ LERP / NLERP / SLERP
+ 两个动画clip之间的LERP

##### 权重

eg. 走路与跑步动画，依据运动速度切换
$$
{\rm weight_1=\dfrac{speed_{current}-speed_2}{speed_1-speed_2}}\\
{\rm weight_2=\dfrac{speed_{current}-speed_1}{speed_2-speed_1}}\\
$$

##### 对齐时间线

+ eg.走路和跑步的步频不同，怎样对齐混合的帧
+ 每一段动画为一步，对每一段动画时间线做归一化

##### Blend Space

eg. 左右前后走/跑

+ 1D Blend Space：
  eg. 左走、正走、右走三个动画，根据左右方向的速度插值（可以有分布不均匀的多个动画）

+ 2D Blend Space：
  eg. 左右前后全部加入2D空间，由动画师指定动画位置
  <img src="/images/games104/L09_2DBlendSpace.jpg" alt="L09_2DBlendSpace" style="zoom:33%;" />
  + 双线性插值
    <img src="/images/games104/L09_Bilinear.jpg" alt="L09_Bilinear" style="zoom:33%;" />
  
  + Delaunay Triangulation 常用
    <img src="/images/games104/L09_DelaunayTriangulation.jpg" alt="L09_DelaunayTriangulation" style="zoom:33%;" />
    + 根据设置的动画点，生成三角形划分
    + 在空间内一点，由周围三角形插值
    + 插值利用重心坐标

##### Skeleton Masked Blending

针对只应用于半身或身体局部的动画，实现多种动画的混合 eg.各种姿态下的鼓掌

+ 绘制一个Mask，只应用于部分Joints

##### Additive Blending

eg. 向着摄影机点头

+ 存储动画的变化量，在基础动画上叠加一层动画
+ 需要非常谨慎，易出现两个动画叠加后产生不自然的运动结果

##### Animation State Machine 状态机

<img src="/images/games104/L09_ASM1.jpg" alt="L09_ASM1" style="zoom: 67%;" /><img src="/images/games104/L09_ASM2.jpg" alt="L09_ASM2" style="zoom: 40%;" />

+ 两种核心元素
  + Node
    + Clip
    + Blend Space
    + 脚本串接的单套动画系统
  + Translation
    + 激活条件
    + Cross Fade
      + Smooth transition 慢慢过渡，插值（各种插值曲线）
      + Frozen transition 先停住动画A，再播放动画B
+ 多层状态机
  <img src="/images/games104/L09_LayeredASM.jpg" alt="L09_LayeredASM" style="zoom: 50%;" />

##### Animation Blend Tree

+ 多层状态机在复杂动画中非常复杂
+ 用树结构表示动画之间的Blend方式（LERP/Additive），类似表达式树
  <img src="/images/games104/L09_ExpressionTree.png" alt="L09_ExpressionTree" style="zoom: 25%;" />
+ 两种节点
  + Terminal Node 执行节点 (叶节点)
    + Clip
    + Blend Space
    + ASM
  + Non-terminal Node （非叶节点）
    + LERP Blend Node
      <img src="/images/games104/L09_ABTLERP.png" alt="L09_ABTLERP" style="zoom: 25%;" />
    + Additive Blend Node
      <img src="/images/games104/L09_ABTAdditive.png" alt="L09_ABTAdditive" style="zoom: 25%;" />
+ Layered ASM to Blend Tree
  <img src="/images/games104/L09_LayeredASM2ABT.png" alt="L09_LayeredASM2ABT" style="zoom: 25%;" />
+ Blend Tree Control Parameters
  + Variable
    + 暴露变量，根据变量切换运动状态
    + eg. 速度、HP
  + Event
    + 外部传入激活状态的指令
    + eg. 持枪、开枪

#### Inverse Kinematics

+ Forward Kinematics 前向传递动画
+ Inverse Kinematics 对末端Joint Key动画
  eg. 崎岖地面走路，脚步顶点反向传递

##### Two Bones IK

+ 2根Bone组成三角形的两边
  <img src="/images/games104/L09_2BonesIK1.jpg" alt="L09_2BonesIK1" style="zoom:25%;" />
+ 大腿根部的Joint到地面接触点距离为第三边
+ 即可得到两根Bone的夹角 $\cos\theta=\dfrac{a^2+c^2-b^2}{2ac}$
  <img src="/images/games104/L09_2BonesIK2.jpg" alt="L09_2BonesIK2" style="zoom: 25%;" />

+ 问题：在3D空间，解有无数个，构成一个圆
  <img src="/images/games104/L09_2BonesIK3.jpg" alt="L09_2BonesIK3" style="zoom:33%;" />
  + 设定Reference Vector
  + 朝着Reference Vector方向取解
    <img src="/images/games104/L09_2BonesIK4.jpg" alt="L09_2BonesIK4" style="zoom:20%;" />

+ 更多复杂的IK
  + Look At
  + Hand
  + Foot
  + Full Body

##### Multi-Joint IK Solving

+ 更多种可能性
  <img src="/images/games104/L09_MultiJointIK1.jpg" alt="L09_MultiJointIK1" style="zoom:33%;" />
+ 首先检查是否能到达目标（最长、最短的触及范围）
  + 最长（拉直）
    <img src="/images/games104/L09_MultiJointIK2.jpg" alt="L09_MultiJointIK2" style="zoom: 25%;" />
  + 最短（最长的单根Bone减去其他Bone）
    <img src="/images/games104/L09_MultiJointIK3.jpg" alt="L09_MultiJointIK3" style="zoom:20%;" /><img src="/images/games104/L09_MultiJointIK4.jpg" alt="L09_MultiJointIK4" style="zoom:20%;" />
+ 约束 Constraints
  关节有运动的约束，不能超出约束范围（比如依据人体的骨骼结构）
+ 解法
  + **CCD, Cyclic Coordinate Decent**
    <img src="/images/games104/L09_CCD.gif" alt="L09_CCD" style="zoom: 25%;" />
    + 逐个Joint遍历，每个Joint朝下一个Joint与目标点连线方向旋转
    + 上述过程反复迭代，不断接近结果
    + 优化：
      + 每次旋转时，使用Tolerance region进行缩小或限制
        <img src="/images/games104/L09_OptimizedCCD1.png" alt="L09_OptimizedCCD1" style="zoom: 20%;" />
      + 越靠近根节点的限制越大，运动幅度越小（处理约束同理）
        <img src="/images/games104/L09_OptimizedCCD2.png" alt="L09_OptimizedCCD2" style="zoom:20%;" />
  + **FABRIK, Forward And Backward Reaching Inverse Kinematics**
    <img src="/images/games104/L09_FABRIK.gif" alt="L09_FABRIK" style="zoom:25%;" />
    + 逐个Joint遍历，每个Joint朝目标点或上一个Joint位移，再将Bone还原设定下一个Joint
    + 从末端Joint出发、从Root出发反复迭代
    + 同样需要Tolerance优化
    + 处理约束：将约束区域投影到Target所在平面，取可运动到的点
      <img src="/images/games104/L09_FABRIKConstraint.gif" alt="L09_FABRIKConstraint" style="zoom:25%;" />

##### IK with Multiple End-Effects

eg. 爬墙、攀岩灯多个目标点的IK
<img src="/images/games104/L09_IKwithMultipleEnd-Effectors.png" alt="L09_IKwithMultipleEnd-Effectors" style="zoom:20%;" />

+ 利用Jacobi矩阵求解：

  <img src="/images/games104/L09_Jacobi1.png" alt="L09_Jacobi1" style="zoom:20%;" />

  <img src="/images/games104/L09_Jacobi2.png" alt="L09_Jacobi2" style="zoom:15%;" />

+ 其他解法

  + 基于物理的解法
  + PBD, Position Based Dynamics
  + Fullbody IK in UE5 (XPBD, Extended PBD)

##### IK的挑战

+ 蒙皮后的自我穿插、交叠
+ 对环境的感知
+ 更自然的人类行为，例如平衡
  + 基于数据的、AI的方法

#### Animation Pipeline with Blending and IK

<img src="/images/games104/L09_AnimationPipelineWithBlendingAndIK.png" alt="L09_AnimationPipelineWithBlendingAndIK" style="zoom: 25%;" />

#### Facial Animation

##### Facial Action Coding System

+ 把表情分成46种，并进行编码
+ 多种表情可以进行组合
+ Apple归纳了28个核心的表情，其中有23个是有对称性的，可以压缩
+ 混合时如果线性叠加：合到一起后效果折半
  -> 存储表情相对于“Neutral Face”的Offset，实现Additive Blending
  即**Morph Target Animation**

##### Morph Target Animation

##### Facial Skeleton

骨骼非常复杂
<img src="/images/games104/L09_FacialSkeleton.png" alt="L09_FacialSkeleton" style="zoom: 15%;" />

##### UV Texture Facial Animation

简单用贴图实现

##### Muscle Model Animation

前沿研究，如果运动脸部肌肉（影视行业开始使用）
<img src="/images/games104/L09_MuscleModelAnimation.jpg" alt="L09_MuscleModelAnimation" style="zoom: 50%;" />

#### Animation Retargeting

##### Skeleton Retargeting

+ 把同一个骨骼动画应用到不同角色
+ Source Character + Target Character
  Source Animation + Target Animation
+ 两幅骨骼比例、位置不同 -> 一一对应
+ 保持Binding Pose的旋转，Retarget相对运动，而不是绝对运动
+ Translation和Scale动画：考虑Bone的长度之比，进行动画的放缩
+ 问题：腿部不同长度时出现浮空
  + 以Pelvis到地面的距离之比为放缩比例，对动画、移动速度做放缩
  + Foot IK
+ 离线方法完成
+ 对不同骨骼结构的Retargeting
  + 以骨骼名字做对应
  + 把有对应骨骼之间的部分做归一化
    <img src="/images/games104/L09_DifferentSkeletonRetargeting.gif" alt="L09_DifferentSkeletonRetargeting" style="zoom: 33%;" />
+ 问题：
  + 角色的自穿插
  + 有语义动作偏移带来语义偏移，例如鼓掌动画，Retargeting后掌合不起来

##### Morph Animation Retargeting

eg. 表情动画
+ 直接存储的是相对于Neutral Face的相对位移，直接Apply到Target上
+ 有语义动作 eg. 闭眼，眼睛大小不同时，直接Apply可能无法闭上
  + 增加约束条件 eg. 闭眼动画限制眼睛必须闭上
  + 手动调整，利用拉普拉斯算子计算，拉眼睑使相近脸部一起运动