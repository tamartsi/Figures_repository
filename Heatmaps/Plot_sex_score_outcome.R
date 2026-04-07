## Dumbell plot

library(ggplot2)
library(dplyr)
pup<-read.csv('~/Downloads/sim_plot_data.csv')[1:20,]
pup <- pup %>%
  mutate(score = recode(score,
                        "Total T"  = "ProtS_Total T",
                        "Bio T" = "ProtS_Bio T",
                        "Free T" = "ProtS_Free T",
                        "Estradiol"   = "ProtS_Estradiol",
                        "SHBG"    = "ProtS_SHBG"
  ))
pup$score<-factor(pup$score, levels = rev(c("ProtS_Total T", "ProtS_Bio T", "ProtS_Free T",
                                            "ProtS_Estradiol", "ProtS_SHBG")))

#### --- Dumbbell / connected dot plot
# Shows HR for female and male side by side connected by a line — the gap between the dots visualizes the 
# sex difference. Works well when you want to emphasize divergence between sexes:

ggplot(pup, aes(x = HR, y = score)) +
  # connecting line between female and male
  geom_line(aes(group = score), color = "gray80", linewidth = 0.5) +
  geom_point(aes(color = sex, alpha = pval_fdr < 0.05),
             size = 2.5) +
  scale_alpha_manual(values = c("TRUE" = 1, "FALSE" = 0.4),
                     guide = "none") +
  scale_color_manual(values = c("Female" = "#C0392B", "Male" = "#2980B9")) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "gray40") +
  scale_x_log10(limits = c(0.55, 2.0)) +
  facet_grid(group ~ Outcome, scales = "fixed", space = "free_y") +
  labs(x = "Hazard ratio (log scale)", y = NULL, color = NULL) +
  theme_classic(base_size = 10) +
  theme(strip.text = element_text(face = "bold"),
        legend.position = "bottom") +
  geom_errorbarh(aes(xmin = HR_lower, xmax = HR_upper),
                 height = 0.08, linewidth = 0.25,
                 color = "gray60", alpha = 0.5,
                 position = position_dodge(width = 0.4))

###### --- Heatmap
# Heatmap of HR by score × outcome × sex
# Shows the full pattern at once — color encodes HR magnitude, asterisks mark significance. 
# Great for showing the sex-dimorphic pattern and which omics layer drives the signal.

ggplot(pup, aes(x = sex, y = score, fill = log(HR))) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = ifelse(pval_fdr < 0.05, "*", "")),
            size = 5, vjust = 0.8) +
  scale_fill_gradient2(low = "#2166AC", mid = "white", high = "#B2182B",
                       midpoint = 0, name = "log(HR)") +
  facet_grid(group ~ Outcome) +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 10) +
  theme(strip.text = element_text(face = "bold"),
        axis.text.x = element_text(face = "bold"))
# Color: red = risk, blue = protective, white = null
