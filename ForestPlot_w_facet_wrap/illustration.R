#####################################################
## forest plot
## estimated effect size with 95% C.I.
## assume we have 5 sleep-related phenotypes (as exposure)
## assume we have 6 CVD-related phenotypes (as outcome)
## we aim to visualize the causal effect estimates of 
## each exposure-outcome combination
## we will show sex-specific effect in this figure
#####################################################
## load R packages
#####################################################

library(ggplot2)

#####################################################
## simulate data
#####################################################

## number of exposures
N.exposure <- 5

## number of outcomes
N.outcome <- 6

## number of sex groups
N.sex.group <- 2

## generate effect estimates (causal effect)
## from standard normal distribution
effect_est <- rnorm(N.exposure*N.outcome*N.sex.group, 0, 0.5)

## generate sd
## from uniform distribution
sd <- runif(N.exposure*N.outcome*N.sex.group, 0, 0.5)

## lower C.I.
CI_L <- effect_est - 1.96*sd

## upper  C.I.
CI_U <- effect_est + 1.96*sd

## sex group
sex <- rep(c("female", "male"), each = N.exposure*N.outcome)

exposure_F <- rep(c("OSA", "Insomnia", "Sleepiness", "Short sleep", "Long sleep"), each = N.outcome)

exposure_M <- rep(c("OSA", "Insomnia", "Sleepiness", "Short sleep", "Long sleep"), each = N.outcome)

## exposure
exposure <- c(exposure_F, exposure_M)

outcome_F <- rep(c("T2DM", "HTN", "HF", "CKD", "CAD", "AF"), N.exposure)

outcome_M <- rep(c("T2DM", "HTN", "HF", "CKD", "CAD", "AF"), N.exposure)

## outcome
outcome <- c(outcome_F, outcome_M)

## final input dataset
Data <- data.frame(effect_est = effect_est, 
                   CI_L = CI_L, 
                   CI_U = CI_U,
                   sex = sex, 
                   exposure = exposure, 
                   outcome = outcome)


#####################################################
## figure
## column: exposure
## row: outcome
#####################################################

#pdf("forst_plot_w_facet_wrap.pdf", height = 10, width = 20)

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

#dev.off()


