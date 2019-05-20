# MODULE 8 - Exploratory Data Analysis (data Visualization)
#
# (c) Copyright 2015-2019 - AMULET Analytics
# ---------------------------------------------------------------

data(ToothGrowth)
data(airquality)
data(iris)

pData <- read.csv("./data/ss06pid.csv")   # ~10MB file
dim(pData)     # Data frame 14931x239
head(pData)    # Show first 6 rows
tail(pData)    # Show last 6 rows

# ---------------------------------------------------------------
# Exploratory plots 
# ---------------------------------------------------------------

# ---------------------------------------------------------------
# Histograms
# ---------------------------------------------------------------

# Single variable frequency plot

# You see that the hist() function first cuts the range of the data in a 
# number of even intervals, and then counts the number of observations in 
# each interval. The bars height is proportional to those frequencies. On 
# the y-axis, you find the counts.

# Draw vis and store object
histObj_freq <- hist(iris$Sepal.Length, freq=TRUE, col="blue")
class(histObj_freq)
#[1] "histogram"

names(histObj_freq)
#[1] "breaks"   "counts"   "density"  "mids"     "xname"    "equidist"

histObj_freq$breaks
#[1] 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0

histObj_freq$counts
#[1]  5 27 27 30 31 18  6  6

# Probability density plot, use prob=TRUE. breaks arg controls # of bins

# What it does is set the vertical axis so that if we were to add the 
# areas of all the rectangles, we would find that they sum to the 
# number 1. Calculate the area of each rectangle, add them up to equal 1

histObj_den <- hist(iris$Sepal.Length, probability=TRUE, breaks=10, col="blue")

# Add a density curve
lines(density(iris$Sepal.Length))

# Read data set
pData <- read.csv("../data/ss06pid.csv") # Set working dir to \code
# Using pData shows a univariate distribution of the data
hist(pData$AGEP,col="blue")    # AGEP is an variable indicating age

# Use breaks=100 for more fine grain
hist(pData$AGEP,col="blue",breaks=100,main="Age")


# ---------------------------------------------------------------
# Boxplots
# ---------------------------------------------------------------

# For a quantitative variable, goal: view distribution of data
boxplot(airquality$Ozone, col="blue")

# Show len broken down by supp variable
boxplot(ToothGrowth$len ~ as.factor(ToothGrowth$supp), col="blue")

# Use color to distinguish data
boxplot(ToothGrowth$len ~ as.factor(ToothGrowth$supp), col=c("blue","orange"), varwidth=TRUE)

# AGEP variable is "integer" - goal is to view the distribution of the data

# Mean - solid line is center of distribution. When the mean
# is in the middle of the blue box it means it is a
# symmetric distribution

# Upper border of blue box is 75th percentile

# Lower border of blue box is 25th percentile

# Upper whisker is 1.5 x 75th percentile

# Lower whisker is 1.5 x 25th percentile

boxplot(pData$AGEP,col="blue")


# Now use DDRS - dressing

# Tilda "~" means show AGEP broken down by DDRS variable

# DDRS=1 have difficulty dressing
# DDRS=2 do not have difficulty dressing

# Interpretation of the dual boxplots is: older people have
# more difficult dressing

boxplot(pData$AGEP ~ as.factor(pData$DDRS),col="blue")


# Now use different colors for each group

# Use varwidth=TRUE so width of box is proportional to the
# number of observations in group

boxplot(pData$AGEP ~ as.factor(pData$DDRS),
        col=c("blue","orange"),names=c("yes","no"),varwidth=TRUE)

# Can also use main, xlab, and ylab arguments

# ---------------------------------------------------------------
# Barplots
# ---------------------------------------------------------------

table(airquality$Temp)

#56 57 58 59 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 
#1  3  2  2  3  2  1  2  2  3  4  4  3  1  3  3  5  4  4  9  7  6  6  5 11  9  4  5 
#85 86 87 88 89 90 91 92 93 94 96 97 
#5  7  5  3  2  3  2  5  3  2  1  1 

barplot(table(airquality$Temp), col="blue")


# Using pData, barplot() shows number of observations in each 
# class ==> CIT has values 1 .. 5
barplot(table(pData$CIT),col="blue")

