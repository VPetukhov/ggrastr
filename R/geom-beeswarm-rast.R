#' This geom is similar to \code{\link[ggbeeswarm]{geom_beeswarm}}, but creates a raster layer
#'
#' @inheritParams geom_point_rast
#'
#' @import ggplot2
#' @import ggbeeswarm
#' @param priority string Method used to perform point layout (see ggbeeswarm::position_beeswarm). 
#' @param cex numeric Scaling for adjusting point spacing (see ggbeeswarm::position_beeswarm)
#' @param groupOnX boolean Should jitter be added to the x axis if TRUE or y axis if FALSE (the default NULL causes the function to guess which axis is the categorical one based on the number of unique entries in each). Refer to see ggbeeswarm::position_beeswarm
#' @param dodge.width Amount by which points from different aesthetic groups will be dodged. This requires that one of the aesthetics is a factor. (see ggbeeswarm::position_beeswarm)
#' @param raster.dpi An integer of length one setting the desired resolution in dots per inch. (default=300)
#' @param dev A character specifying a device. Can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"}. (default="cairo")
#' @param scale numeric Scaling factor to modify the raster object size (default=1). The parameter 'scale=1' results in an object size that is unchanged, 'scale'>1 increase the size, and 'scale'<1 decreases the size. These parameters are passed to 'height' and 'width' of grid::grid.raster(). Please refer to 'rasterise()' and 'grid::grid.raster()' for more details.
#' @return geom_beeswarm plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' ggplot(mtcars) + geom_beeswarm_rast(aes(x = factor(cyl), y = mpg), raster.dpi = 600, cex = 1.5)
#'
#' @export
geom_beeswarm_rast <- function(..., priority= c("ascending", "descending", "density", "random", "none"), cex = 1, groupOnX = NULL, dodge.width = 0, raster.dpi = getOption("ggrastr.default.dpi", 300), dev="cairo", scale = 1) {
  rasterise(ggbeeswarm::geom_beeswarm(..., priority=priority, cex=cex, groupOnX=groupOnX, dodge.width=dodge.width), dpi=raster.dpi, dev=dev, scale=scale)
}

