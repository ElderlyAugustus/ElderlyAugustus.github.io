---
title: "2022-06-18-GAMES104现代游戏引擎-Lecture12-Effects"
date: 2022-06-18T18:00:00+08:00
markup: pandoc
comments: false
tags: ["现代游戏引擎"]
categories: ["图形"]
series: ["笔记"]
math: true
---



### Lecture12 Effects

#### Particle

##### 一个粒子 @PBA

##### 粒子形态

+ Billboard Particle
  永远朝向相机的面片
+ Mesh Particle
  eg. 碎石
+ Ribbon Particle
  光带 eg. 刀的尾迹
  + 样条插值，一般用Catmull

##### 粒子渲染

+ 透明混合顺序
  + 全局排序 精确但开销大
  + 层级结构 系统 -> Emitter -> Within emitter
+ 分辨率，性能开销爆炸
  + Low-Resolution Particles
    低分辨率渲染粒子，再与普通画面混合

##### GPU粒子

+ 定义Particle Pool

+ 管理Dead list和Alive list

+ 在Compute Shader上计算

+ Visualization Culling，管理Alive list

+ Depth Buffer

+ Sorting

  > GPU并行Merge sort
  >
  > + 双指针合并排序，读写会跳来跳去
  > + 优化：单指针遍历待写位置，找该写入的数值写入

+ Depth Buffer Collision
  利用Depth Buffer做碰撞

##### Advanced Particle

+ Animated Particle Mesh
  + 动画可以编码成Texture：Particle Animation Texture
    状态机可以通过切换贴图实现
  + Navigation Texture
    + 从SDF计算Direction Texture（RG通道贴图）
    + 实现群集运动的运动方向
+ eg. Mesh变成粒子再编程Mesh
  + Skeleton mesh emitter
  + Dynamic procedural splines
  + Reactions to other players
  + ...
+ 群集模拟

##### 游戏中的粒子系统工具

+ 早期：设定emitter参数，增加各种效果
+ 现代：节点式，更复杂的处理
+ eg. Niagara

#### Sound System

+ 声音基础知识（略）
+ Panning
+ Attenuation 衰减
  + Attenuation Shape 在区域内不衰减
    + 溪流沿岸 圆柱体
    + 空间内 长方体
    + 喇叭 锥体
  + Obstruction and Occlusion
    + Raycast
+ Reverb 混响
  + 分类
    + Direct (Dry) 干音
    + Early reflection (Echo) 回音
    + Late reverberations (Tail) 尾音
    + 回音 + 尾音 == Wet 湿音
  + Absorption
    + Pre-delay (seconds)
    + HF ratio
    + Dry level
    + Wet level
+ The Dopppler Effect 多普勒效应
+ Spatialization - Soundfield
+ 引擎中间件 eg. Wwise
+ 建模整个声音世界