table(pData$CIT)   # table() useful for numeric distribution
#    1     2     3     4     5 
#14122    13   110   263   423 


# ---------------------------------------------------------------
# Density plots
# ---------------------------------------------------------------

# To fully understand density, you'll need to understand kernal 
# functions, probability density functions (PDF), and probability 
# density estimation - all mathematical concepts in statistics. 

# Many believe that kernal density plots are a much more effective 
# way to view the distribution of a variable.

density(airquality$Temp) # density() calculates kernal density estimates

temp_dens <- density(airquality$Temp)  
plot(temp_dens, lwd=3, col="blue")

# Overlay filtered density
len_dens <- density(ToothGrowth$len)
plot(len_dens, lwd=3, col="blue")

VC_dens <- density(ToothGrowth$len[which(ToothGrowth$supp=="VC")])
lines(VC_dens, lwd=3, col="orange")


# ---------------------------------------------------------------
# Scatterplots - the most used type of plot for exploration. Use 
# to visualize relationships between quantitative variables. 
# ---------------------------------------------------------------

plot(ToothGrowth$len, ToothGrowth$dose, pch=19, col="blue")

plot(ToothGrowth$len, ToothGrowth$dose, pch=ifelse(ToothGrowth$supp=="VC",0,1), col="blue")

# 3D scatter plots
install.packages("scatterplot3d")
library(scatterplot3d)

scatterplot3d(airquality$Solar.R, airquality$Wind, airquality$Temp, highlight.3d=TRUE, col.axis="blue", col.grid="lightblue",main="Air Quality Data Set", pch=20, xlab="Solar Radiation", ylab="Wind", zlab="Temp")


# Pairs() plot for a scatterplot matrix 
pairs(iris[,c(1,2,3,4)])    # To show possible correlations between all variables

# Correlation matrix
# Shows trend where increased Petal.Length corresponds to increased Petal.Width
cor(iris[,c(1,2,3,4)], method="pearson")  # Correlation coefficient used "pearson"
#             Sepal.Length Sepal.Width Petal.Length Petal.Width
#Sepal.Length    1.0000000  -0.1175698    0.8717538   0.8179411
#Sepal.Width    -0.1175698   1.0000000   -0.4284401  -0.3661259
#Petal.Length    0.8717538  -0.4284401    1.0000000   0.9628654
#Petal.Width     0.8179411  -0.3661259    0.9628654   1.0000000

# Correlation confirmed: 96.3% means highly correlated


# Big Data techniques

# Plotting too many points
x <- rnorm(1e5)
y <- rnorm(1e5)
plot(x,y, pch=16)

# Create a random sample index of 1,000 points instead of 100,000
sampledSubset <- sample(1:1e5, size=1000, replace=FALSE)
# Now plot using the sampled index, much better!
plot(x[sampledSubset], y[sampledSubset], pch=16)

# Plot a large number of point. Show outliers
# Notice the outliers in the plot!
smoothScatter(x,y)   # Better depending on your preference

# Count bins
install.packages("hexbin")
library(hexbin)

hbins <- hexbin(x,y)
plot(hbins)


# Now using pData
# x axis - commuting time
# y axis - wage

# The row of data points at top likely have to do with reasons of encoding
plot(pData$JWMNP,pData$WAGP,pch=19,col="blue")  # pch=19 filled in circles

# -----
# Smaller magnification value with cex=0.5 you get better resolution
# for each data point. 
plot(pData$JWMNP,pData$WAGP,pch=19,col="blue",cex=0.5)  # cex=0.5

# -----
# Very important technique to encode a 3rd variable using color
# SEX has values 1 or 2
plot(pData$JWMNP,pData$WAGP,pch=19,col=pData$SEX,cex=0.5)

# -----
# Use dot size to visualize another variable
percentMaxAge <- pData$AGEP/max(pData$AGEP) # Numeric vector, len=14931
percentMaxAge[1:50]

# The size of the x, y data point will have a size = % of max age
plot(pData$JWMNP,pData$WAGP,pch=19,col="blue",cex=percentMaxAge*0.5)

# This works better
plot(pData$JWMNP,pData$WAGP,pch=19,col="blue",cex=percentMaxAge)


