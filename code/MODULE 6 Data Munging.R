# MODULE 6 - Data Munging 
#
# (c) Copyright 2015-2019 - AMULET Analytics
# ---------------------------------------------------------------

# ---------------------------------------------------------------
# Random sampling of a data frame
# ---------------------------------------------------------------

# Use popular iris data set
data(iris)
dim(iris)
# [1] 150   5

# First create an index of the random sample
# Use default replace=F to not allow duplicate selections
sample_index <-sample(1:nrow(iris), 10, replace=FALSE)
sample_index

# Now use the index to select observations
sample_set <- iris[sample_index,]
sample_set

# ---------------------------------------------------------------
# Fixing Variable Names: get rid of "old school" dots
# ---------------------------------------------------------------

# Create a test data frame with no data, just structure
df <- data.frame("Address 1"=character(0), 
                 direction=character(0), 
                 street=character(0), 
                 CrossStreet=character(0), 
                 intersection=character(0), 
                 Location.1=character(0))

# Variable names have:
# - mixed case: better to have all lower
# - name with embedded space (not allowed) so fills with "."
# - name with "." as a separator, should use "_"

names(df)
#[1] "Address.1"    "direction"    "street"       "CrossStreet"  "intersection"
#[6] "Location.1"

# ---------------------------------------------------------------
# Convert to all lower case
names(df) <- tolower(names(df))   
names(df)     
#[1] "address.1"    "direction"    "street"       "crossstreet"  "intersection"
#[6] "location.1" 

# ---------------------------------------------------------------
# Throw away the "." in variable names

? strsplit   # strsplit = "Split elements of a char vector"

# Use regular expressions to define the operation
splitnames <- strsplit(names(df), "\\.")
class(splitnames)
# [1] "list"

# Display list of variable names
splitnames 

# Display length of list
length(splitnames)
# [1] 6

# Display one of the variable names with 1 piece
splitnames[2]
# [[1]]
# [1] "direction"

# Display another variable name with 2 pieces
splitnames[6]        # Used to be "Location.1"

#[[1]]
#[1] "location" "1"  

# Display 1st piece
splitnames[[6]][1]  
# [1] "location"

# Display 2nd piece
splitnames[[6]][2]    
# [1] "1"

# ---------------------------------------------------------------
# Use sapply() to keep only first elements of each sublist
firstelement <- function(x){x[1]}
names(df) <- sapply(splitnames, firstelement)

names(df)
#[1] "address"      "direction"    "street"       "crossstreet" 
#[5] "intersection" "location"   

# ---------------------------------------------------------------
# Create New Variables
# ---------------------------------------------------------------

data("airquality")      # Use airquality data set from base R

airquality$Ozone[1:10]   # Pick out the first 10 Ozone values
# [1] 41 36 12 18 NA 28 23 19  8 NA

# seq() function to define buckets
seq(0,200,by=25)
#[1]   0  25  50  75 100 125 150 175 200

? cut          # Convert numeric to factor
ozoneRanges <- cut(airquality$Ozone, 
                   breaks=seq(0,200,by=25))

# Factor names like "(25,50]" indicate range of values 
ozoneRanges[1:10]
# [1] (25,50] (25,50] (0,25]  (0,25]  <NA>    (25,50] (0,25]  (0,25]  (0,25] 
# [10] <NA>   
#  8 Levels: (0,25] (25,50] (50,75] (75,100] (100,125] (125,150] ... (175,200]

class(ozoneRanges)
# [1] "factor"

# Argument: useNA says whether to include NA values in the table
# <NA> becomes one of the buckets
table(ozoneRanges, useNA="ifany")  # Counts for each bucket
# ozoneRanges
# (0,25]   (25,50]   (50,75]  (75,100] (100,125] (125,150] (150,175] 
# 50        32        12        15         5         1         1 
# (175,200]      <NA> 
#  0        37

# ---------------------------------------------------------------
# Add ozoneRanges to data frame
airquality_copy <- airquality   # Make copy first!

airquality_copy$ozoneRanges <- ozoneRanges

head(airquality_copy)  # Compare Ozone vs. ozoneRanges

