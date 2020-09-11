#' This geom is similar to \code{\link[ggplot2]{geom_tile}}, but creates a raster layer
#'
#' @inheritParams ggplot2::geom_tile
#' @inheritSection ggplot2::geom_tile Aesthetics
#'
#' @param raster.dpi An integer of length one setting the desired resolution in dots per inch. (default=NULL)
#' @param dev A character specifying a device. Can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"}. (default="cairo")
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
geom_tile_rast <- function(..., raster.dpi=300, dev="cairo") {
  rasterise(geom_tile(...), dpi=raster.dpi, dev=dev)
}