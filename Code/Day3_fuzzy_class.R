library(imageRy)
library(terra)
library(RStoolbox)
library(tidyverse)

im.list()

mato <- im.import("matogrosso_ast_2006209_lrg.jpg")

im.plotRGB(mato, 1, 2, 3, title="Matogrosso")

em <- rbind(
  data.frame(mato[c(1, 10, 100)], class="forest"),
  data.frame(mato[c(400, 500, 1000)], class="human")
)

# Unmixing
fracs <- mesma(mato, em)
plot(fracs)

