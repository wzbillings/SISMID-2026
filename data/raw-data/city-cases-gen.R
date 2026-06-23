# Code to generate the fantasy cities dataset
# for the linear models module
# Mostly generated from chatGPT with a few tweaks

library(MASS)      # for rnegbin
library(dplyr)     # for data manipulation
library(tidyr)     # for nesting
library(purrr)     # for functional programming
library(ggplot2)

set.seed(2025)

# --- Constants ---
n_cities <- 37
n_months <- 36  # 3 years
regions <- c("North", "South", "East", "West")

# Distribute cities in regions
region_size_props <- c(0.26, 0.13, 0.39, 0.22)
region_sizes <- round(region_size_props * n_cities)
n_regions <- length(regions)
region_ids <- rep(regions, times = region_sizes)

# --- Create city and region info ---
city_data <- tibble(
	city_id = 1:n_cities,
	region = region_ids
)

# --- Simulate a city's main industry ---
industry_groups <- c("Primary", "Secondary", "Tertiary", "Quaternary")
region_probs <- list(
	North = c(Primary = 0.7, Secondary = 0.15, Tertiary = 0.1, Quaternary = 0.05),
	South = c(Primary = 0.4, Secondary = 0.5, Tertiary = 0.05, Quaternary = 0.05),
	East  = c(Primary = 0.2, Secondary = 0.1, Tertiary = 0.2, Quaternary = 0.5),
	West  = c(Primary = 0.2, Secondary = 0.2, Tertiary = 0.25, Quaternary = 0.35)
)

city_data$industry <- mapply(function(region) {
	sample(industry_groups, size = 1, prob = region_probs[[region]])
}, city_data$region)

# --- Simulate city populations ----
city_data <- city_data |>
	dplyr::mutate(
		region_adjustor = dplyr::case_when(
			region == "North" ~ 0.5,
			region == "South" ~ 0.8,
			region == "West" ~ 1.0,
			region == "East" ~ 1.2,
		),
		population = round(runif(n_cities, 50000, 500000) * region_adjustor)
	)

# --- Create full panel data ---
panel_data <- city_data |>
	crossing(month = 1:n_months) |>
	mutate(
		year = (month - 1) %/% 12 + 1,
		region = factor(region)
	)

# --- Adjust the population size by year ---
n_total <- nrow(panel_data)
p_adj <- 0.03
panel_data <- panel_data |>
	mutate(
		population_adjust = ifelse(month == 1, 0, runif(n_total, -p_adj, p_adj + 0.02)),
		population = population + (population * population_adjust)
	) |>
	dplyr::select(-region_adjustor, -population_adjust)

# --- Simulate smooth seasonal temperature with sinusoidal function ---
# Period = 12 months, amplitude ~ seasonal temperature range, phase shifts for variability
period <- 12
amplitude <- 10    # roughly ±10 degrees variation around mean
mean_temp <- 15    # average temperature across year

region_phases <- tibble(
	region = factor(regions),
	region_phase = runif(length(regions), 0, pi),
	region_amplitude_adjust = c(10, 2, -3, -7)
)

panel_data <- panel_data |>
	left_join(region_phases, by = "region") |>
	mutate(
		region_amplitude = amplitude + region_amplitude_adjust,
		base_temp = mean_temp + 
			region_amplitude * sin(2 * pi * (month / period) + region_phase),
		temperature = base_temp + rnorm(n_total, 0, 2)
	) |>
	select(-region_phase, -region_amplitude, -region_amplitude_adjust, -base_temp)

# --- Simulate city and region level effects ---
city_level_effects <- tibble(
	city_id = 1:n_cities,
	city_contaminant_effect = rnorm(n_cities, 0, 0.03),
	city_intercept = rnorm(n_cities, 0, 0.05)
)

region_level_effects <- tibble(
	region = regions,
	region_contaminant_effect = c(0.03, -0.01, 0.02, 0.005),
	region_intercept = c(0.02, -0.02, 0.10, 0.015)
)

