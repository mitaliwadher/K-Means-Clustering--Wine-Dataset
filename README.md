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

![](https://github.com/mitaliwadher/K-Means-Clustering--Wine-Dataset/blob/main/assets/Distance Graph.png)

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
#### 3 clusters vare optimal because in clusters more than 3, there is overlapping which is not optimal
#### Using 2 groups (K = 2) we had 28.3 % of well-grouped data. Using 3 groups (K = 3) that value raised to 44.8 %, which is a good value for us.
![](https://github.com/mitaliwadher/K-Means-Clustering--Wine-Dataset/blob/main/assets/1.png)
