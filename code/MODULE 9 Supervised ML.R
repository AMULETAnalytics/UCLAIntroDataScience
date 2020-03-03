# MODULE 9 - Supervised Machine Learning
#
# (c) Copyright 2015-2020 - AMULET Analytics
# ---------------------------------------------------------------

# Perform EDA in preparation for linear regression

#install.packages("UsingR")
library(UsingR)

# 928x2 just two variables: child height, parent height
data(galton)       
summary(galton)     # Get familiar with data


# ---------------------------------------------------------------
# Simple Linear regression
# ---------------------------------------------------------------

plot(galton$parent,galton$child,pch=19,col="blue")

# Fit a linear model using basic least squares
# Allows you to predict child given parent where
# child is the response variable, and parent is 
# the predictor (feature variable).
lm1 <- lm(galton$child ~ galton$parent)

# Draw the regression line through the distribution
lines(galton$parent,lm1$fitted,col="red",lwd=3)

# ---------------------------------------------------------------

# Print calculated linear model info
summary(lm1)
# Call:
# lm(formula = galton$child ~ galton$parent)
#
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -7.8050 -1.3661  0.0487  1.6339  5.9264 
#
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)    
# (Intercept)   23.94153    2.81088   8.517   <2e-16 ***
# galton$parent  0.64629    0.04114  15.711   <2e-16 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
# Residual standard error: 2.239 on 926 degrees of freedom
# Multiple R-squared:  0.2105,	Adjusted R-squared:  0.2096 
# F-statistic: 246.8 on 1 and 926 DF,  p-value: < 2.2e-16

# ---------------------------------------------------------------
# Review all components of the linear model object
names(lm1)
#[1] "coefficients"  "residuals"     "effects"       "rank"         
#[5] "fitted.values" "assign"        "qr"            "df.residual"  
#[9] "xlevels"       "call"          "terms"         "model"        

# ---------------------------------------------------------------
# Print coefficient vector
lm1$coeff
#(Intercept) galton$parent 
#23.9415302     0.6462906 

# ---------------------------------------------------------------
# Can use the trained linear model to predict new child heights
# For parent = 60
predict_child <- lm1$coeff[1] + 60 * lm1$coeff[2]
predict_child
# (Intercept) 
#    62.71897 

# ---------------------------------------------------------------

# Residuals plot - should all be centered around 0 line. Residuals 
# are the distances between the actual points and the regression line. 
par(mfrow=c(1,1))

plot(galton$parent,lm1$residuals,col="blue",pch=19)
abline(c(0,0),col="red",lwd=3)


# ---------------------------------------------------------------
# Multiple Linear regression
# ---------------------------------------------------------------

#install.packages("car")
library(car)

data(Prestige)       # Prestige of Canadian occupations

dim(Prestige)        
# [1] 102   6

? Prestige          # Data dictionary

summary(Prestige)
#  education          income          women           prestige    
#Min.   : 6.380   Min.   :  611   Min.   : 0.000   Min.   :14.80  
#1st Qu.: 8.445   1st Qu.: 4106   1st Qu.: 3.592   1st Qu.:35.23  
#Median :10.540   Median : 5930   Median :13.600   Median :43.60  
#Mean   :10.738   Mean   : 6798   Mean   :28.979   Mean   :46.83  
#3rd Qu.:12.648   3rd Qu.: 8187   3rd Qu.:52.203   3rd Qu.:59.27  
#Max.   :15.970   Max.   :25879   Max.   :97.510   Max.   :87.20  
#    census       type   
#Min.   :1113   bc  :44  
#1st Qu.:3120   prof:31  
#Median :5135   wc  :23  
#Mean   :5402   NA's: 4  
#3rd Qu.:8312            
#Max.   :9517     

head(Prestige)
#                    education income women prestige census type
#gov.administrators      13.11  12351 11.16     68.8   1113 prof
#general.managers        12.26  25879  4.02     69.1   1130 prof
#accountants             12.77   9271 15.70     63.4   1171 prof
#purchasing.officers     11.42   8865  9.11     56.8   1175 prof
#chemists                14.62   8403 11.68     73.5   2111 prof
#physicists              15.64  11030  5.13     77.6   2113 prof

# ---------------------------------------------------------------
# Remove observations with type variable NAs
Prestige_noNA <- na.omit(Prestige)

# ---------------------------------------------------------------
# Split data set into training set and test set
n <- nrow(Prestige_noNA)  # Number of observations = 98
ntrain <- round(n*0.6)    # 60% for training set
set.seed(314)             # Set seed for reproducible results
tindex <- sample(n, ntrain) # Create an index

