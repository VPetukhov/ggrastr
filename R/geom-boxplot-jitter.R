#' This geom is similar to \code{\link[ggplot2]{geom_boxplot}}, but allows to jitter outlier points and to raster points layer.
#'
#' @inheritParams ggplot2::geom_boxplot
#' @inheritSection ggplot2::geom_boxplot Aesthetics
#'
#' @param raster.dpi An integer of length one setting the desired resolution in dots per inch. (default=NULL)
#' @param dev A character specifying a device. Can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"}. (default="cairo")
#' @return geom_boxplot plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' yvalues = rt(1000, df=3)
#' xvalues = as.factor(1:1000 %% 2)
#' ggplot() + geom_boxplot_jitter(aes(y=yvalues, x=xvalues), outlier.jitter.width = 0.1)
#'
#' @export
geom_boxplot_jitter <- function(..., raster.dpi=300, dev="cairo"){
  rasterise(geom_boxplot(...), dpi=raster.dpi, dev=dev) 
}