---
title: The User Guide of FlashMatrix
keywords: tutorial
last_updated: Nov 3, 2016
tags: [tutorial]
summary: "The User Guide of FlashMatrix"
sidebar: mydoc_sidebar
permalink: FlashMatrix-user-guide.html
folder: mydoc
---

# FlashR programming tutorial
FlashR is an extension of the R programming framework. It executes R code in parallel automatically and stores and accesses arrays in the R code on disks automatically to scale R to large datasets that can't fit in memory. The core of FlashR is a small set of generalized operators to perform computation in an array-oriented fashion. In addition to the generalized operators, FlashR reimplements many commonly used R functions to provide users a familiar R programming environment to reduce the learning curve. FlashR is completely implemented as an R package.

FlashR is designed with goals in four aspects:
* Efficiency: Comparable to optimized C code.
* Scalability: Tera-scale or larger.
* Generality: as many applications as possible in data mining and machine learning and more.
* Productivity: the same productivity as R.

Although FlashR tries to provide a familiar environment for R users, some operations in the traditional R are not supported in FlashR. The biggest difference is that FlashR does not allow users to modify individual elements in a vector or a matrix. FlashR intentionally chooses so for the sake of performance. FlashR stores vectors and matrices on SSDs. Modifying individual elements results in read-modify-write to SSDs, which causes many small random I/O. It causes efficiency issues and these operations are harmful to SSDs. By forbidding modifying individual elements, FlashR advocates array-oriented programming to achieve superior efficiency.

## How to start

