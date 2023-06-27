
n <- 10000
dat <- data.frame(ID = paste0("person_", 1:n), 
             Sex = sample(c("Male", "Female"), size = n, replace = TRUE))

dat$Primary_index <- rnorm(n, mean = 2 + ifelse(dat$Sex == "Male", 1, 0))
dat$Secondary_index <- rnorm(n, mean = 3 + ifelse(dat$Sex == "Male", 1.5, 0))
dat$Age <- runif(n, min = 20, max = 70)

head(dat)

write.csv(dat, file = "/Users/tamarsofer/Documents/GitHub/Figures_repository/Histograms/Histograms_sample_data_1.csv")
