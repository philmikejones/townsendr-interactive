#' get_shape
#'
#' Internal (not exported) function for obtaining and unziping shapefiles,
#' typically from edina.ac.uk
#'
#' Typically used with `create_z()` function. Call for its side effects; i.e.
#' does not need to be assigned (`<-`)
#'
#' @param url URL to obtain the shapefile from
#' @param destfile destination to download the zip archive to
#' @param exdir destination to unzip the shapefiles to
#' @param ... extra arguments to pass to download.file (i.e. method = "wget")
#'
#' @return Returns an unzipped shapefile
#'
#' @export
#'
#' @examples get_shape(shape_url, "inst/extdata/shape.zip", "inst/extdata")
get_shape <- function(url, destfile, exdir, ...) {
  utils::download.file(url, destfile = destfile, ...)
  utils::unzip(destfile, exdir = exdir)
}

#' prep_variable
#'
#' Prepares Townsend variables from raw data obtained from Nomis web. Internal
#' function.
#'
#' Removes last row if it contains NAs, removes unneeded columns, and spreads
#' the data to form a tidy data frame
#'
#' Expects a data frame with at least the following columns (other columns can
#' be present and are silently dropped):
#' \enumerate{
#'  \item GEOGRAPHY_CODE
#'  \item GEOGRAPHY_NAME
#'  \item CELL_NAME
#'  \item OBS_VALUE
#' }
#' Data frames in this format can be obtained from Nomis
#'
#' @param var A data frame to tidy
#'
#' @return Returns a (tidy) data frame
#'
#' @seealso Nomis: \url{http://www.nomisweb.co.uk}
#'
#' @export
#'
#' @examples prep_variable(lad_car)  # where lad_car is a data frame object
prep_variable <- function(var) {
  if (all(is.na(var[nrow(var), ]))) {  # test if last row is NA
    var <- var[-nrow(var), , drop = FALSE]  # remove last row containing NAs
  }
  var <- var[, c("GEOGRAPHY_CODE", "GEOGRAPHY_NAME", "CELL_NAME",
                 "OBS_VALUE"), drop = FALSE]
  var <- tidyr::spread(var, CELL_NAME, OBS_VALUE)
  var <- as.data.frame(var)

  var

}

#' calc_z
#'
#' Calculates the z score of a given data frame column. Internal function
#' which is usually called as part of `create_z` function.
#'
#' @param var Variable to scale (create z score)
#' @param ... additional arguments to pass to scale() (e.g. to change default
#' behaviour of scale and center arguments)
#'
#' @return Returns a vector with z scores calculated from called argument.
#' Typically assigned to a new column from the original data frame.
#'
#' @export
#'
#' @examples calc_z(lad_car) Calculates z score for car ownership
calc_z <- function(var, ...) {
  z <- var[["variable"]] / var[["total"]] * 100
  z <- scale(z, scale = TRUE, center = TRUE)
  z <- as.vector(z)  # removes attributes
  z
}

#' create_z
#'
#' Creates a data frame containing the geography code, name, and z_score for
#' the variable requested
#'
#' Expects at least the following columns (other columns are silenty dropped):
#' \enumerate{
#'  \item GEOGRAPHY_CODE
#'  \item GEOGRAPHY_NAME
#'  \item CELL_NAME
#'  \item OBS_VALUE
#' }
#'
#' Data frames of this specific format can be obtained from Nomis Web.
#'
#' @param var A dataframe containing geography code, geography name, total
#' population, and population of interest (the Townsend variable) to perform
#' the z calculation on
#'
#' @return A tidy data frame containing geography code, geography name, and
#' z score
#'
#' @seealso Nomis web: \url{http://nomisweb.co.uk}
#'
#' @export
#'
#' @examples create_z(lad_car)
create_z <- function(var) {
  if (!is.data.frame(var)) {
    var <- as.data.frame(var)
    message(paste(var, "converted to data frame"))
  }
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

  var <- prep_variable(var)

  if (ncol(var) > 4) {
    colnames(var)[4:ncol(var)] <- "variable"
    var[, 4]                   <- rowSums(var[, 4:ncol(var)])
    var                        <- var[, 1:4]
  }

  colnames(var) <- c("code", "name", "total", "variable")
  var[["z_"]]   <- calc_z(var)
  var           <- var[, grep("code|name|z_", colnames(var))]

  var
}
