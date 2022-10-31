---
title: "2021-03-01-数值分析-Day04-Jacobi-GaussSeidel"
date: 2021-03-01T20:00:00+08:00
markup: pandoc
comments: false
tags: ["数值分析"]
categories: ["数学"]
series: ["笔记"]
math: true
---



### 3.1 - 6 迭代法

#### 基本思想
对线性方程组 $Ax=b$ ，当 $A$ 为低阶稠密矩阵时，选主元Gauss消去/Doolittle分解均为有效方法。  
工程应用中 $A$ 常为高阶稀疏矩阵，适用迭代法求解：利好计算机存储与性能。

**通法**：  

+ 将 $Ax=b$ 改写为 $x=B_0x+f$ 
+ 任取初始值，如 $x^{(0)}=(0,0,0)^T$ ，将其带入得到方程组解 $x^{(1)}=B_0x^{(0)}+f$ 
+ 依次得： $x^{(2)}=B_0x^{(1)}+f,\ x^{(2)}=B_0x^{(1)}+f,\ \dots,\ x^{(k)}=B_0x^{(k-1)}+f,\ \dots$ 
+ 即得向量序列 $x^{(0)},x^{(1)},\dots,x^{(k)}$ ，迭代公式 $x^{(k)}=B_0x^{(k-1)}+f$ 
+ 迭代次数较高时，向量序列 $x^{(k)}$ **有可能**收敛至逼近精确解的值（不一定）。

根据 $x=Bx+f$ 变形方式的不同，存在多种迭代算法。

**定义1**：  
对于给定方程组 $x=Bx+f$ ，用公式 $x^{k+1}=Bx^{(k)}+f,\ (k=0,1,2,3,\dots)$ 逐步代入求近似解的方法称为迭代法（或称为一阶定常迭代法，这里 $B$ 与 $k$ 无关）。  
如果 $\lim\limits_{k\to\infty}x^{(k)}=x^*$ ，即向量序列**收敛**至精确解序列，则称此迭代法**收敛**，否则称**发散**。  
由于需要研究 $\{x^{(k)}\}$ 的收敛性，引进误差向量 $\varepsilon^{(k+1)}=x^{(k+1)}-x^*$ 。易得到： $\varepsilon^{(k+1)}=B\varepsilon^{(k)}$  ，递推得： $\varepsilon^{(k)}=B\varepsilon^{(k-1)}=\dots=B^k\varepsilon^{(0)}$  。



#### Jacobi迭代

