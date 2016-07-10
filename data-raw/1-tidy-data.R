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
lad_index <- purrr::reduce(dfs, dplyr::inner_join, by = c("code", "name"))

lad_townsend <- dplyr::left_join(car, ppr, by = c("geo_code", "geo_name"))
lad_townsend <- dplyr::left_join(lad_townsend, ten,
                                 by = c("geo_code", "geo_name"))
lad_townsend <- dplyr::left_join(lad_townsend, eau,
                                 by = c("geo_code", "geo_name"))
rm(car, ppr, ten, eau)

lad <- rgdal::readOGR(dsn = "extdata/lad", "england_lad_2011_gen")
for (i in seq_along(colnames(lad@data))) {
  lad@data[, i] <- as.character(lad@data[, i])
}
rm(i)

no_match <- dplyr::anti_join(lad@data, lad_townsend,
                             by = c("label" = "geo_code"))
for (i in no_match[["name"]]) {
  lad_townsend$geo_code[lad_townsend$geo_name == i] <-
    lad@data$label[lad@data$name == i]
}
rm(i, no_match)

lad@data <- dplyr::left_join(lad@data, lad_townsend,
                             by = c("label" = "geo_code"))
stop("Need to add Wales in somehow")
