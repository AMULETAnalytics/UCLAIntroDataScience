# MODULE 7 - Exploratory Data Analytis (numeric)
#
# (c) Copyright 2015-2019 - AMULET Analytics
# ---------------------------------------------------------------

# Data sets to use for EDA
data(ToothGrowth)
data(airquality)
data(iris)

# ---------------------------------------------------------------
# Performing Counts
# ---------------------------------------------------------------

# Show unique values found for a variable
unique(airquality$Month)
#[1] 5 6 7 8 9

# Count unique values for a variable using SQL
library(sqldf)
sqldf("select count(Ozone) from airquality where Ozone=11")
#  count(Ozone)
#1            3

# ---------------------------------------------------------------
# Using summary() and str() for summary statistics
# ---------------------------------------------------------------

# Summary statistics for all variables in data set
# Min: smallest value for a continuous variable
# Max: largest values for a continuous variable
# Mean: arithmetic mean (average) for a continuous variable
# Median: middle number in a sequence of values of a continuous variable
# 1st quartile: the numbers for which one-fourth of the data is smaller
# 3rd quartile: the numbers for which three-fourths of the data is smaller
# Shows # of NAs

summary(airquality)

#Ozone           Solar.R           Wind       
#Min.   :  1.00   Min.   :  7.0   Min.   : 1.700  
#1st Qu.: 18.00   1st Qu.:115.8   1st Qu.: 7.400  
#Median : 31.50   Median :205.0   Median : 9.700  
#Mean   : 42.13   Mean   :185.9   Mean   : 9.958  
#3rd Qu.: 63.25   3rd Qu.:258.8   3rd Qu.:11.500  
#Max.   :168.00   Max.   :334.0   Max.   :20.700  
#NA's   :37       NA's   :7                       
#Temp           Month            Day      
#Min.   :56.00   Min.   :5.000   Min.   : 1.0  
#1st Qu.:72.00   1st Qu.:6.000   1st Qu.: 8.0  
#Median :79.00   Median :7.000   Median :16.0  
#Mean   :77.88   Mean   :6.993   Mean   :15.8  
#3rd Qu.:85.00   3rd Qu.:8.000   3rd Qu.:23.0  
#Max.   :97.00   Max.   :9.000   Max.   :31.0  

# Summary statistics for a specific variable
summary(airquality$Ozone)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#   1.00   18.00   31.50   42.13   63.25  168.00      37 

# Display "structure" of the airquality data set
str(airquality)
#'data.frame':	153 obs. of  6 variables:
#$ Ozone  : int  41 36 12 18 NA 28 23 19 8 NA ...
#$ Solar.R: int  190 118 149 313 NA NA 299 99 19 194 ...
#$ Wind   : num  7.4 8 12.6 11.5 14.3 14.9 8.6 13.8 20.1 8.6 ...
#$ Temp   : int  67 72 74 62 56 66 65 59 61 69 ...
#$ Month  : int  5 5 5 5 5 5 5 5 5 5 ...
#$ Day    : int  1 2 3 4 5 6 7 8 9 10 ...

# Show count of each factor level
summary(iris)       # This data set has a categorical variable Species

# ---------------------------------------------------------------
# Examining a small sample using head() and tail()
# ---------------------------------------------------------------

head(airquality, 10)     # Default n=6
#Ozone Solar.R Wind Temp Month Day
#1    41     190  7.4   67     5   1
#2    36     118  8.0   72     5   2
#3    12     149 12.6   74     5   3
#4    18     313 11.5   62     5   4
#5    NA      NA 14.3   56     5   5
#6    28      NA 14.9   66     5   6

tail(airquality)
#    Ozone Solar.R Wind Temp Month Day
#148    14      20 16.6   63     9  25
#149    30     193  6.9   70     9  26
#150    NA     145 13.2   77     9  27
#151    14     191 14.3   75     9  28
#152    18     131  8.0   76     9  29
#153    20     223 11.5   68     9  30


# ---------------------------------------------------------------
# Simple R statistical functions
# ---------------------------------------------------------------

# Mean, Min, Max, Range, Quantile
mean(airquality$Ozone, na.rm=TRUE)
#[1] 42.12931

min(airquality$Wind)
#[1] 1.7

max(airquality$Solar.R, na.rm=TRUE)
#[1] 334

range(airquality$Month)
#[1] 5 9


# 0 quartile = 0 quantile = 0 percentile
#
# 1 quartile = 0.25 quantile = 25 percentile
#
# 2 quartile = .5 quantile = 50 percentile (median)
#
# 3 quartile = .75 quantile = 75 percentile
#
# 4 quartile = 1 quantile = 100 percentile

# Quantiles using default: probs = seq(0, 1, 0.25)
# Produces sample quantiles corresponding to the given 
# probabilities. The smallest observation corresponds to 
# a probability of 0 and the largest to a probability of 1.
quantile(airquality$Ozone, probs=seq(0,1,0.25),na.rm=TRUE)
#  0%    25%    50%    75%   100% 
#1.00  18.00  31.50  63.25 168.00 

# And now a more detailed probability distribution
quantile(airquality$Ozone, probs=seq(0,1,0.125), na.rm=TRUE)
#     0%   12.5%     25%   37.5%     50%   62.5%     75%   87.5%     100% 
#  1.000  12.000  18.000  23.000  31.500  43.625  63.250  83.250  168.000

