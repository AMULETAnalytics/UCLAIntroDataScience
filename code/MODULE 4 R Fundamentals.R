# MODULE 4 - R fundamentals
#
# (c) Copyright 2015-2020 - AMULET Analytics
# ---------------------------------------------------------------

# A brife detour to the world of dates and times in R

# Dates and times in R using Base R functionality

x <- as.Date("1970-01-01")
x
#[1] "1970-01-01"

x+1     # Allows for date arithmetic
#[1] "1970-01-02"

unclass(x)
#[1] 0       # The origin date, beginning of "R time" Jan 1, 1970

dd <- as.Date("1963-06-06")
unclass(dd)
#[1] -2401   # Dates prior to 1/1/1970 are negative

unclass(as.Date("1970-01-02"))
#[1] 1


# ---------------------------------------------------------------

# More dates and times in R 

weekdays(x)
#[1] "Thursday"

months(x)
#[1] "January"

quarters(x)
#[1] "Q1"


# ---------------------------------------------------------------

# Even more dates and times in R 

# POSIXct class - for storing time data in a data frame
#    In format: 2015-04-14 18:18:41 PDT

# POSIXlt class - is a list under the hood with additional
#    items like day-of-week, day-of-year, etc.

x <- Sys.time()   # POSIXct class
x
#[1] "2015-04-14 18:14:32 PDT"

# Coerce into POSIXlt class
p <- as.POSIXlt(x)
p
#[1] "2015-04-14 18:14:32 PDT"

# Display components in POSIXlt object
names(unclass(p))
#[1] "sec"    "min"    "hour"   "mday"   "mon"    "year"   "wday"  
#[8] "yday"   "isdst"  "zone"   "gmtoff"

? POSIXlt  # For definition of list items

p$min      # 0-59: minutes

p$mday     # 1-31: day of the month

unclass(p)   # Show all list values

# ---------------------------------------------------------------

# Still more dates and times in R 

x <- Sys.time()
x ## Already in `POSIXct' format
#[1] "2015-04-14 18:18:41 PDT"

# Times are stored as number of seconds since 1/1/1970 
# so big number!
unclass(x)    
#[1] 1429060722

x$sec       # Error since in POSIXct format, not POSIXlt

# Coerce the value
p <- as.POSIXlt(x)   # Coerce to list form of time
p$sec     # Now seconds is available


# ---------------------------------------------------------------

# Still more dates and times in R
# strptime() is for date-time conversions to and from char

datestring <- c("January 10, 2012 10:40", "December 9, 2011 09:10") 
x <- strptime(datestring, "%B %d, %Y %H:%M")
x
#[1] "2012-01-10 10:40:00 PST" "2011-12-09 09:10:00 PST"

class(x)
#[1] "POSIXct" "POSIXt"

?strptime        # To see all the "conversion specification" codes


# ---------------------------------------------------------------

# Still more dates and times in R

x <- as.Date("2012-01-01")     # Date class
y <- strptime("9 Jan 2011 11:34:21", "%d %b %Y %H:%M:%S")  # POSIXlt class
x - y    # Error!

x <- as.POSIXlt(x)
x - y             # Now both POSIXlt class
#Time difference of 356.1845 days


# ---------------------------------------------------------------

# Still more dates and times in R 

# Data arithmetic
x <- as.Date("2012-03-01")   # Class is "Date"
y <- as.Date("2012-02-28")   # Class is "Date"
delta <- x - y
delta
#Time difference of 2 days

class(delta)
#[1] "difftime"      # Special "difftime" class

# Below x,y have class "POSIXct" "POSIXt"
x <- as.POSIXct("2012-10-25 01:00:00")     # PDT
# Specify time zone with tz. GMT is UTC
y <- as.POSIXct("2012-10-25 06:00:00", tz = "GMT")  

y - x
#Time difference of -2 hours    


# ---------------------------------------------------------------
# Back to R's powerful loop functions
# ---------------------------------------------------------------

# apply() loop function

# Use rnorm() function to generate test data: random numbers with
# a normal distribution
x <- matrix(rnorm(200), 20, 10)   # Create a 20x10 matrix
dim(x) 
#[1] 20 10

# Compute mean over columns (MARGIN=2 for cols, MARGIN=1 rows)
v <- apply(X=x, MARGIN=2, FUN=mean)
v
#[1] -0.74303310  0.35458880  0.13481934  0.06145236  0.05091838
#[6] -0.17001175 -0.33114470  0.12330392  0.16776065  0.22982988

