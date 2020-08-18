#' This geom is similar to \code{\link[ggbeeswarm]{geom_quasirandom}}, but creates a raster layer
#'
#' @inheritParams geom_point_rast
#' @inheritParams ggbeeswarm::position_quasirandom
#' @inheritSection ggplot2::geom_point Aesthetics
#' @return geom_quasirandom plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot(mtcars) + geom_quasirandom_rast(aes(x = factor(cyl), y = mpg), raster.dpi = 600)
#'
#' @export
geom_quasirandom_rast <- function(..., raster.dpi = 300) {
  rasterise(ggbeeswarm::geom_quasirandom(...), dpi=raster.dpi)
}
