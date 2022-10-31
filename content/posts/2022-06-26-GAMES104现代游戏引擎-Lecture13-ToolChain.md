---
title: "2022-06-26-GAMES104现代游戏引擎-Lecture13-Tool Chains"
date: 2022-06-26T14:00:00+08:00
markup: pandoc
comments: false
tags: ["现代游戏引擎"]
categories: ["图形"]
series: ["笔记"]
math: true
---



### Lecture13 Tool Chains

**游戏引擎工具链的地位**：

+ 用户和引擎Runtime层的桥梁
+ 引擎和DCC软件的桥梁：Asset Conditioning Pipeline
+ 调和不同思维方式的平台：策划 / 美术 / 程序

#### GUI

##### Immediate Mode

+ 逐帧直接绘制，由引擎逻辑绘制，简单轻量直接
+ 扩展性有限，性能有限，将业务压力交给了引擎逻辑
+ eg. Unity UGUI / Omniverse GUI / Piccolo GUI

##### Retained Mode

+ 将需要绘制的图形内容存储成Buffer，再交由GUI绘制
+ 将引擎逻辑和GUI工具隔离，扩展性强，性能表现好
+ 对开发者来说相对复杂
+ eg. Unreal UMG / WPF GUI / QT GUI
+ **Design Pattern**
  + MVC
    <img src="/images/games104/L13_MVC.png" alt="L13_MVC" style="zoom: 25%;" />
  + MVP：在MVC基础上的变化，View进一步与Model分离
    <img src="/images/games104/L13_MVP.jpg" alt="L13_MVP" style="zoom: 50%;" />
  + MVVM：把Presenter换成ViewModel——用Binding将ViewModel和View绑定，用HTML/XAML等简单逻辑表示View
    <img src="/images/games104/L13_MVVM1.jpg" alt="L13_MVVM1" style="zoom: 67%;" />
    <img src="/images/games104/L13_MVVM2.png" alt="L13_MVVM2" style="zoom: 33%;" />
    + 平台兼容性问题，eg. 在Windows下WPF表现较好

#### 数据处理

##### Serialization and Deserialization

序列化与反序列化：文件、数据库、内存、网络之间的数据转换

##### 存储数据 - Serialization

+ **文件格式**
  + 最简单的数据格式：文本文件
    + 易读易处理，但缺乏安全性
    + 纯文本信息 eg. txt/obj/... -> 结构化 eg. XML/... -> 更简单的结构 eg. json/...
    + eg. Unity YAML / Piccolo json / Cryengine XML json
  + 二进制文件
    + 体积小，读取时无需语义处理，加载速度快
+ **Asset Reference**
  + 大量重用的资产 -> 多个Instance引用同一个Asset
  + Object Instance Variance：为Asset提供各种可变性，例如更换贴图
    + 低效方法：copy一份直接修改
    + Data Inheritance，数据继承，override修改部分

##### 加载数据 - Deserialization

+ Parse Asset File
  <img src="/images/games104/L13_ParseAssetFile.png" alt="L13_ParseAssetFile" style="zoom: 20%;" />
  + 语义解析，生成 \<field-value\> tree
    + 文本格式需要较为复杂的parse得到树
    + 二进制文件则一般直接按树的顺序，field name + field data 存成表格
    + 二进制文件需要考虑 Endianness，大端小端序
      + 引擎本身保持同一字节序
      + 根据不同平台判断提前处理
+ Asset Version Compatibility
  + eg. 增删field
    + 强制判断version number，将缺失field设为默认值
    + Protocol buffer：要求在增删field时标记UID，UID按新增顺序增加

#### 如何增强工具链鲁棒性

+ Undo & Redo
  + Command Pattern
    + 原子化操作，存储用户command，Undo/Redo时重新加载command
    + Command类设计
      + UID（及get/set）
      + Data（及get/set）
      + Invoke()
      + Revoke()
      + Serialize()
      + Deserialize()
    + 三类Command
      + 增加对象
        + 数据：通常使用runtime instance的拷贝
        + Invoke：根据数据创建runtime instance
        + Revoke：删除runtime instance
      + 删除对象
        + 数据：通常使用runtime instance的拷贝
        + Invoke：删除runtime instance
        + Revoke：根据数据创建runtime instance
      + 更新对象
        + 数据：通常使用对runtime instance的修改属性的属性名和新值旧值
        + Invoke：设置runtime instance的属性为新值
        + Revoke：设置runtime instance的属性为旧值

#### 如何形成工具链

+ Building Blocks —— 从不同数据中找出共性，原子化
+ Schema —— 一种描述结构，描述Building Blocks的组合
  + 用Schema构建各种高级数据
  + Schema需要支持继承
    <img src="/images/games104/L13_SchemaInheritance.jpg" alt="L13_SchemaInheritance" style="zoom: 50%;" />
  + 两种Schema的定义方式
    + 用独立的Schema定义文件
      + 解耦性好，易于理解
      + 需要用parser创建代码，难以debug
    + 在代码中直接定义
+ 引擎数据的三种视角
  + Runtime内存：强调性能
  + 硬盘：强调节约空间
  + 用户视角/工具视角：强调易于理解

#### What you sees is what you get “所见即所得”

+ 创作视图和运行时一致
+ Stand-alone Tools 工具层和runtime层分开，难以实现所见即所得
+ In Game Tools 工具层直接架在runtime层之上，直接使用runtime层运行创作窗口
+ Play in Editor, PIE
  + 直接在Editor World内运行
    + 简单
    + 会污染runtime层模式
    + 编译成游戏Release版本时可能会出bug
  + 拷贝所有数据运行单独的PIE World
    + 复杂度高，内存开销大
    + 可以较好地保证编译结果一致
    + eg. Unreal Engine

#### Plugin

+ 提供大量的API
+ 尽可能把各种功能API化，自己实现引擎工具链时也使用API实现
