# 1. Download and unzip census data from NOMIS API
# 2. Tidy census data
# 3. Calculate individual z-scores
# 4. Merge z-scores into one data frame
# 5. Calculate overall z-score
# 6. Obtain shapefiles from census.ukdataservice.ac.uk
# 7. Merge England and Wales Shapefiles


# Packages ====
library("tidyr")
library("dplyr")
library("magrittr")
library("RQGIS"); my_env <- set_env("/usr")


# Functions ====
tidy_nomis <- function(var) {

  # Check the argument passed is a (untidy) data frame
  if (!is.data.frame(var)) {
    stop("Argument is not data.frame.\n
         Convert if necessary with 'as.data.frame()'")
  }

  # Last row often NA for some reason. Check and remove if necessary
  if (all(is.na(var[nrow(var), ]))) {
    var <- var[-nrow(var), , drop = FALSE]
  }

  # Check for the necessary columns
  if (!any(grepl("GEOGRAPHY_CODE", colnames(var)))) {
    stop("No column called `GEOGRAPHY_CODE`")
  }
  if (!any(grepl("GEOGRAPHY_NAME", colnames(var)))) {
    stop("No column called `GEOGRAPHY_NAME`")
  }
  if (!any(grepl("CELL_NAME", colnames(var)))) {
    stop("No column called `CELL_NAME`")
  }
  if (!any(grepl("OBS_VALUE", colnames(var)))) {
    stop("No column called `OBS_VALUE`")
  }

  var <- var[, c("GEOGRAPHY_CODE", "GEOGRAPHY_NAME", "CELL_NAME",
                 "OBS_VALUE"), drop = FALSE]
  var <- spread(var, CELL_NAME, OBS_VALUE)
  var <- as.data.frame(var)

  var

}


# LADs ====
lad_car <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_621_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "cell=0,1&measures=20100")
utils::download.file(lad_car, destfile = "inst/extdata/lad_car.csv")

lad_ppr <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_541_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "c_pproomhuk11=0,3,4&measures=20100")
utils::download.file(lad_ppr, destfile = "inst/extdata/lad_ppr.csv")

lad_ten <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_619_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "cell=0,100&measures=20100")
utils::download.file(lad_ten, destfile = "inst/extdata/lad_ten.csv")

lad_eau <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_556_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "cell=1,8&measures=20100")
utils::download.file(lad_eau, destfile = "inst/extdata/lad_eau.csv")


lad_car <- readr::read_csv("inst/extdata/lad_car.csv")
lad_ten <- readr::read_csv("inst/extdata/lad_ten.csv")
lad_eau <- readr::read_csv("inst/extdata/lad_eau.csv")
lad_ppr <- readr::read_csv("inst/extdata/lad_ppr.csv")


# _ppr doesn't use "CELL_NAME" so is inconsistent with the other files
# rename appropriate column to work with function
colnames(lad_ppr)[20] <- "CELL_NAME"

lad_car <- tidy_nomis(lad_car)
lad_ten <- tidy_nomis(lad_ten)
lad_eau <- tidy_nomis(lad_eau)
lad_ppr <- tidy_nomis(lad_ppr)


lad_car$z_car <- scale(lad_car[4] / lad_car[3])
attributes(lad_car$z_car) <- NULL

lad_ten$z_ten <- scale(lad_ten[4] / lad_ten[3])
attributes(lad_ten$z_ten) <- NULL

lad_eau$z_eau <- scale(lad_eau[4] / lad_ten[3])
attributes(lad_eau$z_eau) <- NULL

lad_ppr$z_ppr <- scale(rowSums(lad_ppr[, 4:5]) / lad_ppr[3])
attributes(lad_ppr$z_ppr) <- NULL


lad_car <- lad_car %>% select(GEOGRAPHY_CODE, GEOGRAPHY_NAME, z_car)
lad_ten <- lad_ten %>% select(GEOGRAPHY_CODE, GEOGRAPHY_NAME, z_ten)
lad_eau <- lad_eau %>% select(GEOGRAPHY_CODE, GEOGRAPHY_NAME, z_eau)
lad_ppr <- lad_ppr %>% select(GEOGRAPHY_CODE, GEOGRAPHY_NAME, z_ppr)

lad <- lad_car %>%
  inner_join(lad_ten) %>%
  inner_join(lad_eau) %>%
  inner_join(lad_ppr)

if (nrow(lad) != nrow(lad_car)) {
  stop("Number of rows don't match")
}
rm(lad_car, lad_eau, lad_ppr, lad_ten)


lad$z <- rowSums(lad[, grep("z_", colnames(lad))])


# method = "wget" necessary because edina.ac.uk doesn't return HEAD
# See https://github.com/wch/downloader/issues/8
eng_lad <- paste0("https://census.edina.ac.uk/ukborders/easy_download/",
                  "prebuilt/shape/England_lad_2011_gen.zip")
utils::download.file(eng_lad, "inst/extdata/eng_lad.zip", method = "wget")
utils::unzip("inst/extdata/eng_lad.zip", exdir = "inst/extdata")

wal_lad <- paste0("https://census.edina.ac.uk/ukborders/easy_download/",
                  "prebuilt/shape/Wales_lad_2011_gen.zip")
utils::download.file(wal_lad, "inst/extdata/wal_lad.zip", method = "wget")
utils::unzip("inst/extdata/wal_lad.zip", exdir = "inst/extdata")





# Create a copy of england, call it lad
file_extensions <- list("dbf", "prj", "shp", "shx")
lapply(file_extensions, function(x) {
  file.copy(paste0("inst/extdata/england_lad_2011_gen.", x),
            paste0("inst/extdata/lad_2011_gen.", x),
            overwrite = TRUE)
})
rm(file_extensions)

# Merge Wales into lad_
system("./data-raw/combine-shapefiles.sh")

# #! /bin/bash
#
# ogr2ogr -update -append -f 'ESRI Shapefile' \
# inst/extdata/lad_2011_gen.shp \
# inst/extdata/wales_lad_2011_gen.shp
#
# ogr2ogr -simplify 100 -f 'ESRI Shapefile' \
# inst/extdata/lad_2011_simp.shp         \
# inst/extdata/lad_2011_gen.shp


# Add z-scores to shapefile ====
# Load shape and drop unneeded variables
lad_shp <- rgdal::readOGR("inst/extdata", "lad_2011_gen",
                          stringsAsFactors = FALSE)
lad_shp@data <- dplyr::select(lad_shp@data, -altname, -oldlabel)


stop()

# Find unmatched codes
replacements <- dplyr::full_join(lad_shp@data, lad,
                                 by = c("label" = "GEOGRAPHY_CODE"))
replacements <- replacements[is.na(replacements$GEOGRAPHY_NAME), ]

for (i in seq_along(replacements$GEOGRAPHY_NAME)) {
  lad$code[lad$name == replacements$GEOGRAPHY_NAME[i]] <-
    replacements$label[i]
}
rm(i)
rm(replacements)

lad_shp@data <- dplyr::inner_join(lad_shp@data, lad,
                                  by = c("label" = "code"))

if (nrow(lad) != nrow(lad_shp)) {
  stop("Error in shapefile join, nrows do not match")
}

# Write updated shapefile
rgdal::writeOGR(lad_shp, "data", driver = "ESRI Shapefile")