class(v)               # Numeric vector
# [1] "numeric"

# Compute sum for each row
v <- apply(x, 1, sum)   
v
#[1] -0.7868339  1.2918416 -0.3977886  5.9339352  2.1263949 -1.3846887
#[7] -5.5452877 -0.6641990 -4.3731139  4.4081688 -0.5479200 -4.3701294
#[13]  3.4877387  3.8382023 -1.6243604  0.5771827 -3.9794925 -3.6587491
#[19] -0.4479327  3.6867072


# ---------------------------------------------------------------

# More apply() loop function

# Instead of doing this ...
row_sums = apply(X=x, MARGIN=1, FUN=sum)    # MARGIN=1 for rows
row_means = apply(X=x, MARGIN=1, FUN=mean)  # MARGIN=1 for rows
col_sums = apply(x, 2, sum)                 # MARGIN=2 for cols
col_means = apply(x, 2, mean)               # MARGIN=2 for cols

# ... you can use these built-in function shortcuts
row_sums  <- rowSums(x)
row_means <- rowMeans(x)
col_sums  <- colSums(x)
col_means <- colMeans(x)

# ---------------------------------------------------------------

# Even more apply() loop function

x <- matrix(rnorm(200), 20, 10)      # 20x10 matrix

# Find "Quantiles" of the rows of a matrix. In this example
# calculate 25% and 75% percentiles.
#
# Quantiles are points in a distribution that relate to the rank 
# order of values in that distribution. For example, the middle 
# quantile, or 50th percentile, is known as the median.

m <- apply(X=x, MARGIN=1, FUN=quantile, probs = c(0.25, 0.75))
m
#[,1]       [,2]       [,3]       [,4]       [,5]       [,6]
#25% -0.4739391 -0.8677358 -0.6958262 -0.1979822 -0.6930038 -0.7304902
#75%  0.4367207  0.3091204  0.3277869  0.6755583  0.8138959  0.4037430
#[,7]       [,8]       [,9]     [,10]      [,11]      [,12]
#25% -0.5236675 -0.5798327 -0.5347041 0.5238555 -0.7548490 -1.2683917
#75%  0.5993433  0.5234082  0.6125282 1.5146487 -0.1986852 -0.3488457
#[,13]      [,14]      [,15]      [,16]      [,17]      [,18]
#25% -0.5033292 -0.3253095 -0.2787021 -0.8012668 -1.1480751 -1.0877927
#75%  0.5538329  0.5726695  0.2829677  0.7507799  0.9994819  0.2751738
#[,19]      [,20]
#25% -1.212010 -1.2269352
#75%  1.315204  0.3881853


# ---------------------------------------------------------------

# Still more apply() loop function

# R arrays may contain 1, 2 or more dimensions

# Create a 3-dimensional matrix: 2 rows, 2 columns, 10 depth
a <- array(rnorm(2 * 2 * 10), dim=c(2, 2, 10))

# Average matrix in an array
# Collapse 3rd dimension
# MARGIN=c(1,2) indicates rows and columns
m <-apply(X=a, MARGIN=c(1, 2), FUN=mean) 
m
#            [,1]      [,2]
#[1,] -0.64619153 0.4342067
#[2,]  0.09584386 0.4556951

class(m)
# [1] "matrix"

# Another way to do it
m <- rowMeans(a, dims = 2)     # Also returns a matrix
m
#            [,1]      [,2]
#[1,] -0.64619153 0.4342067
#[2,]  0.09584386 0.4556951


# ---------------------------------------------------------------
# Use apply() to remove all rows with ANY variable containing 
# an empty string

mydf <- data.frame(V1=c("a","","","d",""),
                   V2=c("1","","3","4",""),
                   V3=c("m1","","m3","m4",""))
mydf
#  V1 V2 V3
#1  a  1 m1
#2         
#3     3 m3
#4  d  4 m4
#5         

# MARGIN=1 means rows
mydf <- mydf[!apply(mydf, 1, function(x) any(x=="")),]  
mydf
#  V1 V2 V3
#1  a  1 m1
#4  d  4 m4



# ---------------------------------------------------------------

# tapply() loop function - apply a function over a ragged array

# Take group means

# Define a numeric vector of length 30
# runif() generates random variables with a uniform distribution
x <- c(rnorm(10), runif(10), rnorm(10, 1))

# gl(n,k) generates factor levels, n=# levels, k=# replications
f <- gl(n=3, k=10)        # Create factor variable f
f
#[1] 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3
#Levels: 1 2 3

