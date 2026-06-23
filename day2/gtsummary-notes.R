# Gtsummary notes

library(gt)
library(gtsummary)
library(tidyverse)

cases <- readr::read_csv(here::here("data", "city-cases.csv"))

# Table 1
# Total number of cases per city
# Total cases by region
# How cases differ by sex

n_cities <- dplyr::n_distinct(cases$city)
n_regions <- dplyr::n_distinct(cases$region)
# We can see how many cities are in each region
cities_per_region <-
	cases |>
	dplyr::distinct(region, city) |>
	dplyr::count(region, name = "# Cities")

# We just want to turn this into a nice table
gt::gt(cities_per_region)

# For our actual table 1, we probably want to do some
# summary statistics
# tbl_summary() is gtsummary's equivalent to table1::table1()
gtsummary::tbl_summary(
	cases,
	include = cases,
	by = sex
)

total_case_counts <-
	cases |>
	dplyr::group_by(city, region, sex) |>
	dplyr::summarize(
		total_cases = sum(cases)
	) |>
	dplyr::ungroup()

# Table 2
# Let's do an example regression
example_model <- glm(
	cases ~ sex,
	data = cases,
	family = "poisson",
	offset = log(population)
)

crude_estimates <- gtsummary::tbl_uvregression(
	data = cases,
	y = cases,
	include = c(region, industry, sex, grimbleth_ppm, temperature),
	method = "glm",
	method.args = list(
		family = "poisson",
		offset = log(population)
	),
	exponentiate = TRUE
)

# Now let's make our adjusted estimates
adjusted_model <- glm(
	cases ~ region + industry + sex + grimbleth_ppm + temperature,
	data = cases,
	family = "poisson",
	offset = log(population)
)
summary(adjusted_model)

adjusted_estimates <- gtsummary::tbl_regression(
	adjusted_model,
	exponentiate = TRUE
)

# And gtsummary lets us combine these into table2
table2 <- gtsummary::tbl_merge(
	list(
		"Crude" = crude_estimates,
		"Adjusted" = adjusted_estimates
	),
	tab_spanner	= c("Crude", "Adjusted")
)

# If you want to do bayesian, just replace the glm with this
library(rstanarm)
my_bayesian_model <- rstanarm::stan_glm(
	cases ~ region + industry + sex + grimbleth_ppm + temperature +
		offset(log(population)),
	data = cases,
	family = "poisson",
	chains = 4,
	cores = 4
)