# -----
# scatterplots - numeric variables as factors 
install.packages("Hmisc")
library(Hmisc)               # Need this package for cut2()

# Cut a numeric variable into intervals
ageGroups <- cut2(pData$AGEP,g=5)    # 5 cut points
class(ageGroups)
#[1] "factor" 

levels(ageGroups)
#[1] "[ 0,14)" "[14,29)" "[29,45)" "[45,60)" "[60,93]"

# Use different color for each of the 5 age groups
plot(pData$JWMNP,pData$WAGP,pch=19,col=ageGroups,cex=0.5)

# ---------------------------------------------------------------
# QQ-plots
# ---------------------------------------------------------------

# Quantile-quantitle plot: plots the quantiles of one variable 
# against another. Axes represent the 1st percentile up to the 
# 100th precentile of the variables

# Two vectors of 20 normally distributed random numbers
x <- rnorm(50)
y <- rnorm(50)

# Plot quantiles of x vs. quantiles of y
qqplot(x,y)

# Draw a line with intercept=0 and slope=1
abline(c(0,1))

# NOTE: if the two distributions were exactly the same, the percentiles 
# would land on the line (intercept of 0 and slope of 1)

# 1. Normal Q-Q plots can be extremely effective in highlighting 
#    glaring outliers in a data sequence. 
# 2. An informal graphical test for showing a data sequence is 
#    normally distributed i.e. approximated by a straight line
# 3. ALSO useful in highlighting: distributional asymmetry, heavy 
#    tails, outliers, multi-modality, and other data anomalies. 

# ---------------------------------------------------------------
# Heatmaps
# ---------------------------------------------------------------

# image(x, y, z)
# x, y - locations of grid lines at which the values in z are measured
# z - a matrix containing the values to be plotted

# image() plots a matrix of data points as a grid of boxes, color coding
# the boxes based on the intensity at each location.
# Color represents intensity

image(1:10,161:236,as.matrix(pData[1:10,161:236]))

# -----
data(iris)

# Heatmap color intensity represents how large a data value is. Brighter the
# color the larger the value. White depicts the largest value, red is smallest.

image(1:150, 1:4, as.matrix(iris[1:150, 1:4])) # Use all 150 iris observations

# Transpose data matrix to be more intuitive
# Show observations on y-axis, feature variables on x-axis: more intuitive
transMatrix <- as.matrix(iris[1:150, 1:4])
transMatrix <- t(transMatrix)[, nrow(transMatrix):1]

image(1:4, 1:150, transMatrix)


# ---------------------------------------------------------------
# Missing values and plots 
# ---------------------------------------------------------------

# Boxplot for missing values
boxplot(airquality$Temp ~ is.na(airquality$Solar.R))

# -----
# Generate some test data
x <- c(NA,NA,NA,4,5,6,7,8,9,10)   # X vector has some NAs
y <- 1:10

# xlim, ylim - observations not in this range will be dropped completely
plot(x,y,pch=19,xlim=c(0,11),ylim=c(0,11))
# range will be dropped completely

# -----
x <- rnorm(100)
y <- rnorm(100)
y[x < 0] <- NA    # Insert NAs wherever x < 0

# Notice the TRUE (is NA) box has all negative x values
# and the FALSE (is not NA) box has all positive x values
boxplot(x ~ is.na(y)) # Boxplot splitting x into groups according to is.na(y)


# ---------------------------------------------------------------
# Expository plots
# ---------------------------------------------------------------

par(mfrow=c(1,2))
hist(airquality$Ozone, xlab="Ozone (ppb)", col="blue", main="Ozone Frequencies")

plot(airquality$Ozone, airquality$Temp, pch=16, col="blue", cex=1.25, xlab="Ozone (ppb)", ylab="Temperature (degrees F)", main="Air Quality - Ozone vs. Temp", cex.axis=1.5)
legend(125,60,legend="May-Sep 1973", col="blue", pch=16, cex=1.0)


# -----
# Expository graphs: axes 

# Label your axes with xlab, ylab and ALWAYS include units
plot(pData$JWMNP,pData$WAGP,pch=19,col="blue",cex=0.5,
     xlab="Travel time (min)",ylab="Last 12 month wages (dollars)")

