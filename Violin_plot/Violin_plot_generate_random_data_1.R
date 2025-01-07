
# Generate two variables, X and Y, positively correlated. 
# X will have values between 0 and 1.
# These data will be used to generate a figure with violin plots of Y 
# by strata of X. 
setwd("Violin_plot")

n <- 10000
# Make X from a uniform(0,1) distribution
X <- runif(n, 0, 1)

# make Y depend on X with log normal error
Y <- X + exp(rnorm(n))

dat <- data.frame(X = X, Y= Y)

write.csv(dat, file = "Violin_plot_sample_data_1.csv")
