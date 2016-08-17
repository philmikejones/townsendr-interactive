# 1. Tidy census data
# 2. Calculate individual z-scores
# 3. Merge z-scores into one data frame
# 4. Calculate overall z-score
# 5. Merge England and Wales Shapefiles


# Packages ====
library("tidyr")
library("magrittr")
library("dplyr")
library("rgdal")
library("rmapshaper")


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

lad_score <- lad_car %>%
  inner_join(lad_ten) %>%
  inner_join(lad_eau) %>%
  inner_join(lad_ppr)

if (nrow(lad_score) != nrow(lad_car)) {
  stop("Number of rows don't match")
}
rm(lad_car, lad_eau, lad_ppr, lad_ten)


lad_score$z <- rowSums(lad_score[, grep("z_", colnames(lad_score))])


eng_lad <- readOGR("inst/extdata", "england_lad_2011_gen",
                   stringsAsFactors = FALSE)
wal_lad <- readOGR("inst/extdata", "wales_lad_2011_gen",
                   stringsAsFactors = FALSE)

# Currently IDs overlap between Wales and England. Ensure unique ID for merge
spChFIDs(eng_lad) <- as.character(1:nrow(eng_lad@data))

wal_min <- nrow(eng_lad) + 1
wal_max <- nrow(eng_lad) + nrow(wal_lad)
stopifnot(
  all.equal(nrow(wal_lad) + nrow(eng_lad), wal_max)
)

spChFIDs(wal_lad) <- as.character(wal_min:wal_max)
rm(wal_max, wal_min)

lad_shp <- rbind(eng_lad, wal_lad)
rm(eng_lad, wal_lad)

lad_shp@data <- dplyr::select(lad_shp@data, -altname, -oldlabel)


# rmapshaper::ms_simplify() preserves topology
lad_shp <- ms_simplify(lad_shp, keep = 0.04)
lad_shp@data[] <- lapply(lad_shp@data, as.character)  # [] maintains df class


# Find unmatched codes
replacements <- dplyr::full_join(lad_shp@data, lad_score,
                                 by = c("label" = "GEOGRAPHY_CODE"))
replacements <- replacements[is.na(replacements$GEOGRAPHY_NAME), ]

for (i in seq_along(replacements$GEOGRAPHY_NAME)) {
  lad_score$GEOGRAPHY_CODE[lad_score$GEOGRAPHY_NAME ==
                             replacements$GEOGRAPHY_NAME[i]] <-
    replacements$label[i]
}
rm(i, replacements)


lad_shp@data <- dplyr::inner_join(lad_shp@data, lad_score,
                                  by = c("label" = "GEOGRAPHY_CODE"))
stopifnot(nrow(lad_score) != nrow(lad_shp))


# Write rds object
saveRDS(lad_shp, file = "data/lad_shp")
