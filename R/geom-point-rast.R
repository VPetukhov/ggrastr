#' This geom is similar to \code{\link[ggplot2]{geom_point}}, but creates a raster layer
#'
#' @inheritParams ggplot2::geom_point
#' @inheritSection ggplot2::geom_point Aesthetics
#'
#' @import ggplot2
#' @param raster.width Width of the result image (in inches). Default: deterined by the current device parameters.
#' @param raster.height Height of the result image (in inches). Default: deterined by the current device parameters.
#' @param raster.dpi Resolution of the result image.
#' @return geom_point plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot() + geom_point_rast(aes(x=rnorm(1000), y=rnorm(1000)), raster.dpi=600)
#'
#' @export
geom_point_rast <- function(..., raster.dpi=300) {
  rasterise(geom_point(...), dpi=raster.dpi)
}