Users can follow the [instructions](https://github.com/icoming/FlashX/wiki/FlashX-Quick-Start-Guide) to install FlashR in Ubuntu. To load FlashR to R, run
```
> library(FlashR)
```

## Construct FlashR vectors and matrices

FlashR provides a set of functions to generate FlashR vectors and matrices. These functions have very similar interface as the R counterparts that generate vectors and matrices.
* `fm.rep.int`: Create a vector with replicated elements. e.g., `fm.rep.int(1, 10)` creates a FlashR vector with 10 elements and each element is 1.
* `fm.seq.int`: Create a vector with a sequence of numbers. e.g., `fm.seq.int(1, 10, 1)` creates a FlashR vector with a sequence of numbers between [1:10].
* `fm.runif`: Create a vector with uniformly random numbers. e.g., `fm.runif(10, 0, 1)` creates a FlashR vector with 10 uniformly random values between 0 and 1.
* `fm.matrix`: Create a matrix from a FlashR vector. e.g., `fm.matrix(vec, 10, 2)` creates a 10x2 FlashR matrix from a FlashR vector.

FlashR also provides functions to access vectors and matrices from the filesystem.
* `fm.read.obj`: Read a FlashR object (vector/matrix) from a Linux file.
* `fm.write.obj`: Write a FlashR object (vector/matrix) to a Linux file.

## Interact with native R

FlashR also provides functions to interact with the original R system.
* `fm.as.vector`: convert an R vector to a FlashR vector.
* `fm.as.matrix`: convert an R matrix to a FlashR matrix.
* `as.vector`: convert a FlashR vector to a R vector.
* `as.matrix`: convert a FlashR matrix to a R matrix.

FlashR has the following functions for users to test if an object is a FlashR vector or matrix.
* `fm.is.vector`: test if an object is a FlashR vector.
* `fm.is.matrix`: test if an object is a FlashR matrix.

## Generalized operators

FlashR has two sets of programming API. It provides users a set of generalized operators, with which users can implement varieties of data mining and machine learning algorithms. On top of them, FlashR implements many R functions in the base package with the generalized operators to mimic the original R programming environment.
Generalized operators

Generalized operators (GenOp) are the core of FlashR. There are a very small number of GenOps in FlashR. Each operator accepts a user-defined operator (UDO) or the name of a UDO to perform users' tasks. Currently, there are four GenOps, but some of them have multiple forms. There are many UDOs in FlashR such as addition and subtraction (see `?fm.basic.op` for details). Below lists all GenOps currently supported by FlashR.

**Inner product**: a generalized matrix multiplication. It replaces multiplication and addition in matrix multiplication with two UDOs, respectively. As such, we can define many operations with inner product. For example, we can use inner product to compute various pair-wise distance matrics of data points such as Euclidean distance and Hamming distance.
```
fm.inner.prod(fm, mat, FUN1, FUN2)
```

One example of using `fm.inner.prod` is to compute a pair-wise distance between every data point. `fm.bo.euclidean` and `fm.bo.add` are some UDOs written in C++. `fm.bo.euclidean` computes `(x-y)*(x-y)`. `fm.bo.add` computes `x + y`.
`fm.inner.prod(data, t(data), fm.bo.euclidean, fm.bo.add)`

**Apply**: a generalized form of element-wise operations and has multiple variants.
* `fm.sapply`:  a generalized element-wise unary operation whose UDO takes an element in a vector or a matrix at a time and outputs an element.
* `fm.mapply2`: a generalized element-wise binary operation whose UDO takes an element from each vector or matrix and outputs an element.
* `fm.mapply.row` and `fm.mapply.col` are two variants of `fm.mapply2`. They are similar to `sweep()` in R and the broadcasting mechanism in Numpy. They are equivalent to mapply2 on every row or column of the matrix (in the first argument) with the vector (in the second argument). Currently, `fm.mapply.row` and `fm.mapply.col` only accept the cases that the vector has the same length as a row or a column of the matrix.
```
fm.sapply(o, FUN)
fm.mapply2(o1, o2, FUN)
fm.mapply.row(o1, o2, FUN)
fm.mapply.col(o1, o2, FUN)
```

Many matrix operations in FlashR are implemented with `fm.sapply` and `fm.mapply2`.
Example 1: compute m1 + m2
`fm.mapply2.fm(m1, m2, fm.bo.add)`

Example 2: compute -m1
`fm.sapply(m1, fm.buo.neg)`

These are some examples of using `fm.sapply` and `fm.mapply2`. Both matrix addition and matrix negation have been implemented in FlashR.

Aggregation takes multiple elements and outputs a single element.
* `fm.agg`: aggregates over the entire vector or matrix.
* `fm.agg.mat`: aggregates over each individual row or column of a matrix and outputs a vector.
```
fm.agg(fm, FUN)
fm.agg.mat(fm, margin, FUN)
```

Example 1: compute sum(m)
`fm.agg(x, fm.bo.add)`

Example 2: compute rowSums(m)
`fm.agg.mat(x, 1, fm.bo.add)`

Again, both `sum()` and `rowSums()` have been implemented with aggregation in FlashR.

Groupby is similar to groupby in SQL. It groups multiple elements by their values and perform some computation on the elements. Currently, the function passed to a groupby function has to aggregate values.
`fm.sgroupby`:  groups elements by their values in a vector and invokes UDO on the elements associated with the same value. It outputs a vector.
`fm.groupby`: takes a matrix and a vector of categorical values, groups rows/columns of the matrix based on the corresponding categorical value and runs UDO on the rows/columns with the same categorical value. It outputs a matrix.
```
fm.sgroupby(o, FUN)
fm.groupby(fm, margin, factor, FUN)
```

In practice, groupby requires an aggregation operation over some of the original elements in a group and combine operation over the aggregation results. The reason is that groupby runs in parallel and each time it can only aggregate over some of the elements in a group. Essentially, the combine operation is an aggregation. Usually, it is sufficient to pass a UDO to a groupby function because a UDO can work as both aggregation and combine. In some cases, however, we need these operations to be different. As such, users can pass an aggregation operator to groupby. A user can create an aggregation operator themselves by calling fm.create.agg.op() and specify two UDOs for the aggregation and combine operation.
fm.create.agg.op(agg, combine, name)

## "Base" R functions

FlashR implements many R functions in the base package to mimic the R programming environment. Although we have a goal of having these functions as similar as possible to the original R functions, we do not provide 100% compatibility with the original R version for some functions. Overall, we try to provide similarity under the condition of not sacrificing performance. Below shows a list of R functions in the base package currently supported by FlashR. In the future, more functions will be provided.

The following functions have exactly the same interface as the original R function.
* matrix info: `dim, nrow, ncol, length, typeof`
* change matrix shape: `t`
* element-wise unary: `abs, sqrt, ceiling, floor, round, log, log2, log10, exp, !, -`
* inner product: `%*%, crossprod, tcrossprod`
* aggregation: `sum, min, max, range, all, any, mean, rowSums, colSums, rowMeans, colMeans, sd, cov, cov.wt`

Many binary operations have exactly the same interface as the original R functions. When they are applied to a matrix and a vector, it requires the vector has the same length as the columns in the matrix.
* `+, -, *, /, pmin, pmax, `==, !=, >, >=, <, <=, |, &, sweep`

Some of them have slightly different interface and semantics. These slightly different functions always start with "fm." to indicate that they are actually FlashR functions. In the future, we will provide implementations with exactly the same interface and semantics as the original R functions.
* `fm.table`
* `fm.as.integer, fm.as.numeric`

## Some examples of using FlashR

### PageRank

[PageRank](https://en.wikipedia.org/wiki/PageRank) is the classical algorithm to rank Web pages originally used by Google search engine. PageRank is an iterative algorithm. In each iteration, the PageRank value of a vertex is updated as follow:

![PageRank](https://upload.wikimedia.org/math/8/0/1/80125f33d12ceb608fdb9daec09d9c10.png)

As such, the PageRank algorithm is implemented as follows:

```R
pr1 <- fm.rep.int(1/N, N)
converge <- 0
while (converge < N) {
 pr2 <- (1-d)/N+d*(A %*% (pr1/out.deg))
 diff <- abs(pr1-pr2)
 converge <- sum(diff < epsilon)
 pr1 <- pr2
}
```

### Non-negative Matrix Factorization
[Non-negative Matrix Factorization](https://en.wikipedia.org/wiki/Non-negative_matrix_factorization) (NMF) factorizes a matrix to two non-negative matrices. The following code implements the algorithm described in the Lee's [paper](http://papers.nips.cc/paper/1861-algorithms-for-non-negative-matrix-factorization.pdf).
The update rules described in Lee's paper are implemented as follow
```R
den <- (t(W) %*% W) %*% H
H <- fm.pmax2(H * t(tA %*% W), eps) / (den + eps)
den <- W %*% (H %*% t(H))
W <- fm.pmax2(W * (A %*% t(H)), eps) / (den + eps)
```

One of the convergence condition is ||A - WH||^2. It is computationally expensive to compute the Frobenius norm of (A-WH) directly. Suppose A is a n×m matrix, W is a n×k matrix and H is a k×m matrix. The computation complexity is O(n×k×m). Therefore, instead of computing the Frobenius norm, we compute trace(t(A-WH)(A-WH)) = trace(t(A)A) -2×trace((t(A)W)H)+trace((t(H)(t(W)W))H). We need to order the matrix multiplication in a certain way to reduce computation complexity. The computation complexity of (t(A)W)H is O(l*k), where l is the number of non-zero entries in A. The computation complexity of (t(H)(t(W)W))H is O(k×k×n+k×k×m).
```R
# trace of W %*% H
trace.MM <- function(W, H) {
 X <- W * t(H)
 sum(X)
}

# ||A - W %*% H||^2
Fnorm <- function(A, W, H) {
 sum(A*A) - 2 * trace.MM(t(A) %*% W, H) + trace.MM(t(H) %*% (t(W) %*% W), H)
}
```

### KMeans
KMeans is another iterative algorithm that cluster data pointers. In an iteration, it has three steps and below are the steps and the corresponding FlashR code.
Step 1: calculate distances between all data points to all cluster centers.
```R
m <- fm.inner.prod(data, t(centers), fm.bo.euclidean, fm.bo.add)
```

Step 2: find the closest cluster center for each data point.
```R
parts <- fm.as.integer(fm.agg.mat(m, 1, agg.which.min) - 1)
```

Step 3: update all cluster centers.
```R
centers <- as.matrix(fm.groupby(data, 2, parts, agg.sum))
cnts <- fm.table(parts)
centers <- diag(1/cnts$Freq) %*% centers
```

## Requirements for FlashR users

There are two requirements for FlashR users to get the best performance out of FlashR:
* Array-oriented programming
* Understand space & computation complexity