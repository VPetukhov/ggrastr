#' This geom is similar to \code{\link[ggplot2]{geom_tile}}, but creates a raster layer
#'
#' @inheritParams ggplot2::geom_tile
#' @inheritSection ggplot2::geom_tile Aesthetics
#'
#' @param raster.dpi integer Resolution of the rastered image in dots per inch (default=300).
#' @param dev string Specifies the device used, which can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"} (default="cairo").
#' @param scale numeric Scaling factor to modify the raster object size (default=1). The parameter 'scale=1' results in an object size that is unchanged, 'scale'>1 increase the size, and 'scale'<1 decreases the size. These parameters are passed to 'height' and 'width' of grid::grid.raster(). Please refer to 'rasterise()' and 'grid::grid.raster()' for more details.
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
geom_tile_rast <- function(..., raster.dpi=getOption("ggrastr.default.dpi", 300), dev="cairo", scale=1) {
  rasterise(geom_tile(...), dpi=raster.dpi, dev=dev, scale=scale)
}
