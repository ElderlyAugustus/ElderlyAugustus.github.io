---
title: "2022-10-22-GAMES104现代游戏引擎-Lecture16-Gameplay Systems - Basic Artificial Intelligence"
date: 2022-10-22T21:00:00+08:00
markup: pandoc
comments: false
tags: ["现代游戏引擎"]
categories: ["图形"]
series: ["笔记"]
math: true
---



> PS: Lecture17-20主要涉及[机器学习]、[网络架构]、[面向数据编程]，与本人图形方向相离较多，故仅浏览学习，暂无笔记 

### Lecture16 Gameplay Systems - Basic Artificial Intelligence

#### Navigation

三个步骤：
<img src="/images/games104/L16_NavigationSteps.png" alt="L16_NavigationSteps" style="zoom: 25%;" />

##### Map Representation 地图表达

+ Walkable Area

  + 需要考虑：

    + Physical Collision
    + Climbing Slope/Height
    + Jumping Distance
    + ...

    难以完全模拟人的可行路线，需要一定的限制，类似“空气墙”；
    AI Agents和Player的可行区域相同

  + Waypoint Network
  
    + 路网，类似地铁线路图
      <img src="/images/games104/L16_WaypointNetwork.png" alt="L16_WaypointNetwork" style="zoom: 25%;" />
    + 寻找最近的路点
    + 易于实现，快速寻路不够灵活，路网需要手工标注
  
  + Grid
  
    + Square / Triangle / Hexagon 其中Square相对易于存储
    + <img src="/images/games104/L16_GridPathFinding.gif" alt="L16_GridPathFinding" style="zoom: 33%;" />
    + 易于实现、均匀数据结构、动态可更新
    + 精确性依赖分辨率
    + 密集网格降低寻路性能
    + 内存消耗大
    + 难以处理3D地图（桥梁、隧道等）
  
  + Navigation Mesh
  
    + 用简化的凸多边形表示场景
      <img src="/images/games104/L16_NavMesh.jpg" alt="L16_NavMesh" style="zoom:33%;" />
  
      > 若出现凹多边形，寻路时可能跨越凹边出现在Mesh外区域
      > <img src="/images/games104/L16_NavMeshConvex.png" alt="L16_NavMeshConvex" style="zoom:25%;" />
  
    + 优势：
  
      + 支持3D可行区域
      + 精确
      + 快速寻路
      + 灵活选择起始地、目的地
      + 动态
  
    + 缺陷：
  
      + 复杂的生成算法
      + 不支持3D空间，例如空中飞行
  
  + Sparse Voxel Octree
  
    + 空间八叉树
    + 存储量大
    + 寻路复杂

##### Path Finding 寻找路径

+ 所有表达，都可归为图结构

+ 即在图上找到一个路径，尽可能找到最优（短）路径

+ 深度优先搜索 / 广度优先搜索 消耗比较高，广度优先适合找到最短路径

+ Dijkstra Algorithm

  ```pseudocode
  for each vertex v:
  	dist[v] = ∞
  	prev[v] = none
  dist[source] = 0
  set all vertices to unexplored
  while destination not explored:
  	v = least - valued unexplored vertex
  	set v to explored
  	for each edge(v, w):
  		if dist[v] +len(v, w) < dist[w]:
  			dist[w] = dist[v] + len(v, w)
  			prev[w] = v
  ```

+ A Star （A*） 一种启发式算法，不用精确的最短路径

  + 启发函数：预估当前点到终点的距离 $h(n)$
    + 例如：欧拉距离 / 曼哈顿距离
    + $h(n)$ 的精确性影响性能表现
  + 则每一个当前点消耗为 $f(n)= g(n) + h(n)$
  + 优先搜索 $f(n)$ 最小的情况
  + 走到终点就停止，不追求完全最短

##### Path Smoothing 路径平滑

+ Funnel Algorithm
  + “走路时看前面”
  + 当前点和所在三角形两端点组成一个扇形（漏斗，Funnel），下一个目标点是否在扇形中，来决定行走路线
  + 寻找扇形两端点比较复杂

##### NavMesh Generation

