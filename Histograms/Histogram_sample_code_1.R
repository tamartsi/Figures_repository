library(tidyverse)
library(ggplot2)

dat <- read.csv("Histograms_sample_data_1.csv")

dat$Age_group <- as.factor(cut(dat$Age, 
                            breaks =  c(min(dat$Age), 30,40, 50, 60, max(dat$Age)), 
                            include.lowest = TRUE))



for_plot <- pivot_longer(dat, 
                         cols = c("Primary_index", "Secondary_index"), 
                         names_to = "Index_type", 
                         values_to = "Index")

index_medians <- for_plot %>% group_by(Index_type, Age_group, Sex) %>% 
  summarize_at(vars(Index), list(index_median = median)) 


p <- ggplot(for_plot, aes(x = Index)) + 
  geom_histogram(aes(fill = Sex), alpha = 0.6, position = "identity") +
  ggtitle("Histogram of indices stratitifed by sex") + 
  theme_bw() + 
  scale_fill_brewer(palette="Dark2") + 
  xlab("Index value") + ylab("Count") 

p + facet_grid(Age_group~Index_type) + 
  geom_vline(data = index_medians, mapping = aes(xintercept = index_median, color = Sex)) + 
  scale_color_brewer(palette="Dark2")


ggsave(file = "Hisotgram_example_1.png")
