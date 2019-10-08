# MODULE 3 - R fundamentals
#
# (c) Copyright 2015-2019 - AMULET Analytics
# ---------------------------------------------------------------

# Vectorized operations

x <- 1:4; y <- 6:9     # Define 2 vectors of same length = 4
x + y                  # Vector addition
#[1] 7 9 11 13

x > 2                  # Logical map
#[1] FALSE FALSE TRUE TRUE

x >= 2
#[1] FALSE TRUE TRUE TRUE

y == 8                 # Logical map, compare for equality
#[1] FALSE FALSE TRUE FALSE

x * y                  # Element wise multiplication
#[1] 6 14 24 36

x / y                  # Element wise division
#[1] 0.1666667 0.2857143 0.3750000 0.4444444


# ---------------------------------------------------------------

# Vectorized matrix operations

x <- matrix(1:4, 2, 2); y <- matrix(rep(10, 4), 2, 2)

x * y             # Element-wise multiplication
#     [,1] [,2]
#[1,]   10   30
#[2,]   20   40

x / y             # Element-wise division
#     [,1] [,2]
#[1,]  0.1  0.3
#[2,]  0.2  0.4

x %*% y           # Linear algebra: true matrix multiplication
#     [,1] [,2]
#[1,]   40   40
#[2,]   60   60


# ---------------------------------------------------------------

# Compute transpose and inverse of a matrix 

A <- matrix(c(1,2,3,4), nrow=2)
A
#     [,1] [,2]
#[1,]    1    3
#[2,]    2    4

A_transpose <- t(A)
A_transpose
#     [,1] [,2]
#[1,]    1    2
#[2,]    3    4

# Inverse
A_inv <- solve(A)
#     [,1] [,2]
#[1,]   -2  1.5
#[2,]    1 -0.5

# Try it out using linear algebra definition
A %*% A_inv 
#     [,1] [,2]
#[1,]    1    0
#[2,]    0    1

library(MASS)
A_inv <- ginv(A)   # Uses the Moore-Penrose generalized inverse
#     [,1] [,2]
#[1,]   -2  1.5
#[2,]    1 -0.5

# ---------------------------------------------------------------

# if control structure

a <- 3
if (a == 4) {
  x <- 1
} else {
  x <- 3
  y <- 4
}
  
# Now use if as an expression in an assignment statement

x <- 2
y <- if(x == 2) x else x+1
y

x <- 3   # Same behavior in a different way
y <- if(x != 2) x else x+1
y

# Relational operators:
# x == y  test for equality
# x <= y  test for less than or equal to
# x >= y  test for greater than or equal to
# x != y  test for inequality

# Now use function form: ifelse(test_expression, x, y)

# Also: %% indicates x mod y ("x modulo y") 

a = c(5,7,2,9)
ifelse(a %% 2 == 0,"even","odd")
# [1] "odd"  "odd"  "even" "odd" 


# ---------------------------------------------------------------

# What's the difference between logical operators & and &&, | 
# and || ??

# Here & and && for the AND logical operator work the same
# & evaluates ALL vector elements
# && evaluates only FIRST vector elements
1==1
#[1] TRUE

1==1 & 1==2
#[1] FALSE

1==1 && 1==2
#[1] FALSE

# Now apply to vectors
1:3==1:3                   # Elementwise comparison yields a logical vector
#[1] TRUE TRUE TRUE

1:3==c(1,3,3)              # Elementwise compaison finds 2nd elements not equal
#[1]  TRUE FALSE  TRUE

# A more complex elementwise comparison. Only 2nd element is FALSE
1:3==1:3 & 1:3==c(1,3,3)   # (TRUE TRUE TRUE) & (TRUE FALSE  TRUE)
#[1]  TRUE FALSE  TRUE

# Now use &&.  The R help page says, "The longer form evaluates 
# left to right examining only the first element of each vector."

