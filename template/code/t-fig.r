library(data.table)
library(ggplot2)
library(glue)
theme_set(theme_minimal())

cache <- "../../cache"
res <- glue("{cache}/ex-100-2.csv") |>
  fread()

# Make figure
p <- res[sd2 == 3, .(power = mean(p < 0.05)), .(n2, method)] |>
  ggplot(aes(n2, power, group = method, color = method)) +
  geom_line()
dir.create("out", showWarnings = FALSE)
ggsave("out/t-fig.pdf", p, width = 5, height = 3)