#   Ozone Solar.R Wind Temp Month Day ozoneRanges
# 1    41     190  7.4   67     5   1     (25,50]
# 2    36     118  8.0   72     5   2     (25,50]
# 3    12     149 12.6   74     5   3      (0,25]
# 4    18     313 11.5   62     5   4      (0,25]
# 5    NA      NA 14.3   56     5   5        <NA>
# 6    28      NA 14.9   66     5   6     (25,50]


# ---------------------------------------------------------------
# Discretize Numeric Variables using equal width buckets
# ---------------------------------------------------------------

data(iris)

buckets <- 10    # Pick number of buckets
maxSepLen <- max(iris$Sepal.Length)
minSepLen <- min(iris$Sepal.Length)

# n+1 values shown!
cutPoints <- seq(minSepLen, 
                 maxSepLen, 
                 by=(maxSepLen-minSepLen)/buckets)
cutPoints
#[1] 4.30 4.66 5.02 5.38 5.74 6.10 6.46 6.82 7.18 7.54 7.90

# Use cutPoints to convert numeric to factor. Use include.lowest
# to make sure that the minimum value is part of the interval.
cutSepLen <- cut(iris$Sepal.Length,
                 breaks=cutPoints,
                 include.lowest=TRUE)

# New data frame with original Sepal.Length and discretized version
newiris <- data.frame(contSepLen=iris$Sepal.Length, 
                      discSepLen=cutSepLen)
head(newiris)

#  contSepLen  discSepLen
#1        5.1 (5.02,5.38]
#2        4.9 (4.66,5.02]
#3        4.7 (4.66,5.02]
#4        4.6  [4.3,4.66]
#5        5.0 (4.66,5.02]
#6        5.4 (5.38,5.74]

# ---------------------------------------------------------------
# Date Handling
# ---------------------------------------------------------------

# Use popular lubridate package, part of Tidyverse
install.packages("lubridate")
library(lubridate)

# Use Lakers 2008-2009 basketball data set from lubridate package
data(lakers)      # 34624x13
? lakers          # Review data dictionary

df <- lakers      # Make a copy for testing

class(df$date)    # Integer vector!
class(df$time)    # Character vector!

# Integers are in yyyymmdd format
str(df$date)      # Display structure of df$date variable
# int [1:34624] 20081028 20081028 20081028 20081028 20081028 20081028 20081028 20081028 20081028 20081028 ...

# ---------------------------------------------------------------
# Combine date and time variables into single R date-time object
playdate <- df$date[1]    # Integer
playdate
#[1] 20081028

playtime <- df$time[1]    # Character
playtime
#[1] "12:00"

# Use paste() to concatenate strings
playdatetime <- paste(playdate, playtime)
playdatetime
#[1] "20081028 12:00"

# Use parse_date_time() from lubridate
playdatetime <- parse_date_time(playdatetime, "%y-%m-%d %H.%M")
playdatetime
# [1] "2008-10-28 12:00:00 UTC"
class(playdatetime)
# [1] "POSIXct" "POSIXt" 

# ---------------------------------------------------------------
# Use ymd() from lubridate to parse dates with YMD components 
# into R date-time object
df$date <- ymd(df$date)     # Parse dates in integer format
str(df$date)
# POSIXct[1:34624], format: "2008-10-28" "2008-10-28" "2008-10-28" "2008-10-28" "2008-10-28" ...
class(df$date)
# [1] "POSIXct" "POSIXt" 

# Now create a new variable: PlayDateTime with combined date, time
df$PlayDateTime <- parse_date_time(paste(df$date, df$time), 
                                   "%y-%m-%d %H.%M")
str(df$PlayDateTime)
# POSIXct[1:34624], format: "2008-10-28 12:00:00" "2008-10-28 11:39:00" "2008-10-28 11:37:00" ...


# ---------------------------------------------------------------
# Creating binary categorical variables
# ---------------------------------------------------------------

# Use popular iris data set from base R
data(iris)         # 150x5

# Save 3 levels from Species factor variable
species_cat <- levels(iris$Species)
species_cat
#[1] "setosa"     "versicolor" "virginica"