# Evaluate to TRUE since TRUE AND TRUE is TRUE
1:3==1:3 && 1:3==1:3  
#[1] TRUE

# Same as above since only 1st elements
1:3==1:3 && 1:3==c(1,3,3)  
#[1] TRUE


# But now this next example isn't so clear
x <- 1:5
x
# [1] 1 2 3 4 5

x[x<5]                 # Clear!
#[1] 1 2 3 4

# Now use AND &
# [TRUE  TRUE  TRUE  TRUE FALSE] & [FALSE FALSE  TRUE  TRUE  TRUE]
x[x<5 & x>2]           # Only 3 and 4 elements are both TRUE
#[1] 3 4


# ---------------------------------------------------------------

# for control structure 

for(i in 1:10) {
  print(i)
}


# ---------------------------------------------------------------

# More for control structure 

x <- c("a", "b", "c", "d")
for(i in 1:4) {
  print(x[i])
}

# Note seq_along(x) returns a vector: 1 2 3 4
for(i in seq_along(x)) {
  print(x[i])
}

for(letter in x) {
  print(letter)
}

for(i in 1:4) print(x[i])


# Using a trick to implement NEXT in a for() loop --------------------

for(i in seq(from=1, to=78, by=2)){
  #  stuff, such as
  print(i)
}


# ---------------------------------------------------------------

# nested for loops 

x <- matrix(1:6, 2, 3)   # 2x3 matrix

for(i in seq_len(nrow(x))) {
  for(j in seq_len(ncol(x))) {
    print(x[i, j])        # Print each element
  }
}

#[1] 1
#[1] 3
#[1] 5
#[1] 2
#[1] 4
#[1] 6


# ---------------------------------------------------------------
# while control structure 

count <- 0
while(count < 10) {
  print(count)           # Print 0 .. 9
  count <- count + 1
}


# ---------------------------------------------------------------

# More while control structure 

# Let's try an optimization experiment flipping coins using the
# rbinom() function for random binomial distribution.
z <- 5

# The && form of AND is appropriate for programming control-flow 
# and typically preferred in if clauses.

# Loop stops when z bounces out of end points 3 - 10
while(z >= 3 && z <= 10) {
  print(z)
  # Use binomial distribution: 1 observation, 1 trial, 
  # 0.5 probability of success for each trial (fair coin toss)
  coin <- rbinom(1, 1, 0.5)   
  if(coin == 1) { ## random walk
    z <- z + 1
  } else {
    z <- z - 1
  }
}


# ---------------------------------------------------------------

# repeat control structure 

# Another optimization experiment
x0 <- 1       # Initial value
delta <- 1e-8   # Converge to delta threshold to quit
repeat {
  x1 <- computeEstimate()    # computeEstimate() is a stub fcn
  if(abs(x1 - x0) < delta) {
    break
  } else {
    x0 <- x1
  }
}


# Infinite loop break 

repeat {
  print("infinite loop, bad!")
  
}

# To stop the above, click on STOP SIGN icon in RStudio, type ESC.


# ---------------------------------------------------------------

# Functions - lazy evaluation 

f <- function(a, b) {
  a^2        # Last expression in a function is the return value
}

f(2)    # Call the function passing a value for arg a


f <- function(a, b) {
  print(a)
  print(b)
}

f(45)
#[1] 45
#Error in print(b) : argument "b" is missing, with no default


# ---------------------------------------------------------------

# Recursion in R 

factorial <- function(x){
  
  if(x==1)
    return( 1)
  else
    return(x*factorial(x-1))
  
}

factorial(4)
#[1] 24


# ---------------------------------------------------------------

# R is a "pass arguments by value" language 

# R has pass-by-value semantics, which minimizes accidental side 
# effects (a good thing). However, when code is organized into 
# many functions/methods for reusability/readability/maintainability
# and when that code needs to manipulate large data structures 
# through, e.g., big data frames, through a series of 
# transformations/operations the pass-by-value semantics leads 
# to a lot of copying of data around and much heap thrashing 
# (a bad thing). For example, a 50MB data frame that is passed 
# as a function argument is not managed well. 

