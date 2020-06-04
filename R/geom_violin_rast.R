




GeomViolinRast <- ggplot2::ggproto(
  "GeomViolinRast",
  ggplot2::GeomViolin,
  draw_panel = DrawGeomViolinRast
)

geom_violin <- function(mapping = NULL, 
                        data = NULL,
                        stat = "ydensity", 
                        position = "dodge",
                        ...,
                        draw_quantiles = NULL,
                        trim = TRUE,
                        scale = "area",
                        na.rm = FALSE,
                        orientation = NA,
                        show.legend = NA,
                        inherit.aes = TRUE) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomViolinRast,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(trim = trim,
                  scale = scale,
                  draw_quantiles = draw_quantiles,
                  na.rm = na.rm,
                  orientation = orientation,
                  ...
    )
  )
}