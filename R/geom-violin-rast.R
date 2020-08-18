#' This geom is similar to \code{\link[ggplot2]{geom_violin}}, but creates a raster layer
#'
#' @inheritParams ggplot2::geom_violin
#' @inheritSection ggplot2::geom_violin Aesthetics
#'
#' @import ggplot2
#' @return geom_violin_rast plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot(mpg) + geom_violin_rast(aes(x = factor(cyl), y = hwy), raster.dpi = 600)
#'
#' @export
geom_violin_rast = function(..., raster.dpi=300){
  rasterise(geom_violin(...), dpi=raster.dpi)
}