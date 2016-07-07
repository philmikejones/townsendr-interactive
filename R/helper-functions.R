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
