DrawGeomPointRast <- function(data, panel_params, coord, na.rm = FALSE, width=NULL, height=NULL, dpi=300) {
  if (is.null(width)) {
    width <- par('fin')[1]
  }

  if (is.null(height)) {
    height <- par('fin')[2]
  }

  prev_dev_id <- dev.cur()

  p <- ggplot2::GeomPoint$draw_panel(data, panel_params, coord)
  dev_id <- Cairo::Cairo(type='raster', width=width*dpi, height=height*dpi, dpi=dpi, units='px', bg="transparent")[1]

  grid::pushViewport(grid::viewport(width=1, height=1))
  grid::grid.points(x=p$x, y=p$y, pch = p$pch, size = p$size,
                    name = p$name, gp = p$gp, vp = p$vp, draw = T)
  grid::popViewport()
  cap <- grid::grid.cap()
  dev.off(dev_id)
  dev.set(prev_dev_id)

  grid::rasterGrob(cap, x=0, y=0, width = 1,
                   height = 1, default.units = "native",
                   just = c("left","bottom"))
}

GeomPointRast <- ggplot2::ggproto(
  "GeomPointRast",
  ggplot2::GeomPoint,
  draw_panel = DrawGeomPointRast
)

#' This geom is similar to \code{\link[ggplot2]{geom_point}}, but creates a raster layer
#'
#' @inheritParams ggplot2::geom_point
#' @inheritParams ggbeeswarm::position_beeswarm
#' @inheritSection ggplot2::geom_point Aesthetics
#'
#' @param width Width of the result image (in inches). Default: deterined by the current device parameters.
#' @param height Height of the result image (in inches). Default: deterined by the current device parameters.
#' @param dpi Resolution of the result image.
#'
#' @examples
#' ggplot() + geom_point_rast(aes(x=rnorm(1000), y=rnorm(1000)), dpi=600)
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
  width=NULL, height=NULL, dpi=300
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
                  width = width,
                  height = height,
                  dpi = dpi,
                  ...)
  )
}
