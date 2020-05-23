#' This geom is similar to \code{\link[ggbeeswarm]{geom_beeswarm}}, but creates a raster layer
#'
#' @inheritParams geom_point_rast
#' @inheritParams ggbeeswarm::position_beeswarm
#' @inheritSection ggplot2::geom_point Aesthetics
#'
#' @examples
#' ggplot(mtcars) + geom_beeswarm_rast(aes(x = factor(cyl), y = mpg), raster.dpi = 600, cex = 1.5)
#'
#' @import ggplot2
#' @export
geom_beeswarm_rast <- function(
  mapping = NULL,
  data = NULL,
  stat = 'identity',
  position = 'quasirandom',
  priority = c('ascending', 'descending', 'density', 'random', 'none'),
  cex = 1,
  groupOnX = NULL,
  dodge.width = 0,
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  raster.width=NULL, raster.height=NULL, raster.dpi=300
) {

  position <- ggbeeswarm::position_beeswarm(priority = priority, cex = cex,
                                            groupOnX = groupOnX, dodge.width = dodge.width)

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
