# LADs ====
lad_car <- readr::read_csv("inst/extdata/lad_car.csv")
lad_car <- create_z(lad_car)

lad_ten <- readr::read_csv("inst/extdata/lad_ten.csv")
lad_ten <- create_z(lad_ten)

lad_eau <- readr::read_csv("inst/extdata/lad_eau.csv")
lad_eau <- create_z(lad_eau)

lad_ppr <- readr::read_csv("inst/extdata/lad_ppr.csv")
colnames(lad_ppr)[20] <- "CELL_NAME"
lad_ppr <- create_z(lad_ppr)

dfs <- mget(objects())
rm(lad_car, lad_ten, lad_eau, lad_ppr)
lad_index <- purrr::reduce(dfs, dplyr::inner_join, by = c("code", "name"))

if (nrow(dfs[[1]]) != nrow(lad_index)) {
  stop("Number of rows don't match")
}
rm(dfs)

lad_index$z <- rowSums(lad_index[, grep("z_", colnames(lad_index))])
lad_index   <- lad_index[, c("code", "name", "z")]

# Load LAD shapefile
lad_shp <- rgdal::readOGR("inst/extdata", "lad_2011_gen")
