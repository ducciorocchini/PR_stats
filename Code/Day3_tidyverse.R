# Close R and reopen it
# Source: https://cran.r-project.org/web/packages/tidyterra/vignettes/tidyterra.html

library(tidyterra)
library(tidyverse) # Load all the packages of tidyverse at once
library(scales) # Additional library for labels

# Temperatures in Castille and Leon (selected months)
rastertemp <- terra::rast(system.file("extdata/cyl_temp.tif",
  package = "tidyterra"
))

# Rename with the tidyverse
rastertemp <- rastertemp %>%
  rename(April = tavg_04, May = tavg_05, June = tavg_06)


# Plot with facets
ggplot() +
  geom_spatraster(data = rastertemp) +
  facet_wrap(~lyr, ncol = 2) +
  scale_fill_whitebox_c(
    palette = "muted",
    labels = label_number(suffix = "º"),
    n.breaks = 12,
    guide = guide_legend(reverse = TRUE)
  ) +
  labs(
    fill = "",
    title = "Average temperature in Castille and Leon (Spain)",
    subtitle = "Months of April, May and June"
  )

# Compute the variation between April and June and apply a different palette
incr_temp <- rastertemp %>%
  mutate(var = June - April) %>%
  select(Variation = var)

# Overlay an SpatVector
cyl_vect <- terra::vect(system.file("extdata/cyl.gpkg",
  package = "tidyterra"
))

# Contour map with overlay
ggplot() +
  geom_spatraster_contour_filled(data = incr_temp) +
  geom_spatvector(data = cyl_vect, fill = NA) +
  scale_fill_whitebox_d(palette = "bl_yl_rd") +
  theme_grey() +
  labs(
    fill = "º Celsius",
    title = "Variation of temperature in Castille and Leon (Spain)",
    subtitle = "Difference between April and June"
  )