# Define a user defined function to build a logical map of
# Species variable based on passed value
binarySpecies <- function(c) {return(iris$Species == c)}

# Test the binarySpecies function
# Binary map of whether Species=="versicolor"
binarySpecies("versicolor")  

# Now use sapply to loop through all Species levels
newVars <- sapply(species_cat, binarySpecies)
newVars[50:55,]

#     setosa versicolor virginica
#[1,]   TRUE      FALSE     FALSE
#[2,]  FALSE       TRUE     FALSE
#[3,]  FALSE       TRUE     FALSE
#[4,]  FALSE       TRUE     FALSE
#[5,]  FALSE       TRUE     FALSE
#[6,]  FALSE       TRUE     FALSE

class(newVars)
#[1] "matrix"

# Now combine new binary categorical variables with original iris df
bin_iris <- iris       # Make copy of data set first

bin_iris$setosa <- newVars[,1]       # Include setosa binaries
bin_iris$versicolor <- newVars[,2]   # Include versicolor binaries
bin_iris$virginica <- newVars[,3]    # Include virginica binaries

head(bin_iris)

names(bin_iris)
#[1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"     
#[6] "setosa"       "versicolor"   "virginica"


# ---------------------------------------------------------------
# Simulate SQL joins by merging data frames
# ---------------------------------------------------------------

# Create test data frame 1 - small order history data set:
# customers and what they ordered
df1 = data.frame(CustId=c(1:6),
                 Product=c(rep("Mouse",3),
                           rep("Keyboard",3)))
df1
#  CustId  Product
#1      1    Mouse
#2      2    Mouse
#3      3    Mouse
#4      4 Keyboard
#5      5 Keyboard
#6      6 Keyboard

# Create test data frame 2 - customer profile, state location
df2 = data.frame(CustId=c(2,4,6),
                 State=c(rep("California",2),
                         rep("Oregon",1)))
df2
#  CustId      State
#1      2 California
#2      4 California
#3      6     Oregon

# OUTER JOIN: returns all rows from both tables using common field
# CustID. But not all CustID match
merge(x = df1, y = df2, by = "CustId", all = TRUE)
#  CustId  Product      State
#1      1    Mouse       <NA>
#2      2    Mouse California
#3      3    Mouse       <NA>
#4      4 Keyboard California
#5      5 Keyboard       <NA>
#6      6 Keyboard     Oregon

# LEFT OUTER JOIN: returns all rows from the x data frame 
# with the matching rows in the y data frame
merge(x = df1, y = df2, by = "CustId", all.x=TRUE)

#  CustId  Product      State
#1      1    Mouse       <NA>
#2      2    Mouse California
#3      3    Mouse       <NA>
#4      4 Keyboard California
#5      5 Keyboard       <NA>
#6      6 Keyboard     Oregon

# RIGHT OUTER JOIN: returns all rows from the y data frame with 
# the matching rows in the x data frame
merge(x = df1, y = df2, by = "CustId", all.y=TRUE)

#  CustId  Product      State
#1      2    Mouse California
#2      4 Keyboard California
#3      6 Keyboard     Oregon

# INNER JOIN: returns all rows from both tables as long as 
# there is a match between CustId in both data frames
merge(x = df1, y = df2, by = "CustId", all=FALSE)

#  CustId  Product      State
#1      2    Mouse California
#2      4 Keyboard California
#3      6 Keyboard     Oregon


# ---------------------------------------------------------------
# Sorting data sets
# ---------------------------------------------------------------

# Use the popular ToothGrowth data set that is in base R
# The Effect of Vitamin C on Tooth Growth in Guinea Pigs
data(ToothGrowth)
? ToothGrowth

head(ToothGrowth)
#   len supp dose
#1  4.2   VC  0.5
#2 11.5   VC  0.5
#3  7.3   VC  0.5
#4  5.8   VC  0.5
#5  6.4   VC  0.5
#6 10.0   VC  0.5

# ---------------------------------------------------------------
# Ordering a data frame by single variables
sortedData <- ToothGrowth[order(ToothGrowth$len),]
sortedData[1:10,]

