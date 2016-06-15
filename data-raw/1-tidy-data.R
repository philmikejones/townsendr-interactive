source("data-raw/0-download-data.R")

car <- readr::read_csv("extdata/lad_car.csv")
car <- car[-nrow(car), ]
car <- dplyr::select(car, GEOGRAPHY_CODE, GEOGRAPHY_NAME, CELL_NAME, OBS_VALUE)
car <- tidyr::spread(car, CELL_NAME, OBS_VALUE)
car[["pc_car"]] <- car[["No cars or vans in household"]] /
  car[["All categories: Car or van availability"]]
car[["pc_car"]] <- car[["pc_car"]] * 100
car <- dplyr::select(car, -3, -4)
colnames(car) <- c("geo_code", "geo_name", "pc_car")

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
ppr <- dplyr::select(ppr, -3, -4, -5)
colnames(ppr) <- c("geo_code", "geo_name", "pc_ppr")

ten <- readr::read_csv("extdata/lad_ten.csv")
ten <- ten[-nrow(ten), ]
ten <- dplyr::select(ten, GEOGRAPHY_CODE, GEOGRAPHY_NAME, CELL_NAME, OBS_VALUE)
ten <- tidyr::spread(ten, CELL_NAME, OBS_VALUE)
ten[["pc_ten"]] <- ten[["Owned"]] / ten[["All households"]]
ten[["pc_ten"]] <- ten[["pc_ten"]] * 100
ten <- dplyr::select(ten, -3, -4)
colnames(ten) <- c("geo_code", "geo_name", "pc_ten")

eau <- readr::read_csv("extdata/lad_eau.csv")
eau <- eau[-nrow(eau), ]
eau <- dplyr::select(eau, GEOGRAPHY_CODE, GEOGRAPHY_NAME, CELL_NAME, OBS_VALUE)
eau <- tidyr::spread(eau, CELL_NAME, OBS_VALUE)
eau[["pc_eau"]] <- eau[["Economically active: Unemployed"]] /
  eau[["Economically active: Total"]]
eau[["pc_eau"]] <- eau[["pc_eau"]] * 100
eau <- dplyr::select(eau, -3, -4)
colnames(eau) <- c("geo_code", "geo_name", "pc_eau")
