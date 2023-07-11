# K-Means-Clustering--Wine-Dataset

## Introduction 

- This data set consists of the results of a chemical analysis of wines grown in the same region in Italy but derived from three different cultivators
  
- The analysis determined the quantities of 13 constituents found in each of the three types of wines
  
- Number of samples: 178

|Dataset Attributes||
|---|---|
|1) Alcohol |2) Malic acid|
|3) Ash |4) Alcalinity of ash|
|5) Magnesium |6) Total phenols|
|7) Flavanoids |8) Nonflavanoid phenols|
|9) Proanthocyanins |10) Color intensity|
|11) Hue |12) OD280/OD315 of diluted wines|
|13) Proline| |


## Problem Definition

- Understand the different constituents and their proportion in wine used by each cultivator

- Reveal the presence of clusters in the wine dataset and check if 3 cultivators are distinguishable in the dataset


### Loading libraries
```
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
```

# Working

## Checking for missing values
```
wine1<- na.omit(wine)
dim(wine1)
```
#### 178 rows and 14 columns 

## Remove the first column because we do not want the type of the wine scaled
```
wine1 <- scale(wine[-1])
wine1
dim(wine1)
head(wine1)
```
#### 178 rows and 13 columns

## Plot the Graph
```
distance<- get_dist(wine1)
distance
fviz_dist(distance, gradient=list(low="blue", mid="white",high="red"))
```

![](https://github.com/mitaliwadher/K-Means-Clustering--Wine-Dataset/blob/main/assets/Distance%20Graph)

## Performing K-Means
```
cluster_wine2<- kmeans(wine1, centers=2, nstart= 25)
cluster_wine3<- kmeans(wine1, centers=3, nstart= 25)
cluster_wine4<- kmeans(wine1, centers=4, nstart= 25)
cluster_wine5<- kmeans(wine1, centers=5, nstart= 25)

c2<- fviz_cluster(cluster_wine2, geom="point", data= wine1)+ggtitle("clusters=2")
c3<- fviz_cluster(cluster_wine3, geom="point", data= wine1)+ggtitle("clusters=3")
c4<- fviz_cluster(cluster_wine4, geom="point", data= wine1)+ggtitle("clusters=4")
c5<- fviz_cluster(cluster_wine5, geom="point", data= wine1)+ggtitle("clusters=5")

grid.arrange(c2, c3, c4, c5,  nrow=2)
```
![](https://github.com/mitaliwadher/K-Means-Clustering--Wine-Dataset/blob/main/assets/3.png)

#### 3 clusters are optimal because in clusters more than 3, there is overlapping which is not optimal
#### Using 2 groups (K = 2) we had 28.3 % of well-grouped data. Using 3 groups (K = 3) that value raised to 44.8 %, which is a good value for us
```
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
```
![](https://github.com/mitaliwadher/K-Means-Clustering--Wine-Dataset/blob/main/assets/4.png)
#### Use 3 clusters as from this point onwards the total WCSS (Within Cluster Sum of Squares) doesn’t decrease significantly

```
attributes(cluster_wine3)
```
![](https://github.com/mitaliwadher/K-Means-Clustering--Wine-Dataset/blob/main/assets/5.png)
```
cluster_wine3$centers
```
![](https://github.com/mitaliwadher/K-Means-Clustering--Wine-Dataset/blob/main/assets/6.png)
```
table(wine$Wine,cluster_wine3$cluster)
```
![](https://github.com/mitaliwadher/K-Means-Clustering--Wine-Dataset/blob/main/assets/7.png)

#### Check for any mis- classifications in the original dataset and the optimal clusters. There are 6 records that have been mis-classified
#### Type 1 has no misclassifications
#### Type 2 of the wine there are 3 missclassifications
#### Type 3 has no misclassifications

## Check for correlation between the variables
```
ggcorrplot(cor(wine1), hc.order = TRUE, type = "lower", lab = TRUE, insig = "blank")
```

![](https://github.com/mitaliwadher/K-Means-Clustering--Wine-Dataset/blob/main/assets/9.png)

#### We see that there is high correlation between Flavanoids and Phenols

## Perform k-means clustering with k = 3 clusters
```
cluster_wine3 <- kmeans(wine1, centers = 3, nstart = 25)
cluster_wine3
```
#### 385.6983, 558.6971, 326.3537
#### (between_SS / total_SS =  48.4 %)
#### Data is divided into 3 clusters
```
aggregate(wine1, by=list(cluster=cluster_wine3$cluster), mean)
```
![](https://github.com/mitaliwadher/K-Means-Clustering--Wine-Dataset/blob/main/assets/8.png)

#### There are 3 optimal clusters after running all the tests

# Observations

## Cluster 1
- High content- Proline, Flavanoids, Phenols, Alcohol and OD
- Low content- Malic acid, Non-Flavanoids Phenols and ACL
- Has the highest amount of chemicals
  
## Cluster 2
- Medium content- Hue, OD and ACL
- Low content- Malic acid, ACL and Non-Flavanoids Phenols
- Has the least amount of chemicals
  
## Cluster 3
- High content- Color Int, Malic acid, Non-Flavanoids Phenols and ACL
- Low content- Proanth, Phenols, Hue, Flavanoids and OD

# Interpretation 

- We can point out that one cultivator uses a high amount of alcohol and other cultivator uses small amount of alcohol which could mean that one is a highly alcoholic and the latter is less alcoholic
- We can conclude that all cultivators use different types of constituents in their wine making process and hence we have 3 definite clusters 
- Alcohol and Color Int are positively related so we can say that wines that have high alcohol content could have higher color and vica versa
- Alcohol and Ash are positively related to each other
- Flavanoids and Non-Flavanoids Phenols are negatively related to each other
- Mg and Phenols are positively related to each other
- ACL and Mg are negatively related to each other
- Malic Acid is negatively related to Flavanoids, Proanth and Hue but positively related to Non-Flavanoids Phenols
- Ash and Color int are positively related to each other
- Mg is negatively related to Proanth but positively related to Proline
- Phenols and Proline are positively related to each other
- Non-Flavanoids Phenols is negatively related to Hue, Flavanoids, Proanth and OD
- Proanth is positively related Hue but negatively related to Proline
- Hue and OD are positively related to each other
