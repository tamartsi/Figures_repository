library(tidyverse)
library(ggplot2)
library(glmnet)
library(patchwork)
library(dplyr)
library(wesanderson)
library(stringr)
library(ggpubr)

res_OSA <- read.csv("/Users/yana/Documents/GitHub/Figures_repository/ForestPlots/sample_data.csv")


generateShades <- function(baseColor) {
  return(colorRampPalette(c(baseColor, "white"))(3)[1:1])
}

custom_palette <- c(
  generateShades("#FF8D00"), 
  generateShades("#6699CC"),  
  generateShades("#336699"),
  generateShades("#003366")
)


res_OSA_mgb <- res_OSA[which(res_OSA$PRS == "mgbPRSsum"),]

res_OSA_mgb$PRS <- factor(res_OSA_mgb$PRS, levels = c("mgbPRSsum"))


res_OSA_mgb$stratum <- factor(res_OSA_mgb$stratum, levels = c("Overall","No OSA", "Mild OSA", "Moderate to severe OSA"))
res_OSA_mgb$X <-c(8:1)

forest_plot_1 <- ggplot(res_OSA_mgb, aes(x = Ratios, y = X, colour = stratum)) +
  geom_errorbar(aes(xmin=CI_low, xmax=CI_high), width=0.25, lwd = 1.25, position=position_dodge(.25))+
  geom_point(position=position_dodge(.25), size=2) +
  scale_colour_discrete(na.translate = F)+ 
  geom_vline(xintercept = 1, linetype = 3) + 
  ggtitle(" ")+
  xlab("Estimate for mgbPRSsum") +
  scale_y_discrete(limits = rev(res_OSA_mgb$X),expand = c(0.0005,0.25)) + 
  theme_minimal() +
  scale_color_manual(values = custom_palette, 
                     labels = c("Overall", "No OSA", "Mild OSA", "Moderate to severe OSA"),
                     name="", na.translate = F)+
  scale_x_continuous(breaks = seq(from = 0.5, to = 4.5, by = 0.5)) +
  
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank(), 
        text = element_text(size=20),
        plot.title = element_text(size=20,hjust = 0.5))

forest_plot_1

forest_plot_w_info_1<-forest_plot_1+
  theme(legend.position = "top")+
  
  
  #add N case
  geom_rect(data=res_OSA_mgb, 
            aes(xmin=4.7, xmax=5.15, ymin=-Inf, ymax=Inf),
            fill="#ececec",colour = NA)+
  geom_text(data=res_OSA_mgb, aes(label=N_case, y=X, x=4.925),
            fontface="bold", size=6, colour= "#3b3b3b") +
  ### Add pval header
  annotate("text", x = 4.925, y= 9, label = "N case", size=6, fontface="bold",family="", colour= "#3b3b3b") +
  
  
  #add N case
  geom_rect(data=res_OSA_mgb, 
            aes(xmin=5.2, xmax=5.8, ymin=-Inf, ymax=Inf),
            fill="#ececec",colour = NA)+
  geom_text(data=res_OSA_mgb, aes(label=N_control, y=X, x=5.5),
            fontface="bold", size=6, colour= "#3b3b3b") +
  ### Add pval header
  annotate("text", x = 5.5, y= 9, label = "N control", size=6, fontface="bold",family="", colour= "#3b3b3b") +
  
  
  
  geom_rect(data=res_OSA_mgb, 
            aes(xmin=5.85, xmax=6.3, ymin=-Inf, ymax=Inf),
            fill="#ececec",colour = NA)+
  geom_text(data=res_OSA_mgb, aes(label=log_Ratios_p, y=X, x=6.075),
            fontface="bold", size=6, colour= "#3b3b3b") +
  ### Add pval header
  annotate("text", x = 6.075, y= 9, label = "P-value", size=6, fontface="bold",family="", colour= "#3b3b3b") +
  
  
  # Add column for OR [95% CI]
  geom_rect(data=res_OSA_mgb, aes(xmin=6.35, xmax=7.25, ymin=-Inf, ymax=Inf),
            fill="#ececec",colour = NA)+
  ## Add  OR [95% CI] value 
  geom_text(data=res_OSA_mgb, aes(label=Ratios_CI, y=X, x=6.8),
            fontface="bold", size=6, colour= "#3b3b3b")+
  ### Add OR [95% CI] value 
  annotate("text", x = 6.8, y= 9,label = "Estimate [95% CI]",
           size=6, fontface="bold",family="", colour= "#3b3b3b") +
  
  
  
  # Add column for AUC [95% CI]
  geom_rect(data=res_OSA_mgb, aes(xmin=7.3, xmax=8.2, ymin=-Inf, ymax=Inf),
            fill="#ececec",colour = NA)+
  ## Add  AUC [95% CI] value 
  geom_text(data=res_OSA_mgb, aes(label=AUC_CI, y=X, x=7.75),
            fontface="bold", size=6, colour= "#3b3b3b")+
  ### Add AUC [95% CI] value 
  annotate("text", x = 7.75, y=9,label = "AUC [95% CI]",
           size=6, fontface="bold",family="", colour= "#3b3b3b") +
  
  
  
  # Add title holder
  geom_hline(yintercept =8.5, colour="#141414", size=12, alpha=0.6) +
  geom_hline(yintercept =4.5, colour="#141414", size=12, alpha=0.6) +
  
  ### Add Traits Name in title holder
  annotate("text", x =3.25,  y=8.4, label = "Cross-sectional analysis", 
           size=6,fontface="italic",family="", vjust=0,colour="white") +
  annotate("text", x =3.25,  y=4.4, label = "Incident analysis", 
           size=6,fontface="italic",family="", vjust=0,colour="white")


forest_plot_w_info_1 + theme(legend.position="top")






#ggsave(filename  = "Figures/Assoc_baseline_and_incident_DM_by_OSA_categories_forest_plot_NO_OSA_mgbPRSsum.pdf", width = 18, height = 8, device='pdf', dpi=600)
