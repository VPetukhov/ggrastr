## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- fig.width=5, fig.height=5-----------------------------------------------
library(ggplot2)
library(ggrastr)

plot <- ggplot(diamonds, aes(carat, price, colour = cut))

plot + rasterise(geom_point(), dpi = 72) + theme(aspect.ratio = 1)

## ---- fig.width=5, fig.height=5-----------------------------------------------
# Points remain round across different aspect ratios
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

## ---- fig.width=5, fig.height=5-----------------------------------------------
# smaller objects, scale < 1
ggplot(mtcars, aes(wt, mpg)) + rasterise(list(geom_point(), geom_smooth()))

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

## ---- fig.width=5, fig.height=5-----------------------------------------------
library(ggplot2)
library(ggrastr)

points_num <- 10000
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
gg <- ggplot(df, aes(x=x, y=y, color=c)) + scale_color_discrete(guide=FALSE)

gg_vec <- gg + geom_point(size=0.5)
print(gg_vec)

## ---- fig.width=5, fig.height=5-----------------------------------------------
gg_rast <- gg + geom_point_rast(size=0.5)
print(gg_rast)

## -----------------------------------------------------------------------------
PrintFileSize <- function(gg, name) {
  invisible(ggsave('tmp.pdf', gg, width=4, height=4))
  cat(name, ': ', file.info('tmp.pdf')$size / 1024, ' Kb.\n', sep = '')
  unlink('tmp.pdf')
}

PrintFileSize(gg_rast, 'Raster')
PrintFileSize(gg_vec, 'Vector')

## -----------------------------------------------------------------------------
points_num <- 1000000
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
gg <- ggplot(df, aes(x=x, y=y, color=c)) + scale_color_discrete(guide=FALSE)

gg_vec <- gg + geom_point(size=0.5)
gg_rast <- gg + geom_point_rast(size=0.5)

PrintFileSize(gg_rast, 'Raster')
PrintFileSize(gg_vec, 'Vector')

## ---- fig.width=5, fig.height=5-----------------------------------------------
library(ggplot2)
library(ggrastr)

points_num <- 5000 
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
gg <- ggplot(df, aes(x=x, y=y, color=c)) + scale_color_discrete(guide=FALSE)

gg_jitter_rast <- gg + geom_jitter_rast(raster.dpi=600)
print(gg_jitter_rast)

## ---- fig.width=5, fig.height=5-----------------------------------------------
library(ggplot2)
library(ggrastr)

coords <- expand.grid(1:500, 1:500)
coords$Value <- 1 / apply(as.matrix(coords), 1, function(x) sum((x - c(50, 50))^2)^0.01)
gg_tile_vec <- ggplot(coords) + geom_tile(aes(x=Var1, y=Var2, fill=Value))
gg_tile_rast <- ggplot(coords) + geom_tile_rast(aes(x=Var1, y=Var2, fill=Value))
print(gg_tile_rast)

## -----------------------------------------------------------------------------
PrintFileSize(gg_tile_rast, 'Raster')
PrintFileSize(gg_tile_vec, 'Vector')

## ---- fig.width=5, fig.height=5-----------------------------------------------
library(ggplot2)
library(ggrastr)

gg_violin_vec <- ggplot(mtcars, aes(factor(cyl), mpg)) + geom_violin()
gg_violin_rast <- ggplot(mtcars) + geom_violin_rast(aes(factor(cyl), mpg))
print(gg_violin_rast)

## -----------------------------------------------------------------------------
## difference in size shown
PrintFileSize(gg_tile_rast, 'Raster')
PrintFileSize(gg_tile_vec, 'Vector')

## ---- fig.width=5, fig.height=5-----------------------------------------------
library(ggplot2)
library(ggrastr)

points_num <- 5000
df <- data.frame(x=as.factor(1:points_num %% 2), y=log(abs(rcauchy(points_num))))
gg <- ggplot(df, aes(x=x, y=y)) + scale_color_discrete(guide=FALSE)

boxplot <- gg + geom_boxplot()
print(boxplot)

## ---- fig.width=5, fig.height=5-----------------------------------------------
library(ggplot2)
library(ggrastr)
points_num <- 500000
df <- data.frame(x=as.factor(1:points_num %% 2), y=log(abs(rcauchy(points_num))))
gg <- ggplot(df, aes(x=x, y=y)) + scale_color_discrete(guide=FALSE)

gg_box_vec <- gg + geom_boxplot_jitter(outlier.size=0.1, outlier.jitter.width=0.3, outlier.alpha=0.5)
print(gg_box_vec)

## ---- fig.width=5, fig.height=5-----------------------------------------------
gg_box_rast <- gg + geom_boxplot_jitter(outlier.size=0.1, outlier.jitter.width=0.3, outlier.alpha=0.5, raster.dpi=200)
print(gg_box_rast)

## -----------------------------------------------------------------------------
PrintFileSize(gg_box_rast, 'Raster')
PrintFileSize(gg_box_vec, 'Vector')

## ---- fig.width=5, fig.height=5-----------------------------------------------
library(ggplot2)
library(ggrastr)

ggplot(mtcars) + geom_beeswarm_rast(aes(x = factor(cyl), y=mpg), raster.dpi=600, cex=1.5)

## ---- fig.width=5, fig.height=5-----------------------------------------------
library(ggplot2)
library(ggrastr)

ggplot(mtcars) + geom_quasirandom_rast(aes(x = factor(cyl), y=mpg), raster.dpi=600)

