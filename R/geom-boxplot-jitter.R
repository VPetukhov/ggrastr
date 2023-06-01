
GeomPointRast <- ggplot2::ggproto(
  "GeomPointRast",
  ggplot2::GeomPoint,
  draw_panel = function(self, data, panel_params, coord, raster.dpi, dev, scale) {
    grob <- ggproto_parent(GeomPoint, self)$draw_panel(data, panel_params, coord)
    class(grob) <- c("rasteriser", class(grob))
    grob$dpi <- raster.dpi
    grob$dev <- dev
    grob$scale <- scale
    return(grob)
  }
)

DrawGeomBoxplotJitter <- function(data, panel_params, coord, dev="cairo", ...,
                                  outlier.jitter.width=NULL,
                                  outlier.jitter.height=0,
                                  outlier.colour = NULL,
                                  outlier.fill = NULL,
                                  outlier.shape = 19,
                                  outlier.size = 1.5,
                                  outlier.stroke = 0.5,
                                  outlier.alpha = NULL,
                                  raster=FALSE, raster.dpi=getOption("ggrastr.default.dpi", 300),
                                  raster.width=NULL, raster.height=NULL,
                                  scale = 1
                                  ) {
  boxplot_grob <- ggplot2::GeomBoxplot$draw_group(data, panel_params, coord, ...)
  point_grob <- grep("geom_point.*", names(boxplot_grob$children))
  if (length(point_grob) == 0){
    return(boxplot_grob)
  }

  ifnotnull <- function(x, y) if(is.null(x)) y else x

  if (is.null(outlier.jitter.width)) {
    outlier.jitter.width <- (data$xmax - data$xmin) / 2
  }

  x <- data$x[1]
  y <- data$outliers[[1]]
  if (outlier.jitter.width > 0 & length(y) > 1) {
    x <- jitter(rep(x, length(y)), amount=outlier.jitter.width)
  }

  if (outlier.jitter.height > 0 & length(y) > 1) {
    y <- jitter(y, amount=outlier.jitter.height)
  }

  outliers <- data.frame(
    x = x, y = y,
    colour = ifnotnull(outlier.colour, data$colour[1]),
    fill = ifnotnull(outlier.fill, data$fill[1]),
    shape = ifnotnull(outlier.shape, data$shape[1]),
    size = ifnotnull(outlier.size, data$size[1]),
    stroke = ifnotnull(outlier.stroke, data$stroke[1]),
    fill = NA,
    alpha = ifnotnull(outlier.alpha, data$alpha[1]),
    stringsAsFactors = FALSE
  )

  boxplot_grob$children[[point_grob]] <- GeomPointRast$draw_panel(outliers, panel_params, coord, raster.dpi=raster.dpi, dev=dev, scale = scale)

  return(boxplot_grob)
}

GeomBoxplotJitter <- ggplot2::ggproto("GeomBoxplotJitter",
                                             ggplot2::GeomBoxplot,
                                             draw_group = DrawGeomBoxplotJitter)

#' This geom is similar to \code{\link[ggplot2]{geom_boxplot}}, but allows to jitter outlier points and to raster points layer.
#'
#' @inheritParams ggplot2::geom_boxplot
#' @inheritSection ggplot2::geom_boxplot Aesthetics
#'
#' @param outlier.jitter.width numeric Amount of horizontal jitter (default=NULL). The jitter is added in both positive and negative directions,
#' so the total spread is twice the value specified here. If NULL, no jitter performed.
#' @param outlier.jitter.height numeric Amount of horizontal jitter (default=0). The jitter is added in both positive and negative directions,
#' so the total spread is twice the value specified here. 
#' @param raster.dpi integer Resolution of the rastered image (default=300). Ignored if \code{raster == FALSE}.
#' @param dev string Specifies the device used, which can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"} (default="cairo").
#' @param stat string The statistical transformation to use on the data for this layer, either as a ggproto Geom subclass or as a string naming the stat stripped of the stat_ prefix (e.g. "count" rather than "stat_count"). Refer to ggplot2::layer.
#' @param scale numeric Scaling factor to modify the raster object size (default=1). The parameter 'scale=1' results in an object size that is unchanged, 'scale'>1 increase the size, and 'scale'<1 decreases the size. These parameters are passed to 'height' and 'width' of grid::grid.raster(). Please refer to 'rasterise()' and 'grid::grid.raster()' for more details.
#' @return geom_boxplot plot with rasterized layer
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#'
#' yvalues = rt(1000, df=3)
#' xvalues = as.factor(1:1000 %% 2)
#' ggplot() + geom_boxplot_jitter(aes(y=yvalues, x=xvalues), outlier.jitter.width = 0.1, raster = TRUE)
#'
#' @export
geom_boxplot_jitter <- function(mapping = NULL, data = NULL, dev = "cairo",
                                stat = "boxplot", position = "dodge",
                                na.rm = FALSE, show.legend = NA,
                                inherit.aes = TRUE, ...,
                                outlier.jitter.width=NULL,
                                outlier.jitter.height=0,
                                raster.dpi=getOption("ggrastr.default.dpi", 300),
                                scale = 1
                                ) {
  ggplot2::layer(
    geom = GeomBoxplotJitter, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm,
                  outlier.jitter.width=outlier.jitter.width,
                  outlier.jitter.height=outlier.jitter.height,
                  raster.dpi=raster.dpi, dev=dev, scale = scale, ...))
}
