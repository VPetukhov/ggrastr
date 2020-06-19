#' @importFrom grDevices dev.cur dev.off dev.set
#' @importFrom graphics par
DrawGeomPointRast <- function(data, panel_params, coord, na.rm = FALSE, raster.width=NULL, raster.height=NULL, raster.dpi=300) {
  if (is.null(raster.width)) {
    raster.width <- par('fin')[1]
  }

  if (is.null(raster.height)) {
    raster.height <- par('fin')[2]
  }

  prev_dev_id <- dev.cur()

  p <- ggplot2::GeomPoint$draw_panel(data, panel_params, coord)
  dev_id <- Cairo::Cairo(type='raster', width=raster.width*raster.dpi, height=raster.height*raster.dpi, dpi=raster.dpi, units='px', bg="transparent")[1]

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
#' @inheritSection ggplot2::geom_point Aesthetics
#'
#' @import ggplot2
#' @param raster.width Width of the result image (in inches). Default: deterined by the current device parameters.
#' @param raster.height Height of the result image (in inches). Default: deterined by the current device parameters.
#' @param raster.dpi Resolution of the result image.
#' @return geom_point plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot() + geom_point_rast(aes(x=rnorm(1000), y=rnorm(1000)), raster.dpi=600)
#'
#' @export
geom_point_rast <- function(mapping = NULL,
                        data = NULL,
                        stat = "identity",
                        position = "identity",
                        ...,
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE,
                        raster.width=NULL, raster.height=NULL, raster.dpi=300) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomPointRast,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm,
                  raster.width=raster.width,
                  raster.height=raster.height,
                  raster.dpi=raster.dpi,
                  ...)
  )
}
