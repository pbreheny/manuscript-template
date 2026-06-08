library(data.table)
library(knitr)
library(glue)
library(tidyr)

cache <- "../../cache"
res <- glue("{cache}/ex-100-2.csv") |>
  fread()

# Make table
dir.create("../results", showWarnings = FALSE)
res$Ratio <- glue_data(res, "{n1}:{n2}")
res[delta == 0 & n2 %in% c(16, 10, 4), .(t1e = mean(p < 0.05)), .(Ratio, method)] |>
  pivot_wider(names_from = method, values_from = t1e) |>
  kable("latex", booktabs = TRUE, digits = 2) |>
  writeLines("../results/error-rate.tex")
