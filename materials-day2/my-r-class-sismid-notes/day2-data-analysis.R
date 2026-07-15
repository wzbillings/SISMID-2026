###
# QCRC data analysis
# Zane
# 2026-07-14
# Code for analyzing the QCRC data
###

# Setup ####
library(pacman)
pacman::p_load(
  "rio",
  "here",
  "readxl",
  "janitor",
  "GGally",
  "gtsummary"
)

options(scipen = 999)

# Data load ####

qcrc_path <- here::here("QCRC_FINAL_Deidentified.xlsx")
qcrc_sheets <- readxl::excel_sheets(qcrc_path)

## Main qcrc sheet ####
qcrc_main_dataset <- readxl::read_xlsx(
  qcrc_path,
  sheet = "Main_Dataset",
  na = c("", " ", ".")
  # col_types = c(
  #   "text",
  #   "logical",
  #   "numeric",
  #   "text",
  #   "text",
  #   "logical",
  #   "logical",
  #   "logical",
  #   "date",
  #   "numeric",
  #   "numeric",
  #   "logical",
  #   "text",
  #   "logical",
  #   "logical",
  #   "logical",
  #   "date",
  #   "date",
  #   "date",
  #   "date",
  #   "numeric",
  #   "logical",
  #   "numeric",
  #   "guess",
  #   # YOu have to have one of these per column to use this argument
  # )
)

qcrc_main1 <-
  qcrc_main_dataset |>
  janitor::clean_names() |>
  dplyr::mutate(
    patient_deid = as.character(patient_deid),
    dplyr::across(
      c(decatur_transfer, died, x30d_mortality, x60d_mortality, intubated),
      \(x) factor(x, levels = c(0, 1), labels = c("No", "Yes"))
    )
  )

qcrc_main_subset <-
  qcrc_main1 |>
  dplyr::select(
    patient_deid,
    icu_los,
    bmi,
    age,
    race,
    sex = female,
    intubated,
    pressor_days,
    pressor_2_hours
  )

# TODO finish cleaning the main dataset

## Intake form ####
qcrc_intake_form <- readxl::read_xlsx(
  qcrc_path,
  sheet = "Intake_Form",
  na = c("", " ", ".", "9")
)

intake_form_clean <-
  qcrc_intake_form |>
  janitor::clean_names() |>
  dplyr::mutate(
    patient_deid = as.character(patient_deid),
    dplyr::across(
      dplyr::where(\(x) dplyr::n_distinct(x) <= 4),
      \(x) factor(x)
    )
  )

intake_form_subset <-
  intake_form_clean |>
  # We're going to join this to the main dataset
  # SO we'll select only the variables we need
  dplyr::select(
    patient_deid, pressors, hypertension, stroke_neur, chf
  )

## Join the intake form and main dataset ####
combined_df <- dplyr::left_join(
  qcrc_main_subset,
  intake_form_subset,
  by = "patient_deid"
)

# Data exploration ####
complete_cases <-
  combined_df |>
  tidyr::drop_na()

n_complete_cases <- nrow(complete_cases)

# Pairwise plots of our favorite predictors (and outcome)
pairplot <- GGally::ggpairs(
  complete_cases |>
    dplyr::select(icu_los, bmi, age, pressors, pressor_days, hypertension)
)

pairplot + ggplot2::theme_minimal()

# Table 1 ####
complete_cases2 <- complete_cases |>
  dplyr::mutate(
    race_lumped = forcats::fct_lump_n(race, n = 1)
  )

tbl1 <- gtsummary::tbl_summary(
  complete_cases2,
  by = race_lumped,
  include = -patient_deid,
  label = list(icu_los = "ICU Length of Stay")
) |>
  add_overall(last = TRUE)

readr::write_rds(
  tbl1,
  here::here("table-one.Rds")
)

# you can use gtsummary::tbl_regression() to show and compare
# some regression results