DrawGeomTileRast <- function(data, panel_params, coord, na.rm = FALSE, width=NULL, height=NULL, dpi=300) {
  if (is.null(width)) {
    width <- par('fin')[1]
  }

  if (is.null(height)) {
    height <- par('fin')[2]
  }

  p <- ggplot2::GeomTile$draw_panel(data, panel_params, coord)
  dev_id <- Cairo::Cairo(type='raster', width=width*dpi, height=height*dpi,
                         dpi=dpi, units='px', bg="transparent")[1]
  grid::pushViewport(grid::viewport(width=1, height=1))
  grid::grid.rect(p$x, p$y, width=p$width, height=p$height, just=p$just, hjust=p$hjust,
                  vjust=p$vjust, name=p$name, gp=p$gp, vp=p$vp, draw=T)
  grid::popViewport()
  cap <- grid::grid.cap()
  dev.off(dev_id)

  grid::rasterGrob(cap, x=0, y=0, width = 1,
                   height = 1, default.units = "native",
                   just = c("left","bottom"))
}

GeomTileRast <- ggplot2::ggproto(
  "GeomTileRast",
  ggplot2::GeomTile,
  draw_panel = DrawGeomTileRast
)

#' This geom is similar to \code{\link[ggplot2]{geom_point}}, but creates a raster layer
#'
#' @inheritParams ggplot2::geom_point
#' @inheritSection ggplot2::geom_point Aesthetics
#'
#' @param width Width of the result image (in inches). Default: deterined by the current device parameters.
#' @param height Height of the result image (in inches). Default: deterined by the current device parameters.
#' @param dpi Resolution of the result image.
#'
#' @examples
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
                           width=NULL, height=NULL, dpi=300) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomTileRast,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm,
                  width=width,
                  height=height,
                  dpi=dpi,
                  ...)
  )
}
