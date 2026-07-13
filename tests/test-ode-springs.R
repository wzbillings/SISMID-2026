module_path <- file.path("modules", "Module08-ODEs.qmd")
module_dir <- dirname(module_path)
source <- paste(readLines(module_path, warn = FALSE), collapse = "\n")

failures <- character()

expected_text <- c(
  "## Differential equations",
  "## Spring motion",
  "../images/spring.jpg",
  "spring_ode <- function",
  "spring_solution <- deSolve::ode",
  "spring_analytical",
  "## From springs to epidemics"
)

for (text in expected_text) {
  if (!grepl(text, source, fixed = TRUE)) {
    failures <- c(failures, sprintf("ODE module is missing expected spring material: %s", text))
  }
}

spring_image <- normalizePath(file.path(module_dir, "../images/spring.jpg"), mustWork = FALSE)
if (!file.exists(spring_image)) {
  failures <- c(failures, sprintf("Expected spring image does not exist: %s", spring_image))
}

spring_heading <- regexpr("## Spring motion", source, fixed = TRUE)[[1]]
sir_heading <- regexpr("## Compartment models", source, fixed = TRUE)[[1]]
if (spring_heading > 0L && sir_heading > 0L && spring_heading > sir_heading) {
  failures <- c(failures, "Spring introduction should appear before the SIR compartment material")
}

if (length(failures)) {
  stop(paste(failures, collapse = "\n"), call. = FALSE)
}
