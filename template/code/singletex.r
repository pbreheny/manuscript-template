#!/usr/bin/env Rscript
suppressMessages({
  library(docopt)
  library(stringr)
  library(glue)
})
doc <- "Create a \"flat\" tex file

Usage: singletex <infile> <outfile> [-h]

Fills in input statements, fig/ references, bibliography, etc., so that the
resulting tex file (output to stdin) is portable and can be
compiled anywhere with no additional input files.

Arguments:
  infile     Input .tex file (manuscript.tex)
  outfile    Output .tex file (sub/arxiv/manuscript.tex)

Options:
  -h         Show this help screen"
opt <- docopt(doc)

new <- readLines(opt$infile)

add_ext <- function(path, ext) {
  ifelse(str_detect(path, fixed(".")), path, glue("{path}.{ext}"))
}

# Determine graphics path
fig_dir_line <- grep("graphicspath", new)
if (length(fig_dir_line)) {
  fig_dir_line <- grep("graphicspath", new)
  fig_dir <- gsub(".*\\{\\{([^\\}]+)\\}\\}", "\\1", new[fig_dir_line], perl = TRUE)
}

# Scan for inputs
repeat {
  ind <- grep("\\input\\{", new)[1]
  if (is.na(ind)) break
  old <- new
  filename <- str_replace(old[ind], fixed("}"), "") |>
    str_replace(fixed("\\input{"), "") |>
    add_ext("tex")
  if (file.exists(filename)) {
    buf <- readLines(filename)
  } else if (file.exists(glue("{fig_dir}/{filename}"))) {
    buf <- readLines(glue("{fig_dir}/{filename}"))
  } else {
    stop(glue("Cannot locate {filename}"), call. = FALSE)
  }
  new <- c(old[1:(ind - 1)], buf, old[-(1:ind)])
}

# Copy figs
fig_lines <- grep("^[^%].*includegraphics", new, value = TRUE)
fig <- gsub("[^\\{]+\\{([^\\}]+)\\}.*", "\\1", fig_lines, perl = TRUE) |>
  add_ext("pdf")
file.copy(glue("{fig_dir}/{fig}"), dirname(opt$outfile)) |>
  invisible()

# Bibliography
old <- new
stem <- tools::file_path_sans_ext(opt$infile)
ind <- grep("\\\\bibliography\\{", old)
buf <- readLines(glue("build/{stem}.bbl"))
new <- c(old[1:(ind - 1)], buf, old[-(1:ind)])

# Write tex
writeLines(new, opt$outfile)
