# About this project

Started from a project for my class and now we're here.

This R project uses 2 clustering techniques, K-Means and Hierarchical Clustering, to group 167 countries based on similar profiles and compare which technique is more suitable for this dataset.

## Database and Tools

- R (RStudio)
- Packages: tidyverse, cluster, factoextra, dplyr, ggplot2, factoextra, cluster, corrplot, moments, readxl, rstatix, tidyr
- Methods: K-Means (PAM), Agglomerative Hierarchical Clustering, PCA
- Dataset: Country socio-economic data (167 countries, 9 indicators: child mortality, exports, health spending, imports, income, inflation, life expectancy, fertility, GDP per capita)

## Approach

1. **Explore the data.** Histograms and a correlation matrix show several skewed indicators and strong links between health and income.
2. **Prepare it.** Scale every indicator (z-score) so no single one dominates the distances.
3. **Choose the number of clusters.** Elbow and silhouette methods.
4. **Cluster two ways.** K-Means (PAM) and hierarchical clustering.
5. **Validate.** Compare the two methods and check the structure with PCA.

## Key Findings

- **2 clear clusters:** 69 less-developed and 98 more-developed countries.
- Both methods agree on **87%** of countries (146 of 167).
- The first two principal components capture **64%** of the variance, and the clusters separate clearly on the PCA plot.
- Typical profile (median): child mortality 64.4 vs 10.3, life expectancy 62.2 vs 76.4, GDP per capita $1,170 vs $11,600.
- **Why not more clusters?** At k = 4 the groups were weaker: average silhouette 0.20, only 67% agreement between methods, and one hierarchical group of just 3 outlier countries.

## Files

- dataset
- R code
- full report in PDF
- slide deck in PDF
