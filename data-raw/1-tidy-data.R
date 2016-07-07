# LADs ====
lad_car <- readr::read_csv("inst/extdata/lad_car.csv")
lad_car <- lad_car[-nrow(lad_car), ]  # remove last row containing NAs
lad_car <- lad_car[, c("GEOGRAPHY_CODE", "GEOGRAPHY_NAME", "CELL_NAME",
                       "OBS_VALUE"), drop = FALSE]
lad_car <- tidyr::spread(lad_car, CELL_NAME, OBS_VALUE)

stop()

car[["pc_car"]] <- car[["No cars or vans in household"]] /
  car[["All categories: Car or van availability"]]
car[["pc_car"]] <- car[["pc_car"]] * 100
car$z_car <- scale(car$pc_car, scale = TRUE, center = TRUE)
car <- dplyr::select(car, -3, -4, -5)
colnames(car) <- c("geo_code", "geo_name", "z_car")

ppr <- readr::read_csv("extdata/lad_ppr.csv")
ppr <- ppr[-nrow(ppr), ]
ppr <- dplyr::select(ppr, GEOGRAPHY_CODE, GEOGRAPHY_NAME, C_PPROOMHUK11_NAME,
                     OBS_VALUE)
ppr <- tidyr::spread(ppr, C_PPROOMHUK11_NAME, OBS_VALUE)
ppr[["pc_ppr"]] <- ppr[["Over 1.0 and up to 1.5 persons per room"]] +
  ppr[["Over 1.5 persons per room"]]
ppr[["pc_ppr"]] <- ppr[["pc_ppr"]] /
  ppr[["All categories: Number of persons per room in household"]]
ppr[["pc_ppr"]] <- ppr[["pc_ppr"]] * 100
ppr$z_ppr <- scale(ppr$pc_ppr, scale = TRUE, center = TRUE)
ppr <- dplyr::select(ppr, -3, -4, -5, -6)
colnames(ppr) <- c("geo_code", "geo_name", "z_ppr")

ten <- readr::read_csv("extdata/lad_ten.csv")
ten <- ten[-nrow(ten), ]
ten <- dplyr::select(ten, GEOGRAPHY_CODE, GEOGRAPHY_NAME, CELL_NAME, OBS_VALUE)
ten <- tidyr::spread(ten, CELL_NAME, OBS_VALUE)
ten[["pc_ten"]] <- ten[["Owned"]] / ten[["All households"]]
ten[["pc_ten"]] <- ten[["pc_ten"]] * 100
ten$z_ten <- scale(ten$pc_ten, scale = TRUE, center = TRUE)
ten <- dplyr::select(ten, -3, -4, -5)
colnames(ten) <- c("geo_code", "geo_name", "z_ten")

eau <- readr::read_csv("extdata/lad_eau.csv")
eau <- eau[-nrow(eau), ]
eau <- dplyr::select(eau, GEOGRAPHY_CODE, GEOGRAPHY_NAME, CELL_NAME, OBS_VALUE)
eau <- tidyr::spread(eau, CELL_NAME, OBS_VALUE)
eau[["pc_eau"]] <- eau[["Economically active: Unemployed"]] /
  eau[["Economically active: Total"]]
eau[["pc_eau"]] <- eau[["pc_eau"]] * 100
eau$z_eau <- scale(eau$pc_eau, scale = TRUE, center = TRUE)
eau <- dplyr::select(eau, -3, -4, -5)
colnames(eau) <- c("geo_code", "geo_name", "z_eau")

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
