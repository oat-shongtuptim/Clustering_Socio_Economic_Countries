# R_Project_Country_Clustering

R project to group countries by socio-economic and health indicators.

This project uses clustering to split 167 countries into groups with similar profiles. It shows how a company could choose which markets to enter, or how an NGO could target countries with similar needs instead of designing a program for each one.

> Full walkthrough is in the slide deck: [add link here]

## Database and Tools

- R (RStudio)
- Packages: `tidyverse`, `cluster`, `factoextra`
- Methods: K-Means (PAM), agglomerative hierarchical clustering (Ward), PCA
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

- `clustering.R`: full analysis, from data loading to validation
- `data/`: dataset
- `images/`: plots used in this README

## How to Run

1. Open `clustering.R` in RStudio.
2. Install the packages: `install.packages(c("tidyverse", "cluster", "factoextra"))`
3. Set the working directory to the project folder and run the script.

## Limitations

- Clusters describe this dataset only and reflect the indicators chosen.
- Silhouette scores are modest, so country groups overlap at the edges.

## Author

Thanapol Shongtuptim · [LinkedIn](https://www.linkedin.com/in/YOUR-PROFILE)
