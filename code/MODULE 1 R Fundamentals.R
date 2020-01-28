# MODULE 1 - R fundamentals
#
# (c) Copyright 2015-2020 - AMULET Analytics
# ---------------------------------------------------------------


# Installing new R updates (for Windows only)

install.packages("installr")

library(installr)

R.version.string
#[1] "R version 3.6.2 (2019-12-12)"

# Best to run from RGui not RStudio
updateR() # updating R.


# ---------------------------------------------------------------

# <- is the assignment operator, = is almost the same. 

x <- vector()    # Empty vector assignment 
class(x)         # logical!


# ---------------------------------------------------------------

x <- 1      # Integer vector with 1st element = 1
print(x)

msg <- "hello"   # Character vector, 1 element


# ---------------------------------------------------------------

x <- 5
x            # Implicit printing

# Explicit printing
print(x)     # This prints a vector of length 1 with element = 5
#[1] 5    


# ---------------------------------------------------------------

x <- 1:20    # Use : operator to create integer sequences
x


# ---------------------------------------------------------------

# Use c() concatenate function
x <- c(0.5, 0.6)       ## numeric vector, 2 elements
x <- c(TRUE, FALSE)    ## logical vector, 2 elements
x <- c(T, F)           ## logical vector, 2 elements
x <- c("a", "b", "c")  ## character vector, 3 elements
x <- 9:29              ## integer vector, 21 elements
x <- c(1+0i, 2+4i)     ## complex vector, 2 elements

# Using the vector() function
x <- vector("numeric", length = 10) # numeric vector, 10 elements

# All elements default to 0
x


# ---------------------------------------------------------------

# Mixing objects

# Since vector elements MUST be of same type, coercion occurs!
y <- c(1.7, "a")  ## character vector, "1.7"
y <- c(TRUE, 2)   ## numeric vector (1,2), where TRUE=1, FALSE=0
y <- c("a", TRUE) ## character vector ("a", "TRUE")


# ---------------------------------------------------------------

# Explicit coercion

x <- 0:6       # 0 1 2 3 4 5 6
class(x)
#[1] "integer"

as.numeric(x)
#[1] 0 1 2 3 4 5 6

y <- as.numeric(x)
class(y)
#[1] "numeric"

as.logical(x)
#[1] FALSE TRUE TRUE TRUE TRUE TRUE TRUE

as.character(x)
#[1] "0" "1" "2" "3" "4" "5" "6"

as.complex(x)
#[1] 0+0i 1+0i 2+0i 3+0i 4+0i 5+0i 6+0i


# ---------------------------------------------------------------

# More coercion

x <- c("a", "b", "c")
as.numeric(x)
#[1] NA NA NA
#Warning message:
#  NAs introduced by coercion

as.logical(x)
#[1] NA NA NA


# ---------------------------------------------------------------

# Matrices

# Matrices are vectors with a dimension attribute. The dimension attribute is 
# itself an integer vector of length 2 (nrow, ncol)

m <- matrix(nrow = 2, ncol = 3)
m
#   [,1] [,2] [,3]
#[1,] NA NA NA
#[2,] NA NA NA

# Return dimension attribute of matrix
dim(m)
#[1] 2 3

# Or use the attributes() function
attributes(m)
#$dim
#[1] 2 3


# ---------------------------------------------------------------

# Matrices are constructed column-wise, so entries can be thought of starting 
# in the "upper left" corner and running down the columns.

# Assign values completing a column at a time
m <- matrix(1:6, nrow = 2, ncol = 3)
m
#     [,1] [,2] [,3]
#[1,]    1    3    5
#[2,]    2    4    6

# Another example using c()
m <- matrix(c(3,1,4,1,5,9), nrow=2, ncol=3)
m


# ---------------------------------------------------------------

# More matrices

# Matrices can also be created directly from vectors by adding a dimension attribute.

