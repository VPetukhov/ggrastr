#' This geom is similar to \code{\link[ggbeeswarm]{geom_quasirandom}}, but creates a raster layer
#'
#' @inheritParams geom_point_rast
#' @inheritParams ggbeeswarm::position_quasirandom
#' @inheritSection ggplot2::geom_point Aesthetics
#'
#' @param raster.dpi integer Resolution of the rastered image in dots per inch (default=300).
#' @param dev string Specifies the device used, which can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"} (default="cairo").
#' @param scale numeric Scaling factor to modify the raster object size (default=1). The parameter 'scale=1' results in an object size that is unchanged, 'scale'>1 increase the size, and 'scale'<1 decreases the size. These parameters are passed to 'height' and 'width' of grid::grid.raster(). Please refer to 'rasterise()' and 'grid::grid.raster()' for more details.
#' @return geom_quasirandom plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot(mtcars) + geom_quasirandom_rast(aes(x = factor(cyl), y = mpg), raster.dpi = 600)
#'
#' @export
geom_quasirandom_rast <- function(..., width = NULL, varwidth = FALSE, bandwidth = 0.5, nbins = NULL, method = "quasirandom", groupOnX = NULL, dodge.width = 0, raster.dpi = getOption("ggrastr.default.dpi", 300), dev="cairo", scale=1) {
  rasterise(ggbeeswarm::geom_quasirandom(..., width = width, varwidth = varwidth, bandwidth = bandwidth, nbins = nbins, method = method, groupOnX = groupOnX, dodge.width = dodge.width), dpi=raster.dpi, dev=dev, scale=scale)
}