trainPrestige <- Prestige_noNA[tindex,]  # Create training set
testPrestige <- Prestige_noNA[-tindex,]  # Create test set

# Exploratory data analysis
plot(trainPrestige$prestige, trainPrestige$education) #Trend
plot(trainPrestige$prestige, trainPrestige$income) #No trend
plot(trainPrestige$prestige, trainPrestige$women) #No trend

# ---------------------------------------------------------------

# Train linear model to predict prestige score using all other 
# predictors. We can use the categorical variable "type" which 
# results in 2 dummy variables "typeprof" and "typewc"

lm2 <- lm(prestige~., data=trainPrestige)
summary(lm2)
#Call:
#  lm(formula = prestige ~ ., data = trainPrestige)
#
#Residuals:
#     Min       1Q   Median       3Q      Max 
#-13.7864  -4.0290   0.8807   4.5369  16.9482 
#
#Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
#(Intercept) -1.544e+01  9.901e+00  -1.560  0.12492    
#education    4.562e+00  8.320e-01   5.483 1.24e-06 ***
#income       9.607e-04  3.204e-04   2.999  0.00415 ** 
#women        7.252e-03  4.543e-02   0.160  0.87379    
#census       1.031e-03  7.390e-04   1.396  0.16876    
#typeprof     5.981e+00  5.773e+00   1.036  0.30495    
#typewc      -1.137e+00  3.962e+00  -0.287  0.77531    
#---
#Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
#Residual standard error: 7.145 on 52 degrees of freedom
#Multiple R-squared:  0.8406,  Adjusted R-squared:  0.8222 
#F-statistic: 45.71 on 6 and 52 DF,  p-value: < 2.2e-16

# ---------------------------------------------------------------
# The predicted vs. residual plot confirm a good distribution
plot(lm2$fitted, lm2$residuals)

# ---------------------------------------------------------------
# Plot by index (row of data set)
# Note: there seems to be NO trend based on row #
plot(lm2$residuals,pch=19)    # Index plot shows no trend

# ---------------------------------------------------------------
# Use the trained model to predict the output of test set
predict2 <- predict(lm2, newdata=testPrestige)  # length=39

# ---------------------------------------------------------------
# Check correlation between predicted and actual test set response values 
cor(predict2, testPrestige$prestige)
#[1] 0.8937996          # Very high correlation 

# ---------------------------------------------------------------
# QQ plot for residuals: shows if residuals are normally distributed.
# Good if residuals are close to straight line
rs <- residuals(lm2)
qqnorm(rs)      # Quantile-quantile plot
qqline(rs)

# ---------------------------------------------------------------
# Plot predicted vs. actual in test set
# Use type to explore a post mortem of the analysis
plot(testPrestige$prestige,predict2, pch=c(testPrestige$type))
legend('topleft', legend=c("bc", "prof", "wc"), pch=c(1,2,3), bty='o')

# ---------------------------------------------------------------
# Measuring model performance using RMSE (root mean squared error)

# Define user-defined function for calculating RMSE which shows
# how well the algorithm was able to estimate the response variable.
# In statistics terms, RMSE is the standard deviation of the 
# residuals (prediction errors). Residuals are a measure of how 
# far from the regression line data points are; RMSE is a measure 
# of how spread out these residuals are. In other words, it tells 
# you how concentrated the data is around the line of best fit.
# Lower values of RMSE indicate better fit.

# Example, if you're predicting home prices, the RMSE will 
# indicate how far off your predictions will be in dollars.
# So for homes in 100s of thousands of $, a RMSE of $1,000 would
# be excellent.

rmse <- function(y_hat, y)
{
  return(sqrt(mean((y_hat-y)^2)))
}

# The RMSE for your training and your test sets should be very 
# similar if you have built a good model. If the RMSE for the 
# test set is much higher than that of the training set, it is 
# likely that you've badly over fit the data, i.e. you've 
# created a model that tests well in sample, but has little 
# predictive value when tested out of sample.

# In our case below, the training RSME and test RSME are similar.

# ---------------------------------------------------------------
# Calculate RMSE for training set
rmse_train <- rmse(predict(lm2),trainPrestige$prestige)
rmse_train
# [1] 6.54328

# ---------------------------------------------------------------
# Calculate RMSE for test set
rmse_test <- rmse(predict(lm2, newdata=testPrestige), 
                  testPrestige$prestige)
