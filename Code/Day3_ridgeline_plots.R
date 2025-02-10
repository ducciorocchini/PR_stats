library(sf)
library(terra)
library(tidyverse)
library(ggplot2)
library(imageRy)
library(ggridges)

r <- im.import("greenland")
plot(r)

df <- as.data.frame(r) 

dfpl <- df %>%
  flatten_dbl() %>%
  as.data.frame() %>%
  mutate(year = rep(names(r), each = nrow(df)))

colnames(dfpl)[1] <- "value"

ggplot(dfpl, aes(x = value, y = as.factor(year), fill = stat(x))) +
  geom_density_ridges_gradient(scale = 2, rel_min_height = 0.01) +
  scale_fill_viridis_c(option = "magma") 


# Ridgeline plots
# Example with NDVI data

# NDVI file
ndvi <- im.import("NDVI_2020")

plot(ndvi)

plot(ndvi[[2]],ndvi[[3]])
abline(0,1,col="red")

# Ridgeline plot
names(ndvi) <- c("01 January","05 May","08 August","11 November")
im.ridgeline(ndvi, 2, "viridis")
