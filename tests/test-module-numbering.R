if (!requireNamespace("yaml", quietly = TRUE)) {
  stop("The yaml package is required for this check.", call. = FALSE)
}

read_qmd_title <- function(path) {
  lines <- readLines(path, warn = FALSE)
  if (!length(lines) || lines[[1]] != "---") {
    return("")
  }

  end <- which(lines[-1] == "---")[[1]] + 1L
  front_matter <- paste(lines[2L:(end - 1L)], collapse = "\n")
  metadata <- yaml::yaml.load(front_matter)
  metadata$title %||% ""
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

site <- yaml::read_yaml("_quarto.yml")
sidebar <- site$website$sidebar$contents
core_sections <- c("Day 1 core", "Day 2 core", "Day 3 core")
numbered_module_hrefs <- c(
  "modules/Module00-Welcome.qmd",
  "modules/Module01-Quarto.qmd",
  "modules/Module02-StatReview.qmd",
  "modules/Module03-Iteration.qmd",
  "modules/Module04-Functions.qmd",
  "modules/Module05-FunctionalProgramming.qmd",
  "modules/UsefulPackages.qmd",
  "modules/Module06-S3-lm-formulas.qmd",
  "modules/ODEs.qmd",
  "modules/DiseaseMapping.qmd"
)
unnumbered_core_hrefs <- c(
  "modules/Walkthrough1.qmd",
  "modules/Walkthrough2.qmd"
)

failures <- character()
core_items <- list()

for (section_name in core_sections) {
  matches <- vapply(sidebar, function(item) identical(item$section, section_name), logical(1))
  if (!any(matches)) {
    failures <- c(failures, sprintf("Missing sidebar section: %s", section_name))
    next
  }

  section <- sidebar[[which(matches)[[1]]]]

  for (item in section$contents) {
    core_items <- append(core_items, list(item))
  }
}

core_hrefs <- vapply(core_items, `[[`, character(1), "href")
actual_module_hrefs <- core_hrefs[core_hrefs %in% numbered_module_hrefs]

if (!identical(actual_module_hrefs, numbered_module_hrefs)) {
  failures <- c(
    failures,
    paste(
      "Numbered core module order does not match expected order:",
      paste(actual_module_hrefs, collapse = ", ")
    )
  )
}

for (module_number in seq_along(numbered_module_hrefs) - 1L) {
  href <- numbered_module_hrefs[[module_number + 1L]]
  item <- core_items[[match(href, core_hrefs)]]
  prefix <- sprintf("Module %d: ", module_number)

  if (!startsWith(item$text, prefix)) {
    failures <- c(
      failures,
      sprintf(
        "Sidebar item %s should start with %s",
        shQuote(item$text),
        shQuote(prefix)
      )
    )
  }

  title <- read_qmd_title(href)
  if (!startsWith(title, prefix)) {
    failures <- c(
      failures,
      sprintf(
        "%s title %s should start with %s",
        href,
        shQuote(title),
        shQuote(prefix)
      )
    )
  }
}

for (href in unnumbered_core_hrefs) {
  item <- core_items[[match(href, core_hrefs)]]
  title <- read_qmd_title(href)

  if (startsWith(item$text, "Module ")) {
    failures <- c(
      failures,
      sprintf("Non-module sidebar item %s should not start with 'Module '", shQuote(item$text))
    )
  }

  if (startsWith(title, "Module ")) {
    failures <- c(
      failures,
      sprintf("Non-module title %s should not start with 'Module '", shQuote(title))
    )
  }
}

schedule <- paste(readLines("schedule.qmd", warn = FALSE), collapse = "\n")
for (expected_number in seq_along(numbered_module_hrefs) - 1L) {
  prefix <- sprintf("Module %d:", expected_number)
  if (!grepl(prefix, schedule, fixed = TRUE)) {
    failures <- c(failures, sprintf("schedule.qmd is missing %s", shQuote(prefix)))
  }
}

for (unexpected_number in length(numbered_module_hrefs):20L) {
  prefix <- sprintf("Module %d:", unexpected_number)
  if (grepl(prefix, schedule, fixed = TRUE)) {
    failures <- c(failures, sprintf("schedule.qmd should not include %s", shQuote(prefix)))
  }
}

if (grepl("Module [0-9]+: Data science walkthrough", schedule)) {
  failures <- c(failures, "Data science walkthroughs should not be numbered as modules in schedule.qmd")
}

if (length(failures)) {
  stop(paste(failures, collapse = "\n"), call. = FALSE)
}
