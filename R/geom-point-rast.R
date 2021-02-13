#' This geom is similar to \code{\link[ggplot2]{geom_point}}, but creates a raster layer
#'
#' @inheritParams ggplot2::geom_point
#' @inheritSection ggplot2::geom_point Aesthetics
#'
#' @import ggplot2
#' @param raster.dpi An integer of length one setting the desired resolution in dots per inch. (default=300)
#' @param dev A character specifying a device. Can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"}. (default="cairo")
#' @return geom_point plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot() + geom_point_rast(aes(x=rnorm(1000), y=rnorm(1000)), raster.dpi=600)
#'
#' @export
geom_point_rast <- function(..., raster.dpi=getOption("ggrastr.default.dpi", 300), dev="cairo") {
  rasterise(geom_point(...), dpi=raster.dpi, dev=dev)
}
