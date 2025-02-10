# measuring variability from RS imagery

library(terra)
library(imageRy)
library(viridis)
library(rasterdiv)

im.list()

sent <- im.import("sentinel.png")

im.plotRGB.user(sent, 1, 2, 3)

nir <- sent[[1]]

# calculation
sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd)

viridis <- colorRampPalette(viridis(7))(255)
plot(sd3, col=viridis)

# stacking nir and sd
stacknv <- c(nir, sd3)
plot(stacknv, col=viridis)

# change the moving window
sd5 <- focal(nir, matrix(1/25, 5, 5), fun=sd)
stacknv <- c(nir, sd3, sd5)
plot(stacknv, col=viridis)

# change the moving window
sd7 <- focal(nir, matrix(1/49, 7, 7), fun=sd)
stacknv <- c(nir, sd3, sd5, sd7)
plot(stacknv, col=viridis)

# Shannon's H

# Shannon
shan3 <- Shannon(nir, window=3) 
plot(shan3)

# Speeding up:

# Cropping:
ext <- c(0, 100, 0, 100)
cropnir <- crop(nir, ext)
plot(cropnir)

shan3 <- Shannon(cropnir, window=3) 
plot(shan3)

# Or resampling:
# Example:
r <- rast(nrows=3, ncols=3, xmin=0, xmax=10, ymin=0, ymax=10)
values(r) <- 1:ncell(r)
s <- rast(nrows=25, ncols=30, xmin=1, xmax=11, ymin=-1, ymax=11)
x <- resample(r, s, method="bilinear")
opar <- par(no.readonly =TRUE)
par(mfrow=c(1,2))
plot(r)
plot(x)
par(opar)

# resampling
niragg <- aggregate(nir, fact=5)
plot(niragg)

#Rényi's Index
ren3 <- Renyi(niragg, window=3, alpha=seq(0,12,4), na.tolerance=0.2, np=1)
renstack <- c(ren3[[1]], ren3[[2]], ren3[[3]], ren3[[4]])
plot(renstack)

names(renstack) <- c("alpha=0","alpha=4","alpha=8","alpha=12")
plot(renstack)

