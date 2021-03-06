---
title: The User Guide of FlashR
keywords: tutorial
last_updated: Nov 3, 2016
tags: [tutorial]
summary: "The User Guide of FlashR"
sidebar: mydoc_sidebar
permalink: FlashR-user-guide.html
folder: mydoc
---

FlashR extends the R programming framework for large-scale data analysis, by utilizing the powerful matrix computation in FlashMatrix. It executes R code in parallel automatically and utilizes one or many SSDs (solid-state drives), a type of fast disk that commonly exists in laptops and in the cloud, to scale R to large datasets. 

FlashR mimics the programming interface of the R framework. It reimplements many commonly used R functions in the [base](https://stat.ethz.ch/R-manual/R-devel/library/base/html/00Index.html) and [stats](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/00Index.html) packages to provide users a familiar R programming environment to reduce the learning curve. In addition, FlashR provides a set of generalized matrix operations that extend the R framework to implement more computations efficiently. FlashR is currently implemented as an R package. [This web page](https://flashxio.github.io/FlashX-doc/FlashR-API.html) lists all of the functions in FlashR: 

## How to start

Users can follow these [instructions](https://flashxio.github.io/FlashX-doc/FlashX-Quick-Start-Guide.html) to install FlashR in Ubuntu. To load the FlashR package, run

```R
> library(FlashR)
```

## FlashR arrays

FlashR currently supports vectors and matrices of three types: logical, integer and floating-point. FlashR chooses to co-exist with R matrices. Instead of overiding the existing matrix construction functions in R, FlashR provides a set of functions to create FlashR vectors and matrices explicitly. These functions have interfaces similar to their R counterparts. FlashR provides a set of functions to interact with R. As such, users can utilize the R functions for small matrix computation.

### Functions for creating FlashR vectors:

* [`fm.rep.int`](FlashR-API/fm.rep.int.Rd.html): create a vector with replicated elements. e.g., `fm.rep.int(1, 10)` creates a FlashR vector with 10 elements and each element is 1.
* [`fm.seq.int`](FlashR-API/fm.seq.Rd.html): create a vector with a sequence of numbers. e.g., `fm.seq.int(1, 10, 1)` creates a FlashR vector with a sequence of numbers between [1:10].
* [`fm.runif`](FlashR-API/fm.runif.Rd.html): create a vector with random numbers under uniform distribution. e.g., `fm.runif(10, 0, 1, in.mem=TRUE)` creates a FlashR vector with 10 random values uniformly between 0 and 1, stored in memory. `in.mem` instructs FlashR to store data in memory or on SSDs.
* [`fm.rnorm`](FlashR-API/fm.rnorm.Rd.html): create a vector with random numbers under normal distribution. e.g., `fm.rnorm(10, 0, 1, in.mem=TRUE)` creates a FlashR vector with 10 random values following normal distribution with mean 0 and standard deviation 1 and stores data in memory. Like the one in `fm.runif`, `in.mem` instructs FlashR to store data in memory or on SSDs.

### Functions for creating FlashR matrices:

* [`fm.matrix`](FlashR-API/matrix.Rd.html): create a matrix filled with repeated values from an R object or numeric. e.g., `fm.matrix(0, 10, 2)` creates a 10x2 FlashR matrix with all entries set to 0.
* [`fm.seq.matrix`](FlashR-API/fm.seq.Rd.html): create a matrix filled with sequence numbers. e.g., `fm.seq.matrix(1, 20, 10, 2)` creates a 10x2 FlashR matrix with columns filled with 1:20.
* [`fm.runif.matrix`](FlashR-API/fm.runif.Rd.html): create a matrix filled with random numbers under uniform distribution. e.g., `fm.runif.matrix(10, 2, 0, 1, in.mem=TRUE)` creates a 10x2 FlashR matrix with 20 random values uniformly between 0 and 1, stored in memory.
* [`fm.rnorm.matrix`](FlashR-API/fm.rnorm.Rd.html): create a matrix filled with random numbers under normal distribution. e.g., `fm.rnorm.matrix(10, 2, 0, 1, in.mem=TRUE)` creates a 10x2 FlashR matrix with 20 random values following normal distribution with mean 0 and standard deviation 1, and stores data in memory.

### Functions for loading data from other data sources:

* [`fm.load.dense.matrix`](FlashR-API/fm.get.matrix.Rd.html): load a dense matrix from a text file. Each line in the text file stores a row of the dense matrix. Users may choose to specify a delimiter as the function assumes `","` by default. Users can also specify the element type; by default the function assumes floating-point. The available element types are `"D"` for floating-point values, `"I"` for integers, `"L"` for logical values. Users can also specify the number of columns in the dense matrix. If not, the function will try to determine the number of columns itself. e.g., `fm.load.dense.matrix("matrix.csv", in.mem=TRUE, ele.type="I", delim=",", ncol=10)` loads a dense matrix of integers with 10 columns from a CSV file.
* [`fm.load.dense.matrix.bin`](FlashR-API/fm.get.matrix.Rd.html): load a dense matrix from a binary file that stores data in row-major or column-major order. In this function, users have to specify all information of the dense matrix, such as the number of rows, the number of columns, the element type and the data layout (row-major or column-major). e.g., `fm.load.dense.matrix.bin("matrix.bin", in.mem=TRUE, nrow=1000, ncol=10, byrow=FALSE, ele.type="I")` loads a dense matrix of integers with 1000 rows and 10 columns, stored in column-major order.
* [`fm.load.sparse.matrix`](FlashR-API/fm.get.matrix.Rd.html): load a sparse matrix in the [FlashMatrix format](https://scholar.google.ca/citations?view_op=view_citation&hl=en&user=b1PYJN0AAAAJ&citation_for_view=b1PYJN0AAAAJ:Wp0gIr-vW9MC) from the **Linux filesystem**. The sparse matrix has to be formatted in advance. For a symmetric matrix, users only need to specify the sparse matrix file and the index file of the sparse matrix. For an asymmetric matrix, users need to specify four files: the sparse matrix file, the index file of the sparse matrix, the transpose of the sparse matrix, the index file for the transpose of the sparse matrix.

Some of the functions (`fm.load.dense.matrix`, `fm.load.dense.matrix.bin`, `fm.runif`, `fm.rnorm`, `fm.runif.matrix` and `fm.rnorm.matrix`) have the argument `name`. If a user creates a vector/matrix stored on SSDs with a user-specified name, the vector/matrix will be persistent on SSDs. That is, even if the user exits from the R framework, the vector/matrix is still on SSDs and the user can load the vector/matrix to FlashR with the same name for further computation. To load a dense vector/matrix, a user can use `fm.get.dense.matrix`.

### Interact with native R

FlashR currently provides a limited number of linear algebra routines. As such, users still need to rely on the ones in R, such as linear solver and Choleski factorization, for many machine learning algorithms. FlashR provides functions for users to interact with the original R system.

* [`fm.as.vector`](FlashR-API/vector.Rd.html): convert an R vector/matrix or a FlashR matrix to a FlashR vector. The current implementation only supports converting from a one-column FlashR matrix to a FlashR vector.
* [`fm.as.matrix`](FlashR-API/matrix.Rd.html): convert an R vector/matrix or a FlashR vector to a FlashR matrix. A vector is converted into a one-column matrix.
* [`fm.as.factor`](FlashR-API/fm.as.factor.Rd.html): convert a FlashR vector to a factor vector. The current implementation only supports converting an integer vector. By default, this function determines the number of levels in the factor vector automatically. Users can also provide a maximal number of levels. Right now, FlashR factor vectors are used by `fm.sgroupby` and `fm.groupby`.
* [`as.vector`](FlashR-API/vector.Rd.html): convert a FlashR vector/matrix to an R vector.
* [`as.matrix`](FlashR-API/matrix.Rd.html): convert a FlashR vector/matrix to an R matrix.

FlashR has the following functions to test if an object is a FlashR vector or matrix.

* [`fm.is.vector`](FlashR-API/vector.Rd.html): test if an object is a FlashR vector.
* [`fm.is.matrix`](FlashR-API/matrix.Rd.html): test if an object is a FlashR matrix.

## "Base" functions

FlashR implements many R functions in the base package to mimic the existing R programming environment. Although we aim to have these functions as similar as possible to the original R functions, we do not provide 100% compatibility with R for some functions, for the sake of performance. Below is the list of **ever increasing** R functions in the base package currently supported by FlashR.

The following functions have exactly the same interface as the original R function.

* matrix info: [`dim`](FlashR-API/dim.Rd.html), [`nrow`](FlashR-API/nrow.Rd.html), [`ncol`](FlashR-API/nrow.Rd.html), [`length`](FlashR-API/length.Rd.html), [`typeof`](FlashR-API/typeof.Rd.html)
* change matrix shape: [`t`](FlashR-API/transpose.Rd.html)
* element-wise unary operations: [`abs`, `sqrt`](FlashR-API/MathFun.Rd.html), [`ceiling`, `floor`, `round`](FlashR-API/round.Rd.html), [`log`, `log2`, `log10`, `exp`](FlashR-API/log.Rd.html), [`!`](FlashR-API/Logic.Rd.html), [`-`](FlashR-API/Arithmetic.Rd.html)
* matrix multiplication: [`%*%`](FlashR-API/matmult.Rd.html), [`crossprod`, `tcrossprod`](FlashR-API/crossprod.Rd.html)
* aggregation: [`sum`](FlashR-API/sum.Rd.html), [`min`, `max`](FlashR-API/Extremes.Rd.html), [`range`](FlashR-API/range.Rd.html), [`all`](FlashR-API/all.Rd.html), [`any`](FlashR-API/any.Rd.html), [`mean`](FlashR-API/mean.Rd.html), [`rowSums`, `colSums`, `rowMeans`, `colMeans`](FlashR-API/colSums.Rd.html)
* type cast: [`as.integer`](FlashR-API/integer.Rd.html), [`as.numeric`](FlashR-API/numeric.Rd.html)
* element extraction: [`[]`](FlashR-API/Extract.Rd.html), [`head`, `tail`](FlashR-API/head.Rd.html)
* element selection: [`ifelse`](FlashR-API/ifelse.Rd.html)

Many operations have exactly the same interface as the original R functions but perform computation slightly differently in certain cases.

* binary operations: [`+`, `-`, `*`, `/`, `^`](FlashR-API/Arithmetic.Rd.html), [`==`, `!=`, `>`, `>=`, `<`, `<=`](FlashR-API/Comparison.Rd.html), [`|`, `&`](FlashR-API/Logic.Rd.html). When they are applied to a matrix and a vector, it requires the vector has the same length as the columns of the matrix.
* [`sweep`](FlashR-API/sweep-fm-method.Rd.html) requires the vector in `STATS` has the same length as the rows or the columns of the matrix in `x`. In addition, the function in `FUN` has to be one of the pre-defined element operators in FlashR (see the section "Generalized operations").
* [`print`](FlashR-API/print.Rd.html): instead of printing the elements in a FlashR vector/matrix, this function prints the basic information of the FlashR object, such as the number of rows or columns.
* [`pmin`, `pmax`](FlashR-API/Extremes.Rd.html) requires input arrays to be all FlashR vectors or FlashR matrices. These functions do not work on a mix of FlashR vectors/matrices and R vectors/matrices. In addition, we create `pmin2` and `pmax2` to compute parallel maxima and minima of two input vectors/matrices.
* [`rbind`, `cbind`](FlashR-API/fm.bind.Rd.html) work almost exactly the same as the ones in the R framework. Currently, we don't support `deparse.level`.

Some of them have slightly different interface and semantics. These slightly different functions always start with "fm." to indicate that they are actually FlashR functions. In the future, we will provide implementations with exactly the same interface and semantics as the original R functions.

* [`fm.table`](FlashR-API/fm.table.Rd.html): similar to [`table`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/table.html) in R, builds a contingency table of the counts of unique elements in the input vector. It currently only works for FlashR vectors and factor vectors. It outputs a list with two FlashR vectors: `val` and `Freq`. `val` contains the unique values in the input vector and `Freq` contains the counts of the unique values.
* [`fm.summary`](FlashR-API/fm.summary.Rd.html) computes the summary of a FlashMatrix vector/matrix. For a matrix, this function computes the summary of each column. It computes min, max, mean, L1 norm, L2 norm and the number of non-zero values.
* [`fm.eigen`](FlashR-API/fm.eigen.Rd.html) is an eigensolver to solve a very large eigenvalue problem. By default, it uses `eigs` from the RSpectra package to compute eigenvalues. This eigensolver has a limit on the size of an eigenvalue problem and does not parallelize all computation in eigensolving. To solve an even larger eigenvalue problem, users need to compile FlashR with the [Anasazi eigensolvers](https://trilinos.org/packages/anasazi/) from the Trilinos project (see more instructions [here](https://flashxio.github.io/FlashX-doc/FlashX-with-anasazi.html)). To compute eigenvalues, users define a function for matrix multiplication and pass the function as the first argument. e.g., `fm.eigen(function(x, args) mat %*% x, 10, nrow(mat))` computes 10 eigenvalues on the matrix `mat`. The function that defines matrix multiplication must return a FlashR matrix or vector.
* [`fm.svd`](FlashR-API/fm.svd.Rd.html) performs singular-value decomposition on a large matrix. e.g., `fm.svd(mat, 10, 0)` computes 10 left singular vectors on the input matrix.

## "Stats" functions

FlashR also implements some `stats` functions. They perform the same computation as the ones in the original "stats" package.

* [`sd`](FlashR-API/sd.Rd.html) computes standard deviation. 
* [`cov`, `cor`](FlashR-API/cor.Rd.html) computes covariance and correlation.
* [`cov.wt`](FlashR-API/cov.wt-fm-method.Rd.html) computes the weighted covariance matrix
* [`fm.kmeans`](FlashR-API/fm.kmeans.Rd.html) computes k-means with the Lloyd algorithm and random initialization.

## Generalized operations (GenOps)

In addition to the basic functions above, FlashR provides a set of generalized operations to increase the generality of FlashR. A GenOp takes some matrices and an element operator, which defines the computation on elements, to perform actual computation. FlashR defines only four GenOps and many element operators to cover computations required by many data mining and machine learning algorithms. Most of the "Base" and "stats" R functions shown above are also implemented with the GenOps.

### Element operators:

FlashR defines three types of element operators. Some operators take two elements and output one element (binary operators); some take only one element and output one element (unary operators); the others take multiple elements and output one element (aggregation operators). The tables below list the name and the corresponding R object for an element operator. Users can pass an element operator to a GenOp by using either its name or its R object.

#### Binary operators in FlashR

| name | R object | Computation semantics |
| :---| :--- | :--- |
| "+" or "add" | fm.bo.add | numeric addition. e.g., `2+1=3` |
| "-" or "sub" | fm.bo.sub | numeric subtraction. e.g, `2-1=1` |
| "*" or "mul" | fm.bo.mul | numeric multiplication. e.g, `2*3=6` |
| "/" or "div" | fm.bo.div | numeric division. e.g., `6/2=3` |
| "min" | fm.bo.min | minimum of two elements. e.g., `min(1, 2)=1` |
| "max" | fm.bo.max | maximum of two elements. e.g., `max(1, 2)=2` |
| "pow" | fm.bo.pow | raise to power of. e.g., `pow(2, 3)=8` |
| "==" or "eq" | fm.bo.eq | equal. e.g., `2 == 3 = FALSE` |
| "!=" or "neq" | fm.bo.neq | not equal. e.g., `2 != 3 = TRUE` |
| ">" or "gt" | fm.bo.gt | larger than. e.g., `2 > 3 = FALSE` |
| ">=" or "ge" | fm.bo.ge | larger than or equal to. e.g., `2 >= 3 = FALSE` |
| "<" or "lt" | fm.bo.lt | less than. e.g., `2 < 3 = TRUE` |
| "<=" or "le" | fm.bo.le | less than or equal to. e.g., `2 <= 3 = TRUE` |
| "\|" or "or" | fm.bo.or | logical or. e.g., `TRUE | FALSE = TRUE` |
| "&" or "and" | fm.bo.and | logical and. e.g., `TRUE & FALSE = FALSE` |

#### Special binary operators mainly used for aggregation

| name | R object | Computation semantics |
| :---| :--- | :--- |
| "count" | fm.bo.count | count the length of an array. e.g., `count(1, 2, 1)=3` |
| "which.max" | fm.bo.which.max | compute the index of the maximal value. e.g., `which.max(1, 2, 1)=2` |
| "which.min" | fm.bo.which.min | compute the index of the minimal value. e.g., `which.max(1, 2, 1)=1` |

#### Common unary operators in FlashR

| name | R object | Computation semantics |
| :---| :--- | :--- |
| "neg" | fm.buo.neg | negate. e.g., `neg(1)=-1` |
| "sqrt" | fm.buo.sqrt | sqare root. e.g., `sqrt(9)=3` |
| "abs" | fm.buo.abs | absolute value. e.g., `abs(-1)=1` |
| "not" | fm.buo.not | logical not. e.g., `not(TRUE)=FALSE` |
| "ceil" | fm.buo.ceil | ceiling of a numeric value. e.g., `ceil(1.1)=2` |
| "floor" | fm.buo.floor | floor of a numeric value. e.g., `floor(1.1)=1` |
| "log" | fm.buo.log | the natural logarithm. e.g., `log(10)=2.302585` |
| "log2" | fm.buo.log2 | the logarithm base 2. e.g., `log2(4)=2` |
| "log10" | fm.buo.log10 | the logarithm base 10. e.g., `log10(100)=2` |
| "round" | fm.buo.round | round a value to 0 decimal place. e.g., `round(1.1)=1` |
| "as.int" | fm.buo.as.int | cast a value to an integer |
| "as.numeric" | fm.buo.as.numeric | cast a value to a floating-point number |

In addition to binary and unary operators, FlashR also needs aggregation operators to perform aggregation, such as `fm.agg` and `fm.groupby` (see [Section "GenOps in FlashR"](#genops-in-flashr) for more details), on matrices. An aggregation operator has two parts: `agg` and `combine`, both of which are binary operators themselves. `agg` runs on (part of) an input array and outputs an aggregation result; `combine` is optional, which runs on partial aggregation results from `agg` and combines them to generate the final aggregation result. For many aggregation operators, `agg` and `combine` are the same.

FlashR provides `fm.create.agg.op(agg, combine, name)` to construct an aggregation operator from binary operators.

* For many aggregations, such as summation, product, minimum and maximum, we can provide the same binary operators ("+", "*", "min", "max") as both `agg` and `combine`, because these binary operators have the same input and output element type.
* For some aggregations, `agg` and `combine` takes different binary operators. For example, counting is defined as `fm.create.agg.op("count", "+", "count")` because "count" always outputs integers regardless of the input element type.
* For some aggregations, `combine` is not applicable. The examples are "which.min" and "which.max".

FlashR allows users to define their own element operators. Currently, a new element operator has to be defined in C/C++. More instructions of adding new element operators are shown [here](https://flashxio.github.io/FlashX-doc/FlashR-extension.html).

### GenOps in FlashR

**Inner product** ([`fm.inner.prod`](FlashR-API/fm.inner.prod.Rd.html)) is a generalized matrix multiplication. It replaces multiplication and addition in matrix multiplication with two element operators, respectively. As such, we can define many operations with inner product. For example, we can use inner product to compute various pair-wise distance matrics of data points, such as Euclidean distance and Hamming distance.

Example: compute the Euclidean distance between every pair of data points. We create a special binary operator `fm.bo.euclidean`, which computes the square of the difference of two elements: `euclidean(x, y)=(x - y)^2`, and register it to FlashR.

```R
data <- fm.runif.matrix(10000, 10)
# This computes a 10000x10000 distance matrix.
dist <- fm.inner.prod(data, t(data), fm.bo.euclidean, fm.bo.add)
```

**Apply** is an element-wise operation and has multiple variants.

* [`fm.sapply`](FlashR-API/fm.sapply.Rd.html):  an element-wise unary operation that applies a unary element operator to individual elements in an array. The output array of this function has the same shape as the input array.
* [`fm.mapply2`](FlashR-API/fm.mapply2.Rd.html): an element-wise binary operation that applies a binary element operator to the two input arrays. The two input arrays and the output array must have the same shape.
* [`fm.mapply.row`](FlashR-API/fm.mapply2.Rd.html) and [`fm.mapply.col`](FlashR-API/fm.mapply2.Rd.html) perform element-wise operations on every row or column of the matrix (in the first argument) with the vector (in the second argument). Currently, `fm.mapply.row` and `fm.mapply.col` only accept the cases that the vector has the same length as a row or a column of the matrix. The output matrix has the same shape as the input matrix.

All of these element-wise functions have the argument `set.na`. When `set.na` is `TRUE`, the `NA` values will propogate in the computation. That is, if one of the elements in the input array is `NA`, the element in the corresponding location of the output array will be set to `NA`. The default value of `set.na` is `TRUE`.

The examples below illustrate how the "base" matrix operations in FlashR are implemented with `fm.sapply` and `fm.mapply2`.

Example 1: compute m1 + m2.

```R
m1 <- fm.runif(100)
m2 <- fm.runif(100)
sum <- fm.mapply2(m1, m2, fm.bo.add)
sum <- fm.mapply2(m1, m2, "+")
```

Example 2: compute m1 + v2 (in this case, the vector v2 must have the same length as the columns of the matrix m1)

```R
m1 <- fm.runif.matrix(100, 10)
v2 <- fm.runif(100)
sum <- fm.mapply.col(m1, v2, fm.bo.add)
sum <- fm.mapply.col(m1, v2, "+")
```

Example 3: compute -m1

```R
m1 <- fm.runif(100)
neg <- fm.sapply(m1, fm.buo.neg)
neg <- fm.sapply(m1, "neg")
```

**Aggregation** ([`fm.agg`](FlashR-API/fm.agg.Rd.html) and [`fm.agg.mat`](FlashR-API/fm.agg.Rd.html)) take an array and an aggregation operator, and outputs a single element or a vector. If these functions get a binary operator, they will try to construct an aggregation operator with `fm.create.agg.op`.

* [`fm.agg`](FlashR-API/fm.agg.Rd.html) aggregates over the entire array.
* [`fm.agg.mat`](FlashR-API/fm.agg.Rd.html) aggregates over each individual row or column of a matrix and outputs a vector.

Example 1: compute `sum(m)`

```R
m <- fm.runif(100)
sum <- fm.agg(m, fm.bo.add)
sum <- fm.agg(m, "+")
```

Example 2: compute `rowSums(m)`

```R
m <- fm.runif.matrix(1000, 10)
rs <- fm.agg.mat(m, 1, fm.bo.add)
rs <- fm.agg.mat(m, 1, "+")
```

**Groupby** is similar to groupby in SQL. It groups multiple elements and performs aggregation on the elements within groups. Like aggregation functions, groupby functions also accept binary operators.

* [`fm.sgroupby`](FlashR-API/fm.groupby.Rd.html) groups elements by their own values in a vector and invokes FUN on the elements associated with the same value. It outputs a list with two fields `val` and `agg`. `val` is a FlashR vector with unique values in the original input vector; `agg` is a FlashR vector that stores the aggregation results for each unique value.
* [`fm.groupby`](FlashR-API/fm.groupby.Rd.html) takes a matrix and a factor vector, groups rows/columns of the matrix based on the factor vector and runs aggregation FUN on the rows/columns within the same group to generate a single row/column. If we group rows, `fm.groupby` outputs a matrix with the number of rows equal to the number of groups and the number of columns equal to the number of columns in the input matrix; if we group columns, `fm.groupby` outputs a matrix with the number of columns equal to the number of groups and the number of rows equals to the number of rows in the input matrix.

Example 1: count the occurrence of unique values in a vector.

```R
vec <- as.integer(fm.runif(1000) * 100)
cnt <- fm.sgroupby(vec, "count")
```

Example 2: group rows based on the labels and compute means within each group.

```R
mat <- fm.runif.matrix(1000, 10)
labels <- fm.as.factor(fm.runif(1000)*10)
g.sums <- fm.groupby(mat, 2, labels, "+")
cnts <- fm.sgroupby(labels, "count")
g.means <- fm.mapply.col(g.sums, cnts$agg, "/")
```

## FlashR configuration

Sometimes, users need to tune FlashR to get better performance or use SSDs to scale computation to larger datasets.

* [`fm.set.conf`](FlashR-API/fm.set.conf.Rd.html): users can pass a configuration file to tune the parameters in FlashR. The details of the parameters in FlashR are shown [here](https://flashxio.github.io/FlashX-doc/FlashX-conf.html).
* [`fm.print.conf`](FlashR-API/fm.set.conf.Rd.html) prints the current parameters in FlashR.
* [`fm.print.features`](FlashR-API/fm.set.conf.Rd.html) prints the features that have been compiled into FlashR when FlashR is installed.

## Guidelines for FlashR programmers

Although FlashR tries to provide a familiar environment for R users, it sacrifices full compatibility for performance. As such, there is some differences between R and FlashR that FlashR programmers need to take into consideration when implementing a new algorithm in FlashR.

### Array-oriented programming

The biggest difference between R and FlashR is that FlashR does not allow users to modify individual elements in a vector or a matrix. FlashR intentionally chooses so for the sake of performance. FlashR stores vectors and matrices on SSDs. Modifying individual elements results in read-modify-write to SSDs, causes many small random I/Os, loss of efficiency and potential harm to SSDs.

Although FlashR allows programmers to read individual elements in a vector or a matrix, it is highly recommended to **avoid** reading them individually as much as possible. FlashR advocates array-oriented programming to achieve optimal performance. Programmers should use the "base" array operations if possible. In addition, programmers should use generalized matrix operations to cover many more computation patterns.

### Lazy evaluation and matrix materialization

FlashR gains performance by lazily evaluating most of the matrix operations and merging them into a single execution. As such, the matrices output from most of the matrix operations (all generalized matrix operations and most of the "base" functions) do not contain actual computation results. This strategy dramatically improves performance for most computation, but it *may* lead to overhead in rare cases. As such, programmers sometimes need to provide FlashR some hints to achieve the maximal performance.

In a simple example of `mat1 + mat2`, the output of this operation stores the computation and the input matrices, instead of actual computation results.

```R
> mat1 <- fm.runif.matrix(1000, 10)
> mat2 <- fm.runif.matrix(1000, 10)
> mat <- mat1 + mat2
> fm.print.mat.info(mat1)
dense matrix with 1000 rows and 10 cols in col-major order
dense matrix is stored on 4 NUMA nodes
matrix store: mem_mat-1(1000,10)
> fm.print.mat.info(mat2)
dense matrix with 1000 rows and 10 cols in col-major order
dense matrix is stored on 4 NUMA nodes
matrix store: mem_mat-3(1000,10)
> fm.print.mat.info(mat)
dense matrix with 1000 rows and 10 cols in col-major order
dense matrix is stored on 4 NUMA nodes
matrix store: vmat-11=ifelse2_op(vmat-10=cast_bool2int(vmat-9=||(vmat-6=cast_bool2int(vmat-5=isna_only(mem_mat-1(1000,10))), vmat-8=cast_bool2int(vmat-7=isna_only(mem_mat-3(1000,10))))), vmat-4=+(mem_mat-1(1000,10), mem_mat-3(1000,10)))
```

However, FlashR needs to perform some computation to interact with R and return users the final computation results. For example, R needs actual values for its `if` conditions and `while` loops. FlashR performs actual computation in the following cases:

* The aggregation functions that output an R scalar value perform actual computation when the functions are called. Such functions include `sum`, `min`, `max`, `any`, `all`.
* The functions that access part of a matrix can also trigger computation. Such functions include `[]`, `head`, `tail`. 
* The functions that convert FlashR vectors/matrices to R vectors/matrices can also trigger the computation. Such functions include `as.vector` and `as.matrix`.
* `fm.materialize` and `fm.materialize.list` explicitly materialize the input matrices.

Lazy evaluation can potentially increase the computation overhead in rare cases. We use the code below to illustrate an example. Here, `sum` and `prod` do not store actual computation results. Materializing `res2` and `res3` trigger the computation in `sum` and `prod`. Because we materialize `res2` and `res3` separately, FlashR potentially has to perform the computation in `sum` and `prod` twice.


```R
> mat0 <- fm.runif.matrix(1000, 10)
> mat1 <- fm.runif.matrix(1000, 10)
> sum <- mat0 + mat1
> prod <- crossprod(sum)
> mat2 <- fm.runif.matrix(1000, 10)
> mat3 <- fm.runif.matrix(1000, 10)
> res2 <- mat2 %*% prod
> fm.materialize(res2)
> res3 <- mat3 %*% prod
> fm.materialize(res3)
```

To reduce computation overhead while still having small memory consumption, FlashR stores the computation results of small matrices in memory when their computation results are generated. In the example above, materializing `res2` triggers the computation in `sum` and `prod`, and FlashR saves the computation result in `prod` in memory by default. However, the computation result of `sum` is not saved because `sum` is potentially a very large matrix. The [paper](https://scholar.google.ca/citations?view_op=view_citation&hl=en&user=b1PYJN0AAAAJ&citation_for_view=b1PYJN0AAAAJ:mVmsd5A6BfQC) describes the policy of identifying small matrices in R code.

However, in some cases, FlashR needs programmers to provide some hints on saving computation results of large matrices. Programmers can call `fm.set.cached` to hint FlashR to save the computation result of a matrix and where (in memory or on SSDs) to save the computation result. The code below, which computes k-means, shows an example of using `fm.set.cached` to save computation. Each iteration first compute computes the distance of a data point to every cluster center and store the closest cluster Id to a data point in `parts`. If we don't cache the materialized result of `parts`, each access to `parts` triggers the expensive the distance computation and almost double the entire k-means computation. As such, we notify FlashR to save `parts` in memory whenever its elements are accessed.

```R
    while (iter < max.iters) {
        centers <- new.centers
        old.parts <- parts
        m <- fm.inner.prod(data, t(centers), "euclidean", "+")

        parts <- as.integer(fm.agg.mat(m, 1, agg.which.min) - 1)
        # Have the vector materialized during the computation.
        fm.set.cached(parts, TRUE, TRUE)

        new.centers <- cal.centers(data, fm.as.factor(parts, num.centers))
        if (!is.null(old.parts))
            num.moves <- sum(as.numeric(old.parts != parts))
        iter <- iter + 1
    }
```