# -----
# Expository graphs: axes larger 

# Same as above, just make the axes easier to read
plot(pData$JWMNP,pData$WAGP,pch=19,col="blue",cex=0.5,
     xlab="Travel time (min)",ylab="Last 12 month wages (dollars)",cex.lab=2,cex.axis=1.5)

# -----
# Expository graphs: legends 

plot(pData$JWMNP,pData$WAGP,pch=19,col="blue",cex=0.5,xlab="TT (min)",ylab="Wages (dollars)")

# Use legend() with x,y coords for upper/left corner of legend box 
# Might have to play around with positioning
legend(100,200000,legend="All surveyed",col="blue",pch=19,cex=0.5)


# -----
# Expository graphs: legends

# Use color to represent 3rd variable: SEX
plot(pData$JWMNP,pData$WAGP,pch=19,cex=0.5,xlab="TT (min)",ylab="Wages (dollars)",col=pData$SEX)

# Use col argument to sync up color coding for sEX and legend
legend(100,200000,legend=c("men","women"),col=c("black","red"),pch=c(19,19),cex=c(0.5,0.5))


# -----
# Expository graphs: Titles 

# Always use main argument to present title of the graph ... explain well!
plot(pData$JWMNP,pData$WAGP,pch=19,cex=0.5,xlab="CT (min)",
     ylab="Wages (dollars)",col=pData$SEX,main="Wages earned versus commute time")
legend(100,200000,legend=c("men","women"),col=c("black","red"),pch=c(19,19),cex=c(0.5,0.5))


# -----
# Expository graphs: Multiple Panels

# Stacking graphs is common, up to 4 otherwise too hard to read
par(mfrow=c(1,2))

# Histogram
hist(pData$JWMNP,xlab="CT (min)",col="blue",breaks=100,main="")

# Scatterplot with legend
plot(pData$JWMNP,pData$WAGP,pch=19,cex=0.5,xlab="CT (min)",ylab="Wages (dollars)",col=pData$SEX)
legend(100,200000,legend=c("men","women"),col=c("black","red"),pch=c(19,19),cex=c(0.5,0.5))

par(mfrow=c(1,1))   # Reset panel argument

# -----
# (additional) - Adding text

par(mfrow=c(1,2))
hist(pData$JWMNP,xlab="CT (min)",col="blue",breaks=100,main="")
# Adding figure designation (a)
mtext(text="Figure (a)",side=3,line=1)

plot(pData$JWMNP,pData$WAGP,pch=19,cex=0.5,xlab="CT (min)",ylab="Wages (dollars)",col=pData$SEX)
legend(100,200000,legend=c("men","women"),col=c("black","red"),pch=c(19,19),cex=c(0.5,0.5))
# Adding figure designation (b)
mtext(text="Figure (b)",side=3,line=1)

par(mfrow=c(1,1))   # Reset panel argument

# -----
# (additional) - Creating a PDF

pdf(file="twoPanel.pdf",height=4,width=8)   # Dimensions in inches
par(mfrow=c(1,2))
hist(pData$JWMNP,xlab="CT (min)",col="blue",breaks=100,main="")
mtext(text="(a)",side=3,line=1)
plot(pData$JWMNP,pData$WAGP,pch=19,cex=0.5,xlab="CT (min)",ylab="Wages (dollars)",col=pData$SEX)
legend(100,200000,legend=c("men","women"),col=c("black","red"),pch=c(19,19),cex=c(0.5,0.5))
mtext(text="(b)",side=3,line=1)
dev.off()


# -----
# (additional) - Creating a PNG, also bmp(), jpeg(), and tiff()


png(file="twoPanel.png",height=480,width=(2*480))
par(mfrow=c(1,2))
hist(pData$JWMNP,xlab="CT (min)",col="blue",breaks=100,main="")
mtext(text="(a)",side=3,line=1)
plot(pData$JWMNP,pData$WAGP,pch=19,cex=0.5,xlab="CT (min)",ylab="Wages (dollars)",col=pData$SEX)
legend(100,200000,legend=c("men","women"),col=c("black","red"),pch=c(19,19),cex=c(0.5,0.5))
mtext(text="(b)",side=3,line=1)
dev.off()






