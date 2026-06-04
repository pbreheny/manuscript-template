library(data.table)
library(ggplot2)
library(glue)

cache <- "../../cache"
res <- glue("{cache}/ex-100-2.csv") |>
  fread()

# Make figure
p <- res[sd2 == 3, .(power = mean(p < 0.05)), .(n2, equal_var)] |>
  ggplot(aes(n2, power, group = equal_var, color = equal_var)) +
  geom_line()
dir.create("out", showWarnings = FALSE)
ggsave("out/t-fig.pdf", p, width = 5, height = 3)
