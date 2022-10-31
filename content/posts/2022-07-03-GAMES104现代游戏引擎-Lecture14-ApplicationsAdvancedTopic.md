---
title: "2022-07-03-GAMES104现代游戏引擎-Lecture14-Tool Chains Applications & Advanced Topic"
date: 2022-07-03T14:00:00+08:00
markup: pandoc
comments: false
tags: ["现代游戏引擎"]
categories: ["图形"]
series: ["笔记"]
math: true
---



### Lecture14 Tool Chains Applications & Advanced Topic

#### Architecture of A World Editor

**A hub for everything to build the world**

+ Editor Viewport
  + 运行一个完整游戏，“Editor Mode”
  + 代码存在Editor Only -> 避免编译到最终游戏中
+ Everything is an Editable Object
  + Objects Views
    + Tree View
    + Layer View
    + Categories and groups

  + 通过Schema系统编辑Object参数，参数编辑面板

+ Content Browser
+ Editing Utilities in World Editor
  + 鼠标选取

    + Ray casting
      + 不需要缓存，支持同时选取多个物体
      + 遍历性能差

    + RTT
      + 在G-Buffer中存储Object ID
      + 根据点击像素直接对应Object ID
      + 其他Trick来选取无Mesh的Object

  + Object Transform Editing
  + Terrain
    + Heightmap
    + Texture
    + 植被、水体等
    + Brush
      + Height Brush 笔刷边缘的过渡、笔刷的可拓展性
      + Instance Brush eg.刷植被

  + Environment
    + Sky
    + Light
    + Roads
    + Rivers
    + ...

  + Rule System in Environment
    + eg. 路上不能有植被
    + 保证局部修改而不是全部重新生成


#### Plugin Architecture

+ 系统和对象的功能“矩阵”
  <img src="/images/games104/L14_MatrixOfSystemsAndObjects.jpg" alt="L14_MatrixOfSystemsAndObjects" style="zoom: 33%;" />
  插件既需要在横向上拓展对象，也需要在纵向上拓展系统
+ 插件的Combination
  + Covered：覆盖原有逻辑 eg.地形编辑系统
    <img src="/images/games104/L14_PluginsCombinationCoverd.jpg" alt="L14_PluginsCombinationCoverd" style="zoom: 67%;" />
  + Distributed：分布式，最终混合输出 eg.大部分编辑系统
    <img src="/images/games104/L14_PluginsCombinationDistributed.jpg" alt="L14_PluginsCombinationDistributed" style="zoom: 67%;" />
  + Pipeline：串联，前者输出作为后者输入 eg.资产预处理、物理几何体
    <img src="/images/games104/L14_PluginsCombinationPipeline.jpg" alt="L14_PluginsCombinationPipeline" style="zoom: 67%;" />
  + Onion rings：洋葱圈，如图 eg.地形插件的道路编辑插件
    <img src="/images/games104/L14_PluginsCombinationOnionRings.jpg" alt="L14_PluginsCombinationOnionRings" style="zoom: 67%;" />
+ 版本控制
  + 理想情况：版本更新 with 插件版本更新
  + 插件使用SDK的方式不确定，保持SDK相同的输入输出并不一定代表稳定迭代更新

#### Design Narrative Tools 设计叙事工具

##### eg. Sequencer in UE

+ Track
+ Property Track
+ Timeline
+ Key Frame
+ Sequence

#### Reflection and Gameplay

##### 反射

+ 反射是Sequencer的基础，修改参数怎样应用到Runtime的对象上。Schema架构，反射系统执行
+ Visual Scripting System eg.UE蓝图 —— 核心解决问题：底层代码的可扩展性
  + eg. 底层增加一个新的Function，表层也需要跟着增加相应的调用，非常麻烦（可以通过继承减少一部分工作）
  + 利用反射解决
+ 反射：构建代码和工具之间的桥梁
  + 使用反射生成代码元数据map，包括class_name、func_name
  + 生成accessor（gettor、setter、invoker、...）

##### C++如何实现反射

+ 生成Schema
  + GPL编译规范
    <img src="/images/games104/L14_GPL.jpg" alt="L14_GPL" style="zoom: 67%;" />
  + 从AST（Abstract Syntax Tree）可以很方便得到类型信息，生成Schema大量开源的编译器可以生成AST eg. gcc clang
  + Piccolo
    + clang生成AST，得到Schema数据结构
    + 利用宏定义精确控制反射范围（不是所有变量、函数都需要被反射）
      + clang可以定义`__attribute__`，控制编译器行为
+ 生成Accessor
  + get / set / invoke
  + 代码渲染
    + 自动化生成代码
    + 节约人力
    + 很难出错
    + 数据和逻辑分离
  + Piccolo
    + 利用Mustache生成代码

#### Collaborative Editing 协同编辑

+ 核心问题：多人协作发生冲突
+ 文件区分方式
  + 分层方
    + 按照资产分成多层，各自编辑单独层，最后Merge
    + 分层难以完全分离，层之间经常存在相互关联

  + 分块
    + 将世界分成多块，各自单独编辑，最后Merge
    + 难以解决块之间的连接
    + 单独有Artist处理边界

  + **OFPA, One File Per Actor** @UE5
    + 每个对象都有独立的文件
    + 很好地解决冲突
    + 但最终文件提交量非常大
    + cooking时打包小文件开销大

+ 基于网络同时编辑，互相可见
  + 问题
    + 需要处理网络架构
    + 操作之间相互同步，要将操作原子化
    + 怎么解决Undo&Redo
  + 方案
    + 使用“锁定”机制固定部分资产不可修改
    + OT, Operation Transform
    + CRDT, Conflict-free Replicated Data Type
  + 现在大部分网络方案：客户端提交，由服务器决策分发
    + Client Crash： Nothing
    + Server Crash： Boom
