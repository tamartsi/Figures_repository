library(tidyverse)
library(ggplot2)
library(glmnet)
library(patchwork)
library(dplyr)
library(wesanderson)
library(stringr)
library(ggpubr)
# #read in results for T2D PRS assoc w DM at baseline
# PRS_vec <- c("PRSstd_mgb_std","PRSstd_sum_std", "PRSstd_gap_std") 
# 
# res1 <- read.csv("/Users/yana/Library/CloudStorage/OneDrive-BethIsraelLaheyHealth/2022_diabetes_PRS_interaction_sleep/Code/Code_for_GitHub/Results/assoc_PRS_baseline_DM_w_comparison_PRSs.csv")
# 
# res1 <- res1 %>% filter(PRS %in% PRS_vec)
# 
# res1$OR <- exp(res1$log_OR)
# res1$CI_low <- exp(res1$log_OR -1.96*res1$log_OR_SE)
# res1$CI_high <- exp(res1$log_OR +1.96*res1$log_OR_SE)
# 
# res1$PRS <- as.factor(res1$PRS)
# res1$X <- c(1:nrow(res1))
# 
# # subset by OSA categories only 
# OSA_strats <- c("All","No_OSA", "Mild_OSA", "Mod_severe_OSA")
# res1_OSA <- res1 %>% filter(stratum %in% OSA_strats)
# 
# #rename variables to not include underscores
# res1_OSA <- res1_OSA %>% mutate(stratum=recode(stratum, 'All'= 'Overall','No_OSA'='No OSA', 'Mild_OSA' = 'Mild OSA', 'Mod_severe_OSA' = 'Moderate to severe OSA'))
# 
# #rename PRSs
# res1_OSA <- res1_OSA %>% mutate(PRS=recode(PRS, 'PRSstd_sum_std'= 'PRSsum','PRSstd_gap_std'='gapPRSsum', 'PRSstd_mgb_std' = 'mgbPRSsum', 'PGS002308_std_PRSs' = 'PGS002308_PRS', 'PGS003867_std_PRSs' = 'PGS003867_PRS'))
# 
# #format ORs
# res1_OSA$OR_CI <- paste0(format(round(res1_OSA$OR, 2), nsmall = 2), " [", format(round(res1_OSA$CI_low, 2), nsmall = 2), " ; ", format(round(res1_OSA$CI_high, 2), nsmall = 2), "]")
# 
# ## add AUCs
# assoc_PRS_baseline <- read.csv("/Users/yana/Library/CloudStorage/OneDrive-BethIsraelLaheyHealth/2022_diabetes_PRS_interaction_sleep/Code/Code_for_GitHub/Results/assoc_PRS_baseline_DM_w_AUC_CI.csv")
# 
# assoc_PRS_baseline <- assoc_PRS_baseline[which(assoc_PRS_baseline$PRS %in% PRS_vec),]
# assoc_PRS_baseline$AUC_CI <- paste0(format(round(assoc_PRS_baseline$mean_AUC, 2), nsmall = 2), " [", format(round(assoc_PRS_baseline$AUC_CI_lower, 2), nsmall = 2), " ; ", format(round(assoc_PRS_baseline$AUC_CI_upper, 2), nsmall = 2), "]")
# assoc_PRS_baseline <- assoc_PRS_baseline %>% mutate(PRS=recode(PRS, 'PRSstd_sum_std'= 'PRSsum','PRSstd_gap_std'='gapPRSsum', 'PRSstd_mgb_std' = 'mgbPRSsum'))
# 
# #extract only sleep phenos we need
# assoc_PRS_baseline_OSA <- assoc_PRS_baseline %>% filter(stratum %in% OSA_strats)
# 
# assoc_PRS_baseline_OSA <- assoc_PRS_baseline_OSA %>% mutate(stratum=recode(stratum, 'All'= 'Overall','No_OSA'='No OSA', 'Mild_OSA' = 'Mild OSA', 'Mod_severe_OSA' = 'Moderate to severe OSA'))
# 
# #extract only AUC and the PRS type to merge on
# assoc_PRS_baseline_OSA_sub <- assoc_PRS_baseline_OSA[,c("stratum", "PRS","mean_AUC","AUC_CI_lower", "AUC_CI_upper","AUC_CI")]
# 
# res1_OSA <- merge(res1_OSA, assoc_PRS_baseline_OSA_sub, by.x=c("stratum", "PRS"))
# 
# res1_OSA <- rbind(res1_OSA[10:12,],res1_OSA[7:9,], res1_OSA[1:3,], res1_OSA[4:6,])
# res1_OSA$X <- c(nrow(res1_OSA):1)
# 
# res1_OSA$log_OR_p <- signif(res1_OSA$log_OR_p, digits=1)
# 
# #only plot mgbPRS
# #res1_OSA <- res1_OSA[which(res1_OSA$PRS == "mgbPRSsum"),]
# 
# #res1_OSA$PRS <- factor(res1_OSA$PRS, levels = c("mgbPRSsum"))
# 
# res1_OSA$stratum <- factor(res1_OSA$stratum, levels = c("Overall","No OSA", "Mild OSA", "Moderate to severe OSA"))
# 
# #only keep the columns we need
# res1_OSA <- res1_OSA[c("X", "n", "N_case", "N_control","stratum", "PRS","OR", "CI_low", "CI_high", "log_OR_p", "OR_CI", "mean_AUC","AUC_CI_lower", "AUC_CI_upper", "AUC_CI")]
# 
# res1_OSA$Analysis <- "Cross-sectional"
# 
# res1_OSA$X <- c(8,7,6,5)
# 
# 
# #add incident results
# PRS_vec <- c("PRSstd_mgb_std","PRSstd_sum_std", "PRSstd_gap_std")
# res2 <- read.csv("/Users/yana/Library/CloudStorage/OneDrive-BethIsraelLaheyHealth/2022_diabetes_PRS_interaction_sleep/Code/Code_for_GitHub/Results/assoc_PRS_incident_DM_w_comparison_PRSs.csv")
# 
# res2 <- res2 %>% filter(PRS %in% PRS_vec)
# 
# res2$IRR <- exp(res2$log_IRR)
# res2$CI_low <- exp(res2$log_IRR -1.96*res2$log_IRR_SE)
# res2$CI_high <- exp(res2$log_IRR +1.96*res2$log_IRR_SE) 
# 
# res2$PRS <- as.factor(res2$PRS)
# res2$X <- c(1:nrow(res2))
# 
# # subset by OSA categories only 
# OSA_strats_2 <- c("All","No_OSA", "Mild_OSA", "Mod_severe_OSA")
# res2_OSA <- res2 %>% filter(stratum %in% OSA_strats_2)
# 
# 
# #rename variables to not include underscores
# res2_OSA <- res2_OSA %>% mutate(stratum=recode(stratum, 'All'= 'Overall','No_OSA'='No OSA', 'Mild_OSA' = 'Mild OSA', 'Mod_severe_OSA' = 'Moderate to severe OSA'))
# 
# #rename PRSs
# res2_OSA <- res2_OSA %>% mutate(PRS=recode(PRS, 'PRSstd_sum_std'= 'PRSsum','PRSstd_gap_std'='gapPRSsum', 'PRSstd_mgb_std' = 'mgbPRSsum', 'PGS002308_std_PRSs' = 'PGS002308_PRS', 'PGS003867_std_PRSs' = 'PGS003867_PRS'))
# 
# 
# res2_OSA$IRR_CI <- paste0(format(round(res2_OSA$IRR, 2), nsmall = 2), " [", format(round(res2_OSA$CI_low, 2), nsmall = 2), " ; ", format(round(res2_OSA$CI_high, 2), nsmall = 2), "]")
# 
# 
# ## add AUCs
# assoc_PRS_incident <- read.csv("/Users/yana/Library/CloudStorage/OneDrive-BethIsraelLaheyHealth/2022_diabetes_PRS_interaction_sleep/Code/Code_for_GitHub/Results/assoc_PRS_incident_DM_w_AUC_CI.csv")
# 
# assoc_PRS_incident <- assoc_PRS_incident[which(assoc_PRS_incident$PRS %in% PRS_vec),]
# assoc_PRS_incident$AUC_CI <- paste0(format(round(assoc_PRS_incident$mean_AUC, 2), nsmall = 2), " [", format(round(assoc_PRS_incident$AUC_CI_lower, 2), nsmall = 2), " ; ", format(round(assoc_PRS_incident$AUC_CI_upper, 2), nsmall = 2), "]")
# assoc_PRS_incident <- assoc_PRS_incident %>% mutate(PRS=recode(PRS, 'PRSstd_sum_std'= 'PRSsum','PRSstd_gap_std'='gapPRSsum', 'PRSstd_mgb_std' = 'mgbPRSsum'))
# 
# #extract only sleep phenos we need
# assoc_PRS_incident_OSA <- assoc_PRS_incident %>% filter(stratum %in% OSA_strats_2)
# 
# assoc_PRS_incident_OSA <- assoc_PRS_incident_OSA %>% mutate(stratum=recode(stratum, 'All'= 'Overall','No_OSA'='No OSA', 'Mild_OSA' = 'Mild OSA', 'Mod_severe_OSA' = 'Moderate to severe OSA'))
# 
# #extract only AUC and the PRS type to merge on
# assoc_PRS_incident_OSA_sub <- assoc_PRS_incident_OSA[,c("stratum", "PRS","mean_AUC","AUC_CI_lower", "AUC_CI_upper", "AUC_CI")]
# 
# res2_OSA <- merge(res2_OSA, assoc_PRS_incident_OSA_sub, by.x=c("stratum", "PRS"))
# 
# res2_OSA <- rbind(res2_OSA[10:12,],res2_OSA[7:9,], res2_OSA[1:3,], res2_OSA[4:6,])
# res2_OSA$X <- c(nrow(res2_OSA):1)
# 
# 
# res2_OSA$log_IRR_p <- signif(res2_OSA$log_IRR_p, digits=1)
# 
# #only plot mgbPRS
# #res2_OSA <- res2_OSA[which(res2_OSA$PRS == "mgbPRSsum"),]
# 
# #res2_OSA$PRS <- factor(res2_OSA$PRS, levels = c("mgbPRSsum"))
# 
# res2_OSA$stratum <- factor(res2_OSA$stratum, levels = c("Overall","No OSA", "Mild OSA", "Moderate to severe OSA"))
# 
# #only keep the columns we need
# res2_OSA <- res2_OSA[c("X", "n", "N_case", "N_control","stratum", "PRS", "IRR", "CI_low", "CI_high", "log_IRR_p", "IRR_CI", "mean_AUC","AUC_CI_lower", "AUC_CI_upper", "AUC_CI")]
# 
# res2_OSA$Analysis <- "Incident"
# 
# res2_OSA$X <- c(4,3,2,1)
# 
# #rename columns of the two df's to rbind them for plotting
# colnames(res1_OSA) <- c("X", "N", "N_case", "N_control", "stratum", "PRS", "Ratios", "CI_low", "CI_high", "log_Ratios_p", "Ratios_CI", "mean_AUC","AUC_CI_lower", "AUC_CI_upper", "AUC_CI", "Analysis")
# colnames(res2_OSA) <- c("X", "N", "N_case", "N_control", "stratum", "PRS","Ratios", "CI_low", "CI_high", "log_Ratios_p", "Ratios_CI", "mean_AUC","AUC_CI_lower", "AUC_CI_upper", "AUC_CI", "Analysis")
# 
# res_OSA <- rbind(res1_OSA,res2_OSA)
# 
# 
# res_OSA$Analysis <- factor(res_OSA$Analysis, levels = c("Cross-sectional","Incident"))
# 
# 
# res_OSA$log_Ratios_p <- format(res_OSA$log_Ratios_p, scientific=T, digits = 1)
# 
# #save file with final dataset
# write.csv(res_OSA, "/Users/yana/Library/CloudStorage/OneDrive-BethIsraelLaheyHealth/2022_diabetes_PRS_interaction_sleep/Draft/Results/raw_files/SuppFig_3a_b_c_T2D_PRS_assoc_baseline_and_incident_DM_stratified_by_OSA_severity_levels.csv")
# 


res_OSA <- read.csv("/Users/yana/Library/CloudStorage/OneDrive-BethIsraelLaheyHealth/2022_diabetes_PRS_interaction_sleep/Draft/Results/raw_files/SuppFig_3a_b_c_T2D_PRS_assoc_baseline_and_incident_DM_stratified_by_OSA_severity_levels.csv")





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
        #axis.title.x = element_blank(),
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






#ggsave(filename  = "/Users/yana/Library/CloudStorage/OneDrive-BethIsraelLaheyHealth/2022_diabetes_PRS_interaction_sleep/Code/Code_for_GitHub/Figures/Assoc_baseline_and_incident_DM_by_OSA_categories_forest_plot_NO_OSA_mgbPRSsum_v2.pdf", width = 18, height = 8, device='pdf', dpi=600)