m <- 1:10       # Design an integer vector of 10 elements
m
#[1] 1 2 3 4 5 6 7 8 9 10

# Assign to dimension attribute making object a matrix
dim(m) <- c(2, 5)    # 2 rows, 5 columns
m
#     [,1] [,2] [,3] [,4] [,5]
#[1,]    1    3    5    7    9
#[2,]    2    4    6    8   10


# ---------------------------------------------------------------

# cbinding and rbinding

# Matrices can be created by column-binding or row-binding with cbind() and rbind().

# Define two integer vectors, each with 3 elements
x <- 1:3
y <- 10:12
cbind(x, y)         # Combine by column
#     x  y
#[1,] 1 10
#[2,] 2 11
#[3,] 3 12

rbind(x, y)         # Combing by row
#  [,1] [,2] [,3]
#x    1    2    3
#y   10   11   12


# ---------------------------------------------------------------

# Lists

# Lists are a special type of vector that can contain elements of different classes. 
# Lists ae a very important data type in R and you should get to know them well. 

x <- list(1, "a", TRUE, 1 + 4i)
x             # See double brackets for elements of a list
#[[1]]
#[1] 1
#
#[[2]]
#[1] "a"
#
#[[3]]
#[1] TRUE
#
#[[4]]
#[1] 1+4i

class(x)
#[1] "list"

# ---------------------------------------------------------------

# Vectors containing lists

list1 <- list(1,2,3)
list2 <- list(4,5)

x <- vector(mode="list")   # Define a null "vector" using "list" mode

x[[1]] <- list1
x[[2]] <- list2
x                        # Note: the list is ragged - a list of lists!

class(x)    # List object although we used vector()

# More on constructing lists 

n = c(2, 3, 5)    # Numeric vector
s = c("aa", "bb", "cc", "dd", "ee")   # Character vector
b = c(TRUE, FALSE, TRUE, FALSE, FALSE)   # Logical vector

# x is a list of vectors!
x = list(n, s, b, 3)   # List object x contains copies of n, s, b 

# List slicing
# We retrieve a list slice with the single square bracket "[]" operator. 
# The following is a slice containing the second member of x, which 
# is a copy of s. 
x[2] 
# [[1]]
# [1] "aa" "bb" "cc" "dd" "ee"

# Member reference
# In order to reference a list member directly, we have to use the 
# double square bracket "[[]]" operator. The following object x[[2]] 
# is the second member of x. In other words, x[[2]] is a copy of s, 
# but is NOT a slice containing s or its copy. 
x[[2]]
# [1] "aa" "bb" "cc" "dd" "ee"

# With an index vector, we can retrieve a slice with multiple members. 
# Here a slice containing the second and fourth members of x. 
x[c(2, 4)] 
# [[1]]
# [1] "aa" "bb" "cc" "dd" "ee"
#
# [[2]]
# [1] 3

# We can modify its content directly. 
x[[2]][1] = "ta" 
x[[2]]
#[1] "ta" "bb" "cc" "dd" "ee" 
s
# [1] "aa" "bb" "cc" "dd" "ee"       # s is unaffected

# ---------------------------------------------------------------

# Factors

# Used for categorical variables in statistics (not quantitative)

x <- factor(c("yes", "yes", "no", "yes", "no"))
x
#[1] yes yes no  yes no 
#Levels: no yes

table(x)    # frequency of factor values
#x
# no yes 
#  2   3

class(x)
#[1] "factor"

unclass(x)   # Convert a factor to its integer codes for level #
#[1] 2 2 1 2 1
#attr(,"levels")
#[1] "no"  "yes"

# Another example
y <- factor(c("b", "a", "a", "c", "a", "b", "c"))
unclass(y)
#[1] 2 1 1 3 1 2 3
#attr(,"levels")
#[1] "a" "b" "c"


# ---------------------------------------------------------------

# More factors

# The order of the levels can be set using the levels argument to factor(). 