# Take group means
a <- tapply(X=x, INDEX=f, FUN=mean)
a
#         1          2          3 
#-0.1518069  0.5257590  0.4846167 

class(a)
# [1] "array"

# ---------------------------------------------------------------

# More tapply() loop function

# Take group means without simplification.

# Use argument simplify=FALSE always returns "list"
list1 <- tapply(X=x, INDEX=f, FUN=mean, simplify = FALSE)
list1
#$`1`
#[1] -0.1518069

#$`2`
#[1] 0.525759

#$`3`
#[1] 0.4846167


# ---------------------------------------------------------------

# Even more tapply() loop function

# Find group ranges.

# Calculate the MIN and MAX values
tapply(x, f, range)
#$`1`
#[1] -1.817712  1.013674

#$`2`
#[1] 0.1173772 0.9314156

#$`3`
#[1] -1.192308  3.340692


# ---------------------------------------------------------------

# split() function - split vector x according to factor f into
# a list with a number of elements equal to # levels 
# Also: unsplit()

x <- c(rnorm(10), runif(10), rnorm(10, 1))   # Vector length 30
f <- gl(n=3, k=10)   # n=number of levels, k=number of replications

# Divide x into the groups defined by f
s <- split(x, f)
s
#$`1`
#[1]  0.6747407  0.7809243 -1.3207132  0.1955758  1.2876734  1.3496505
#[7] -1.1890280 -1.1237316  1.4768832 -1.4751009

#$`2`
#[1] 0.6419825 0.3419221 0.6671094 0.5453081 0.5255481 0.1115069
#[7] 0.6517376 0.2380157 0.9482666 0.0627268

#$`3`
#[1] 1.1046428 1.4646097 1.5050529 3.1584884 0.6394136 0.9963238
#[7] 1.5416058 0.8581232 1.5952700 1.0198079


# ---------------------------------------------------------------

# More split() function

# A common idiom is split() followed by an lapply()

# Same as tapply
lapply(split(x, f), mean)
#$`1`
#[1] 0.06568742

#$`2`
#[1] 0.4734124

#$`3`
#[1] 1.388334


# ---------------------------------------------------------------

# splitting a data frame 

library(datasets)
head(airquality)

# Create a list s with one element a list for each month
s <- split(airquality, airquality$Month)
s       # Check this out!
s[['7']]    # For July

# Calculate column mean for Ozone, Solar.R, Wind
# Notice some are NA because of missing data
# Good example of embedding a function in a function call
lapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")]))


# ---------------------------------------------------------------

# More splitting a data frame 

# The data set only has months May-Sept
# Missing data causes the NA
s1 <- sapply(s, 
             function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")]))
s1
#               5         6          7        8        9
#Ozone         NA        NA         NA       NA       NA
#Solar.R       NA 190.16667 216.483871       NA 167.4333
#Wind    11.62258  10.26667   8.941935 8.793548  10.1800

# Now repeat above by remove the NAs
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")],
                               na.rm = TRUE))
#                5         6          7          8         9
#Ozone    23.61538  29.44444  59.115385  59.961538  31.44828
#Solar.R 181.29630 190.16667 216.483871 171.857143 167.43333
#Wind     11.62258  10.26667   8.941935   8.793548  10.18000


# ---------------------------------------------------------------

# mapply() loop function
#
# mapply stands for 'multivariate' apply. Its purpose is to be 
# able to vectorize arguments to a function that is not usually 
# accepting vectors as arguments. In short, mapply applies a 
# Function to Multiple List or multiple Vector Arguments.

m <- matrix(c(rep(1, 4), rep(2, 4), rep(3, 4), rep(4, 4)),4,4)
m
#     [,1] [,2] [,3] [,4]
#[1,]    1    2    3    4
#[2,]    1    2    3    4
#[3,]    1    2    3    4
#[4,]    1    2    3    4

# We could have done the above more concisely by using mapply 
# to vectorize the action of the function rep.

m <- mapply(FUN=rep,1:4,4)
m
#     [,1] [,2] [,3] [,4]
#[1,]    1    2    3    4
#[2,]    1    2    3    4
#[3,]    1    2    3    4
#[4,]    1    2    3    4


# ---------------------------------------------------------------
# Generating random numbers for test data
# ---------------------------------------------------------------

