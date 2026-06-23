# Notes on bootstrapping

# First we'll load the low birthweight data from the
# MASS package
library(MASS)
data("birthwt", package = "MASS")

# calculate a 95% CI for the risk difference in low birth
# weight between mothers who smoke and don't
# First calculate the point estimate of the RD
risk_overall <- mean(birthwt$low)
risk_smoke <- mean(birthwt$low[birthwt$smoke == 1])
risk_no_smoke <- mean(birthwt$low[birthwt$smoke == 0])

# Now we can calculate the RD (risk difference)
smoking_rd <- risk_smoke - risk_no_smoke

# Now we want to calculate a CI for the risk difference
# To calculate the bootstrap CI, the first thing we need
# to do is create B number of resamples.
# Each resample is a random sample from the original dataset
# that is also size n (the sample size), but we draw the
# random sample WITH REPLACEMENT.
# In each resample, the same observation can appear
# multiple times.
n <- nrow(birthwt)

# A quick rule of thumb for choosing B:
# While you're checking if your code works, B = 10
# is plenty to make sure your statistic is correct.
# -for slow calculations, 100 is fine
# For you, B = 1,000 is fine
# For your boss, B = 10,000 is fine
# For reviewer 2, B = 100,000 is fine
B <- 10000

# Let's make a list of resamples.
# There is an R function called "sample()" that we can repeat
# B times to get B resamples with replacement.
# This is a good fit for lapply()
# There's also a function called replicate() that specifically
# works well here.
# Because we're drawing random numbers, we need to SET THE SEED!
# The seed can be ANY positive integer number.
set.seed(646986)
resamples_list <- lapply(
	1:B,
	function(i) birthwt[sample(1:n, size = n, replace = TRUE), ]
)

# Now that we have our resamples, we need to calculate the
# statistic of interest (risk difference) on each resample.
# First we need to write a function to calculate the RD
# on a resample.
get_smoking_rd <- function(resample) {
	risk_overall <- mean(resample$low)
	risk_smoke <- mean(resample$low[resample$smoke == 1])
	risk_no_smoke <- mean(resample$low[resample$smoke == 0])
	
	# Now we can calculate the RD (risk difference)
	smoking_rd <- risk_smoke - risk_no_smoke
	return(smoking_rd)
}

bootstrap_rd_estimates <- sapply(
	resamples_list,
	# Because this is a function with one argument (the current
	# resample), we can pass it as an argument without any
	# parentheses or extra details.
	get_smoking_rd
)

# OK, great.
# Now we have the RD for each resample.
# How do we get a confidence interval out of this?
# Let's look at the distribution of RDs
plot(density(bootstrap_rd_estimates), lwd = 3)

# We can now get a (1 - alpha)% CI by calculating the
# empirical quantiles of the bootstrap statistic distribution.
alpha <- 0.05
cutoff <- 1 - alpha/2
critical_probabilities <- c(1 - cutoff, cutoff)

# This is called estimating the CI with the
# "bootstrap percentile" method
bootstrap_ci <- quantile(
	bootstrap_rd_estimates,
	probs = critical_probabilities
)

round(c(smoking_rd, bootstrap_ci), 2)

# We can get an approximate p-value from the bootstrap distribution
# This is an APPROXIMATE one-tailed p-value
# Review 2 probably won't like this because it is one-tailed.
p_value <- 1 - mean(bootstrap_rd_estimates > 0)

# If we want to calculate multiple statistics with bootstrap
# CI's, it is technically better to always use the same set
# of resamples.
# This avoids "Monte Carlo error" introduced by the differences
# between two sets of resamples.
# It's really easy to calculate many statistics at one time.
# Let's write a function that does that.
get_smoking_stats <- function(resample) {
	risk_overall <- mean(resample$low)
	risk_smoke <- mean(resample$low[resample$smoke == 1])
	risk_no_smoke <- mean(resample$low[resample$smoke == 0])
	
	# Now we can calculate the RD (risk difference)
	smoking_rd <- risk_smoke - risk_no_smoke
	
	# We can also calculate the RR (risk ratio)
	smoking_rr <- risk_smoke / risk_no_smoke
	
	# And the OR (odds ratio)
	# Odds = risk / (1 - risk)
	odds_smoke <- risk_smoke / (1 - risk_smoke)
	odds_no_smoke <- risk_no_smoke / (1 - risk_no_smoke)
	smoking_or <- odds_smoke / odds_no_smoke
	
	stats_vector <- c(smoking_rd, smoking_rr, smoking_or)
	names(stats_vector) <- c("RD", "RR", "OR")
	
	return(stats_vector)
}
smoking_stats_point_estimates <- get_smoking_stats(birthwt)

# Now we can sapply() this function to the resamples
# to calculate all three statistics at once
bootstrap_stats_estimates <- sapply(
	resamples_list,
	get_smoking_stats
)

# We can use another member of the *apply() family to get
# the CIs for all three statistics from this matrix.
bootstrap_stat_cis <- apply(
	bootstrap_stats_estimates,
	MARGIN = 1,
	\(x) quantile(x, probs = critical_probabilities)
)

cleaned_bootstrap_estimates <-
	rbind(
		smoking_stats_point_estimates,
		bootstrap_stat_cis
	) |>
	round(2) |>
	t()

colnames(cleaned_bootstrap_estimates) <- c(
	"Estimate", "Lower", "Upper"
)

cleaned_bootstrap_estimates
