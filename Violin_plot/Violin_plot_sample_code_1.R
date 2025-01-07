library(ggplot2)

dat <- read.csv("Violin_plot_sample_data_1.csv")
head(dat)

# verify that X has values from 0 to 1. 
range(dat$X)

dat$X_category <- cut(x = dat$X, breaks = seq(0, 1, by = 0.2))

# another option is to use quintiles (say):
dat$X_category <- cut(dat$X, breaks = quantile(dat$X, seq(0, 1, by = 0.2)), 
               right = TRUE,
               include.lowest = TRUE,
                labels = c("q1", "q2", "q3", "q4", "q5"))


summary(dat$X_category)
# q1   q2   q3   q4   q5 
# 2000 2000 2000 2000 2000 

dat$log_Y <- log(dat$Y)

p <- ggplot(data = dat, aes(x = X_category, y = log_Y, fill = X_category)) + 
  geom_violin(trim = FALSE) + 
  theme_bw() + 
  geom_boxplot(width=0.1, fill="white")+
  scale_fill_brewer(palette = "Dark2")+ 
  xlab("Quintiles of X") + 
  ylab("Distribution of natural logarithm of Y") +
  theme(legend.position = "none")
p
ggsave(p, file = "Violin_plot_1.png", height = 3, width = 7)
