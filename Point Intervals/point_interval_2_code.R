library(tidyverse)

dat <- read.csv("point_interval_2_data.csv")

p1<- ggplot(dat, aes(x = Category, y = est, color = Method)) +
  geom_errorbar(aes(ymin = lower_CI, ymax = upper_CI), position = position_dodge(0.7), width = 0.1, linewidth = 1.5) +
  geom_point(position = position_dodge(0.7), size = 3) +
  facet_grid(Outcome ~ Type, scales = "free") +
  theme_bw(base_size = 25) +
  xlab(NULL)+
  ylab("Estimates") +
  theme(legend.position = "bottom", legend.text = element_text(size = 22), legend.title = element_text(size = 22)) +
  scale_color_brewer(palette = "Set1") +
  theme(plot.caption = element_text(hjust = 0.5, size = 22))