library(gtsummary)
library(magrittr)
library(dplyr)
library(officer)
library(webshot)
library(gridExtra)
library(ggplot2)
library(ggpubr)
library(formattable)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
library(scales)
library(forcats)
library(ggfittext)



results <- read.csv(file = "BarPlot_sample_data_1.csv", stringsAsFactors = TRUE)

# edit some values in the df as needed
results <- results %>% mutate(group=recode(group,'Hispanic'='Hispanic/Latino'))

# round values to 1 decimal point and strore as numeric for using in ggplot
percent_value_string <- results$test_evr
numerical_value_string <- round(as.numeric(substr(percent_value_string, 1,4)), 1)
results$test_evr <- numerical_value_string



# round values to 1 decimal point and strore as numeric for using in ggplot
percent_value_string <- as.numeric(sub("%", "", results$full_test_evr)) 
numerical_value_string <- round(as.numeric(percent_value_string), 1)
results$full_test_evr <- numerical_value_string


# add columns to the df to include model type so we can add that to the vertical strip title
Genetic_model_PVE <- c("Genetic model")
Ensemble_model_PVE <- c("Ensemble model")


results$Genetic_model_PVE <- Genetic_model_PVE 
results$Ensemble_model_PVE <- Ensemble_model_PVE 



#create a top plot:  the bar plot is split by phenotype (systolic and diastolic blood pressure) in the Genetic model 

h <- ggplot(data = results, aes(x = fct_relevel(group, "Overall", after = 4), test_evr, group = Model, fill=Model)) +
  geom_col(width = 0.9, position = position_dodge(0.9),  alpha=1, show.legend = TRUE) +
  geom_text(aes(label=test_evr, y=test_evr), size=2.5, position=position_dodge2(width=0.9, preserve='single'), vjust= -0.5) + 
  labs(y = "PVE (%)", x = "", fill = "Model") + 
  ylim(0.0,8.0) +
  scale_fill_manual(values = wes_palette("Rushmore1")[c(5,3,4)]) + 
  facet_grid(Genetic_model_PVE ~ Phenotype) + theme_bw() + theme(panel.spacing = unit(.05, "lines"),
                                                                 panel.border = element_rect(color = "black", fill = NA, size = 0.1),
                                                                 strip.background = element_rect(color = "black", size = 0.1))
h + theme(legend.position = "top") 



#create a bottom plot:  the bar plot is split by phenotype (systolic and diastolic blood pressure) in the Ensemble model

q <- ggplot(data = results, aes(x = fct_relevel(group, "Overall", after = 4), full_test_evr, group = Model, fill=Model)) +
  geom_col(width = 0.9, position = position_dodge(0.9),  alpha=1, show.legend = TRUE) +
  geom_text(aes(label=full_test_evr, y=full_test_evr), size=2.5, position=position_dodge2(width=0.9, preserve='single'), vjust= -0.5) + 
  labs(y = "PVE (%)", x = "", fill = "Model") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  ylim(0.0,40.0) +
  scale_fill_manual(values = wes_palette("BottleRocket2")[c(1,4,5)]) +
  facet_grid(Ensemble_model_PVE ~ Phenotype) + theme_bw() + theme(panel.spacing = unit(.05, "lines"),
                                                                  panel.border = element_rect(color = "black", fill = NA, size = 0.1),
                                                                  strip.background = element_rect(color = "black", size = 0.1))


q + theme(legend.position="top") 


# combine the two bar plot (facet grids) into a single figure
k <- grid.arrange(h, q, ncol = 1) 

k



ggsave(filename  = "BarPlot_output_figure_1.png", plot = k, width = 10, height = 5, device='png', dpi=600)



