#' This geom is similar to \code{\link[ggplot2]{geom_violin}}, but creates a raster layer
#'
#' @inheritParams ggplot2::geom_violin
#' @inheritSection ggplot2::geom_violin Aesthetics
#'
#' @param raster.dpi An integer of length one setting the desired resolution in dots per inch. (default=NULL)
#' @param dev A character specifying a device. Can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"}. (default="cairo")
#' @return geom_violin_rast plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot(mpg) + geom_violin_rast(aes(x = factor(cyl), y = hwy), raster.dpi = 600)
#'
#' @export
geom_violin_rast = function(..., raster.dpi=300, dev="cairo"){
  rasterise(geom_violin(...), dpi=raster.dpi, dev=dev)
}