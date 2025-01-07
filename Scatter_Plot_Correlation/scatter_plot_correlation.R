library(ggplot2)
library(ggpubr)
library(dplyr)

#Read-In Data and Merge by rsid

data1 <- read.table("method1_data.txt", sep = "\t", header=TRUE)
data2 <- read.table("method2_data.txt", sep = "\t", header=TRUE)

data <- left_join(data1, data2, by='rsid') 

#Create Scatter Plot with Correlation of P-values between Two Methods

ggplot(data, aes(x=pval_method1, y=pval_method2))+ 
  geom_point() +
  geom_smooth(method=lm, se=FALSE, col='blue', size=1) +
  stat_cor(method = "pearson", label.x =0, label.y = 1.1) +
  labs(x = "Pvalue from Untransformed Analysis",
       y = "Pvalue from Transformed Analysis",
       title = "Correlation Plot") +
  theme_classic() +
  theme(plot.title = element_text(hjust=0.5))

