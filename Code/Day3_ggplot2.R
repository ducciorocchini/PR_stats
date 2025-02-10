library(viridis)
library(RStoolbox)
library(imageRy)

# list files
im.list()

# import file
mato <- im.import("matogrosso_ast_2006209_lrg.jpg")

ggR(mato, layer=1:2, geom_raster=T, stretch="lin") +
scale_fill_viridis(colors=viridis(100))

