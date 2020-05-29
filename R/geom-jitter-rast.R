#' This geom is similar to \code{\link[ggplot2]{geom_jitter}}, but creates a raster layer
#'
#' @inheritParams geom_point_rast
#' @inheritSection ggplot2::geom_point Aesthetics
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot(mpg) + geom_jitter_rast(aes(x = factor(cyl), y = hwy), raster.dpi = 600)
#'
#' @export
geom_jitter_rast <- function(
  mapping = NULL,
  data = NULL,
  stat = 'identity',
  position = 'jitter',
  width = NULL,
  height = NULL,
  seed = NA,
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  raster.width = NULL, raster.height = NULL, raster.dpi = 300
) {

  ggplot2::position = position_jitter(width = NULL, height = NULL, seed = NA)

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
