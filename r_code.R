#Group_Project: Data Analytics Project: Clustering Socio-Economic Profiles of Countries
#Preparation: Set up 
install.packages(c("dplyr", "ggplot2", "factoextra", "cluster", "corrplot", "moments"))
library(dplyr)
library(ggplot2)
library(factoextra)
library(cluster)
library(corrplot)
library(moments)
install.packages("readxl")
library(readxl)
install.packages("rstatix")
library(rstatix)

options(scipen = 999) #To not use scientific numbers.
library(tidyr)

#Part 1: Data Preparation and Exploration (20%)
#Load and inspect the data set
df <- read_excel("Country-data.xlsx")
dim(df)
head(df)

#Check for missing values
missing_rows <- df[!complete.cases(df), ]
print("Rows with missing values:")
print(missing_rows)

#Check for duplicates
duplicate_count <- length(which(duplicated(df)))
print(paste("Total duplicate rows:", duplicate_count))

#Generate summary statistics and visualizations (histograms, box plots)
summary(df)

#histogram: see the skewness & distribution
df_long <- df %>%
  select(-country) %>%
  pivot_longer(cols = everything(),
               names_to = "variable",
               values_to = "value") %>%
  mutate(group = case_when(
    variable %in% c("health", "life_expec", "child_mort", "total_fer") ~ "Health",
    TRUE ~ "Finance"
  ))

ggplot(df_long, aes(x = value, fill = group)) +
  geom_histogram(color = "white", bins = 30) +
  facet_wrap(~variable, scales = "free") +
  theme_minimal() +
  labs(title = "Distribution of Variables",
       x = "Value",
       y = "Frequency") +
  scale_fill_manual(values = c(
    "Health" = "#2ca02c",
    "Finance" = "#1f77b4"
  )) +
  theme(legend.position = "none")

#box plot: see the outliers & median
ggplot(df_long, aes(x = value, fill = group)) +
  geom_boxplot(alpha = 0.7) +
  facet_wrap(~variable, scales = "free") +
  theme_light() +
  labs(title = "Boxplots of Variables",
       y = "Value") +
  scale_fill_manual(values = c(
    "Health" = "#2ca02c",
    "Finance" = "#1f77b4"
  )) +
  theme(legend.position = "none",
        strip.text = element_text(face = "bold"))

#Analyze skewness and correlation among variables
numeric_data <- df[, sapply(df, is.numeric)]
cor_matrix <- cor(numeric_data, use = "complete.obs")
print(cor_matrix)

#Part 2: Data Wrangling (10%)
#Drop country and GDP from clustering input
df_cluster <- subset(df, select = -c(country, gdpp))

#Scale the remaining variables using z-score normalization
df_scaled <- scale(df_cluster)
df_scaled <- as.data.frame(df_scaled)
head(df_scaled)
summary(df_scaled)

#Part 3: Clustering Analysis (50%)
#1. K-Means Clustering
#Use Elbow Method and Silhouette Score to determine optimal number of clusters
set.seed(1)
fviz_nbclust(df_scaled, pam, method = "wss") +
  labs(title = "Elbow Method")

# Silhouette Score 
fviz_nbclust(df_scaled, pam, method = "silhouette") +
  labs(title = "Silhouette Score")

k_optimal <- 2
kResult <- pam(df_scaled, k = k_optimal)
print(kResult$medoids)

#Assign cluster labels and analyze cluster profiles
df$PAM_Cluster <- as.factor(kResult$clustering)

summary(subset(df, PAM_Cluster == 1))
summary(subset(df, PAM_Cluster == 2))

#Visualize clusters using box plots and scatter plots
#Box plot: see the difference of each clusters income
df_long <- df %>%
  select(-country) %>%
  pivot_longer(cols = -PAM_Cluster,
               names_to = "variable",
               values_to = "value")

ggplot(df_long, aes(x = PAM_Cluster, y = value, fill = PAM_Cluster)) +
  geom_boxplot(alpha = 0.7) +
  facet_wrap(~variable, scales = "free") +
  theme_minimal() +
  labs(title = "Cluster Comparison Across All Variables",
       x = "Cluster",
       y = "Value") +
  theme(legend.position = "none",
        strip.text = element_text(face = "bold"))

#Scatter plot:
plot(kResult)

#2. Hierarchical Clustering
#caculate the distance matrix
d <- dist(df_scaled, method = "euclidean")
#Use AGNES (Agglomerative Hierarchical Clustering)
aResult <- agnes(d, diss = TRUE, method = "ward")
print(aResult)

#Generate a dendrogram and determine the number of clusters
plot(aResult)

#create cluster (k=2)
aClusters <- cutree(aResult, k = 2)

#Append cluster membership
df$aClusters <- as.factor(aClusters)

##Analyze cluster profiles
summary(as.factor(df$aClusters))

summary(subset(df, aClusters == 1))
summary(subset(df, aClusters == 2))

#Compare cluster profiles with K-Means results
comparison_table <- table(df$PAM_Cluster, df$aClusters)
print(comparison_table)

#3. Principal Component Analysis
#Apply PCA to reduce dimensionality
pca_res <- prcomp(df_scaled)
summary(pca_res)

#see the PCA's weights, to see which metric has more impact on PC1, PC2...
pca_res$rotation

pca_df <- as.data.frame(pca_res$x)

stopifnot(nrow(pca_df) == nrow(df))
pca_df$PAM_Cluster <- df$PAM_Cluster

head(pca_df)

#Visualize clusters in 2D using principal components
ggplot(pca_df, aes(x = PC1, y = PC2, color = PAM_Cluster)) +
  geom_point(size = 3, alpha = 0.8) +
  stat_ellipse(level = 0.95, linetype = 2) + 
  theme_minimal() +
  labs(title = "2D PCA Plot of Clusters (PAM Method)",
       subtitle = "Visualizing multidimensional national data in two principal components",
       x = "Principal Component 1 (PC1)",
       y = "Principal Component 2 (PC2)",
       color = "Cluster")