arg1 <- 1

f <- function(x) {x <- 2}

f(arg1)   # arg1 is passed by value
print(arg1)    # Still 1! Not passed by reference. 


# ---------------------------------------------------------------

# lapply() loop function

# Create a list with 2 elements: integer vector of length=5
# and numeric vector of length=10

# lapply() always returns a list, regardless of the class of 
# the input.

x <- list(a = 1:5, b = rnorm(10))  # Normal distribution values
x
#$a
#[1] 1 2 3 4 5
#
#$b
#[1]  1.7233800  1.1606824 -2.0491337 -0.3789917 -0.4466583  0.4138854
#[7]  1.2072786 -1.6345064 -1.1511696  0.5912451

lapply(x, mean)   # Calculate mean of both vectors
#$a
#[1] 3
#
#$b
#[1] 0.0296824


# ---------------------------------------------------------------

# More lapply() loop function

# For rnorm(), mean=0 is default
# Here c uses mean=1
# Here d uses mean=5
x <- list(a = 1:4, b = rnorm(10), c = rnorm(20, 1), 
          d = rnorm(100, 5))

lapply(x, mean)
#$a
#[1] 2.5

#$b
#[1] 0.06082667

#$c
#[1] 1.467083

#$d
#[1] 5.074749


# ---------------------------------------------------------------

# Even more lapply() loop function

x <- 1:4

# Generates random deviates
args(runif)     # Check out arg list for uniform distribution fcn
# arg n is number of observations
# Create a list object
# Element 1 has 1 random 
# Element 2 has 2 randoms
# Element 3 has 3 randoms
# Element 4 has 4 randoms

l2 <- lapply(x, runif) 
l2
#[[1]]
#[1] 0.2675082

#[[2]]
#[1] 0.2186453 0.5167968

#[[3]]
#[1] 0.2689506 0.1811683 0.5185761

#[[4]]
#[1] 0.5627829 0.1291569 0.2563676 0.7179353


# ---------------------------------------------------------------

# Still more lapply() loop function

x <- 1:4

# Note the ... argument is for min=0, max=10 below
? lapply

lapply(x, runif, min = 0, max = 10)
#[[1]]
#[1] 3.302142

#[[2]]
#[1] 6.848960 7.195282

#[[3]]
#[1] 3.5031416 0.8465707 9.7421014

#[[4]]
#[1] 1.195114 3.594027 2.930794 2.766946


# ---------------------------------------------------------------

# Final lapply() loop function

# Define a list consisting of 2 matrices
x <- list(a = matrix(1:4, 2, 2), b = matrix(1:6, 3, 2))
x
#$a
#     [,1] [,2]
#[1,]    1    3
#[2,]    2    4

#$b
#     [,1] [,2]
#[1,]    1    4
#[2,]    2    5
#[3,]    3    6

# lapply() and friends make heavy use of "anonymous" functions 

# Define a "anonymous" function inside of lappy() for extracting 
# first column of each matrix

l3 <- lapply(x, function(elt) elt[,1])
l3
#$a
#[1] 1 2

#$b
#[1] 1 2 3


# ---------------------------------------------------------------

# sapply() loop function

# First let's look at the lapply result
x <- list(a = 1:4, b = rnorm(10), c = rnorm(20, 1), 
          d = rnorm(100, 5))
lapply(x, mean)
#$a
#[1] 2.5

#$b
#[1] 0.06082667

#$c
#[1] 1.467083

#$d
#[1] 5.074749

# Now let's use sapply to simplify

s1 <- sapply(x, mean)   # Returns a numeric vector, NOT a list
s1
#         a          b          c          d
#2.50000000 0.06082667 1.46708277 5.07474950

mean(x)           # Can't use mean() for lists

