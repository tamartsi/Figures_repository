#####################################################
## forest plot
#####################################################
## load R packages
#####################################################

library(ggplot2)

#####################################################
## figure: forest plot
## column: exposure
## row: outcome
## point estimate with 95% C.I.
#####################################################

ggplot(Data, aes(y = outcome, x = effect_est))+
  geom_pointrange(aes(xmin = CI_L, xmax = CI_U, color = sex), position = position_dodge(0.5), size = 0.74, fatten = 5) + 
  scale_color_manual(name = "sex", values = c("#FF7F00", "#008080")) +
  facet_wrap( ~ exposure, ncol = N.exposure, scales = "free") + 
  geom_vline(lty = 2, aes(xintercept = 0), colour = '#708090', size = 0.86) + 
  #labs(title = "") + 
  theme_bw() + 
  xlab("") + 
  theme(panel.spacing = unit(.05, "lines"),
        plot.title = element_text(size = 30),
        panel.border = element_rect(color = "black", fill = NA, size = 1.5),
        strip.background = element_rect(color = "black", size = 0.1),
        axis.ticks.x=element_blank(),
        legend.position = "none", 
        strip.text = element_text(size = 30),
        axis.title.y = element_text(size = 30),
        axis.title.x = element_text(size = 30),
        axis.text.y = element_text(size = 20),
        axis.text.x = element_text(size = 20),
        legend.text = element_text(size = 25), 
        legend.title = element_text(size = 25))
