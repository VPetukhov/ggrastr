## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- fig.width=5, fig.height=5-----------------------------------------------
library(ggplot2)
library(ggrastr)

plot <- ggplot(diamonds, aes(carat, price, colour = cut)) +
  geom_point()

rasterize(plot, layers='Point', dpi=50)

## ---- fig.width=5, fig.height=5-----------------------------------------------
ggplot() + 
  rasterise(geom_point(aes(carat, price, colour = cut), data=diamonds), dpi=30) +
  geom_point(aes(x=runif(20, 0, 5), y=runif(20, 0, 20000)), size=10, color="black", shape=8)

## ---- fig.width=5, fig.height=5-----------------------------------------------
# Points remain round across different aspect ratios
plot <- ggplot(diamonds, aes(carat, price, colour = cut))
plot + rasterise(geom_point(), dpi = 72) + theme(aspect.ratio = 0.2)

## ---- fig.width=5, fig.height=5-----------------------------------------------
# The default 'cairo' at dpi=5
plot + rasterise(geom_point(), dpi = 5, dev = "cairo")

## ---- fig.width=5, fig.height=5-----------------------------------------------
# Using 'ragg' gives better anti-aliasing but has unexpected alpha blending
plot + rasterise(geom_point(), dpi = 5, dev = "ragg")

## ---- fig.width=5, fig.height=5-----------------------------------------------
# Using 'ragg_png' solves the alpha blend, but requires writing a temporary file to disk
plot + rasterise(geom_point(), dpi = 5, dev = "ragg_png")

## ---- fig.width=5, fig.height=5-----------------------------------------------
# Facets will not warp/distort points
set.seed(123)
plot + rasterise(geom_point(), dpi = 300) + facet_wrap(~ sample(1:3, nrow(diamonds), 2))

## ---- fig.width=5, fig.height=5-----------------------------------------------
# unchanged scaling, scale=1
plot <- ggplot(diamonds, aes(carat, price, colour = cut))
plot + rasterise(geom_point(), dpi = 300, scale = 1)

## ---- fig.width=5, fig.height=5-----------------------------------------------
# larger objects, scale > 1
plot <- ggplot(diamonds, aes(carat, price, colour = cut))
plot + rasterise(geom_point(), dpi = 300, scale = 2)

## ---- fig.width=5, fig.height=5-----------------------------------------------
# smaller objects, scale < 1
plot <- ggplot(diamonds, aes(carat, price, colour = cut))
plot + rasterise(geom_point(), dpi = 300, scale = 0.5)

## ---- fig.width=7, fig.height=5-----------------------------------------------
world1 <- sf::st_as_sf(maps::map('world', plot = FALSE, fill = TRUE))
ggplot() + rasterise(
  list(
    list(
      geom_sf(data = world1),
      theme(panel.background = element_rect(fill = "skyblue"))
    ),
    list(
      list(
        geom_point(aes(x = rnorm(100, sd = 10), y = rnorm(100, sd = 10)))
      ),
      theme(panel.border = element_rect(fill = NA, colour = "blue"))
    )
  )
)

## ---- fig.width=5, fig.height=5-----------------------------------------------
## set ggrastr.default.dpi with options()
options(ggrastr.default.dpi=750)

plot <- ggplot(diamonds, aes(carat, price, colour = cut))
new_plot = plot + rasterise(geom_point()) + theme(aspect.ratio = 1)
print(new_plot)

## set back to default 300
options(ggrastr.default.dpi=300)

