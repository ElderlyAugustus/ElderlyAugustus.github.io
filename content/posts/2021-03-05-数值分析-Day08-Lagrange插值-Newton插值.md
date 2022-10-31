---
title: "2021-03-05-数值分析-Day08-Lagrange插值-Newton插值"
date: 2021-03-05T18:00:00+08:00
markup: pandoc
comments: false
tags: ["数值分析"]
categories: ["数学"]
series: ["笔记"]
math: true
---



### 5.1 - 5.3 插值的引入与Lagrange插值

#### 插值的定义

设函数 $y=f(x)$ 在区间 $[a,b]$ 上连续，给定 $n+1$ 个点： $a\le x_0<x_1<\dots<x_n\le b$ 。  
已知 $f(x_k)=y_k(k=0,1,\dots,n)$ ，在函数类 $P$ 中寻找一函数 $\varphi(x)$ 作为 $f(x)$ 的近似表达式，使满足：  
$\varphi(x_k)=f(x_k)=y_k,\ k=0,1,2,\dots,n $ 。则称 $y=f(x)$ 为**被插值函数**，称 $\varphi(x)$ 为**插值函数**。称 $x_0,x_1,\dots,x_n$ 为**插值节点**； $\varphi(x_k)=f(x_k)=y_k,\ k=0,1,2,\dots,n$ 为**插值条件**，寻求插值函数的方法称为**插值方法**。