rmse_test
# [1] 7.539384

# ---------------------------------------------------------------
# Define a user-defined function for calculating R-squared.
# Value of R-squared is between 0-1 where closer to 1 means
# the regression model is good. 
rsquared <- function(y_hat, y){
  mu <- mean(y)
  rse <- mean((y_hat - y)^2) / mean((mu - y)^2)
  rsquared <- (1 - rse) * 100   # Return a percentage!
  return(rsquared)
}

# ---------------------------------------------------------------
# Calculate TRAINING SET error metrics

y_hat <- lm2$fitted.values   # y-hat: predicted response values
y <- trainPrestige$prestige  # y: actual response values
rsquared(y_hat, y)           # R-squared for training set
# [1] 84.43107               # 0.8443107 is close to 1

# A different way to calculate training RMSE
rmse_train <- (mean((y_hat - y)^2))^0.5   # RMSE for training set
rmse_train
#[1] 6.54328

# Calculate training R-squared
mu <- mean(y)
rse <- mean((y_hat - y)^2) / mean((mu - y)^2)  # RSE for training set
rse
#[1] 0.1556893

rsquared_calc <- 1 - rse      # R-squared again
rsquared_calc
#[1] 0.8443107

# ---------------------------------------------------------------
# Calculate TEST SET error metrics

y_hat <- predict(lm2, newdata=testPrestige) # y-hat
y <- testPrestige$prestige                  # y
rsquared(y_hat, y)                          # R-squaured for test set
#[1] 77.60012

rmse_test <- (mean((y_hat - y)^2))^0.5      # RMSE for test set
rmse_test
#[1] 7.539384

mu <- mean(y)
rse <- mean((y_hat - y)^2) / mean((mu - y)^2)   # RSE for test set
rse
#[1] 0.2239988

rsquared_calc <- 1 - rse        # R-squared for test set again
rsquared_calc
#[1] 0.7760012

# Also Adjusted R-squared - a harsher judge of accuracy, meaning we
# can be more confident in our regression fit.

# ---------------------------------------------------------------
# Display linear regression series of 4 diagnostic plots
# See class slides for GOOD/BAD samples and descriptions
plot(lm2)


# ---------------------------------------------------------------
# Classification - Logistic Regression
# ---------------------------------------------------------------

data(iris)

# ---------------------------------------------------------------
# Split data set into training set and test set
n <- nrow(iris)  # Number of observations
ntrain <- round(n*0.6)  # 60% for training set
set.seed(314)    # Set seed for reproducible results
tindex <- sample(n, ntrain)   # Create an index

train_iris <- iris[tindex,]   # Create training set
test_iris <- iris[-tindex,]   # Create test set

# ---------------------------------------------------------------
# Create new binary categorical variable
newcol <- data.frame(isVersicolor=(train_iris$Species=="versicolor"))

# Combine iris and binary var
train_iris <- cbind(train_iris, newcol)   
head(train_iris)
#    Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#71           5.9         3.2          4.8         1.8 versicolor
#13           4.8         3.0          1.4         0.1     setosa
#145          6.7         3.3          5.7         2.5  virginica
#84           6.0         2.7          5.1         1.6 versicolor
#3            4.7         3.2          1.3         0.2     setosa
#105          6.5         3.0          5.8         2.2  virginica
#    isVersicolor
#71          TRUE
#13         FALSE
#145        FALSE
#84          TRUE
#3          FALSE
#105        FALSE

# ---------------------------------------------------------------
# Single predictor:

# Use logistic regression to predict Versicolor class
# Must use family=binomial for logistic regression (logit model)
glm1 <- glm(isVersicolor ~ Sepal.Width, 
            data=train_iris, 
            family=binomial)
glm1
# Call:  glm(formula = isVersicolor ~ Sepal.Width, family = binomial, 
#     data = train_iris)
#
# Coefficients:
# (Intercept)  Sepal.Width  
#       8.774       -3.141  
#
# Degrees of Freedom: 89 Total (i.e. Null);  88 Residual
# Null Deviance:	    115.9 
# Residual Deviance: 93.41 	AIC: 97.41

