
# Generate two variables, X, and having two groups: group A and group B. 
# X will have a normal distribution, mean and variance depend on group.
setwd("Density_plot")

n <- 10000
nA <- 7000
nB <- n - nA
# random group assignments:
group <- c(rep("Group A", nA), rep("Group B", nB))

# generate A
X <- c(rnorm(nA, 3, 1), rnorm(nB, 4, 1.5))

dat <- data.frame(Group = group, X= X)

write.csv(dat, file = "Density_plot_sample_data_1.csv")