在构造插值函数时，函数类 $P$ 的不同选取，对应不同的插值方法，这里主要讨论函数类为代数多项式的插值方法，即**多项式插值**。若用 $P_n$ 表示所有次数不超过 $n$ 的多项式函数类，则若 $p_n(x)\in P_n$ ，则 有$p_n(x)=a_0+a_1x+\dots+a_nx^n$ ，由 $n+1$ 个系数唯一确定。若 $p_n(x)$ 满足插值条件，即 $\left\{\begin{array}{l}a_0+a_1x_1+\dots+a_nx_1^n\\a_0+a_1x_2+\dots+a_nx_2^n\\\dots\\a_0+a_1x_n+\dots+a_nx_n^n\end{array}\right.$ 。令 $\{a_0,a_1,\dots,a_n\}$ 为元，则该方程系数行列式为 $\begin{vmatrix}1&x_0&\cdots&x_0^n\\1&x_1&\cdots&x_1^n\\\vdots&\vdots&\ddots&\vdots\\1&x_n&\cdots&x_n^n\end{vmatrix}$ ，由范德蒙行列式得: $\begin{vmatrix}1&x_0&\cdots&x_0^n\\1&x_1&\cdots&x_1^n\\\vdots&\vdots&\ddots&\vdots\\1&x_n&\cdots&x_n^n\end{vmatrix}=\begin{vmatrix}1&1&\cdots&1\\x_0&x_1&\cdots&x_n\\\vdots&\vdots&\ddots&\vdots\\x_0^n&x_2^n&\cdots&x_n^n\end{vmatrix}=\prod\limits_{0\le<j\le n}(x_j-x_i)\neq0$ ，因此该方程有解。  
由此得定理：满足上述条件的插值问题， $p_n(x)$ 存在且唯一。

#### Lagrange插值

##### 线性插值

最简单的插值问题：已知两点 $(x_0,y_0)\ (x_1,y_1)$ 。通过此两点的插值多项式是一条直线，即两点式： $\displaystyle L_1(x)=\frac{x-x_1}{x_0-x_1}y_0+\frac{x-x_0}{x_1-x_0}y_1$ 。称 $L_1(x)$ 为**线性插值函数**。  
令 $\left\{\begin{array}{l}\displaystyle l_0(x)=\frac{x-x_1}{x_0-x_1}\\\displaystyle l_1(x)=\frac{x-x_0}{x_1-x_0}\end{array}\right.$ ，则有 $\left\{\begin{array}{l}L_1(x)=y_0l_0(x)+y_1l_1(x)\\l_0(x_0)=1\quad l_0(x_1)=0\\l_1(x_0)=0\quad l_1(x_1)=1\end{array}\right.$ ，称 $l_0(x),\ l_1(x)$ 为关于 $x_0,\ x_1$ 的**线性插值基函数**。

##### 抛物插值

已知三点 $(x_0,y_0)\ (x_1,y_1)\ (x_2,y_2)$ 。构造插值函数 $L_2(x)$ 。称 $L_2(x)$ 为**抛物插值函数**。  
设 $L_2(x)=y_0l_0(x)+y_1l_1(x)+y_2l_2(x)$ ，则由插值条件可知 $\left\{\begin{array}{l}l_0(x_0)=1\quad l_0(x_1)=0\quad l_2(x_2)=0\\l_0(x_0)=0\quad l_0(x_1)=1\quad l_2(x_2)=0\\l_0(x_0)=0\quad l_0(x_1)=0\quad l_2(x_2)=1\end{array}\right.$ ，可解得 $\left\{\begin{array}{l}\displaystyle l_0(x)=\frac{(x-x_1)(x-x_2)}{(x_0-x_1)(x_0-x_2)}\\\displaystyle l_1(x)=\frac{(x-x_0)(x-x_2)}{(x_1-x_0)(x_1-x_2)}\\\displaystyle l_2(x)=\frac{(x-x_0)(x-x_1)}{(x_2-x_0)(x_2-x_1)}\end{array}\right.$ ，称为**二次插值基函数**。  
得到 $\displaystyle L_2(x)=y_0\frac{(x-x_1)(x-x_2)}{(x_0-x_1)(x_0-x_2)}+y_1\frac{(x-x_0)(x-x_2)}{(x_1-x_0)(x_1-x_2)}+y_2\frac{(x-x_0)(x-x_1)}{(x_2-x_0)(x_2-x_1)}$ 。

##### $\mathbf n$ 次插值

推广到一般形式：考虑已知 $n+1$ 个点 $(x_i,y_i)(i=0,1,2,\dots,n)$ ，构造插值多项式 $L_n(x)$ 。  
设 $\displaystyle L_n(x)=\sum_{i=0}^{n}y_il_i(x)$ ，则 $l_i(x_j)=\left\{\begin{array}{l}1,\ j=i\\0,\ j\neq i\end{array}\right.\ i,j=0,1,\dots,n$ ，解得 $\displaystyle l_i(x)=\prod_{j=0,j\neq i}^{n}\frac{x-x_j}{x_i-x_j}$ 。
> 引入记号： $\displaystyle \omega_{n+1}(x)=\prod_{i=0}^{n}(x-x_i)$
则有：
$$
\begin{aligned}L_n&=\displaystyle\sum_{i=0}^n\left(\prod_{j=0,j\neq i}^n\frac{x-x_j}{x_i-x_j}\right)y_i\\
&=\displaystyle\sum_{i=0}^n\frac{\omega_{n+1}(x)}{(x-x_i)\omega_{n+1}'(x_i)}y_i\end{aligned}
$$
称这两式为 $\mathbf n$ **次插值多项式**，也称为**Lagrange插值多项式**。

##### Lagrange插值余项

若在 $[a,b]$ 上用 $L_n(x)$ 近似 $f(x)$ ，则其**截断误差**为 $R_n(x)=f(x)-L_n(x)$ ，也称其为插值多项式的**余项**。

设 $f^{(n)}(x)$ 在 $[a,b]$ 上连续， $f^{(n+1)}(x)$ 在 $(a,b)$ 内存在，节点 $a\le x_0<x_1<\dots<x_n\le b$ ， $L_n(x)$ 是插值多项式，则 $\forall x\in [a,b],\ R_n=\displaystyle\frac{f^{(n+1)}(\xi)}{(n+1)!}\omega_{n+1}(x)$ ，其中 $a<\xi<b$ 且依赖于 $x$ 。

插值多项式 $L_n(x)$ 逼近 $f(x)$ 的截断误差限为 $\left|R_n(x)\right|\le\displaystyle\frac{\max_{a<x<b}\left|f^{(n+1)}(x)\right|}{(n+1)!\left|\omega_{n+1}(x)\right|}$ 。

当被插值函数未知时，无法用上述插值余项估计误差。

##### 事后误差估计

求 $L_n(x)$ 为 $f(x)$ 以 $x_0,x_1,\dots,x_n$ 为节点的 $n$ 次插值多项式；  
求 $L_n^{(1)}(x)$ 为 $f(x)$ 以 $x_1,x_2,\dots,x_n,x_{n+1}$ 为节点的 $n$ 次插值多项式；  
认为两者较 $f(x)$ 误差相近，则有：
$$
\begin{array}{c}
\displaystyle\frac{f(x)-L_n(x)}{f(x)-L_n^{(1)}}\approx\frac{x-x_0}{x-x_{n+1}}\\
\displaystyle f(x)\approx\frac{x-x_{n+1}}{x_0-x_{n+1}}L_n(x)+\frac{x-x_0}{x_{n+1}-x_0}L_n^{(1)}(x)\\
\displaystyle f(x)-L_n(x)\approx\frac{x-x_0}{x_0-x_{n+1}}(L_n(x)-L_n^{(1)}(x))
\end{array}
$$

则第三式可用于事后误差估计，第二式可用于较精确的插值多项式。

### 5.4 - 5.5 差商与Newton插值

> #### 差商（或称均差）
>
> **定义**：
> 
> + 称 $f[x_0,x_k]=\displaystyle\frac{f(x_k)-f(x_0)}{x_k-x_0}$ 为函数 $f(x)$ 关于点 $x_0,\ x_k$ 的一阶差商；
> + 称 $f[x_0,x_1,x_k]=\displaystyle\frac{f[x_1,x_k]-f[x_0,x_1]}{x_k-x_0}$ 为函数 $f(x)$ 关于点 $x_0,\ x_k$ 的二阶差商；
> + 称 $f[x_0,x_1,\dots,x_k]=\displaystyle\frac{f[x_1,\dots,x_{k-1},x_{k}]-f[x_0,x_1,\dots,x_{k-1}]}{x_k-x_0}$ 为函数 $f(x)$ 关于点 $x_0,\ x_k$ 的 $k$ 阶差商。
>
> **性质**：
> 
> +  $\displaystyle f[x_0,\dots,x_k]=\sum_{j=0}^k\frac{f(x_j)}{(x_j-x_0)\cdots(x_j-x_{j-1})(x_j-x_{j+1})\cdots(x_j-x_k)}=\sum_{j=0}^k\frac{f(x_j)}{\omega_{k+1}(x_j)}$ 
> + 差商与节点的排列次序无关；
> + 若 $f(x)$ 在 $[a,b]$ 上存在 $n$ 阶导数，且差商节点位于区间内，则：  
>    $f[x_0,\dots,x_n]=\displaystyle\frac{f^{(n)}(\xi)}{n!},\quad\xi\in[a,b]$ 。

#### Newton插值

+ 由直线方程点斜式得到线性插值函数：
  $$
  L_1(x)=y_0+a_1(x-x_0),\quad a_1=\frac{y_1-y_0}{x_1-x_0}
  $$

+ 推广至三点情况得到二次插值函数：
  $$
  \begin{array}{c}
  L_2(x)=a_0+a_1(x-x_0)+a_2(x-x_0)(x-x_1)\\
  \left\{\begin{array}{l}
  a_0=y_0\\
  a_1=\displaystyle\frac{y_1-y_0}{x_1-x_0}\\
  a_2=\displaystyle\frac{\displaystyle\frac{y_2-y_0}{x_2-x_0}-\frac{y_1-y_0}{x_1-x_0}}{x_2-x_1}
  \end{array}\right.
  \end{array}
  $$

+ 推广至 $n+1$ 点情况得到 $n+1$ 次插值函数：
  $$
  \begin{aligned}
  L_n(x)&=a_0+a_1(x-x_0)+a_2(x-x_0)(x-x_1)+\dots+a_n(x-x_0)\dots(x-x_{n-1})\\
  &=\displaystyle\sum_{i=0}^{n}\left[a_i\left(\prod_{j=0}^{i-1}(x-x_j)\right)\right]\end{aligned}
  $$
  由前面的推导和差商的定义可知 $a_i=f[x_0,x_1,\dots,x_i]$ ；或进行如下推导：
  $$
  \begin{aligned}
  &\quad\left\{\begin{array}{l}
  f(x)=f(x_0)+f[x,x_0](x-x_0)\\
  f[x,x_0]=f[x_0,x_1]+f[x,x_0,x_1])(x-x_1)\\
  f[x,x_0,\dots,x_{n-1}]=f[x_0,x_1,\dots,x_n]+f[x,x_0,\dots,x_n]\end{array}\right.\\
  &\begin{aligned}\Rightarrow\ 
  f(x)&=f(x_0)+f[x_0,x_1](x-x_0)+f[x_0,x_1,x_2](x-x_0)(x-x_1)\\
  &+\dots+f[x_0,x_1,\dots,x_n](x-x_0)\cdots(x-x_{n-1})+f[x,x_0,\dots,x_n]\omega_{n+1}(x)\\
  &\equiv N_n(x) + R_n(x)\\\end{aligned}\\
  &\begin{aligned}
  N_n(x)&=f(x_0)+f[x_0,x_1](x-x_0)+f[x_0,x_1,x_2](x-x_0)(x-x_1)\\
  &+\dots+f[x_0,x_1,\dots,x_n](x-x_0)\cdots(x-x_{n-1})\\
  R_n(x)&=f[x,x_0,\dots,x_n]\omega_{n+1}(x)
  \end{aligned}\end{aligned}
  $$
  其中 $N_n(x)$ 就称作**Newton插值多项式**，其与Lagrange插值多项式是等价的。 $R_n(x)$ 为Newton插值多项式的余项，它比Lagrange插值多项式的余项更具有一般性，对于离散函数 $f$ 或 $f$ 导数不存在时均适用。
  
  > Lagrange插值多项式的缺陷：当节点发生改变时，所有计算需要重新计算。





### 代码：Lagrange插值
```c++
//
// Created by xa on 2021-03-05.
//

#include <iostream>
#include <vector>

using std::vector;

double L(vector<vector<double>> xy_array, double x);

int main() {
    vector<vector<double>> sqrt_xy {{100, 10}, {121, 11}, {144, 12}};
    std::cout << L(sqrt_xy, 120) << std::endl;
}

double L(vector<vector<double>> xy_array, double x) {
    double sum = 0;
    for (int i = 0; i < xy_array.size(); ++i) {
        double prod = 1;
        for (int j = 0; j < xy_array.size(); ++j)
            if (j != i) prod *= (x-xy_array[j][0]) / (xy_array[i][0]-xy_array[j][0]);
        sum += prod  * xy_array[i][1];
    }
    return sum;
}
```


### 代码：Newton插值（含生成差商表）
```c++
//
// Created by xa on 2021-03-05.
//

#include <iostream>
#include <vector>

using std::vector;

vector<vector<double>> xy_array;
vector<vector<double>> DD;

void refreshDD();
void printDD();
double N(vector<vector<double>> xy_array, double x);

int main() {
    vector<vector<double>> sqrt_xy {{-2, 5}, {-1, 3}, {1, 17}, {2, 21}};
    std::cout << N(sqrt_xy, 0);
}

//获取Divided Difference 差商表
void refreshDD() {
    vector<double> tmp;
    if (DD.size() < 1 && xy_array.size() >= 2) {
        for (int i = 0; i < xy_array.size()-1; ++i) {
            for (int j = 0; j <= DD.size(); ++j) {
                if (j < 1) tmp.push_back((xy_array[i][1]-xy_array[i+1][1])/(xy_array[i][0]-xy_array[i+1][0]));
                else tmp.push_back((DD[i-1][j-1]-tmp[j-1])/(xy_array[i-j][0]-xy_array[i+1][0]));
            }
            DD.push_back(tmp);
            tmp.clear();
        }
    } else if (DD.size() >= 1 && xy_array.size() >= 2 && xy_array.size() > DD.size()+1) {
        int i = xy_array.size() - 2;
        for (int j = 0; j < xy_array.size()-1; ++j) {
            if (j < 1) tmp.push_back((xy_array[i][1]-xy_array[i+1][1])/(xy_array[i][0]-xy_array[i+1][0]));
            else {
                tmp.push_back((DD[i-1][j-1]-tmp[j-1])/(xy_array[i-j][0]-xy_array[i+1][0]));
            }
        }
        DD.push_back(tmp);
        tmp.clear();
    }
    printDD();
}

void printDD() {
    std::cout << "(" << DD.size() << ", " << DD.back().size() << ")" << std::endl;
    for (int i = 0; i < DD.size(); ++i) {
        for (int j = 0; j < DD[i].size(); ++j)
            std::cout << DD[i][j] << " ";
        std::cout << std::endl;
    }
}

double N(vector<vector<double>> xy_array_, double x) {
    xy_array.assign(xy_array_.begin(), xy_array_.end());
    refreshDD();
    double sum = xy_array[0][1]; double prod = 1;
    for (int i = 1; i < xy_array.size(); ++i) {
        for (int j = 0; j < i; ++j) prod *= x - xy_array[j][0];
        sum += DD[i-1].back() * prod;
        prod = 1;
    }
    return sum;
}
```