library("maptools")

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

# Create a copy of england
file_extensions <- list("dbf", "prj", "shp", "shx")
lapply(file_extensions, function(x) {
  file.copy(paste0("inst/extdata/england_lad_2011_gen.", x),
            paste0("inst/extdata/lad_2011_gen.", x),
            overwrite = TRUE)
})
rm(file_extensions)

# Merge Wales into copy
system("./data-raw/combine-shapefiles.sh")

# Load shape and drop unneeded variables
lad_shp <- rgdal::readOGR("inst/extdata", "lad_2011_gen",
                          stringsAsFactors = FALSE)
lad_shp@data <- dplyr::select(lad_shp@data, -altname, -oldlabel)

# Find unmatched codes
replacements <- dplyr::full_join(lad_shp@data, lad_index,
                                 by = c("label" = "code"))
replacements <- replacements[is.na(replacements$name.y), ]

for (i in seq_along(replacements$name.x)) {
  lad_index$code[lad_index$name == replacements$name.x[i]] <-
    replacements$label[i]
}
rm(i)
rm(replacements)

lad_shp@data <- dplyr::inner_join(lad_shp@data, lad_index,
                                  by = c("label" = "code"))

if (nrow(lad_index) != nrow(lad_shp)) {
  stop("Error in shapefile join, nrows do not match")
}

# Tidy for ggplot
lad_index_f <- broom::tidy(lad_shp, region = "label")
