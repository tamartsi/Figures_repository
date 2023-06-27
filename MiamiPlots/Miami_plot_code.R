###############################################
## Miami plot
## combine two Manhattan plots in one figure
## use R package "gap"
## install.packages("gap")
###############################################

## load R "gap" library
library(gap)

###############################################
## the example dataset
## summary statistics
###############################################
head(mhtdata)

dim(mhtdata)

colnames(mhtdata)


###############################################
## draw Miami plot
## use function "miamiplot2"
## the inputs we need in this function are
## 1: GWAS1, GWAS2
## 2. position1, position2
## 3. chromosome1, chromosome2
## 4. pvalue1, pvalue2
## 5. name1, name2 (the tilte of each Manhattan plot)
###############################################

## prepare the input GWAS summary statistics file
## only need three variables
## chromosome, position, p-value
gwas1 <- mhtdata[, c("chr", "pos", "p")]

gwas2 <- mhtdata[, c("chr", "pos", "p")]

## check to use the same column name in this package
colnames(gwas1) <- c("chr", "pos", "p")

colnames(gwas2) <- c("chr", "pos", "p")


## draw Miami plot

tiff("Miami_plot_example.tiff", res = 300, height = 3000, width = 5000)

miamiplot2(gwas1, gwas2, name1 = "GWAS1", name2 = "GWAS2", p1 = "p", p2 = "p", yAxisInterval = 5)

dev.off()



###############################################
## change other settings
## change the y-axis interval: yAxisInterval = 2
## change color
## top Manhattan plot: topcols = c("green3", "darkgreen")
## bottome Manhattan plot: botcols = c("royalblue1", "navy")
## change the significant threshold
## "sug" and "sig"
## sug: The threshold for suggestive significance, plotted as a light grey dashed line
## sig: The threshold for genome-wide significance, plotted as a dark grey dashed line
###############################################







