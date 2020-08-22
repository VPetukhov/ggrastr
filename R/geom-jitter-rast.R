#' This geom is similar to \code{\link[ggplot2]{geom_jitter}}, but creates a raster layer
#'
#' @inheritParams geom_point_rast
#' @inheritSection ggplot2::geom_point Aesthetics
#' @import ggplot2
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