summary(glm1)
# Call:
# glm(formula = isVersicolor ~ Sepal.Width, family = binomial, 
#    data = train_iris)
#
# Deviance Residuals: 
#     Min       1Q   Median       3Q      Max  
# -1.9933  -0.8609  -0.4757   0.9359   2.1143  
#
# Coefficients:
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept)   9.1013     2.5534   3.564 0.000365 ***
# Sepal.Width  -3.3010     0.8656  -3.813 0.000137 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
# (Dispersion parameter for binomial family taken to be 1)
#
#     Null deviance: 113.136  on 89  degrees of freedom
# Residual deviance:  90.326  on 88  degrees of freedom
# AIC: 94.326
#
# Number of Fisher Scoring iterations: 5

# ---------------------------------------------------------------
# Bi-modal plot for Sepal.Width vs. isVericolor
plot(train_iris$Sepal.Width, train_iris$isVersicolor)

# ---------------------------------------------------------------
# Add S-shaped "sigmoid" function to plot which shows the 
# dichotomist nature of the algorithm. Notice how the y-axis 
# shows values of isVersicolor between 0 and 1, thus representing 
# the probabilities for different values in the training set 
# for Sepal.Width
curve(predict(glm1, data.frame(Sepal.Width=x), type="response"), 
      add=TRUE) 

# ---------------------------------------------------------------
# Predict single new observation, Sepal.Width=2.4
# Here, the probability is 77% that the response variable is species
# Versicolor
newdata <- data.frame(Sepal.Width=2.4)

# Probability Species is Versicolor
predict.glm(glm1, newdata, type="response") 
#        1 
#0.7749088

# ---------------------------------------------------------------
# Multiple predictors:

formula <- isVersicolor ~Sepal.Length + Sepal.Width + Petal.Length + Petal.Width

glm2 <- glm(formula, data=train_iris, family="binomial")

# Notice the smallest p-value is associated with Sepal.Width, 
# meaning there is an association between Sepal.Width and 
# isVersicolor.
summary(glm2)
#Call:
#  glm(formula = formula, family = "binomial", data = train_iris)
#
#Deviance Residuals: 
#  Min       1Q   Median       3Q      Max  
#-2.0732  -0.7529  -0.4250   0.9386   2.2185  
#
#Coefficients:
#             Estimate Std. Error z value Pr(>|z|)   
#(Intercept)    5.9490     3.3423   1.780  0.07509 . 
#Sepal.Length   0.4966     0.8340   0.595  0.55156   
#Sepal.Width   -3.2680     1.0456  -3.125  0.00178 **
#Petal.Length   0.5930     0.7837   0.757  0.44920   
#Petal.Width   -1.7861     1.3396  -1.333  0.18241   
#---
#  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
#(Dispersion parameter for binomial family taken to be 1)
#
#    Null deviance: 113.136  on 89  degrees of freedom
#Residual deviance:  87.066  on 85  degrees of freedom
#AIC: 97.066
#
#Number of Fisher Scoring iterations: 5

# ---------------------------------------------------------------
coef(glm2)
#(Intercept) Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#5.9489966    0.4966006   -3.2679800    0.5930357   -1.7861451 

# ---------------------------------------------------------------
summary(glm2)$coef
#               Estimate Std. Error    z value    Pr(>|z|)
#(Intercept)   5.9489966  3.3422812  1.7799211 0.075088880
#Sepal.Length  0.4966006  0.8340266  0.5954254 0.551559180
#Sepal.Width  -3.2679800  1.0456208 -3.1253970 0.001775653
#Petal.Length  0.5930357  0.7836647  0.7567467 0.449201602
#Petal.Width  -1.7861451  1.3395827 -1.3333593 0.182413915

# ---------------------------------------------------------------
# Once trained, we can use the model to make predictions for the
# test set. The type argument value "response" tells R to 
# output probabilities that the response is 1 given the predictors.
prob <- predict(glm2, newdata=test_iris, type="response")
prob <- round(prob,3)*100   # Get percentages
prob
#   4   10   11   12   16   20   21   22   23   24   27   38   40   49   59 
#23.1 26.8  3.9 14.9  0.3  2.6 11.6  2.0  2.6  4.9  5.3  8.9  9.1  4.3 64.2 
#  60   61   66   67   68   74   80   82   86   88   90   92   94   95   96 
#47.8 91.5 27.9 51.9 85.9 88.2 61.6 83.5 16.7 82.8 69.0 59.0 76.9 69.8 64.5 
#  98   99  100  101  102  103  107  108  115  116  117  120  121  123  125 
#53.4 35.3 56.5 13.3 56.2 41.3 69.4 90.0  8.7  6.2 63.3 94.0 11.1 89.8 24.0 
# 129  130  132  133  134  135  138  140  142  143  144  145  148  149  150 
#47.4 84.2 28.5 35.9 81.5 98.1 60.5 14.9  2.9 56.2 19.1  4.5 22.6  6.5 50.2 


