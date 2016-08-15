# Packages ====
library("tidyr")


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
  var <- tidyr::spread(var, CELL_NAME, OBS_VALUE)
  var <- as.data.frame(var)

  var

}


# LADs ====

# Read files
lad_car <- readr::read_csv("inst/extdata/lad_car.csv")
lad_ten <- readr::read_csv("inst/extdata/lad_ten.csv")
lad_eau <- readr::read_csv("inst/extdata/lad_eau.csv")
lad_ppr <- readr::read_csv("inst/extdata/lad_ppr.csv")

# Tidy files
# _ppr doesn't use "CELL_NAME" so is inconsistent with the other files
# rename appropriate column to work with function
colnames(lad_ppr)[20] <- "CELL_NAME"

lad_car <- tidy_nomis(lad_car)
lad_ten <- tidy_nomis(lad_ten)
lad_eau <- tidy_nomis(lad_eau)
lad_ppr <- tidy_nomis(lad_ppr)



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

# Write updated shapefile
rgdal::writeOGR(lad_shp, "data", driver = "ESRI Shapefile")
