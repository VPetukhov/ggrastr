DrawGeomTileRast <- function(data, panel_params, coord, na.rm = FALSE, raster.width=NULL, raster.height=NULL, raster.dpi=300) {
  if (is.null(raster.width)) {
    raster.width <- par('fin')[1]
  }

  if (is.null(raster.height)) {
    raster.height <- par('fin')[2]
  }

  prev_dev_id <- dev.cur()

  p <- ggplot2::GeomTile$draw_panel(data, panel_params, coord)
  dev_id <- Cairo::Cairo(type='raster', width=raster.width*raster.dpi, height=raster.height*raster.dpi,
                         dpi=raster.dpi, units='px', bg="transparent")[1]
  grid::pushViewport(grid::viewport(width=1, height=1))
  grid::grid.rect(p$x, p$y, width=p$width, height=p$height, just=p$just, hjust=p$hjust,
                  vjust=p$vjust, name=p$name, gp=p$gp, vp=p$vp, draw=T)
  grid::popViewport()
  cap <- grid::grid.cap()
  dev.off(dev_id)
  dev.set(prev_dev_id)

  grid::rasterGrob(cap, x=0, y=0, width = 1,
                   height = 1, default.units = "native",
                   just = c("left","bottom"))
}

GeomTileRast <- ggplot2::ggproto(
  "GeomTileRast",
  ggplot2::GeomTile,
  draw_panel = DrawGeomTileRast
)

#' This geom is similar to \code{\link[ggplot2]{geom_tile}}, but creates a raster layer
#'
#' @inheritParams ggplot2::geom_tile
#' @inheritSection ggplot2::geom_tile Aesthetics
#'
#' @param raster.width Width of the result image (in inches). Default: deterined by the current device parameters.
#' @param raster.height Height of the result image (in inches). Default: deterined by the current device parameters.
#' @param raster.dpi Resolution of the result image.
#' @return geom_tile plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' coords <- expand.grid(1:100, 1:100)
#' coords$Value <- 1 / apply(as.matrix(coords), 1, function(x) sum((x - c(50, 50))^2)^0.01)
#' ggplot(coords) + geom_tile_rast(aes(x=Var1, y=Var2, fill=Value))
#'
#' @export
geom_tile_rast <- function(mapping = NULL,
                           data = NULL,
                           stat = "identity",
                           position = "identity",
                           ...,
                           na.rm = FALSE,
                           show.legend = NA,
                           inherit.aes = TRUE,
                           raster.width=NULL,
                           raster.height=NULL,
                           raster.dpi=300) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomTileRast,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm,
                  raster.dpi=raster.dpi,
                  raster.width = raster.width,
                  raster.height = raster.height,
                  ...)
  )
}
