
meas_cln <- readr::read_csv(here::here("data", "MeaslesClean.csv"))
regions <- readr::read_csv(here::here("data", "countries-regions.csv"))

reg <- regions |>
	dplyr::select(
		iso3c = `alpha-3`,
		country = name,
		region = region,
		sub_region = `sub-region`
	)

out <- dplyr::left_join(
	meas_cln,
	reg
)

readr::write_rds(out, here::here("data", "measles_final.Rds"))
