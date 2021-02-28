#' This geom is similar to \code{\link[ggplot2]{geom_point}}, but creates a raster layer
#'
#' @inheritParams ggplot2::geom_point
#' @inheritSection ggplot2::geom_point Aesthetics
#'
#' @import ggplot2
#' @param raster.dpi integer Resolution of the rastered image in dots per inch (default=300).
#' @param dev string Specifies the device used, which can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"} (default="cairo").
#' @param scale numeric Scaling factor to modify the raster object size (default=1). The parameter 'scale=1' results in an object size that is unchanged, 'scale'>1 increase the size, and 'scale'<1 decreases the size. These parameters are passed to 'height' and 'width' of grid::grid.raster(). Please refer to 'rasterise()' and 'grid::grid.raster()' for more details.
#' @return geom_point plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot() + geom_point_rast(aes(x=rnorm(1000), y=rnorm(1000)), raster.dpi=600)
#'
#' @export
geom_point_rast <- function(..., raster.dpi=getOption("ggrastr.default.dpi", 300), dev="cairo", scale=1) {
  rasterise(geom_point(...), dpi=raster.dpi, dev=dev, scale=scale)
}