# ---------------------------------------------------------------
# Classification - Logistic Regression with ROC Curves
# ---------------------------------------------------------------

# The following function calculates a Receiver Operating
# Characteristics (ROC) curve from predicted probabilities 
# and the ground truth. This function is somewhat complex, 
# so don't worry if you don't understand how it works. 
# Below you will learn how to use this function to generate ROC 
# curves from the fitted model.

calc_ROC <- function(probabilities, known_truth, model.name=NULL)
{
  outcome <- as.numeric(factor(known_truth))-1
  pos <- sum(outcome) # total known positives
  neg <- sum(1-outcome) # total known negatives
  pos_probs <- outcome*probabilities # probabilities for known positives
  neg_probs <- (1-outcome)*probabilities # probabilities for known negatives
  true_pos <- sapply(probabilities,
                     function(x) sum(pos_probs>=x)/pos) # true pos. rate
  false_pos <- sapply(probabilities,
                      function(x) sum(neg_probs>=x)/neg)
  if (is.null(model.name))
    result <- data.frame(true_pos, false_pos)
  else
    result <- data.frame(true_pos, false_pos, model.name)
  result %>% arrange(false_pos, true_pos)
}

# ---------------------------------------------------------------
#install.packages("dplyr")
library(dplyr)
#install.packages("ggplot2")
library(ggplot2)
attach(iris)

# ---------------------------------------------------------------
# Make a reduced iris data set that only contains virginica 
# and versicolor species
# filter() comes from dplyr
iris_small <- filter(iris, Species %in% c("virginica", "versicolor"))
dim(iris_small)
#[1] 100   5

# -------------------------------------------------------------
# Example of using the calc_ROC() function
glm1 <- glm(Species ~ Petal.Width,
               data = iris_small,
               family = binomial)
# calc_ROC() with:
# probabilities arg: predicted probabilities
# known_truth arg: the known truth, i.e. true species assignment
# model.name arg: an arbitrary name to distinguish different ROC curves 
ROC1 <- calc_ROC(probabilities=glm1$fitted.values, 
                 known_truth=iris_small$Species,      
                 model.name="Petal.Width")            
head(ROC1)
#true_pos false_pos  model.name
#1     0.06         0 Petal.Width
#2     0.06         0 Petal.Width
#3     0.06         0 Petal.Width
#4     0.12         0 Petal.Width
#5     0.12         0 Petal.Width
#6     0.12         0 Petal.Width

class(ROC1)
#[1] "data.frame"

# -------------------------------------------------------------
# Now make a few additional models, calculate ROC curves for them, 
# and then make a plot showing the various ROC curves in one graph.
glm1 <- glm(Species ~ Sepal.Width,
            data = iris_small,
            family = binomial)
ROC2 <- calc_ROC(probabilities=glm1$fitted.values,
                 known_truth=iris_small$Species,
                 model.name="Sepal.Width")

glm1 <- glm(Species ~ Petal.Length,
            data = iris_small,
            family = binomial)
ROC3 <- calc_ROC(probabilities=glm1$fitted.values,
                 known_truth=iris_small$Species,
                 model.name="Petal.Length")

glm1 <- glm(Species ~ Petal.Width + Petal.Length + Sepal.Width,
               data = iris_small,
               family = binomial)
ROC4 <- calc_ROC(probabilities=glm1$fitted.values,
                 known_truth=iris_small$Species,
                 model.name="combined")

# -------------------------------------------------------------
# Display ROC curve
ggplot(data=NULL, aes(x=false_pos, y=true_pos)) +
  geom_line(data=ROC1, aes(color=model.name)) +
  geom_line(data=ROC2, aes(color=model.name)) +
  geom_line(data=ROC3, aes(color=model.name)) +
  geom_line(data=ROC4, aes(color=model.name))

# -------------------------------------------------------------
# Calculate the area under the ROC curve (AUC) for the first 
# model (stored previously in the variable ROC1). (Hint: the 
# function lag() makes this calculation very easy.)
#
# NOTE: the higher the AUC, the better the model is at making predictions

ROC1 %>% mutate(delta=false_pos-lag(false_pos)) %>% 
  summarize(AUC=sum(delta*true_pos, na.rm=T))
# 1 0.9888

# Combine all ROCs into one big table
ROCs <- rbind(ROC1, ROC2, ROC3, ROC4)

