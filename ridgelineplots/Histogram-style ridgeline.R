library(data.table)
library(dplyr)
library(ggplot2)
library(ggridges)
library(viridis)

# File paths
pc_file <- "/Users/yogeshpurushotham/Library/CloudStorage/OneDrive-BethIsraelLaheyHealth/Sofer, Tamar (HMFP - Cardiology)'s files - 2024_APOE_kmers/21mer/Data/PC/DRAGEN_imputed_12PCs.csv"
output_file <- "/Users/yogeshpurushotham/Desktop/ridgeline_PC1_histogram_style.png"

# Load PCs
pcs_df <- fread(pc_file)

# Recode background groups from gengrp6
pcs_df <- pcs_df %>%
  mutate(
    group = case_when(
      gengrp6 %in% c(0, "0", "Dominican") ~ "Dominican",
      gengrp6 %in% c(1, "1", "Central_American", "Central American") ~ "Central_American",
      gengrp6 %in% c(2, "2", "Cuban") ~ "Cuban",
      gengrp6 %in% c(3, "3", "Mexican") ~ "Mexican",
      gengrp6 %in% c(4, "4", "Puerto_Rican", "Puerto Rican") ~ "Puerto_Rican",
      gengrp6 %in% c(5, "5", "South_American", "South American") ~ "South_American",
      gengrp6 %in% c(6, "6", "Other") ~ "Other",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(PC1), !is.na(group))

# Order groups by median PC1
group_order <- pcs_df %>%
  group_by(group) %>%
  summarise(group_median = median(PC1, na.rm = TRUE), .groups = "drop") %>%
  arrange(group_median) %>%
  pull(group)

pcs_df <- pcs_df %>%
  mutate(group = factor(group, levels = group_order))

# Plot
p <- ggplot(pcs_df, aes(x = PC1, y = group, fill = group)) +
  geom_density_ridges(
    alpha = 0.7,
    stat = "binline",
    bins = 30,
    scale = 1.1,
    color = "white",
    linewidth = 0.3
  ) +
  scale_fill_viridis_d(option = "C") +
  labs(
    title = "Histogram-Style Ridgeline of Genetic PC1 by Background Group",
    x = "Genetic PC1",
    y = "Background Group"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    panel.grid.minor = element_blank(),
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

ggsave(output_file, p, width = 10, height = 6, dpi = 300)