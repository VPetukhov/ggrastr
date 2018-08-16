#' This geom is similar to \code{\link[ggbeeswarm]{geom_quasirandom}}, but creates a raster layer
#'
#' @inheritParams ggplot2::geom_point
#' @inheritParams ggbeeswarm::position_quasirandom
#' @inheritSection ggplot2::geom_point Aesthetics
#'
#' @param width Width of the result image (in inches). Default: deterined by the current device parameters.
#' @param height Height of the result image (in inches). Default: deterined by the current device parameters.
#' @param dpi Resolution of the result image.
#'
#' @examples
#' ggplot(mtcars) + geom_quasirandom_rast(aes(x = factor(cyl), y = mpg), dpi = 600)
#'

#' @export
geom_quasirandom_rast <- function(
  mapping = NULL,
  data = NULL,
  stat = 'identity',
  position = 'quasirandom',
  varwidth = FALSE,
  bandwidth=.5,
  nbins=NULL,
  method = 'quasirandom',
  groupOnX=NULL,
  dodge.width=0,
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  width=NULL, height=NULL, dpi=300
) {

  if (!requireNamespace('ggbeeswarm', quietly = T)) {
    stop('Install \"ggbeeswarm\" to use this function', call. = F)
  }

  position <- ggbeeswarm::position_quasirandom(width = width, varwidth = varwidth, bandwidth = bandwidth, nbins = nbins,
                                               method = method, groupOnX = groupOnX, dodge.width = dodge.width)

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomPointRast,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm,
                  width = width,
                  height = height,
                  dpi = dpi,
                  ...)
  )
}
