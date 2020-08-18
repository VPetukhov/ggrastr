#' This geom is similar to \code{\link[ggplot2]{geom_jitter}}, but creates a raster layer
#'
#' @inheritParams geom_point_rast
#' @inheritSection ggplot2::geom_point Aesthetics
#' @import ggplot2
#' @param width Amount of vertical and horizontal jitter. The jitter is added in both positive and negative directions, so the total spread is twice the value specified here. Refer to ggplot2::position_jitter.
#' @param height Amount of vertical and horizontal jitter. The jitter is added in both positive and negative directions, so the total spread is twice the value specified here. Refer to ggplot2::position_jitter.
#' @param seed A random seed to make the jitter reproducible. Refer to ggplot2::position_jitter.
#' @param raster.dpi An integer of length one setting the desired resolution in dots per inch. (default=NULL)
#' @param dev A character specifying a device. Can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"}. (default="cairo")
#' @return geom_point_rast plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot(mpg) + geom_jitter_rast(aes(x = factor(cyl), y = hwy), raster.dpi = 600)
#'
#' @export
geom_jitter_rast <- function(..., raster.dpi = 300, dev="cairo"){
  rasterise(geom_jitter(...), dpi=raster.dpi, dev=dev)
}