# Calculate AUCs
ROCs %>% group_by(model.name) %>% 
  mutate(delta=false_pos-lag(false_pos)) %>%
  summarize(AUC=sum(delta*true_pos, na.rm=T)) %>%
  arrange(desc(AUC))
# A tibble: 4 x 2
#model.name     AUC
#<fct>        <dbl>
#1 combined     0.997
#2 Petal.Width  0.989
#3 Petal.Length 0.988
#4 Sepal.Width  0.710


# -------------------------------------------------------------
# Classification - Random Forests
# -------------------------------------------------------------

# Random Forests is a tree-based machine learning algorithm
# It is also considered an "ensemble" method because it uses
# a set of classification trees that are calculated on random
# subsets of the data.

# Random Forests also can be used for regression. 

#install.packages("randomForest")
library(randomForest)

data(iris)

# ---------------------------------------------------------------
# Split data set into training set and test set
n <- nrow(iris)  # Number of observations
ntrain <- round(n*0.6)  # 60% for training set
set.seed(314)    # Set seed for reproducible results

tindex <- sample(n, ntrain)   # Create an index

train_iris <- iris[tindex,]   # Create training set
test_iris <- iris[-tindex,]   # Create test set

# ---------------------------------------------------------------
# Train randomForest to predict Species using all predictors
rf <- randomForest(Species~., data=train_iris, ntree=500, 
                   mtry=2, importance=TRUE)

# ---------------------------------------------------------------
# Using trained model rf, predict test set response values
prediction <- predict(rf, newdata=test_iris, type="class")

# ---------------------------------------------------------------
# Print "confusion matrix" with the actual test set response values
# along with the predicted values using the fitted model "prediction"
table(prediction, test_iris$Species)
# prediction   setosa versicolor virginica
# setosa           14          0         0
# versicolor        0         19         5
# virginica         0          0        22

# ---------------------------------------------------------------
# calculate misclassification error rate
misclassification_error_rate <- sum(test_iris$Species != prediction) / 
  nrow(test_iris)*100
misclassification_error_rate   # 8.3% is pretty good error rate
#[1] 8.333333

# ---------------------------------------------------------------
# The "importance" component of rf contains a matrix with a number 
# of columns equal to the number of CLASSES +2, so 5 columns for 
# iris.
# Cols 1-3: class-specific measures computed as mean decrease in 
#           accuracy
# Col 4   : is the mean decrease in accuracy over all classes
# Col 5   : is the mean decrease in Gini index (a measure of total 
#           variance across classes in the model)
importance(rf)
#                 setosa   versicolor   virginica MeanDecreaseAccuracy
#Sepal.Length 0.04522895  0.021642010 0.071957664          0.046288212
#Sepal.Width  0.00523258 -0.003301299 0.006098693          0.002920681
#Petal.Length 0.31637557  0.290288009 0.354026892          0.316221928
#Petal.Width  0.30126501  0.249734399 0.286229751          0.275835179
#             MeanDecreaseGini
#Sepal.Length         6.852732
#Sepal.Width          1.407675
#Petal.Length        27.888180
#Petal.Width         23.093445

# ---------------------------------------------------------------
# Printing the rf object offers a summary of the analysis, 
# specifically the so-called OOB (out-of-bag) error rate for all
# observations and the three classes.
# OOB error rate of 6.67% is pretty good.
print(rf)
#Call:
#  randomForest(formula = Species ~ ., data = train_iris, ntree = 500, mtry = 2, importance = TRUE) 
#                Type of random forest: classification
#                      Number of trees: 500
#No. of variables tried at each split: 2
#
#        OOB estimate of  error rate: 6.67%
#Confusion matrix:
#           setosa versicolor virginica class.error
#setosa         30          0         0  0.00000000
#versicolor      0         26         3  0.10344828
#virginica       0          3        28  0.09677419

# ---------------------------------------------------------------
# varImpPlot() provides a dot chart of variable importance as 
# measured by Random Forest - which variables are important and
# which are weak. We see that Petal.Width and Petal.Length
# are most important. 
varImpPlot(rf)

# ---------------------------------------------------------------
# Variables used in a Random Forest
# Find out which predictors are actually used in the Random Forest.
# Function returns an integer vector containing frequencies that
# variables are used in the forest. Below rank order is:
# Petal.Length (447)
# Petal.Width (236)
# Sepal.Length (774)
# Sepal.Width (816) WINNER!
varUsed(rf, by.tree=FALSE, count=TRUE)
#[1] 447 236 774 816







