module_path <- file.path("modules", "Module01-Quarto.qmd")
module_dir <- dirname(module_path)
source <- paste(readLines(module_path, warn = FALSE), collapse = "\n")

failures <- character()

if (!grepl("toc:[[:space:]]*false", source, perl = TRUE)) {
  failures <- c(failures, "Module 1 should set toc: false to avoid an overflowing revealjs Page Items slide")
}

expected_graphics <- c(
  "../images/module01-quarto-anatomy.svg",
  "../images/module01-render-flow.svg",
  "../images/module01-editor-modes.svg",
  "../images/module01-chunk-options.svg"
)

for (graphic in expected_graphics) {
  if (!grepl(graphic, source, fixed = TRUE)) {
    failures <- c(failures, sprintf("Module 1 is missing expected graphic reference: %s", graphic))
  }

  graphic_path <- normalizePath(file.path(module_dir, graphic), mustWork = FALSE)
  if (!file.exists(graphic_path)) {
    failures <- c(failures, sprintf("Expected graphic file does not exist: %s", graphic_path))
  }
}

old_missing_graphics <- c(
  "images/quarto-dark-bg.jpeg",
  "images/28-fig28.png",
  "images/28-quarto-visual-editor.png",
  "images/28-chunk-label.png",
  "images/quarto-chunk-nav.png",
  "images/28-chunk-options.png"
)

for (graphic in old_missing_graphics) {
  if (grepl(graphic, source, fixed = TRUE)) {
    failures <- c(failures, sprintf("Module 1 still references old missing graphic: %s", graphic))
  }
}

image_matches <- gregexpr("!\\[([^\\]\\n]*)\\]\\(([^)]+)\\)", source, perl = TRUE)
images <- regmatches(source, image_matches)[[1]]

if (length(images)) {
  for (image in images) {
    alt_text <- sub("^!\\[([^\\]\\n]*)\\].*$", "\\1", image, perl = TRUE)
    raw_path <- sub("^!\\[[^\\]\\n]*\\]\\(([^)]+)\\).*$", "\\1", image, perl = TRUE)
    image_path <- sub("[[:space:]]+.*$", "", raw_path)

    if (!nzchar(trimws(alt_text))) {
      failures <- c(failures, sprintf("Image reference is missing alt text: %s", image))
    }

    is_external <- grepl("^(https?:|data:|#)", image_path)
    if (!is_external) {
      resolved <- normalizePath(file.path(module_dir, image_path), mustWork = FALSE)
      if (!file.exists(resolved)) {
        failures <- c(failures, sprintf("Local image reference does not exist: %s -> %s", image_path, resolved))
      }
    }
  }
}

if (length(failures)) {
  stop(paste(failures, collapse = "\n"), call. = FALSE)
}
