# MODULE 10 - Unsupervised Machine Learning
#
# (c) Copyright 2015-2019 - AMULET Analytics
# ---------------------------------------------------------------


# EDA on small simulated data set 

set.seed(1234)    # Seed, for reproducible results

par(mar=c(5,5,5,5))   # Set margin, c(bottom,left,top,right)

# Create a simulated data set
# Actually two vectors x, y for coordinates of plot
# Using mean and sd args we have created 3 clusters

# NOTE: experiment with different mean and sd to see effect!
x <- rnorm(12,mean=rep(1:3,each=4),sd=0.2)
x

y <- rnorm(12,mean=rep(c(1,2,1),each=4),sd=0.2)
y

# Scatterplot of data
plot(x,y,col="blue",pch=19,cex=2)

# Display integer labels (12) to the upper-right of the dot
text(x+0.05,y+0.05,labels=as.character(1:12))

# -------------------------------------------------------
# Hierarchical clustering with simulated data set

# Hierarchical clustering is an agglomerative (bottom-up)
# approach toward the clustering process. It compares all 
# pairs of data points and then merges the pairs with the 
# closest distance. 

df <- data.frame(x=x, y=y)   # Create 12x2 data frame

# Calculate distance between points. dist() is just for clustering.
# The top part of the rectangle of values is not include since it
# will be the same as the bottom part. The diagnoal of the matrix
# is not shown since the distance between any point and itself is 0.
distxy <- dist(df)   # Default distance method = euclidean metric
distxy

class(distxy)
#[1] "dist"

#distxy <- dist(df, method="minkowski")   # other distance measures!


# Produce cluster object
hClustering <- hclust(distxy, method="complete")  # hclust requires a dist object, returns hclust object
class(hClustering)
#[1] "hclust"

# Plot "dendrogram" showing 3 clusters
plot(hClustering)   

# Cut the tree high yields fewer clusters at height 1.5
cutree(hClustering,h=1.5)   # Will yield fewer clusters
# [1] 1 1 1 1 2 2 2 2 3 3 3 3

# Cut the tree low at height 0.5
cutree(hClustering,h=0.5)   # Will yield more clusters
# [1] 1 2 2 1 3 3 3 4 5 5 5 5


# -------------------------------------------------------
# Visualizing hierarchical clustering using a Heatmap

dataFrame <- data.frame(x=x, y=y)
set.seed(143)

# Take a small sample of the rows. Each sample() returns different random seq
dataMatrix <- as.matrix(dataFrame)[sample(1:12),]  # 12x2

# Clusters together the rows and columns
heatmap(dataMatrix)   # heatmap() requires matrix argument

# Another style of heatmap
library(gplots)
heatmap.2(dataMatrix)

# ---------------------------------------------------------------

# Use kmeans() algorithm

# Partitioning approach as opposed to an agglomerative approach.
# A partitioning approach starts with all of the data points and
# tries to divide them into a fixed number of clusters. 

# K-means clustering algorithm:
# Specify starting centroids
# Assign to closest centroid
# Recalculate centroids
# Reassign values
# Update centroids

dataFrame <- data.frame(x,y)

# You choose 3 centroids
# YOu can also define the max # of iterations the algorithm is to 
# perform just in case it doesn't converge. Defaults for iter.max is 10
kmeansObj <- kmeans(dataFrame,centers=3)

names(kmeansObj)   # List components of the kmeans object
#[1] "cluster"      "centers"      "totss"        "withinss"    
#[5] "tot.withinss" "betweenss"    "size"         "iter"        
#[9] "ifault" 

# Which cluster each data point has been assigned to. 
kmeansObj$cluster    # Grouping numbers of data points
#[1] 3 3 3 3 1 1 1 1 2 2 2 2

# K-means is not a deterministic algorithm. If you use the 
# exact same data set with different starting centroids, 
# it may converge to a different set of clusters. So you 
# can use the nstart arg to take an average. 

# Datavis for clusters

#par(mar=rep(0.2,4))    # Set margins

# Use col arg for coloring clusters
# Use pch for the plot symbol to use (use ? pch)
# Use cex for symbol magnification (default 1)
plot(x,y,col=kmeansObj$cluster,pch=19,cex=2)

# Use centers component of kmeans object - matrix of cluster centers
kmeansObj$centers    # 3x2 matrix: x column, y column
#          x        y
#1 1.8483752 2.132128
#2 2.9344135 1.033810
#3 0.9785004 1.051081

# pch=3 is a "+" symbol, and cex=3 magnifies it. 
# lwd arg is for line width for drawing symbols
points(kmeansObj$centers,col=1:3,pch=3,cex=3,lwd=3)




