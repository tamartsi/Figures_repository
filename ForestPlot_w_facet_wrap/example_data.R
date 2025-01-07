#####################################################
## example data
#####################################################

## number of exposures
N.exposure <- 5

## number of outcomes
N.outcome <- 6

## number of sex groups
N.sex.group <- 2

## generate effect estimates (causal effect)
## from standard normal distribution
effect_est <- rnorm(N.exposure*N.outcome*N.sex.group, 0, 0.5)

## generate sd
## from uniform distribution
sd <- runif(N.exposure*N.outcome*N.sex.group, 0, 0.5)

## lower C.I.
CI_L <- effect_est - 1.96*sd

## upper C.I.
CI_U <- effect_est + 1.96*sd

## sex group
sex <- rep(c("female", "male"), each = N.exposure*N.outcome)

exposure_F <- rep(c("OSA", "Insomnia", "Sleepiness", "Short sleep", "Long sleep"), each = N.outcome)

exposure_M <- rep(c("OSA", "Insomnia", "Sleepiness", "Short sleep", "Long sleep"), each = N.outcome)

## exposure
exposure <- c(exposure_F, exposure_M)

outcome_F <- rep(c("T2DM", "HTN", "HF", "CKD", "CAD", "AF"), N.exposure)

outcome_M <- rep(c("T2DM", "HTN", "HF", "CKD", "CAD", "AF"), N.exposure)

## outcome
outcome <- c(outcome_F, outcome_M)

## final input dataset
Data <- data.frame(effect_est = effect_est, 
                   CI_L = CI_L, 
                   CI_U = CI_U,
                   sex = sex, 
                   exposure = exposure, 
                   outcome = outcome)

head(Data)




