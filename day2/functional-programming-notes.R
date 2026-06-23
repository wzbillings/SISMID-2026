# In the functions module, we wrote a function that looks
# like this to get statistics for the measles dataset.
get_country_stats <- function(df, iso3_code){
	
	country_data <- subset(df, iso3c == iso3_code)
	
	# Get the summary statistics for this country
	country_cases <- country_data$measles_cases
	country_quart <- quantile(
		country_cases, na.rm = TRUE, probs = c(0.25, 0.5, 0.75)
	)
	country_range <- range(country_cases, na.rm = TRUE)
	
	#country_name <- unique(country_data$country)
	
	country_summary <- data.frame(
		#country = country_name,
		min = country_range[[1]],
		Q1 = country_quart[[1]],
		median = country_quart[[2]],
		Q3 = country_quart[[3]],
		max = country_range[[2]]
	)
	
	return(country_summary)
}

# We can easily replicate this in a loop now, using our function.
# First we need to load the measles dataset.
meas <- readRDS("data/measles_final.Rds") |>
	tidyr::drop_na(iso3c)

# Get the statistics for every country in the measles dataset
countries <- unique(meas$iso3c)
res <- vector(mode = "list", length = length(countries))
for (i in 1:length(countries)) {
	this_country <- countries[i]
	out <- get_country_stats(meas, this_country)
	res[[i]] <- out
}

# Instead of writing a loop we can use tools from
# "functional programming"
# In R, the most basic FP tool is called lapply()
# Most functions have multiple arguments though, so we need
# some specific tools to make lapply() work
# The following code doesn't work
# res_fp <- lapply(
# 	X = countries,
# 	FUN = get_country_stats
# )

# lapply() only works when the argument FUN is a function with
# a single argument
# But a workaround to this is using an "anonymous function"
res_fp <- lapply(
	X = countries,
	FUN = function(country) get_country_stats(meas, country)
)

# To write an anonymous function in R (version 4.4.1 or newer)
# You can abbreviate the keyword "function" as a "\" instead.
res_fp2 <- lapply(
	X = countries,
	FUN = \(country) get_country_stats(meas, country)
)

# Normally we would have to write another function to deal with
# this problem
# But I'm lazy and I don't want to do this every time,
# so an anonymous function is an easy solution.
get_country_stats_on_meas_data <- function(country) {
	out <- get_country_stats(meas, country)
	return(out)
}

# tapply() is another *apply function that lets us do grouped
# operations instead of doing everything on a flat list.

# We want to get the average vaccine coverage for each country in the measles
# dataset – we need to separate this by the two vaccines as well.
# To deal with both MCV1 and MCV2 vaccines at the same time, we need to "pivot"
# the data to "long form". That means instead of having one column for MCV1
# coverage and one for MCV2 coverage, we need a column with vaccine type and
# a column for coverage.
# You can read more about pivoting in the free online book "R For Data Science"
# by Hadley Wickham: https://r4ds.hadley.nz/
library(tidyr)
library(dplyr)
meas_long <- meas |>
	pivot_longer(
		c(MCV1_coverage, MCV2_coverage),
		names_to = "vaccine",
		values_to = "coverage"
	) |>
	mutate(
		vaccine = factor(
			vaccine,
			levels = c("MCV1_coverage", "MCV2_coverage"),
			labels = c("MCV1", "MCV2")
		)
	)

mean_coverage_per_country <- tapply(
	# We want to summarize the vaccine coverage
	meas_long$coverage,
	INDEX = list(
		# We want to group by country
		meas_long$iso3c,
		# And by vaccine
		meas_long$vaccine
	),
	# The function we want to use for our summaries is
	# the mean
	FUN = \(y) mean(y, na.rm = TRUE)
)

# If we want to look at a specific country, R lets
# us "index by position"
# Remember that rows come first in the square brackets
# then columns comes second
# "RC Cola"
# And a blank spot means "get everything for this dimension"
mean_coverage_per_country[3, ]
countries[3]

# We can also "index by names"
mean_coverage_per_country["UZB", ]

# You can do more than one at the same time
countries_to_get <- c("PAK", "IND")
mean_coverage_per_country[countries_to_get, ]

# We can also "index by a boolean"
# We can check whether a condition is TRUE or FALSE
# And get all of the entries where the condition is TRUE
# Let's get the mean coverage for all countries in Asia
country_region <- meas |>
	dplyr::distinct(country, region)
# The == is called a "logical operator" and it allows us
# to check whether a statement is true or false without
# explictly using an "if" statement.
is_country_in_asia <- country_region$region == "Asia"
# This is the vaccine coverage stats ONLY for countries
# where the region is Asia
# R will automatically select rows where is_country_in_asia
# is TRUE, and drop the rows that are FALSE.
coverage_in_asia <-
	mean_coverage_per_country[is_country_in_asia, ]

# Sorting one column is easy
mcv_1_coverage_sorted <-
	sort(coverage_in_asia[ , 1], decreasing = TRUE)
coverage_in_asia_sorted <-
	coverage_in_asia[names(mcv_1_coverage_sorted), ]

# We can get the top 5 and bottom 5 countries in Asia ranked
# by MCV coverage
n_countries <- nrow(coverage_in_asia_sorted)
coverage_in_asia_sorted[c(1:5, (n_countries - 5):n_countries), ]

# lapply() ALWAYS ALWAYS returns a LIST of things.
# (that's what the l stands for).
# Sometimes you don't want a list, that can be too complicated.
# So you can use sapply() instead
# (the s stands for "simplify"/"simple")
# What that means is that sapply() will try to return
# a vector-type thing instead of a list.
# (It can be a matrix or array instead of a vector,
# vectors are 1D, matrices are 2D, arrays are 3+D).

# Say we want to get the mean and 95% CI of the MCV1
# Coverage in each country/year in the measles data.
library(Hmisc)
get_mean_and_ci_for_each_country <- function(country) {
	country_data <- meas[meas$iso3c == country, ]
	mean_and_ci <- Hmisc::smean.cl.normal(
		country_data$MCV1_coverage,
		na.rm = TRUE
	)
	
	return(mean_and_ci)
}

get_mean_and_ci_for_each_country("IND")

# Using lapply gives us a list of numeric vectors
# Which is maybe a bit complicated to use.
# We have to lapply() everything to a list, whereas
# if this were a matrix (vector-like thing), we could
# use nice vectorized functions.
lapply_output <-
	lapply(
		countries,
		FUN = get_mean_and_ci_for_each_country
	)

# If we use sapply() instead of lapply(), R will try to
# give us the nicer, simpler output.
sapply_output <-
	sapply(
		countries,
		FUN = get_mean_and_ci_for_each_country
	)

