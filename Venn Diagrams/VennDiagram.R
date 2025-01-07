##################################
#  USING THE "ggVennDiagram"  
################################## 
# load packages 
install.packages("ggVennDiagram")
library(ggVennDiagram)
#install.packages("ggplot2")
library(ggplot2)

# List of items
x <- list(A = 1:5, B = 2:7, C = 5:10)

# Venn diagram with custom border
png("VennDiagram_plot_example1.png", res = 300, height = 1000, width = 1200)

ggVennDiagram(x, color = "black", lwd = 0.8, lty = 1) + 
  scale_fill_gradient(low = "#F4FAFE", high = "#4981BF")

dev.off()

# Change the color 
# More options see: https://www.sthda.com/english/wiki/colors-in-r 
ggVennDiagram(x, color = "black", lwd = 0.8, lty = 1) + 
  scale_fill_gradient(low = "#FFCC66", high = "#FF9900")

# List of items
x <- list(A = 1:5, B = 2:7, C = 5:10)

# Venn diagram with custom legend
ggVennDiagram(x) + 
  guides(fill = guide_legend(title = "Title")) +
  theme(legend.title = element_text(color = "red"),
        legend.position = "bottom")

# Venn diagram with percentages
ggVennDiagram(x, label = "percent",
              color = "black", lwd = 0.8, lty = 1) + 
  scale_fill_gradient(low = "#F4FAFE", high = "#FF9900") 

# Venn diagram with count labels
ggVennDiagram(x, label = "count", 
              color = "black", lwd = 0.8, lty = 1) + 
  scale_fill_gradient(low = "#F4FAFE", high = "#FF9900")

# More complex with four areas 
# List of items
x <- list(A = 2:8, B = 6:15, C = 12:19, D = 10:28, E = 22:33)

# 4D Venn diagram
png("VennDiagram_plot_example2.png", res = 300, height = 1000, width = 1200)

ggVennDiagram(x, label = "count", color = "black", lwd = 0.8, lty = 1) + 
  scale_fill_gradient(low = "#F4FAFE", high = "#FF9900") 

dev.off()

############################################
#     USING THE "VennDiagram"  
############################################
# Load library
install.packages("VennDiagram")
library(VennDiagram)

# Generate 3 sets of 200 words
set1 <- paste(rep("word_" , 200) , sample(c(1:1000) , 200 , replace=F) , sep="")
set2 <- paste(rep("word_" , 200) , sample(c(1:1000) , 200 , replace=F) , sep="")
set3 <- paste(rep("word_" , 200) , sample(c(1:1000) , 200 , replace=F) , sep="")

# Prepare a palette of 3 colors with R colorbrewer:
library(RColorBrewer)
myCol <- brewer.pal(3, "Pastel2")

# Chart  
venn.diagram(
  x = list(set1, set2, set3),
  category.names = c("Environment" , "Behaviors" , "Mental Disorders"),
  filename = 'VennDiagram_plot_example3.png',
  output=TRUE,

  # Output features
  imagetype="png" ,
  height = 1000,
  width = 1000,
  resolution = 300,
  compression = "lzw",
  
  # Circles
  lwd = 2,
  lty = 'blank',
  fill = myCol,
  
  # Numbers
  cex = .6,
  fontface = "bold",
  fontfamily = "sans",
  
  # Set names
  cat.cex = 0.6,
  cat.fontface = "bold",
  cat.default.pos = "outer",
  cat.pos = c(-27, 27, 135),
  cat.dist = c(0.055, 0.055, 0.085),
  cat.fontfamily = "sans",
  rotation = 1
) 

gc() 
