---
title: "2021-03-11-数值分析-Day14-RungeKutta方法-线性多步方法"
date: 2021-03-11T17:00:00+08:00
markup: pandoc
comments: false
tags: ["数值分析"]
categories: ["数学"]
series: ["笔记"]
math: true
---



### 7.5 - 7.7 Runge-Kutta方法

#### 单步高阶方法构造思路

设 $y(x)$ 是一阶常微分方程初值问题的精确解，Taylor展开得：
$$
\begin{aligned}
\displaystyle y(x_{n+1})&=y(x_n)+y'(x_n)h+\frac{y''(x_n)}{2!}h^2+\dots+\frac{y^{(p)}(x_n)}{p!}h^p+\frac{y^{({p+1})}(x_n)}{(p+1)!}h^{p+1}\\
&=y(x_n)+hf(x_n,y(x_n))+\frac{h^2}{2!}f^{(1)}(x_n,y(x_n))+\dots+\frac{h^p}{p!}f^{(p-1)}(x_n,y(x_n))+O(h^{p+1})\end{aligned}
$$
因此可建立节点处近似值 $y_n$ 满足的差分公式：
$$
\left\{\begin{array}{l}\displaystyle y_{n+1}=y_n+hf(x_n,y_n)+\frac{h^2}{2!}f^{(1)}(x_n,y_n)+\dots+\frac{h^p}{p!}f^{(p-1)}(x_n,y_n)\\y_0=\alpha,\quad n=0,1,\dots,N-1\end{array}\right.
$$
称之为 $\mathbf p$ **阶Taylor展开方法**。
其中： $\begin{array}{l}\displaystyle f^{(1)}(x,y)=\frac{\partial f(x,y)}{\partial x}+\frac{\partial f(x,y)}{\partial y}f(x,y)\\\displaystyle f^{(2)}(x,y)=\frac{\partial^2f}{\partial x^2}+2\frac{\partial^2f}{\partial x\partial y}f+\frac{\partial^2 f}{\partial y^2}f^2+\frac{\partial f}{\partial x}\frac{\partial f}{\partial y}+\left(\frac{\partial f}{\partial y}\right)^2f\\\dots\end{array}$

> 计算过于复杂，很少直接使用

减少Taylor展开次数得：
$$
y(x_{n+1})=y(x_n)+hy'(\xi)=y(x_n)+hf(\xi,y(\xi)),\quad x_n\le\xi\le x_{n+1}
$$
构造差分方法即利用适当的函数值来近似计算 $f(\xi,y(\xi))$ 。

+ Euler方法用 $K_1$ 作为其近似，其 $y_{n+1}$ 表达式与精确解的Taylor展式前 $2$ 项一致。为 $1$ 阶方法。
+ 改进Euler方法用 $K_1,K_2$ 的线性组合作为其近似，其 $y_{n+1}$ 表达式与精确解的Taylor展式前 $3$ 项一致。为 $2$ 阶方法。
+ 能否增加计算 $f(x,y)$ 的次数来提高方法阶数？

#### Runge-Kutta方法

$$
\left\{\begin{array}{l}
y_{n+1}=y_n+h(\lambda_1K_1+\lambda_2K_2+\dots+\lambda_pK_p)\\
K_1=f(x_n,y_n)\\
K_2=f(x_n+\alpha_2h,y_n+h\beta_{21}K_1)\\
\dots\\
K_p=f(x_n+\alpha_ph,y_n+h\sum\limits_{i=1}^{p-1}\beta_{pi}K_i)
\end{array}\right.
$$
其中 $\{\lambda_i,\alpha_i,\beta_{ij}\}$ 为待定系数，此公式称为 $\mathbf p$ **级Runge-Kutta方法**。
若该公式局部截断误差为 $O(h^{p+1})$ ，则称其为 $\mathbf p$ **阶Runge-Kutta方法**。

+  $\mathbf{p=2}$ 时，二级R-K公式：
  $$
  \left\{\begin{array}{l}
  y_{n+1}=y_n+h(\lambda_1K_1+\lambda_2K_2)\\
  K_1=f(x_n,y_n)\\
  K_2=f(x_n+\alpha h,y_n+h\beta K_1)\\
  \end{array}\right.
  $$
  Taylor展开分析易得，只要令 $\lambda_1+\lambda_2=1,\ \alpha\lambda_2=1/2,\ \beta\lambda_2=1/2$ 即可使局部截断误差达到 $O(h^3)$ ，为二阶R-K公式。该条件有多组解：
  +  $\alpha=1,\ \lambda_1=\lambda_2=1/2,\ \beta=1$ 时即为改进Euler公式。
  +  $\lambda_1=0,\ \lambda_2=1,\ \alpha=\beta=1/2$ 时为**中点公式**。
+  $\mathbf{p=3}$ 时，三阶R-K公式：
  $$
  \left\{\begin{array}{l}
  \displaystyle y_{n+1}=y_n+\frac{h}{6}(K_1+4K_2+K_3)\\
  \displaystyle K_1=f(x_n,y_n)\\
  \displaystyle K_2=f(x_n+\frac{1}{2}h,y_n+\frac{1}{2}hK_1)\\
  \displaystyle K_3=f(x_n+h,y_n-hK_1+2hK_2)
  \end{array}\right.
  $$
+  $\mathbf{p=4}$ 时，四阶R-K公式：
  $$
  \left\{\begin{array}{l}
  \displaystyle y_{n+1}=y_n+\frac{h}{6}(K_1+2K_2+2K_3+K_4)\\
  \displaystyle K_1=f(x_n,y_n)\\
  \displaystyle K_2=f(x_n+\frac{1}{2}h,y_n+\frac{1}{2}hK_1)\\
  \displaystyle K_3=f(x_n+\frac{1}{2}h,y_n+\frac{1}{2}hK_2)\\
  \displaystyle K_4=f(x_n+h,y_n+hK_3)
  \end{array}\right.
  $$

##### 隐式Runge-Kutta方法

一般形式：
$$
\left\{\begin{array}{l}
\displaystyle y_{n+1}=y_n+h\sum_{r=1}^p\lambda_rK_r\\
\displaystyle K_r=f(x_n+\alpha_rh,y_n+h\sum_{i=1}^r\lambda_{ri}K_i),\quad r=1,2,\dots,p
\end{array}\right.
$$
称为 $\mathbf p$ **级隐式Runge-Kutta方法**。（如梯形公式就是二级隐式R-K方法。）

缺点是计算量较大，优点是数值稳定性好。

##### 变步长Runge-Kutta方法

设从 $x_n$ 以步长 $h$ 计算 $y(x_{n+1})$ 的近似值为 $y_{n+1}^{(h)}$ ，设有局部截断误差 $y(x_{n+1})-y_{n+1}^{(h)}=Ch^{p+1}$ 。

设从 $x_n$ 以步长 $\frac{h}{2}$ 计算 $y(x_{n+1})$ 的近似值为 $y_{n+1}^{(\frac{h}{2})}$ ，则有局部截断误差 $\displaystyle y(x_{n+1})-y_{n+1}^{(\frac{h}{2})}\approx \frac{1}{2^p}Ch^{p+1}$ 。

两式相除得 $\displaystyle\frac{y(x_{n+1})-y_{n+1}^{(\frac{h}{2})}}{y(x_{n+1})-y_{n+1}^{(h)}}\approx\frac{1}{2^p}$ ，从而得事后误差估计 $\displaystyle y_{n+1}^{(\frac{h}{2})}-y_{n+1}^{(h)}\approx\frac{1}{2^p-1}(y_{n+1}^{(\frac{h}{2})}-y_{n+1}^{(h)})$ 。

因此当 $\displaystyle\left|y_{n+1}^{(\frac{h}{2})}-y_{n+1}^{(h)}\right|\le\varepsilon$ 时，可取 $\displaystyle y_{n+1}^{(\frac{h}{2})}\approx y_{n+1}^{(h)}$ ，否则将步长减半计算，直至满足精度要求。



### 7.7 - 7.11 单步方法的性质

#### 收敛性

求解初值问题的单步显式方法可统一写为如下形式：
$$
y_{n+1}=y_n+h\Phi(x_n,y_n,h)
$$
其中 $\Phi(x,y,h)$ 称为**增量函数**。不同方法对应着不同的增量函数。

**定义**：设 $y(x)$ 是一阶常微分方程初值问题的精确解， $y_n$ 是某单步方法产生的近似解，如任一固定点 $x_n$ ，均有：
$$
\displaystyle\lim_{h\to0}y_n=y(x_n)
$$
则称此单步方法**收敛**。因为此时 $y(x_n)-y_n$ 不仅与 $y_{n+1}$ 一步计算有关，而与前面的 $n$ 步计算均有关，故称之为**整体截断误差**。（该定义也适用于单步隐式方法和多步方法。）

**定理**：若某单步显式方法满足：
+ 是 $p$ 阶方法，也即局部截断误差为 $O(h^{p+1})$ ；
+ 增量函数 $\Phi(x,y,h)$ 在区域 $\{a\le x\le b,-\infty<y<+\infty,0\le h\le h_0\}$ 上连续，且关于 $y$ 满足Lipschitz条件，即存在常数 $L>0$ 使 $|\Phi(x,y,h)-\Phi(x,\bar{y},h)|\le L|y-\bar{y}|$ ；
+ 初始近似 $y_0=y(\alpha)=\alpha$ 。
则此单步方法收敛，且存在与 $h$ 无关的常数 $C$ ，使得 $|y(x_n)-y_n|\le Ch^p$ 。

易证，Euler方法、改进Euler方法均是收敛的。

（注意，此处差分方法的收敛性与前面构造改进Euler方法时所用到的“校正步骤的收敛性不同。）

#### 稳定性

> 收敛性反映截断误差，稳定性反映舍入误差。

下面用 $y(x_n)$ 表示精确值， $y_n$ 表示理论计算值（只考虑截断误差）， $\bar{y}_n$ 表示实际计算值（还考虑舍入误差）。

讨论数值方法稳定性通常仅限于典型试验方程： $\displaystyle\frac{dy}{dx}=\lambda y$ ，其中 $\lambda$ 为复数且 $Re(\lambda)<0$ 。

**定义1**：对于某给定初值问题（试验方程），假设只在一个节点值 $y_n$ 上产生计算误差 $\delta$ ，若该误差引起之后各节点的计算值变化均不超过 $\delta$ ，则称此差分方法**绝对稳定**。（对一般差分方法。）

**定义2**：将单步方法应用于解试验方程，假设得 $y_{n+1}=E(\lambda h)y_n$ ，若满足条件 $|E(\lambda h)|<1$ ，则称此单步方法**绝对稳定**。在复平面上，变量 $\lambda h$ 满足 $|E(\lambda h)|<1$ 的区域称为该方法的**绝对稳定域**，其与实轴的交集称为**绝对稳定区间**。（ $|E(\lambda h)|=1$ 时也可认为误差没有增长，方法稳定。）（对单步方法。）

+ Euler方法：绝对稳定域 $|1+\lambda h|<1$ ，绝对稳定区间 $(-2,0)$ 。 
+ 梯形公式：绝对稳定域 $Re(\lambda h)<0$ ，绝对稳定区间 $(-\infty,0)$ 。 
+ 改进Euler方法：绝对稳定区间 $(-2,0)$ 。 
+ 二阶R-K方法：绝对稳定区间 $(-2,0)$ 。 
+ 三阶R-K方法：绝对稳定区间 $(-2.51,0)$ 。 
+ 四阶R-K方法：绝对稳定区间 $(-2.78,0)$ 。 

综上，单步显式方法的稳定性与步长密切相关。步长过小时又会导致计算量过大。



### 7.12 - 7.13 线性多步方法

> 单步方法计算简便，但精度较低。精度较高的单步方法（如四阶R-K方法），计算量较大。

#### 待定参数法构造线性多步方法
$$
\displaystyle y_{n+1}=\sum_{i=0}^r\alpha_iy_{n-i}+h\sum_{i=-1}^r\beta_if_{n-1}
$$

若 $\beta_{-1}\neq0$ 公式为隐式，反之为显式。

参数 $\{\alpha_i,\beta_i\}$ 的选择原则是使方法局部截断误差 $y(x_{n+1})-y_{n+1}=O(h^{r+2})$ 。（指在 $y(x_{n-i})=y_{n-i}$ 前提下的截断误差。）

#### 数值积分构造线性多步方法

由
$$
\displaystyle y(x_{n+1})=y(x_n)+\int_{x_n}^{x_{n+1}}f(x,y(x))dx
$$
设 $p_r(x)$ 为函数 $f(x,y(x))$ 的某个 $r$ 次插值多项式，则有
$$
\displaystyle y(x_{n+1})=y(x_n)+\int_{x_n}^{x_{n+1}}p_r(x)dx+R_n
$$
其中 $R_n=\int_{x_n}^{x_{n+1}}(f(x,y(x))-p_r(x))dx$ 。由此可建立差分公式：
$$
\displaystyle y_{n+1}=y_n+\int_{x_n}^{x_{n+1}}p_r(x)dx
$$

##### Adams显式公式
设精确解 $y(x)$ 在步长为 $h$ 的等距节点 $x_{n-r},\dots,x_n$ 上的近似值 $y_{n-r},\dots,y_n$ 。
记 $f_k=f(x_k,y_k)$ ，利用 $r+1$ 个数据 $(x_{n-r},f_{n-r}),\dots,(x_n,f_n)$ 构造 $r$ 次Lagrange插值多项式：
$$
\displaystyle p_r(x)=\sum_{j=0}^rl_{n-j}(x)f_{n-j}
$$
其中:
$$
\displaystyle l_{n-j}(x)=\prod_{k=0,k\neq j}^r\frac{x-x_{n-k}}{x_{n-j}-x_{n-k}},\quad j=0,1,\dots,r
$$
由此建立差分公式：
$$
\displaystyle y_{n+1}=y_n+\sum_{j=0}^r\left(\int_{x_n}^{x_{n+1}}l_{n-j}(x)dx\right)f_{n-j}
$$

由此整理得差分公式的具体形式：
$$
\begin{array}{c}\displaystyle y_{n+1}=y_n+h\sum_{j=0}^r\beta_{rj}f_{n-j}\\
令x=x_n+th,\displaystyle\quad\beta_{rj}=\frac{(-1)^j}{j!(r-j)!}\int_0^1\prod_{k=0,k\neq j}^r(t+k)dt,\quad j=0,1,\dots,r\end{array}
$$
称之为 $\mathbf{r+1}$ **步Adams显式公式**。

+  $r=0,\quad\displaystyle y_{n+1}=y_n+hf_n+\frac{1}{2}h^2y''(x_n)$ 
+  $r=1,\quad\displaystyle y_{n+1}=y_n+\frac{h}{2}(3f_n-f_{n-1})+\frac{5}{12}h^3y'''(x_n)$ 
+  $r=2,\quad\displaystyle y_{n+1}=y_n+\frac{h}{12}(23f_n-16f_{n-1}+5f_{n-2})+\frac{3}{8}h^4y^{(4)}(x_n)$ 
+  $r=3,\quad\displaystyle y_{n+1}=y_n+\frac{h}{24}(55f_n-59f_{n-1}+37f_{n-2}-9f_{n-3})+\frac{251}{720}h^5y^{(5)}(x_n)$ 

##### Adams隐式公式
利用 $r+1$ 个数据 $(x_{n-r+1},f_{n-r+1}),\dots,(x_{n+1},f_{n+1})$ ，则可到处数值稳定性较好的隐式公式，其一般形式为：
$$
\begin{array}{c}\displaystyle y_{n+1}=y_n+h\sum_{j=0}^r\beta_{rj}^*f_{n-j+1}\\
令x=x_n+th,\displaystyle\quad\beta_{rj}^*=\frac{(-1)^j}{j!(r-j)!}\int_{-1}^0\prod_{k=0,k\neq j}^r(t+k)dt,\quad j=0,1,\dots,r\end{array}
$$

+  $r=0,\quad\displaystyle y_{n+1}=y_n+hf_{n+1}+\frac{1}{2}h^2y''(x_n)$ 
+  $r=1,\quad\displaystyle y_{n+1}=y_n+\frac{h}{2}(f_{n+1}+f_n)-\frac{1}{12}h^3y'''(x_n)$ 
+  $r=2,\quad\displaystyle y_{n+1}=y_n+\frac{h}{12}(5f_{n+1}-8f_n-f_{n-1})-\frac{1}{24}h^4y^{(4)}(x_n)$ 
+  $r=3,\quad\displaystyle y_{n+1}=y_n+\frac{h}{24}(9f_{n+1}+19f_n-5f_{n-1}+f_{n-2})-\frac{19}{720}h^5y^{(5)}(x_n)$ 

##### Adams预估-校正公式
由显式公式提供一个预估值，再用隐式公式校正一次得到数值解，称为预估-校正方法。
一般预估公式和校正公式都采用同阶公式（ $r$ 相等）。

如使用四阶Adams显式公式和隐式公式则：
$$
\bar{f}_{n+1}=f(x_{n+1},\bar{y}_{n+1}),\ n=3,4,\dots
$$
称为**四阶Adams预估校正公式**，实际计算中通常用四阶单步方法（如四阶R-K公式）为其提供起始值 $y_1,y_2,y_3$ 。
