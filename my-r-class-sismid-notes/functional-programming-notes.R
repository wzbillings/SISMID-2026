###
# Functional programming lecture notes
# Zane
# 2026-07-14
###

# Setting up the output of a loop
# Pre-allocated
# n = number of loop iterations
# out <- vector(mode = "list", length = n)
# Not-preallocated
# out <- list()

# tapply example ####
# First we need to load and pivot the measles data to long form
meas <- readRDS("measles_final.Rds")


meas_long <- meas |>
  tidyr::pivot_longer(
    dplyr::starts_with("MCV"),
    names_to = "vaccine_antigen",
    values_to = "vaccine_coverage"
  )

str(meas_long)

#mean_without_na <- function(x, ...) mean(x, na.rm = TRUE, ...)

# This gives us all NAs!
out <- tapply(
  meas_long$vaccine_coverage,
  list(meas_long$iso3c, meas_long$vaccine_antigen),
  FUN = mean
)

# We use an anonymous function to handle setting the other arguments
# of mean()
out_no_nas <- tapply(
  meas_long$vaccine_coverage,
  list(meas_long$iso3c, meas_long$vaccine_antigen),
  FUN = function(x) mean(x, na.rm = TRUE) 
)

round(out_no_nas, 0)

# Reading in QCRC data with lapply ####
data_file <- "QCRC_FINAL_Deidentified.xlsx"
sheet_names <- readxl::excel_sheets(data_file)
sheet_list <- lapply(
  sheet_names,
  function(name) {
    sheet <- readxl::read_xlsx(data_file, sheet = name)
    message("Read sheet: ", name)
    return(sheet)
  }
)
names(sheet_list) <- sheet_names

# What is the number of rows in each of our sheets?
lapply_nrow <- lapply(sheet_list, nrow)
sapply_nrow <- sapply(sheet_list, nrow)


# Apply() mortality rate calculation example ####
d_matrix <- sheet_list[["Main_Dataset"]] |>
  dplyr::select(Died, `30D_Mortality`, `60D_Mortality`) |>
  as.matrix()

mortality_rates <- apply(
  d_matrix,
  MARGIN = 2,
  FUN = mean
)

# Reading in the main QCRC sheets with dates ####
# recommend using lubridate package for date calculation
main_sheet <- readxl::read_xlsx(
  "QCRC_FINAL_Deidentified.xlsx",
  sheet = 1,
  na = c("", " ", ".")
)