# Returns "Tukey five-number" summaries: (minimum, lower-hinge, 
# median, upper-hinge, maximum) 
# lower, upper-hinge: the median of the lower and upper half of the data.
fivenum(airquality$Ozone, na.rm=TRUE)
#[1]   1.0  18.0  31.5  63.5 168.0

# Variance: The variance is a numerical value used to indicate how 
# widely individuals in a group vary. If individual observations 
# vary greatly from the group mean, the variance is big. A variance 
# of 0 means all the values are identical.
var(airquality$Temp)
# [1] 89.59133

var(airquality$Ozone, na.rm=TRUE)
# [1] 1088.201

# Highly correlated variables
cor(iris$Sepal.Length, iris$Petal.Length)
#[1] 0.8717538

# Weak correlation, negative correlation: larger Wind tends to have 
# smaller Temp
cor(airquality$Wind, airquality$Temp, method="pearson")
# [1] -0.4579879

# Correlation of all variables in data set
cor(airquality)
#        Ozone Solar.R       Wind       Temp        Month          Day
#Ozone       1      NA         NA         NA           NA           NA
#Solar.R    NA       1         NA         NA           NA           NA
#Wind       NA      NA  1.0000000 -0.4579879 -0.178292579  0.027180903
#Temp       NA      NA -0.4579879  1.0000000  0.420947252 -0.130593175
#Month      NA      NA -0.1782926  0.4209473  1.000000000 -0.007961763
#Day        NA      NA  0.0271809 -0.1305932 -0.007961763  1.000000000

# Text tool for viewing the distribution of a numeric vector
stem(airquality$Wind)
# Below is called a "stem-and-leaf plot," a device for presenting 
# quantitative data in a graphical format, similar to a histogram, 
# to assist in visualizing the shape of a distribution.

# Stem-and-leaf is a special table where each numeric value is split 
# into a stem (First digit(s)) and a leaf (last Digit). For example, 
# 57 will split into 5 as stem and 7 as leaf.
# The decimal point is at "|" character. 
#  
#1  | 7
#2  | 38
#3  | 4
#4  | 016666
#5  | 111777
#6  | 33333333999999999
#7  | 4444444444
#8  | 0000000000066666666
#9  | 2222222277777777777
#10 | 3333333333399999999
#11 | 555555555555555
#12 | 0000666
#13 | 2288888
#14 | 33333399999999
#15 | 555
#16 | 1666
#17 | 
#18 | 4
#19 | 
#20 | 17

# Calculate a cummulative sum
# Subset Ozone values for May, removing NAs
sub_Ozone <- with(airquality, subset(Ozone, Month ==5 & !is.na(Ozone)))
cumsum(sub_Ozone)
#[1]  41  77  89 107 135 158 177 185 192 208 219 233 251 265 299 305 335 346 347 358 362 394
#[23] 417 462 577 614

# ---------------------------------------------------------------
# Explore levels of a factor variable (categorical variable)
# ---------------------------------------------------------------

# Show all levels of a categorical variable (factor)
levels(ToothGrowth$supp)
#[1] "OJ" "VC"

# Count number of instances for each level in a factor variable 
table(iris$Species)
#setosa versicolor  virginica 
#    50         50         50 

# Produce a "contingency table" or crosstab
ctab <- list(c(3,14,15,14,15,3,15),c("a","xy","a","a", "xy", "a", "a"))
ctab
#[[1]]
#[1]  3 14 15 14 15  3 15
#
#[[2]]
#[1] "a"  "xy" "a"  "a"  "xy" "a"  "a" 

table(ctab)
#     ctab.2
#ctab.1 a xy
#    3  2  0
#    14 1  1
#    15 2  1


# ---------------------------------------------------------------
# Counting the number of non-missing values of a variable
# ---------------------------------------------------------------

# 3 ways to find the number of non-missing values of Ozone
length(airquality$Ozone[is.na(airquality$Ozone) == FALSE])
# [1] 116

length(airquality$Ozone[!is.na(airquality$Ozone)])
# [1] 116

sum(!is.na(airquality$Ozone))
# [1] 116


# ---------------------------------------------------------------
# Common statistical tests for continuous random variables
# ---------------------------------------------------------------

# t.test() - Student's t-test
# var.test() - F-test
# aov() - analysis of variance
# pairwise.t.test() - t-test between every pair of groups
# shapiro.test() - Shapiro-Wilk test
# ks.test() - Kolmogorov-Smirnov test
# cor.test() - Pearson's or Spearman's rank correlation
# wilcox.test() - Wilcoxon's rank test: non-parametric equivalent to t-test
# kruskal.test() - Kruskal-Wallis rank-sum test
# flinger.test() - Flinger-Killeen (median) test

# ---------------------------------------------------------------
# Common statistical tests for discrete data (categorical)
# ---------------------------------------------------------------

# prop.test() - proportions test
# binom.test() - Binomial distribution test
# fisher.test() - Fisher's exact test
# chisq.test() - chi-squared test
# mantelhaen.test() - Cochran-Mantel-Haenszel test
# friendman.test() - Friedman rank-sum test


# For quality vignettes, search for R-oriented tutorials: http://www.r-bloggers.com/

# For example, here is a good tutorial for the chi-squared test:
# http://www.r-bloggers.com/applications-of-chi-square-tests/




















