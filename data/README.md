# Course Data README

> Review before teaching: this README is a draft based on repository inspection
> on 2026-07-07. Confirm source, permissions, provenance, and any
> sensitive-data language before release.

## Recommended default for Exercises 1 and 2

### QCRC COVID-19 ICU workbook

- File: `data/QCRC_FINAL_Deidentified.xlsx`
- Recommended use: Exercises 1 and 2 mini-manuscript/report arc.
- Main sheet for most students: `Main_Dataset`.
- Other sheets available for advanced students: `Oxygen_Delivery`, `SOFA`,
  `Long_Labs`, `Long_Vitals`, `Static_Compliance`, `PAO2_FIO2`, `ICU_Meds`,
  `Intake_Form`, and `Daily_Form`.
- Useful main-sheet variables include age, sex, race, mortality endpoints,
  ICU length of stay, BMI, treatment indicator, intubation, CRRT, labs, and
  oxygenation measures.
- Important caution: some numeric variables are stored as text, and missing
  values may be written as `"."`.

Use QCRC unless another dataset clearly better supports your question.

## Other course datasets

- `data/measles_final.Rds`: country-year measles cases, population, vaccine
  coverage, country, region, and sub-region.
- `data/city-cases.csv`: simulated monthly city-level records with region,
  industry, date, sex, exposure-like values, population, temperature, and cases.
- `data/SIR-observed.csv`: daily total cases for ODE and epidemic-curve work.
- `data/mos-nyc.csv`: county-level PCR-positive and pool-submission counts for
  surveillance or mapping-style summaries.

If students choose a non-QCRC dataset, they should add two sentences to their
report:

1. Why this dataset is better for their question.
1. What limitation they accept by not using QCRC.
