#' This geom is similar to \code{\link[ggplot2]{geom_boxplot}}, but allows to jitter outlier points and to raster points layer.
#'
#' @inheritParams ggplot2::geom_boxplot
#' @inheritSection ggplot2::geom_boxplot Aesthetics
#'
#' @param outlier.jitter.width Amount of horizontal jitter. The jitter is added in both positive and negative directions,
#' so the total spread is twice the value specified here. Default: boxplot width.
#' @param outlier.jitter.height Amount of horizontal jitter. The jitter is added in both positive and negative directions,
#' so the total spread is twice the value specified here. Default: 0.
#' @param raster Should outlier points be rastered?.
#' @param raster.dpi Resolution of the rastered image. Ignored if \code{raster == FALSE}.
#' @param raster.width Width of the result image (in inches). Default: deterined by the current device parameters. Ignored if \code{raster == FALSE}.
#' @param raster.height Height of the result image (in inches). Default: deterined by the current device parameters. Ignored if \code{raster == FALSE}.
#' @return geom_boxplot plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' yvalues = rt(1000, df=3)
#' xvalues = as.factor(1:1000 %% 2)
#' ggplot() + geom_boxplot_jitter(aes(y=yvalues, x=xvalues), outlier.jitter.width = 0.1, raster = TRUE)
#'
#' @export
geom_boxplot_jitter <- function(..., raster.dpi=300){
  rasterise(geom_boxplot(...), dpi=raster.dpi)
}