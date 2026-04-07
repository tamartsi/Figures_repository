README: Ridgeline Plots for Genetic Principal Components

OVERVIEW
This document describes three variations of ridgeline plots used to visualize
the distribution of genetic principal component 1 (PC1) across Hispanic/Latino
background groups.

These plots are derived from PCA performed on genotype data and are intended to
complement traditional scatter and pairs plots by highlighting distributional
differences across populations.

---------------------------------------------------------------------

DATA SOURCE

PC data file:
- DRAGEN_imputed_12PCs.csv

Grouping variable:
- gengrp6 (Hispanic/Latino background groups)

Background groups include:
- Dominican
- Central American
- Cuban
- Mexican
- Puerto Rican
- South American
- Other

---------------------------------------------------------------------

OBJECTIVE

The goal is to visualize how genetic structure varies across population
subgroups by examining the distribution of PC1.

Unlike scatter plots, ridgeline plots:
- Show full distributions
- Highlight shifts in central tendency
- Reveal overlap and heterogeneity between groups

---------------------------------------------------------------------

PLOTS INCLUDED

1) STANDARD RIDGELINE PLOT (DENSITY-BASED)

Description:
A smooth density-based ridgeline plot showing the distribution of PC1 across groups.

Key features:
- Uses kernel density estimation
- Emphasizes distribution shape and overlap
- Groups are ordered by median PC1 for interpretability

Interpretation:
- Separation between ridges indicates genetic differentiation
- Overlapping ridges indicate shared ancestry structure

---------------------------------------------------------------------

2) HISTOGRAM-STYLE RIDGELINE PLOT

Description:
A ridgeline plot using binned histograms instead of smoothed densities.

Key features:
- Uses stat = "binline"
- Displays discrete distribution structure
- Reduces smoothing assumptions

Interpretation:
- Useful for identifying skewness, clustering, and spread
- Provides a more data-driven view of distribution

---------------------------------------------------------------------

3) GRADIENT RIDGELINE PLOT

Description:
A ridgeline plot where color represents the value of PC1.

Key features:
- Uses geom_density_ridges_gradient
- Fill color reflects PC1 magnitude
- Enhances visual interpretation of distribution shifts

Interpretation:
- Color gradients highlight low vs high PC1 values
- Makes directional shifts across groups easier to detect

---------------------------------------------------------------------

WHY RIDGELINE PLOTS?

Ridgeline plots provide a more informative alternative to:
- Scatter plots (which show point clouds but not distributions)
- Violin plots (which show distributions but less clearly across many groups)

They are especially useful in genomics for:
- Visualizing population structure
- Comparing PRS or PC distributions
- Exploring heterogeneity across ancestry groups

---------------------------------------------------------------------

KEY TAKEAWAY

These plots demonstrate that:
- Genetic principal components vary systematically across Hispanic/Latino subgroups
- Distribution-based visualization provides deeper insight into population structure
- Ridgeline plots are a powerful addition to standard PCA workflows

---------------------------------------------------------------------

DEPENDENCIES

Required R packages:
- ggplot2
- ggridges
- dplyr
- data.table
- viridis (for gradient version)

---------------------------------------------------------------------

NOTES

- Groups are ordered by median PC1 to improve readability
- Missing values are excluded prior to plotting
- These plots are derived from the same PCA framework used in prior analyses