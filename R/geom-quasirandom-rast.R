#' This geom is similar to \code{\link[ggbeeswarm]{geom_quasirandom}}, but creates a raster layer
#'
#' @inheritParams geom_point_rast
#' @inheritParams ggbeeswarm::position_quasirandom
#' @inheritSection ggplot2::geom_point Aesthetics
#' @param raster.dpi An integer of length one setting the desired resolution in dots per inch. (default=NULL)
#' @param dev A character specifying a device. Can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"}. (default="cairo")
#' @return geom_quasirandom plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot(mtcars) + geom_quasirandom_rast(aes(x = factor(cyl), y = mpg), raster.dpi = 600)
#'
#' @export
geom_quasirandom_rast <- function(..., width = NULL, varwidth = FALSE, bandwidth = 0.5, nbins = NULL, method = "quasirandom", groupOnX = NULL, dodge.width = 0, raster.dpi = 300, dev="cairo") {
  rasterise(ggbeeswarm::geom_quasirandom(..., width = width, varwidth = varwidth, bandwidth = bandwidth, nbins = nbins, method = method, groupOnX = groupOnX, dodge.width = dodge.width), dpi=raster.dpi, dev=dev)
}
