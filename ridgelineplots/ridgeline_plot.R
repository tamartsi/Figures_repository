library(data.table)
library(dplyr)
library(ggplot2)
library(ggridges)

# File paths
pc_file <- "/Users/yogeshpurushotham/Library/CloudStorage/OneDrive-BethIsraelLaheyHealth/Sofer, Tamar (HMFP - Cardiology)'s files - 2024_APOE_kmers/21mer/Data/PC/DRAGEN_imputed_12PCs.csv"
output_file <- "/Users/yogeshpurushotham/Desktop/ridgeline_PC1_by_background_group.png"

# Load PCs
pcs_df <- fread(pc_file)

# Check unique values in gengrp6 if needed
print(unique(pcs_df$gengrp6))

# Recode background groups
# This handles both numeric-coded and already-labeled versions
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

# Colors
group_colors <- c(
  "Dominican" = "#E41A1C",
  "Central_American" = "#FF7F00",
  "Cuban" = "#984EA3",
  "Mexican" = "#4DAF4A",
  "Puerto_Rican" = "#377EB8",
  "South_American" = "#F781BF",
  "Other" = "#999999"
)

# Order groups by median PC1
group_order <- pcs_df %>%
  group_by(group) %>%
  summarise(group_median = median(PC1, na.rm = TRUE), .groups = "drop") %>%
  arrange(group_median) %>%
  pull(group)

pcs_df <- pcs_df %>%
  mutate(group = factor(group, levels = group_order))

# Ridgeline plot
p <- ggplot(pcs_df, aes(x = PC1, y = group, fill = group)) +
  geom_density_ridges(alpha = 0.7, scale = 1.2, color = "white", linewidth = 0.3) +
  scale_fill_manual(values = group_colors) +
  labs(
    title = "Distribution of Genetic PC1 Across Hispanic/Latino Background Groups",
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