library(ggplot2)
library(patchwork)
library(dplyr)
library(wesanderson)
setwd("/Users/michaelcassidy/Documents/GitHub/Figures_repository/Point Intervals")

PRS_vec <- c("PRSstd_sum_std", "PRSstd_gap_std", "PRSstd_mgb_std")
OSA_strats <- c("Healthy_sleep", "Mild_OSA", "Mod_severe_OSA")

#visualizations for separate files by sleep and PRS
#first starting with point_interval_1_data_1

res1 <- read.csv("point_interval_1_data_1.csv")
res1 <- res1 %>% filter(PRS %in% PRS_vec, stratum %in% OSA_strats)
res1
res1$OR <- exp(res1$log_OR)
res1$CI_low <- exp(res1$log_OR -1.96*res1$log_PR_SE)
res1$CI_high <- exp(res1$log_OR +1.96*res1$log_PR_SE)
res1

res1$PRS <- as.factor(res1$PRS)


p1 <- ggplot(res1, aes(x = stratum, y = OR, group = PRS, color = PRS)) + 
  geom_point(size = 2.5, position = position_dodge(width=0.6)) + 
  geom_errorbar(aes(ymin = CI_low, ymax = CI_high), width = 0.2, lwd = 1.5, position = position_dodge(width=0.6)) + 
  geom_hline(yintercept = 1, lwd = 1, color = "grey", linetype= "dashed") + 
  theme_bw() +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  ggtitle("Diabetes status at baseline") +
  scale_color_manual(values = wes_palette("Darjeeling1"))
p1

#now using point_interval_1_data_2
res2 <- read.csv("point_interval_1_data_2.csv")
res2 <- res2 %>% filter(PRS %in% PRS_vec, stratum %in% OSA_strats)
res2
res2$IRR <- exp(res2$log_IRR)
res2$CI_low <- exp(res2$log_IRR -1.96*res2$log_IRR_SE)
res2$CI_high <- exp(res2$log_IRR +1.96*res2$log_IRR_SE)
res2

res2$PRS <- as.factor(res2$PRS)

p2 <- ggplot(res2, aes(x = stratum, y = IRR, group = PRS, color = PRS)) + 
  geom_point(size = 2.5, position = position_dodge(width=0.6)) + 
  geom_errorbar(aes(ymin = CI_low, ymax = CI_high), width = 0.2, lwd = 1.5, position = position_dodge(width=0.6)) + 
  geom_hline(yintercept = 1, lwd = 1, color = "grey", linetype= "dashed") + 
  theme_bw() +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  ggtitle("Incident diabetes among individuals without diabetes") +
  scale_color_manual(values = wes_palette("Darjeeling1"))
p2


#now using point_interval_1_data_3
res3 <- read.csv("point_interval_1_data_3.csv")
res3 <- res3 %>% filter(PRS %in% PRS_vec, stratum %in% OSA_strats)
res3
res3$IRR <- exp(res3$log_IRR)
res3$CI_low <- exp(res3$log_IRR -1.96*res3$log_IRR_SE)
res3$CI_high <- exp(res3$log_IRR +1.96*res3$log_IRR_SE)
res3

res3$PRS <- as.factor(res3$PRS)

p3 <- ggplot(res3, aes(x = stratum, y = IRR, group = PRS, color = PRS)) + 
  geom_point(size = 2.5, position = position_dodge(width=0.6)) + 
  geom_errorbar(aes(ymin = CI_low, ymax = CI_high), width = 0.2, lwd = 1.5, position = position_dodge(width=0.6)) + 
  geom_hline(yintercept = 1, lwd = 1, color = "grey", linetype= "dashed") + 
  theme_bw() +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  ggtitle("Incident diabetes among normal glycemic individuals") +
  scale_color_manual(values = wes_palette("Darjeeling1"))
p3

#now using point_interval_1_data_4
res4 <- read.csv("point_interval_1_data_4.csv")
res4 <- res4 %>% filter(PRS %in% PRS_vec, stratum %in% OSA_strats)
res4
res4$IRR <- exp(res4$log_IRR)
res4$CI_low <- exp(res4$log_IRR -1.96*res4$log_IRR_SE)
res4$CI_high <- exp(res4$log_IRR +1.96*res4$log_IRR_SE)
res4

res4$PRS <- as.factor(res4$PRS)

p4 <- ggplot(res4, aes(x = stratum, y = IRR, group = PRS, color = PRS)) + 
  geom_point(size = 2.5, position = position_dodge(width=0.6)) + 
  geom_errorbar(aes(ymin = CI_low, ymax = CI_high), width = 0.2, lwd = 1.5, position = position_dodge(width=0.6)) + 
  geom_hline(yintercept = 1, lwd = 1, color = "grey", linetype= "dashed") + 
  theme_bw() +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  ggtitle("Incident diabetes or pre-diabetes among normal glycemic individuals") +
  scale_color_manual(values = wes_palette("Darjeeling1"))
p4


#plot all 4 with each other
all_plots <- p1 + p2 + p3 + p4 & theme(legend.position = "bottom")
all_plots + plot_layout(guides = "collect")