# Random number generation for the normal distribution with 
# mean equal to mean and standard deviation equal to sd.
x <- rnorm(10, mean=0, sd=1)
x
#[1] -1.0699555 -0.5408636 -1.2404782  2.4247933 -0.1610625  0.6300392
#[7]  0.7965898  0.3648089  1.6164017  0.6919018

# 10 random numbers, normally distributed, mean=20, sd=2
x <- rnorm(10, mean=20, sd=2)
x
#[1] 21.78827 22.77555 19.77708 19.53316 21.55689 18.56826 23.19788
#[8] 18.47157 20.30528 19.34516

summary(x)


# ---------------------------------------------------------------

# Generating random numbers with seed() for experimental 
# reproducability 

rnorm(5)
#[1] -0.6264538  0.1836433 -0.8356286  1.5952808  0.3295078

# Different random numbers!
rnorm(5)
#[1] -0.8204684  0.4874291  0.7383247  0.5757814 -0.3053884

# Use same seed value to generate the same random numbers
set.seed(1)
rnorm(5)
#[1] -0.6264538  0.1836433 -0.8356286  1.5952808  0.3295078

set.seed(1)
rnorm(5)
#[1] -0.6264538  0.1836433 -0.8356286  1.5952808  0.3295078

# ---------------------------------------------------------------

# Generating Poisson distribution data with rpois()

# The Poisson Distribution is a theoretical discrete probability 
# distribution that is very useful in situations where the 
# discrete events occur in a continuous manner. This has a huge 
# application in many practical scenarios like determining the 
# number of calls received per minute at a call center.

rpois(n=10, lambda=1)    # lambda (rate) =1, vector of means
#[1] 0 0 1 1 2 1 1 4 1 2

rpois(10, 2)             # Now rate = 2 so slightly larger
#[1] 4 1 2 0 1 1 0 1 4 1

rpois(10, 20)            # Now rate = 20
#[1] 19 19 24 23 22 24 23 20 11 22

# ---------------------------------------------------------------

# Generating random numbers for a linear model

set.seed(20)
x <- rnorm(100)        # Single predictor x
e <- rnorm(100, 0, 2)  # Error term, mean=0, sd=2

# Use coefficients b1=2, b0=0.5
y <- 0.5 + 2 * x + e   # Linear model calc response y

summary(y)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#-6.4080 -1.5400  0.6789  0.6893  2.9300  6.5050 

plot(x, y)    # Note the linear trend


# ---------------------------------------------------------------

# Now use binomial distribution - binary

# The binomial distribution model is an important probability 
# model that is used when there are two possible outcomes 
# (hence "binomial"). 

# Arguments: 
# n=1 Number of observations 
# size=1 Number of independent trials 
# prob=0.5 probability of SUCCESS for each trial (fair coin toss)

# 10 different random numbers
rbinom(n = 10, size = 1, prob = 0.5)
# [1] 0 1 0 1 1 0 1 0 1 0

# Find number of successes in 10 trials
rbinom(n = 1, size = 10, p = 0.5)
# [1] 3


set.seed(10)         # Set seed for reproducibility

# Number of observations=100, number of trials=1, prob of 
# success each trial=0.5
x <- rbinom(100, 1, 0.5)    # All binary
e <- rnorm(100, 0, 2)
y <- 0.5 + 2 * x + e

summary(y)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#-3.4940 -0.1409  1.5770  1.4320  2.8400  6.9410 

plot(x, y)         # X is binary


# ---------------------------------------------------------------

# Now use Poisson distribution

set.seed(1)

x <- rnorm(100)
log.mu <- 0.5 + 0.3 * x
y <- rpois(n=100, lambda=exp(log.mu))

summary(y)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.00    1.00    1.00    1.55    2.00    6.00 

plot(x, y)


# ---------------------------------------------------------------
# Random sampling with sample()
# ---------------------------------------------------------------

set.seed(1)        # seed() must preceed all random functions

sample(1:10, 4)    # Choose from integers 1:10, choose 4 items
#[1] 3 4 5 7

sample(1:10, 4)    # Repeat with no seed()
#[1] 3 9 8 5

letters            # Built-in character vector
#[1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q"
#[18] "r" "s" "t" "u" "v" "w" "x" "y" "z"

sample(letters, 5) # Choose random letters
#[1] "q" "b" "e" "x" "p"

sample(1:10)       # permutation 1
#[1] 4 7 10 6 9 2 8 3 1 5

sample(1:10)       # permutation 2
#[1] 2 3 4 1 9 5 10 8 6 7

# Default is replace=FALSE, no replacement
sample(1:10, replace = TRUE) # Sample w/replacement


