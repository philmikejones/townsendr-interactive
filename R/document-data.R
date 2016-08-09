#' Townsend scores for LADs in England and Wales
#'
#' Spatial data set for use with ggplot2 (i.e. fortified) of Townsend scores
#' for LADs in England and Wales.
#'
#' @format A data frame with 216333 rows and 10 variables:
#' \describe{
#'  \item{long}{Longitude (x) coordinate}
#'  \item{lat}{Latitude (y) coordinate}
#'  \item{order}{Plot order (used internally)}
#'  \item{hole}{Logical: is the polygon empty?}
#'  \item{piece}{Polygon number}
#'  \item{group}{Polygon identifier}
#'  \item{id}{LAD identifier}
#'  \item{z}{z (Townsend) score for each LAD}
#'  \item{name}{LAD name}
#' }
#' @source \url{https://www.nomisweb.co.uk/census/2011}
"lad_index_f"