#   len supp dose
#1  4.2   VC  0.5
#9  5.2   VC  0.5
#4  5.8   VC  0.5
#5  6.4   VC  0.5
#10 7.0   VC  0.5
#3  7.3   VC  0.5
#37 8.2   OJ  0.5
#38 9.4   OJ  0.5
#34 9.7   OJ  0.5
#40 9.7   OJ  0.5

# ---------------------------------------------------------------
# Ordering a data frame by multiple variables
sortedData <- ToothGrowth[order(ToothGrowth$supp, ToothGrowth$len),]
sortedData[1:10,]

#   len supp dose
#37  8.2   OJ  0.5
#38  9.4   OJ  0.5
#34  9.7   OJ  0.5
#40  9.7   OJ  0.5
#36 10.0   OJ  0.5
#35 14.5   OJ  0.5
#49 14.5   OJ  1.0
#31 15.2   OJ  0.5
#39 16.5   OJ  0.5
#33 17.6   OJ  0.5

# ---------------------------------------------------------------
# Reshape data sets
# ---------------------------------------------------------------

# Need reshape2 package for its melt() function
library(reshape2)

# Create a small test data frame
misShaped <- as.data.frame(matrix(c(NA,5,1,4,2,3), 
                                  byrow=TRUE, 
                                  nrow=3))
misShaped 
#  V1 V2
#1 NA  5
#2  1  4
#3  2  3

# Assign column names
names(misShaped) <- c("Quiz 1", "Quiz 2")
misShaped
#  Quiz 1 Quiz 2
#1     NA      5
#2      1      4
#3      2      3

# Add a new student name column
misShaped$student <- c("Ellen", "Catherine", "Stephen")
misShaped

#  Quiz 1 Quiz 2   student
#1     NA      5     Ellen
#2      1      4 Catherine
#3      2      3   Stephen

# Melt the data
melt(misShaped, id.vars="student", 
     variable.name="Quiz", 
     value.name="score")
#    student   Quiz score
#1     Ellen Quiz 1    NA
#2 Catherine Quiz 1     1
#3   Stephen Quiz 1     2
#4     Ellen Quiz 2     5
#5 Catherine Quiz 2     4
#6   Stephen Quiz 2     3


# ---------------------------------------------------------------
# Data Manipulation Using dplyr
# ---------------------------------------------------------------

# Use the dplyr package that is part of the Tidyverse
#install.packages("dplyr")
library(dplyr)

data(ToothGrowth)

# ---------------------------------------------------------------
# dplyr function to create a tbl_df in dplyr
ToothGrowth_df <- tbl_df(ToothGrowth)  

# ---------------------------------------------------------------
# Filter rows with dplyr filter(): 
# return rows with matching conditions
filter(ToothGrowth_df, len==11.2 & supp=="VC")  
# A tibble: 2 x 3
#    len supp   dose
#  <dbl> <fct> <dbl>
#1  11.2 VC      0.5
#2  11.2 VC      0.5

# ---------------------------------------------------------------
# Arrange rows with dplyr arrange()
arrange(ToothGrowth_df, supp, desc(len))  
# A tibble: 60 x 3
#    len supp   dose
#  <dbl> <fct> <dbl>
#1  30.9 OJ        2
#2  29.4 OJ        2
#3  27.3 OJ        1
#4  27.3 OJ        2
#5  26.4 OJ        1
#6  26.4 OJ        2
#7  26.4 OJ        2
#8  25.8 OJ        1
#9  25.5 OJ        2
#10  25.2 OJ        1
# ... with 50 more rows

# ---------------------------------------------------------------
# Select columns with dplyr select()
select(ToothGrowth_df, dose, supp)  
# A tibble: 60 x 2
#    dose supp 
#   <dbl> <fct>
# 1   0.5 VC   
# 2   0.5 VC   
# 3   0.5 VC   
# 4   0.5 VC   
# 5   0.5 VC   
# 6   0.5 VC   
# 7   0.5 VC   
# 8   0.5 VC   
# 9   0.5 VC   
#10   0.5 VC   
# ... with 50 more rows

