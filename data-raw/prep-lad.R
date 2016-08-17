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
library("rgdal")
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





# Move shapefiles to separate folder
# qgis:mergevectorlayers alg expects all files to be merged in one dir
dir.create("inst/extdata/shapefiles", showWarnings = FALSE)

shapes <- list.files("inst/extdata/", pattern = "wales", full.names = TRUE)
file.copy(shapes, "inst/extdata/shapefiles/")
file.remove(shapes)

shapes <- list.files("inst/extdata/", pattern = "england", full.names = TRUE)
file.copy(shapes, "inst/extdata/shapefiles/")
file.remove(shapes)
rm(shapes)


get_usage(alg = "qgis:mergevectorlayers", qgis_env = my_env, intern = TRUE)

params <- get_args_man(alg = "qgis:mergevectorlayers", qgis_env = my_env)
params$LAYERS <- c("inst/extdata/shapefiles/england_lad_2011_gen.shp",
                   "inst/extdata/shapefiles/wales_lad_2011_gen.shp")
params$OUTPUT <- "inst/extdata/test.shp"

out <- run_qgis(alg = "qgis:mergevectorlayers", params = params, qgis_env = my_env)

info <- qgis_session_info()
info$supported_saga_versions

stop()











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
