#' Create a "flat" tex file (self-contained, except for figures)
#'
#' Fills in input statements, fig/ references, bibliography, etc., so that the
#' resulting tex file is portable and can be compiled anywhere with no
#' additional input files.
#'
#' Usage:
#'     Rscript code/singletex.r my-paper.tex arxiv/my-paper.tex
#'
#' * Run from manuscript home
#' * First argument is wrapper file
#' * Second argument is where you want the flat tex file to be
suppressMessages({
  library(stringr)
  library(glue)
})

# Process arguments
opt <- commandArgs(TRUE)
infile <- opt[[1]]
outfile <- opt[[2]]

add_ext <- function(path, ext) {
  ifelse(str_detect(path, fixed(".")), path, glue("{path}.{ext}"))
}

# Determine graphics path
for (texfile in list.files(pattern = "*.tex", full.names = TRUE)) {
  tex = readLines(texfile)
  path_line <- grep("graphicspath", tex, value = TRUE)
  if (length(path_line) != 0) break
}
fig_dir <- gsub(r"(.*\{\{([^\}]+)\}\})", "\\1", path_line, perl = TRUE)

# Scan for inputs
new <- readLines(infile)
repeat {
  ind <- grep("\\input\\{", new)[1]
  if (is.na(ind)) break
  old <- new
  filename <- str_replace(old[ind], fixed("}"), "") |>
    str_replace(fixed("\\input{"), "") |>
    trimws() |>
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
file.copy(glue("{fig_dir}/{fig}"), dirname(outfile)) |>
  invisible()

# Bibliography
old <- new
stem <- tools::file_path_sans_ext(infile)
ind <- grep("\\\\bibliography\\{", old)
buf <- readLines(glue("{stem}/{stem}.bbl"))
new <- c(old[1:(ind - 1)], buf, old[-(1:ind)])

# Write tex
writeLines(new, outfile)