# --- Simulate contaminant as a function of region, city, temp, and month ---
# This isn't exactly what I want, I want to model leeching less strongly as a function of
# time. but it will do for now.
# Time effect is log units increase per month, it should be slow
time_contaminant_effect <- 0.003
# Temp effect is additional log units increase per month per temp degree
temp_contaminant_effect <- 0.005
panel_data <-
	panel_data |>
	dplyr::left_join(city_level_effects, by = "city_id") |>
	dplyr::left_join(region_level_effects, by = "region") |>
	dplyr::mutate(
		log_contaminant = city_contaminant_effect + region_contaminant_effect +
			#time_contaminant_effect * month +
			temp_contaminant_effect * month * temperature +
			rnorm(dplyr::n(), 0, 0.05),
		contaminant = round(exp(log_contaminant), 2)
	) |>
	dplyr::select(-city_contaminant_effect, -region_contaminant_effect, -log_contaminant)

# --- Fixed effects model coefficients ---
coefs <- list(
	intercept = -8,
	primary_industry = 0.28,
	secondary_industry = 0.13,
	primary_north = 0.23,
	primary_south = 0.38,
	primary_east = 0.05,
	primary_west = 0.57,
	contaminant = 0.75,
	contaminant2 = 0.2
)

# --- Linear predictor ---
panel_data <- panel_data |>
	mutate(
		lp = coefs$intercept +
			city_intercept + region_intercept +
			coefs$primary_industry * (industry == "Primary") +
			coefs$secondary_industry * (industry == "Secondary") +
			(industry == "Primary") * dplyr::case_when(
				region == "North" ~ coefs$primary_north,
				region == "South" ~ coefs$primary_south,
				region == "East" ~ coefs$primary_east,
				region == "West" ~ coefs$primary_west
			),
			coefs$contaminant * log10(contaminant) +
			coefs$contaminant2 * log10(contaminant) ^ 2,
		lp = lp + log(population)
	)

# --- Generate outcome: Negative binomial ---
dispersion <- 1.5  # controls overdispersion
panel_data <- panel_data |>
	mutate(
		mu = exp(lp),
		cases = rnegbin(n = n(), mu = mu, theta = dispersion),
		cases_m = floor(0.6 * cases),
		cases_f = cases - cases_m
	) |>
	dplyr::select(-cases)

panel_data <- panel_data |>
	tidyr::pivot_longer(
		c(cases_m, cases_f),
		names_to = "sex",
		values_to = "cases"
	) |>
	dplyr::mutate(sex = factor(sex, c("cases_m", "cases_f"), c("M", "F")))

# --- Replace the region and city names with the real ones ---
region_names_dict <- c(
	East = "Aldrithwaite",
	West = "Elmswycke",
	South = "Gryndelmere",
	North = "Westridinge"
)
city_names_dict <- c(
	"Blythwick", "Harrowden", "Fenmarsh", "Duncombe", "Grethby",
	"Woolhaven", "Ravenshold", "Easthall", "Loxley", "Thornbridge",
	"Marstonfeld", "Hightwell", "Stonewold", "Coldby", "Nettleford",
	"Brackenholt", "Cranwick", "Westermere", "Ashbourn", "Keldham",
	"Mereford", "Longcross", "Harcrest", "Drelwich", "Foxmere",
	"Oldenforth", "Harrowick", "Spenlow", "Wending Wyll", "Glenthorne",
	"Crowleigh", "Byrnstead", "Tharlesby", "Ashwynd", "Kelverdon",
	"Morlinch", "Draymere"
)
names(city_names_dict) <- 1:n_cities

panel_data <-
	panel_data |>
	dplyr::mutate(
		region = factor(
			region,
			levels = names(region_names_dict),
			labels = unname(region_names_dict)
		),
		city = factor(
			city_id,
			levels = names(city_names_dict),
			labels = unname(city_names_dict)
		),
		industry = factor(
			industry,
			levels = c("Primary", "Secondary", "Tertiary", "Quaternary")
		),
		time = month,
		year = year + 2015,
		month = factor(
			(time - 1) %% 12,
			levels = 0:11,
			labels = month.abb
		),
		dt = lubridate::ymd(paste0(year, "-", month, "-01")),
		.before = dplyr::everything()
	) |>
	dplyr::select(
		city, region, industry, month, year, time_point = time, date = dt, sex,
		grimbleth_ppm = contaminant,
		population, temperature, cases
	)

readr::write_csv(
	panel_data,
	here::here("data", "city-cases.csv")
)

# TODO
# add age structuring?
# make sex interact with grimbleth for a by spline
# age structuring?
# find another city-level categorical covariate that doesn't require structuring
# but can interact with industry or region or something
