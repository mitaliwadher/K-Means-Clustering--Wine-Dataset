#Mitali Wadher
########## Wine Data Set Information############

#These data are the results of a chemical analysis of wines 
#grown in the same region in Italy but derived from three different cultivators.

#The analysis determined the quantities of 13 constituents 
#found in each of the three types of wines.
#Number of samples : 178
#Dataset Attributes:

#1) Alcohol
#2) Malic acid
#3) Ash
#4) Alcalinity of ash
#5) Magnesium
#6) Total phenols
#7) Flavanoids
#8) Nonflavanoid phenols
#9) Proanthocyanins
#10) Color intensity
#11) Hue
#12) OD280/OD315 of diluted wines
#13) Proline

######Libraries####
library(tidyverse) #data manipulation 
library(cluster)  #clustering algorithms 
library(factoextra) #clustering visualization
library(corrplot)
library(gridExtra)
library(GGally)
library(knitr)
library(leaps)
library(ggplot2)
library(reshape2)
library(MASS)
library(ggcorrplot)
library(plotmo)
library(gridExtra)

######Working####

#Read the data
wine <- read.csv("C:/Users/Mitali Wadher/OneDrive - Shri Vile Parle Kelavani Mandal/4- Predictive Analytics/wine.csv")
View(wine)


#Checking for missing values
wine1<- na.omit(wine)
dim(wine1)
#we have 178 values and 14 columns 

#we are removing the first column because we do not want the type of the wine scaled
wine1 <- scale(wine[-1])
wine1
dim(wine1)
head(wine1)
#we have 178 values and 13 columns

#Plotting the Graph
distance<- get_dist(wine1)
distance
fviz_dist(distance, gradient=list(low="blue", mid="white",high="red"))

#K-Means
cluster_wine2<- kmeans(wine1, centers=2, nstart= 25)
cluster_wine3<- kmeans(wine1, centers=3, nstart= 25)
cluster_wine4<- kmeans(wine1, centers=4, nstart= 25)
cluster_wine5<- kmeans(wine1, centers=5, nstart= 25)

c2<- fviz_cluster(cluster_wine2, geom="point", data= wine1)+ggtitle("clusters=2")
c3<- fviz_cluster(cluster_wine3, geom="point", data= wine1)+ggtitle("clusters=3")
c4<- fviz_cluster(cluster_wine4, geom="point", data= wine1)+ggtitle("clusters=4")
c5<- fviz_cluster(cluster_wine5, geom="point", data= wine1)+ggtitle("clusters=5")

grid.arrange(c2, c3, c4, c5,  nrow=2)
#We take 3 clusters because in clusters more than 3, there is overlapping which is not optimal

#Using 2 groups (K = 2) we had 28.3 % of well-grouped data. Using 3 groups (K = 3) 
#that value raised to 44.8 %, which is a good value for us.

set.seed(999)

#function to compute total within cluster sum of square 
wss<- function(k){kmeans(wine1, k, nstart=10)$tot.withinss}

#compute and plot wss for k=1 to k=15
k.values<- 1:15

#extract wss for 2-15 clusters
wss_values<- map_dbl(k.values, wss)
plot(k.values, wss_values,
     type="b",pch=19, frame=FALSE,
     xlab="Number of clusters k",
     ylab="Total within- clusters sum of squares")

#we could use 3 clusters, since from this point 
#onwards the total WCSS (Within Cluster Sum of Squares) 
#doesn’t decrease significantly.

attributes(cluster_wine3)
cluster_wine3$centers
table(wine$Wine,cluster_wine3$cluster)

#Type 1 has no misclassifications
#Type 2 of the wine there are 3 missclassifications
#Type 3 has no misclassifications

#to check for correlation between the variables
ggcorrplot(cor(wine1), hc.order = TRUE, type = "lower", lab = TRUE, insig = "blank")
#We see that there is high correlation between Flavanoids and Phenols

#perform k-means clustering with k = 3 clusters
cluster_wine3 <- kmeans(wine1, centers = 3, nstart = 25)

cluster_wine3
#385.6983, 558.6971, 326.3537
#(between_SS / total_SS =  48.4 %)
#we see that the data is divided into 3 clusters

aggregate(wine1, by=list(cluster=cluster_wine3$cluster), mean)