# Can also set order of levels
x <- factor(c("yes", "yes", "no", "yes", "no"),
            levels = c("yes", "no"))
x
#[1] yes yes no yes no
#Levels: yes no


# ---------------------------------------------------------------

# Missing values
# na: not available
# nan: not a number

x <- c(1, 2, NA, 10, 3)   # Numeric vector
is.na(x)                  # Only 3rd element is NA
#[1] FALSE FALSE TRUE FALSE FALSE

is.nan(x)    # Is any element "Not a Number"? NO!
#[1] FALSE FALSE FALSE FALSE FALSE

is.nan(NA)   # NA is not considered NaN
#[1] FALSE

x <- c(1, 2, NaN, NA, 4)
is.na(x)           # NA and NaN considered missing value
#[1] FALSE FALSE TRUE TRUE FALSE

is.nan(x)     # Only 1 actual Nan
#[1] FALSE FALSE TRUE FALSE FALSE


# ---------------------------------------------------------------

# Data frames

x <- data.frame(foo = 1:4, bar = c(T, T, F, F))
x
#  foo   bar
#1   1  TRUE
#2   2  TRUE
#3   3 FALSE
#4   4 FALSE

nrow(x)
#[1] 4

ncol(x)
#[1] 2


# ---------------------------------------------------------------

# Names

# R objects can also have names, which is very useful for writing readable code and 
# self-describing objects.

x <- 1:3    # Create an integer vector
x
#[1] 1 2 3

names(x)    # No names for this vector object
#NULL

# Now assign some names for each element
names(x) <- c("foo", "bar", "norf")
x             # Print with names
#foo bar norf
#  1   2    3

names(x)       # Now just print the names, no values
#[1] "foo" "bar" "norf"


# ---------------------------------------------------------------

# More names

# Lists can also have names
x <- list(a = 1, b = 2, c = 3)   # Create a new list with names
x
#$a
#[1] 1
#$b
#[1] 2
#$c
#[1] 3


# ---------------------------------------------------------------

# Even more names

# Matrices can also have names
m <- matrix(1:4, nrow = 2, ncol = 2)  # Define 2x2 matrix
m                       # Note: no names, just indexes
#     [,1] [,2]
#[1,]    1    3
#[2,]    2    4

# Assign some names
dimnames(m) <- list(c("a", "b"), c("c", "d"))
m                       # Print matrix with names
#  c d
#a 1 3
#b 2 4

#m$a             # Cannot refer to a matrix row by name like this.

# ---------------------------------------------------------------

# matrix() dimensionality 
# Matrices are ONLY 2-dimensional, e.g. rows and columns as in mathematics
# byrow=TRUE - matrix is filled by rows instead of default columns

x <- matrix(1:4, nrow=2, ncol=2, byrow=TRUE)


# ---------------------------------------------------------------

# dim(x) and attributes(x) where x is a vector 

x <- 1:5    # Integer vector
x

length(x)   # Return the number of elements in vector

# dim(x) only works for matrix, array, data frame

# How about attributes()??

x <- 1:3   # Define an integer vector
names(x) <- c("a", "b", "c")    # Assign via $names attribute

attributes(x)   # This works

x$names   # No go! This should work. 

names(x)  # No problem


# ---------------------------------------------------------------

# Arrays

x <- array(1:24, dim=c(3,4,2))   # 3-dimensional array
x
#, , 1
#
#     [,1] [,2] [,3] [,4]
#[1,]    1    4    7   10
#[2,]    2    5    8   11
#[3,]    3    6    9   12

#, , 2

#     [,1] [,2] [,3] [,4]
#[1,]   13   16   19   22
#[2,]   14   17   20   23
#[3,]   15   18   21   24


dim(x)
#[1] 3 4 2

attributes(x)
#$dim
#[1] 3 4 2

class(x)           # array
#[1] "array"

mode(x)
#[1] "numeric"

typeof(x)
#[1] "integer"

