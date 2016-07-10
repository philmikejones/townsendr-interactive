# LADs ====
lad_car <- readr::read_csv("inst/extdata/lad_car.csv")
lad_car <- create_z(lad_car)

lad_ten <- readr::read_csv("inst/extdata/lad_ten.csv")
lad_ten <- create_z(lad_ten)

lad_eau <- readr::read_csv("inst/extdata/lad_eau.csv")
lad_eau <- create_z(lad_eau)

lad_ppr <- readr::read_csv("inst/extdata/lad_ppr.csv")



colnames(lad_ppr)[20] <- "CELL_NAME"
lad_ppr <- prep_variable(lad_ppr)
lad_ppr$variable <- rowSums(lad_ppr[, 4:5])
lad_ppr <- lad_ppr[, c(1:3, 6)]
colnames(lad_ppr) <- c("code", "name", "total", "variable")
lad_ppr$z_ppr <- calc_z(lad_ppr)
lad_ppr <- lad_ppr[, c("code", "name", "z_ppr")]






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
