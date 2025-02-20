library(terra)
library(imageRy)
library(hexbin)

b8 <- im.import("sentinel.dolomites.b8.tif")

dol <- im.import("sentinel.dol")

dol

dol1 = dol[[1]]
dol2 = dol[[2]]
plot(dol1, dol2)

# NDVI
ndvi <- im.import("NDVI_20")
plot(ndvi[[2]], ndvi[[3]])


library(hexbin)

dold = as.data.frame(dol1)
dol2d = as.data.frame(dol2)

hbin = hexbin(dold[[1]], dol2d[[1]], xbins = 40)
plot(hbin)

library(ggplot2)
ggplot(data.frame(x = rnorm(10000), y = rnorm(10000)), aes(x = x, y = y)) +
  geom_hex() + coord_fixed() +
  scale_fill_viridis() + theme_bw()
