# Species Distribution Modelling
# install.packages("sdm")
# install.packages("rgdal", dependencies=T)
# install.packages("viridis")

library(sdm)
library(raster) # predictors
# library(rgdal) # species
library(viridis)

file <- system.file("external/species.shp", package="sdm") 
species <- shapefile(file)

# looking at the set
species

# plot
plot(species)

# looking at the occurrences
species$Occurrence

# copy and then write:
plot(species[species$Occurrence == 1,],col='blue',pch=16)
points(species[species$Occurrence == 0,],col='red',pch=16)

# predictors: look at the path
path <- system.file("external", package="sdm") 

# list the predictors
lst <- list.files(path=path,pattern='asc$',full.names = T) #
lst

# stack
preds <- stack(lst)

# plot preds
plot(preds, col=viridis(100))

# plot predictors and occurrences
plot(preds$elevation, col=viridis(100), main="elevation")
points(species[species$Occurrence == 1,], pch=16)

plot(preds$temperature, col=viridis(100), main="temperature")
points(species[species$Occurrence == 1,], pch=16)

plot(preds$precipitation, col=viridis(100), main="precipitation")
points(species[species$Occurrence == 1,], pch=16)

plot(preds$vegetation, col=viridis(100), main="vegetation")
points(species[species$Occurrence == 1,], pch=16)

# model

# set the data for the sdm
datasdm <- sdmData(train=species, predictors=preds)

# model
m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data=datasdm, methods = "glm")

# make the raster output layer
p1 <- predict(m1, newdata=preds) 

# plot the output
plot(p1, col=viridis(100))
points(species[species$Occurrence == 1,], pch=16)

# colorist

# https://besjournals.onlinelibrary.wiley.com/doi/epdf/10.1111/2041-210X.13477

# First map

library(colorist)
data("fiespa_occ")

# First map with single distributions
m1 <- metrics_pull(fiespa_occ)
p1 <- palette_timecycle(fiespa_occ)
map_multiples(m1, p1, ncol=4, labels=names(fiespa_occ))

# Common map
m1_distill <- metrics_distill(fiespa_occ)
map_single(m1_distill, p1)

# Spheric graph
legend_timecycle(p1, origin_label="Jan 1")

# Second example single maps
data("elephant_ud")
m2 <- metrics_pull(elephant_ud)
p2 <- palette_set(2)
map_multiples(m2, p2, ncol = 2, lambda_i=-5,labels=names(elephant_ud))

# Common map
m2_distill <- metrics_distill(elephant_ud)
map_single(m2_distill, p2, lambda_i=-5)

# Legends
legend_set(p2, group_labels=names(elephant_ud))

# cartograms

# https://cran.r-project.org/web/packages/cartogram/readme/README.html

library(cartogram)
library(sf)
library(tmap)

data("World")
afr <- World[World$continent == "Africa", ]

# project the map
afr <- st_transform(afr, 3395)
worldn <- st_transform(World, 3395)

# construct cartogram
afr_cont <- cartogram_cont(afr, "pop_est", itermax = 5)
worldn_cont <- cartogram_cont(worldn, "pop_est", itermax = 5)

# plot it
tm_shape(afr_cont) + tm_polygons("pop_est", style = "jenks") +
  tm_layout(frame = FALSE, legend.position = c("left", "bottom"))

tm_shape(worldn_cont) + tm_polygons("pop_est", style = "jenks") +
  tm_layout(frame = FALSE, legend.position = c("left", "bottom"))

