# Ellis et al Figure 4 Replication: 
# Volcano Plot of TwinsUK APOE - metabolite associations

# Load required libraries 
library(tidyverse)
library(ggplot2)
library(ggrepel)
library(patchwork)

# Read in the data 
dat_raw <- read_excel(
  "volcano_plot_sample_data.xlsx",
  sheet = 2
)

dat_apoe2 <- dat_raw %>%
  select(
    CHEMICAL_NAME = col1,
    Est = "C(APOE_Status, Treatment(reference=1))[T.E2]",
    pval = "C(APOE_Status, Treatment(reference=1))[T.E2]_p", 
    fdr_pval = "E2_pval_adj"
  )

dat_apoe4 <- dat_raw %>%
  select(
    CHEMICAL_NAME = col1,
    Est = "C(APOE_Status, Treatment(reference=1))[T.E4]",
    pval = "C(APOE_Status, Treatment(reference=1))[T.E4]_p", 
    fdr_pval = "E4_pval_adj"
  ) 


# Figure 4A (APOE E2)
pval_thresh = 0.05
fdr_thresh = min(dat_apoe2$pval[dat_apoe2$fdr_pval > .1], na.rm = TRUE)
# color negatively associated points gold and positively associated points blue
dat_apoe2 <- dat_apoe2 %>% 
  mutate(color = if_else(pval > 0.05, "black", if_else(Est > 0, "blue", "gold")), 
         label = if_else(color != "black", CHEMICAL_NAME, NA), 
         highlight = if_else(pval < fdr_thresh, 1, 0)) %>% 
  mutate(logp = -log10(pval))

volcano_plot_apoe2 <- ggplot(dat_apoe2, aes(x = Est, y = logp)) +
  geom_point(color = dat_apoe2$color, size = 2) +
  geom_text_repel(data = subset(dat_apoe2, highlight == 0),
    aes(label = label), size = 4, 
    max.overlaps = 7, 
    na.rm = TRUE, 
    color = "black", 
    min.segment.length = 0) + 
  geom_label_repel(
    data = subset(dat_apoe2, highlight == 1),
    aes(label = label),
    fill = "yellow",
    label.size = 0
  ) + 
  geom_hline(yintercept = -log10(fdr_thresh), linetype = "dashed", color = "black") +
  annotate("text", y = -log10(fdr_thresh), x = -0.45, label = "pFDR ~ 0.1", vjust = -0.5, size = 3) + 
  geom_hline(yintercept = -log10(pval_thresh), linetype = "dashed", color = "black") + 
  annotate("text", y = -log10(pval_thresh), x = -0.45, label = "p = 0.05", vjust = -0.5, size = 3) + 
  geom_vline(xintercept = 0, linetype = "dashed", color = "black") + 
  labs(
    title = "APOE E2",
    x = "Beta Value",
    y = "-log10 p-value",
  ) +
  theme_bw(base_size = 14) + 
  xlim(-0.5, 0.5) + 
  ylim(0,4) + 
  theme(
    plot.title = element_text(hjust = 0.5)
  )


# Figure 4B (APOE E4)
pval_thresh = 0.05
fdr_thresh = min(dat_apoe4$pval[dat_apoe4$fdr_pval > .1], na.rm = TRUE)
# color negatively associated points gold and positively associated points blue
dat_apoe4 <- dat_apoe4 %>% 
  mutate(color = if_else(pval > 0.05, "black", if_else(Est > 0, "blue", "gold")), 
         label = if_else(color != "black", CHEMICAL_NAME, NA), 
         highlight = if_else(pval < fdr_thresh, 1, 0)) %>% 
  mutate(logp = -log10(pval))

volcano_plot_apoe4 <- ggplot(dat_apoe4, aes(x = Est, y = logp)) +
  geom_point(color = dat_apoe4$color, size = 2) +
  geom_text_repel(data = subset(dat_apoe4, highlight == 0),
                  aes(label = label), size = 4, 
                  max.overlaps = 7, 
                  na.rm = TRUE, 
                  color = "black", 
                  min.segment.length = 0) + 
  geom_label_repel(
    data = subset(dat_apoe4, highlight == 1),
    aes(label = label),
    fill = "yellow",
    label.size = 0
  ) + 
  geom_hline(yintercept = -log10(pval_thresh), linetype = "dashed", color = "black") + 
  annotate("text", y = -log10(pval_thresh), x = -0.45, label = "p = 0.05", vjust = -0.5, size = 3) + 
  geom_vline(xintercept = 0, linetype = "dashed", color = "black") + 
  labs(
    title = "APOE E4", 
    x = "Beta Value",
    y = "-log10 p-value",
  ) +
  theme_bw(base_size = 14) + 
  xlim(-0.5, 0.5) + 
  ylim(0,4) + 
  theme(
    plot.title = element_text(hjust = 0.5)
  )


fig <- (volcano_plot_apoe2 / volcano_plot_apoe4) +
  plot_annotation(tag_levels = "A")

png("volcano_plot_example.png", 
    width = 10, height = 10, units = "in", res = 300)
print(fig)
dev.off()