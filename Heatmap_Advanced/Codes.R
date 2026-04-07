##################################################
#   Advanced heatmap using simulated data 
################################################## 
# Example 1 using pheatmap ---- 
# install.packages("pheatmap")
library(pheatmap)

set.seed(123)

mat <- matrix(rnorm(200), nrow = 20)
rownames(mat) <- paste0("Feature", 1:20)
colnames(mat) <- paste0("ID", 1:10)

# Column annotation
annotation_col <- data.frame(
  Group = rep(c("Unexposed", "Exposed"), each = 5)
)
rownames(annotation_col) <- colnames(mat)

# Colors
ann_colors <- list(
  Group = c(Unexposed = "blue", Exposed = "red")
)

pheatmap(mat,
         scale = "row",
         annotation_col = annotation_col,
         annotation_colors = ann_colors,
         clustering_method = "complete",
         color = colorRampPalette(c("blue", "white", "red"))(100),
         cluster_rows = FALSE, # or could set to TRUE if let r find the clustering pattern 
         cluster_cols = FALSE)

gc() 

# Example 2 using ggplot2 ---- 
library(ggplot2)
library(reshape2)

set.seed(123)

mat <- matrix(rnorm(100), nrow = 10)
rownames(mat) <- paste0("Feature A", 1:10)
colnames(mat) <- paste0("Feature B", 1:10)

df <- melt(mat)

ggplot(df, aes(Var2, Var1, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red") +
  geom_text(aes(label = sprintf("%.2f", value))) + 
  #geom_text(aes(label = ifelse(abs(value) > 1, round(value,2), ""))) + # for only showing important values meeting threshold 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "", y = "", fill = "Value") 

gc() 
