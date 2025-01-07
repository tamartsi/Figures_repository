library(ggplot2)

dat <- read.csv("Density_plot_sample_data_1.csv")
head(dat)

# no grouping
p <- ggplot(data = dat, aes(x = X)) + 
  geom_density( alpha = 0.8, fill = "pink", position = "identity") + 
  theme_bw() + 
  xlab("Variable X") + ylab("Density") 

p


ggsave(p, file = "Density_plot_no_group_1.png", height = 3, width = 7)

# with grouping 
p <- ggplot(data = dat, aes(x = X,  fill = group)) + 
  geom_density( alpha = 0.8, position = "identity") + 
  theme_bw() + 
  scale_fill_manual(values = c("pink", "lightblue"))+
  xlab("Variable X") + ylab("Density") 

p


ggsave(p, file = "Density_plot_two_groups_1.png", height = 3, width = 7)