+ 先将整个场景体素化
+ Region Segmentation
  + 寻找Edge Voxel，生成Distance Field，找到区块的中心区域（离Edge最远的）
  + ”洪水“算法，类似Voroni算法，找到空间划分
  + 处理Overlap问题
+ 生成分割区域，凸多边形
+ 可以为不同的凸多边形打上不同的标记 Polygon Flag
  + AI寻路逻辑
  + AI移动速度
  + ...

##### Advanced Features

+ 基于Tile的分区域NavMesh，易于更新
+ Off-Mesh Link建立不同Mesh之间的连接，手动，实现攀爬等动作

#### Steering 转向系统

寻路中，车辆无法严格执行路径（受到物理限制），需要转向系统

+ Seek / Flee 追着目标点
  + Pursue 追踪
  + Path Following
  + Wander
  + Flow Field Following 方向场
+ Velocity Match
  + 目标点速度，反向算每步加速度
+ Align 保证朝向一致
  + 目标点角速度，反向算每步角加速度

#### Crowd Simulation 群集模拟

参考《基于物理的动画-粒子系统》

+ “Boids” 
+ 三种力
  + Separation
  + Cohesion
  + Alignment
+ 行人，沿着一定的Line运动
+ 避障、避免碰撞
+ 对每个个体做寻路消耗非常大 —— Distance Field

##### Velocity-based Models

+ 核心想法：个体相遇时，产生速度的障碍，调整速度
+ **Reciprocal Velocity Obstacle**
+ 两个以上个体相遇时产生冲突，如何优化？
  **Optimal Reciprocal Collision Avoidance**
+ 结果最优，但开销大，根据需求自主选择（基于力的方式效果较差但开销小）

#### Sensing or Perception

+ AI所获得的信息
  + 内部：位置、HP、子弹、Buff等
  + 外部：
    + 静态空间信息
      + Navigation Data
      + Tactical Map 战术地图（更具有战术价值的位置）
      + Smart Object eg.可打破的墙等
      + Cover Point 掩体点
      + ...
    + 动态空间信息
      + Influence Map 战场态势感知的热力图，避开危险系数高的区域
      + Navigation Data上更新的标记
      + Sight Area 视野区域
      + ...
    + Game Object
+ Sensing Simulation 模仿人类的感知
  + 考虑开销
  + 共享Influence Map等方式
+ 引擎侧提供充足的接口和自定义性

#### Classic Decision Making Algorithms

+ **Finite State Machine**
+ **Behavior Tree**
+ Hierarchical Tasks Network
+ Goal Oriented Action Planning
+ Monte Carlo Tree Search
+ Deep Learning

##### Finite State Machine

<img src="/images/games104/L16_FiniteStateMachine.png" alt="L16_FiniteStateMachine" style="zoom:20%;" />

+ State
+ Transition
+ Condition
+ 问题：
  + 复杂情形下State过于多，网络过于复杂
  + 解决方法：Hierarchical Finite State Machine
    <img src="/images/games104/L16_HierarchicalFiniteStateMachine.png" alt="L16_HierarchicalFiniteStateMachine" style="zoom:15%;" />
    子状态之间切换变得复杂

##### Behavior Tree

+ 状态机是对AI逻辑的抽象，并不符合人的知觉系统
+ 将AI的行为Pattern从状态机的“飞线”转换为更符合人的**决策树**结构
+ Execution Node 执行节点（叶子节点）：
  + Condition Node 条件节点
  + Action Node 动作节点
    三种状态：
    + Success
    + Failure
    + Running
+ Control Node
  + Sequence 依次执行
  + Selector 按优先级选择执行：A不行执行B，B不行执行C，有一个可执行就继续执行下去
    <img src="/images/games104/L16_BTSelector.png" alt="L16_BTSelector" style="zoom:20%;" />
  + Parallel 并行执行
  + Decorator 修饰器，例如增加延时等
+ 如何Tick行为树？
  + 每一次从根节点开始Tick，防止动作保持在某一叶子节点
  + 行为树同时在Running的节点不一定只有一个
+ Blackboard
  记录环境变量，环境信息，与Gameplay交换信息的介质
+ 缺点：Tick的消耗较大

#### Upcoming: AI Planning and Goals

上述提到的AI方法，均为条件-执行逻辑，AI是没有计划和目的的，期待下一课...
