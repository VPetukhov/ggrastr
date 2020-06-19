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
geom_quasirandom_rast <- function(
  mapping = NULL,
  data = NULL,
  stat = 'identity',
  position = 'quasirandom',
  width = NULL,
  varwidth = FALSE,
  bandwidth = 0.5,
  nbins = NULL,
  method = 'quasirandom',
  groupOnX = NULL,
  dodge.width = 0,
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  raster.width = NULL, raster.height = NULL, raster.dpi = 300
) {

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
                  raster.width = raster.width,
                  raster.height = raster.height,
                  raster.dpi = raster.dpi,
                  ...)
  )
}