**通法细节**：  
将 $A$ 分裂成 $A=M-N$ ，其中 $M$ 为可选择的非奇异矩阵，使 $Mx=d$ 易解，一般选择为 $A$ 的某种近似，称 $M$ 为**分裂矩阵**。  
则原方程 $Ax=b$ 转化为 $Mx=Nx+b$ ，即求解： $x=M^{-1}Nx+M^{-1}b$ 。  
可构造一阶定常迭代法：
$$
\left\{\begin{array}{l}x^{(0)}\\x^{(k+1)}=Bx^{(k)}+f\ (k=0,1,\dots)\end{array}\right.\\
B=M^{-1}N=M^{-1}(M-A)=I-M^{-1}A,\quad f=M^{-1}b
$$
称 $B=I-M^{-1}A$ 为迭代法的迭代矩阵，选取 $M$ 阵就得到 $Ax=b$ 的各种迭代法。

**Jacobbi迭代**：  
设 $a_{ii}\neq0(i=1,2,\dots,n)$ ，并将 $A$ 写成三部分：
$$
\begin{aligned}A&=\begin{pmatrix}
a_{11}\\
&a_{22}\\
&&\ddots\\
&&&a_{nn}
\end{pmatrix}\\
&-\begin{pmatrix}
0\\
-a_{21}&0\\
\vdots&\vdots&\ddots\\
-a_{n-1,1}&-a_{n-1,2}&\cdots&0\\
-a_{n,1}&-a_{n,2}&\cdots&-a_{n,n-1}&0
\end{pmatrix}\\
&-\begin{pmatrix}
0&-a_{12}&\cdots&-a_{1,n-1}&-a_{1,n}\\
&0&\cdots&-a_{2,n-1}&-a_{2,n}\\
&&\ddots&\vdots&\vdots\\
&&&0&-a_{n-1,n}\\
&&&&0
\end{pmatrix}\\
&\equiv D-L-U
\end{aligned}
$$
由此，当 $a_{ii}\neq0(i=1,2,\dots,n)$ 时，选取 $M$ 为 $A$ 的对角元素部分，即选取 $M=D$ ，$A=D-N$ ，即得到 $Ax=b$ 的**Jacobi迭代法**。
$$
\begin{aligned}&\left\{\begin{array}{l}x^{(0)}\\x^{(k+1)}=Bx^{(k)}+f\ (k=0,1,\dots)\end{array}\right.\\
&其中\ \begin{aligned}&B=D^{-1}(L+U)\equiv J\\
&f=D^{-1}b\end{aligned}\end{aligned}
$$
称 $J$ 为Jacobi迭代法的**迭代矩阵**。

**Jacobi迭代法的分量计算公式**：
记 $x^{(k)}=(x_1^{(k)},x_2^{(k)},\dots,x_n^{(k)})$ ，则有：
$$
\begin{array}{l}
\begin{aligned}Dx^{k+1}&=(L+U)x^{(k)}+b
a_{ii}x_i^{k+1}\\&=-\sum\limits_{j=1}^{i-1}a_{ij}x_j^{(k)}-\sum\limits_{j=i+1}^{n}a_{ij}x_j^{(k)}+b_i\quad(i=1,2,\dots,n)\end{aligned}\\
B=I-M^{-1}A,\ f=M^{-1}b
\end{array}
$$
因此，解 $Ax=b$ 的Jacobi迭代法的计算公式为：
$$
\left\{\begin{array}{l}
x^{(0)}=(x_1^{(0)},\dots,x_i^{(0)},\dots,x_n^{(0)})^T\\
x_i^{(k+1)}=(b_i-\sum\limits_{j=1,j\neq i}^na_{ij}x_j^{(k)})/a_{ii}\\
i=1,2,\dots,n\\
k=0,1,\dots\ 表示迭代次数
\end{array}\right.
$$
矩阵表示为：
$$
\begin{array}{l}
Ax=b\Leftrightarrow(D-L-U)x=b\Leftrightarrow Dx=(L+U)x+b\\
\begin{aligned}Dx&=\begin{pmatrix}
a_{11}\\
&a_{22}\\
&&\ddots\\
&&&a_{nn}
\end{pmatrix}
\begin{pmatrix}x_1\\x_2\\\vdots\\x_n\end{pmatrix}\\
&=\begin{pmatrix}
0&-a_{12}&\cdots&-a_{1,n-1}&-a_{1,n}\\
-a_{21}&0&\cdots&-a_{2,n-1}&-a_{2,n}\\
\vdots&\vdots&\ddots&\vdots&\vdots\\
-a_{n-1,1}&-a_{n-1,2}&\cdots&0&-a_{n-1,n}\\
-a_{n,1}&-a_{n,2}&\cdots&-a_{n,n-1}&0
\end{pmatrix}
\begin{pmatrix}x_1\\x_2\\\vdots\\x_n\end{pmatrix}+b\\
&=(L+U)x+b
\end{aligned}\end{array}
$$


#### Gauss-Seidel迭代法

**改进Jacobi迭代法**：选取分裂矩阵 $M$ 为 $A$ 的下三角部分，即 $M=D-L$ ， $A=M-U$ ，得到：
$$
\begin{array}{l}\left\{\begin{array}{l}x^{(0)}\quad初始向量\\x^{(k+1)}=Bx^{(k)}+f\quad (k=0,1,\dots)\end{array}\right.\\
B=I-(D-L^{-1})A=(D-L)^{-1}U\equiv G,\quad f=(D-L)^{-1}b\end{array}
$$
称 $G$ 为Gauss-Seidel迭代法的迭代矩阵。

**分量计算公式**：
$$
\begin{array}{l}Dx^{(k+1)}=Dx^{(k)}-(Lx^{(k+1)}+Ux^{k}-Dx^{(k)}+b)\\\\
\left\{\begin{array}{l}
x_1^{(k+1)}=\displaystyle-\frac{a_{12}}{a_{11}}x_2^{(k)}-\frac{a_{13}}{a_{11}}x_3^{(k)}-\dots-\frac{a_{1n}}{a_{11}}x_n^{(k)}+\frac{b_2}{a_{22}}\\
x_2^{(k+1)}=\displaystyle-\frac{a_{21}}{a_{22}}x_2^{(k+1)}-\frac{a_{23}}{a_{22}}x_3^{(k)}-\dots-\frac{a_{2n}}{a_{22}}x_n^{(k)}+\frac{b_2}{a_{22}}\\
x_3^{(k+1)}=\displaystyle-\frac{a_{31}}{a_{33}}x_2^{(k+1)}-\frac{a_{32}}{a_{33}}x_3^{(k+1)}-\dots-\frac{a_{3n}}{a_{33}}x_n^{(k)}+\frac{b_3}{a_{33}}\\
\dots\\
x_n^{(k+1)}=\displaystyle-\frac{a_{n1}}{a_{nn}}x_2^{(k+1)}-\frac{a_{n2}}{a_{nn}}x_3^{(k+1)}-\dots-\frac{a_{n,n-1}}{a_{nn}}x_n^{(k+1)}+\frac{b_n}{a_{nn}}\\
\end{array}\right.\\
即\ \displaystyle{x_i^{k+1}=\frac{b_n-\sum\limits_{j=1}^{i-1}a_{ij}x_j^{(k+1)}-\sum\limits_{j=i+1}^{n}a_{ij}x_j^{(k)}}{a_{ii}}}\end{array}
$$





### 代码：Jacobi迭代
```c++
//
// Created by xa on 2021-03-01.
//
#include <iostream>
#include <vector>

using std::vector;

vector<vector<double>> A;
vector<double> b;
vector<double> x;
vector<double> next_x;

int size = 0;

void iterate(vector<vector<double>> A_, vector<double> b_);

int main(){
    vector<vector<double>> A_{{10, 3, 1}, {2, -10, 3}, {1, 3, 10}};
    vector<double> b_{14, -5, 14};
    iterate(A_, b_);
}

void iterate(vector<vector<double>> A_, vector<double> b_) {
    A.assign(A_.begin(), A_.end());
    b.assign(b_.begin(), b_.end());
    size = A.size();

    vector<double> x(size);
    vector<double> next_x(size);

    int k = 0;
    while (true) {
        for (int i = 0; i < size; ++i) {
            double tmp = b[i];
            for (int j = 0; j < size; ++j)
                if (j != i) tmp -= A[i][j] * x[j];
            next_x[i] = tmp / A[i][i];
        }
        for (int i = 0; i < size; ++i) {
            x[i] = next_x[i];
            std::cout << x[i] << ' ';
        }
        std::cout << " 第"<< k << "次" << std::endl;
        if (k > 100) break;
        ++k;
    }
}
```

### 代码：Gauss-Seidel迭代
```c++
/***区别***/
//Jacobi
for (int j = 0; j < size; ++j)
    if (j != i) tmp -= A[i][j] * x[j];
//Gauss-Seidel
for (int j = 0; j < size; ++j) {
    if (j < i) tmp -= A[i][j] * next_x[j];
    if (j > i) tmp -= A[i][j] * x[j];
}
```
```c++
//
// Created by xa on 2021-03-01.
//
#include <iostream>
#include <vector>

using std::vector;

vector<vector<double>> A;
vector<double> b;
vector<double> x;
vector<double> next_x;

int size = 0;

void iterate(vector<vector<double>> A_, vector<double> b_);

int main(){
    vector<vector<double>> A_{{10, 3, 1}, {2, -10, 3}, {1, 3, 10}};
    vector<double> b_{14, -5, 14};
    iterate(A_, b_);
}

void iterate(vector<vector<double>> A_, vector<double> b_) {
    A.assign(A_.begin(), A_.end());
    b.assign(b_.begin(), b_.end());
    size = A.size();

    vector<double> x(size);
    vector<double> next_x(size);

    int k = 0;
    while (true) {
        for (int i = 0; i < size; ++i) {
            double tmp = b[i];
            for (int j = 0; j < size; ++j) {
                if (j < i) tmp -= A[i][j] * next_x[j];
                if (j > i) tmp -= A[i][j] * x[j];
            }

            next_x[i] = tmp / A[i][i];
        }
        for (int i = 0; i < size; ++i) {
            x[i] = next_x[i];
            std::cout << x[i] << ' ';
        }
        std::cout << " 第"<< k << "次" << std::endl;
        if (k > 100) break;
        ++k;
    }
}
```