# ---------------------------------------------------------------
# Add new columns with dplyr mutate()

# Create a new variable supp_num
# OJ coerced to 1
# VC coerced to 2
ToothGrowth_df <- mutate(ToothGrowth_df, supp_num=as.numeric(supp))   # dplyr function

attach(ToothGrowth_df)         
plot(len ~ dose,pch=supp_num)     # Scatterplot


# ---------------------------------------------------------------
# Handling missing data
# ---------------------------------------------------------------

#install.packages("e1071")
library(e1071)    # Needed for impute()  

# Create some missing data in iris data set
iris_missing_data <- iris           # Make copy first

# Assign NA to arbitrary variables
iris_missing_data[5,1] <- NA
iris_missing_data[7,3] <- NA
iris_missing_data[10,4] <- NA

# See missing values
iris_missing_data[1:10, -5]
#   Sepal.Length Sepal.Width Petal.Length Petal.Width 
#1           5.1         3.5          1.4         0.2  
#2           4.9         3.0          1.4         0.2  
#3           4.7         3.2          1.3         0.2  
#4           4.6         3.1          1.5         0.2  
#5            NA         3.6          1.4         0.2  
#6           5.4         3.9          1.7         0.4 
#7           4.6         3.4           NA         0.3  
#8           5.0         3.4          1.5         0.2  
#9           4.4         2.9          1.4         0.2  
#10          4.9         3.1          1.5          NA  

# impute the missing data values
iris_repaired <- impute(iris_missing_data[,1:4], what='mean')

iris_repaired[1:10, -5]
#      Sepal.Length Sepal.Width Petal.Length Petal.Width
# [1,]     5.100000         3.5     1.400000    0.200000
# [2,]     4.900000         3.0     1.400000    0.200000
# [3,]     4.700000         3.2     1.300000    0.200000
# [4,]     4.600000         3.1     1.500000    0.200000
# [5,]     5.848993         3.6     1.400000    0.200000
# [6,]     5.400000         3.9     1.700000    0.400000
# [7,]     4.600000         3.4     3.773826    0.300000
# [8,]     5.000000         3.4     1.500000    0.200000
# [9,]     4.400000         2.9     1.400000    0.200000
# [10,]    4.900000         3.1     1.500000    1.206711

# ---------------------------------------------------------------
# Now show how to discard records with missing values
# Discard each record with at least one missing value

df <- iris_missing_data
nrow(df)
# [1] 150

# Method 1
iris_trimmed <- df[complete.cases(df[,1:4]),]

# Method 2
iris_trimmed <- na.omit(df) 

nrow(iris_trimmed)
# [1] 147

# ---------------------------------------------------------------
# Find all NA observations first and then delete
# MARGIN=1 is for rows
df.has.na <- apply(X=df,MARGIN=1,FUN=function(x){any(is.na(x))})
sum(df.has.na)
#[1] 3

iris_trimmed <- df[!df.has.na,]     # Remove rows using index


# ---------------------------------------------------------------
# Feature Scaling
# ---------------------------------------------------------------

head(iris)    # Note the range of each feature
#  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#1          5.1         3.5          1.4         0.2  setosa
#2          4.9         3.0          1.4         0.2  setosa
#3          4.7         3.2          1.3         0.2  setosa
#4          4.6         3.1          1.5         0.2  setosa
#5          5.0         3.6          1.4         0.2  setosa
#6          5.4         3.9          1.7         0.4  setosa

# Scale each numeric column
scaleiris <- scale(iris[, 1:4])

head(scaleiris)
#     Sepal.Length Sepal.Width Petal.Length Petal.Width
#[1,]   -0.8976739  1.01560199    -1.335752   -1.311052
#[2,]   -1.1392005 -0.13153881    -1.335752   -1.311052
#[3,]   -1.3807271  0.32731751    -1.392399   -1.311052
#[4,]   -1.5014904  0.09788935    -1.279104   -1.311052
#[5,]   -1.0184372  1.24503015    -1.335752   -1.311052
#[6,]   -0.5353840  1.93331463    -1.165809   -1.048667







