#' This geom is similar to \code{\link[ggbeeswarm]{geom_beeswarm}}, but creates a raster layer
#'
#' @inheritParams geom_point_rast
#'
#' @import ggplot2
#' @import ggbeeswarm
#' @param priority Method used to perform point layout (see ggbeeswarm::position_beeswarm)
#' @param cex Scaling for adjusting point spacing (see ggbeeswarm::position_beeswarm)
#' @param groupOnX Should jitter be added to the x axis if TRUE or y axis if FALSE (the default NULL causes the function to guess which axis is the categorical one based on the number of unique entries in each) Refer to see ggbeeswarm::position_beeswarm 
#' @param dodge.width Amount by which points from different aesthetic groups will be dodged. This requires that one of the aesthetics is a factor. (see ggbeeswarm::position_beeswarm)
#' @return geom_beeswarm plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot(mtcars) + geom_beeswarm_rast(aes(x = factor(cyl), y = mpg), raster.dpi = 600, cex = 1.5)
#'
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
  raster.width = NULL, raster.height = NULL, raster.dpi = 300
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
