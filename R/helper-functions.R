#' get_shape
#'
#' Internal function for obtaining and unziping shapefiles,
#' typically from edina.ac.uk
#'
#' @param url URL to obtain the shapefile from
#' @param destfile destination to download the zip archive to
#' @param exdir destination to unzip the shapefiles to
#' @param ... extra arguments to pass to download.file (i.e. method = "wget")
#'
#' @return
#'
#' @examples get_shape(shape_url, "inst/extdata/shape.zip", "inst/extdata")
get_shape <- function(url, destfile, exdir, ...) {
  download.file(url, destfile = destfile, ...)
  unzip(destfile, exdir = exdir)
}

#' prep_variable
#'
#' Prepares Townsend variables. Specifically removes last row if it contains
#' NAs, removes unneeded columns, and spreads the data to form a tidy data
#' frame
#'
#' Expects the following columns:
#' 1. GEOGRAPHY_CODE
#' 2. GEOGRAPHY_NAME
#' 3. CELL_NAME
#' 4. OBS_VALUE
#'
#' These are obtained from Nomis
#'
#' @param var The variable to prepare
#'
#' @return
#'
#' @examples prep_variable(car)  # where car is a data frame object
prep_variable <- function(var) {
  if (all(is.na(var[nrow(var), ]))) {  # test if last row is NA
    var <- var[-nrow(var), , drop = FALSE]  # remove last row containing NAs
  }
  var <- var[, c("GEOGRAPHY_CODE", "GEOGRAPHY_NAME", "CELL_NAME",
                 "OBS_VALUE"), drop = FALSE]
  var <- tidyr::spread(var, CELL_NAME, OBS_VALUE)

  var

}

#' calc_z
#'
#' Calculates the z score of a given data frame variable. Usually called as
#' part of `create_z` function
#'
#' @param var Variable to scale (create z score)
#' @param scale arguments passed to scale(). Defaults to TRUE
#' @param center arguments passed to scale(). Defaults to TRUE
#'
#' @return
#'
#' @examples calc_z(lad_car) Calculates z score for car ownership
calc_z <- function(var, scale = TRUE, center = TRUE) {
  z <- var[["variable"]] / var[["total"]] * 100
  z <- scale(z, scale = scale, center = center)
  z
}

#' create_z
#'
#' Creates a data frame containing the geography code, name, and z_score for
#' the variable requested
#'
#' @param var A dataframe containing geography code, geography name, total
#' population, and population of interest (the Townsend variable) to perform
#' the z calculation on
#'
#' @return
#'
#' @examples create_z(lad_car)
create_z <- function(var) {
  var           <- prep_variable(var)
  colnames(var) <- c("code", "name", "total", "variable")
  var$z_car     <- calc_z(var)
  var           <- var[, grep("code|name|z_", colnames(var))]
}
