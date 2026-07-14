###
# Loop practice notes
# Zane
# 2026-07-13
# I would put a longer description here if this were
# for my job
###

# Load the measles dataset
measles <- readRDS("measles_final.Rds")

# Preallocate storage space for country summary
# stats
res <- vector(mode = "list", length = length(unique(measles$country)))

# Make a sequence variable for our countries
countries <- unique(measles$country)

# Calculate summary stats for each country
for (i in 1:length(countries)) {
  this_country <- countries[[i]]
  
  this_country_data <- subset(measles, country == this_country) |>
    na.omit()
  
  # Calculate summary stats of interest
  output <- data.frame(
    "country" = this_country,
    "n_years" = nrow(this_country_data),
    "median" = median(this_country_data$measles_cases),
    "Q1" = quantile(this_country_data$measles_cases, probs = c(0.25)),
    "Q3" = quantile(this_country_data$measles_cases, probs = c(0.75)),
    "min" = min(this_country_data$measles_cases),
    "max" = max(this_country_data$measles_cases)
  )
  
  output$range <- output$max - output$min
  
  # Collect the output for this iteration
  res[[i]] <- output 
}

# ABove loop is an "index variable loop" or "construction"
# We  could also sometimes do a "for-each" construction
# for (this_country in countries) {}

# Let's turn our list of length 1 data frames into one data frame
# with 214 observations
country_summary_stats_df <- do.call(what = rbind, args = res)
rownames(country_summary_stats_df) <- NULL

# Calculate incidence per 1k
measles$incidence_per_1000 <- measles$measles_cases /
  measles$population * 1000

# Make a blank plot to draw the lines on
plot(
  NULL, NULL,
  xlim = c(2000, 2022),
  ylim = c(0, 30),
  xlab = "Year",
  ylab = "Incidence per 1000 people"
)

for (i in 1:length(countries)) {
  this_country <- countries[[i]]
  
  this_country_data <- subset(measles, country == this_country) |>
    na.omit()
  
  lines(
    x = this_country_data$year,
    y = this_country_data$incidence_per_1000
  )
}
