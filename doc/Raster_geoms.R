## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- fig.width=4, fig.height=4-----------------------------------------------
library(ggplot2)
library(ggrastr)

points_num <- 50  
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
gg <- ggplot(df, aes(x=x, y=y, color=c)) + scale_color_discrete(guide=FALSE)

gg_vec <- gg + geom_point(size=0.5)
print(gg_vec)

## ---- fig.width=4, fig.height=4-----------------------------------------------
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

## ---- fig.width=4, fig.height=4-----------------------------------------------
library(ggplot2)
library(ggrastr)

points_num <- 5000 
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
gg <- ggplot(df, aes(x=x, y=y, color=c)) + scale_color_discrete(guide=FALSE)

gg_jitter_rast <- gg + geom_jitter_rast(raster.dpi=600)
print(gg_jitter_rast)

## -----------------------------------------------------------------------------
library(ggplot2)
library(ggrastr)

coords <- expand.grid(1:500, 1:500)
coords$Value <- 1 / apply(as.matrix(coords), 1, function(x) sum((x - c(50, 50))^2)^0.01)
gg_tile_vec <- ggplot(coords) + geom_tile(aes(x=Var1, y=Var2, fill=Value))
gg_tile_rast <- ggplot(coords) + geom_tile_rast(aes(x=Var1, y=Var2, fill=Value))

## -----------------------------------------------------------------------------
PrintFileSize(gg_tile_rast, 'Raster')
PrintFileSize(gg_tile_vec, 'Vector')

## ---- fig.width=5, fig.height=4-----------------------------------------------
library(ggplot2)
library(ggrastr)

points_num <- 500
df <- data.frame(x=as.factor(1:points_num %% 2), y=log(abs(rcauchy(points_num))))
gg <- ggplot(df, aes(x=x, y=y)) + scale_color_discrete(guide=FALSE)

boxplot <- gg + geom_boxplot()
print(boxplot)

## ---- fig.width=4, fig.height=3-----------------------------------------------
points_num <- 500
df <- data.frame(x=as.factor(1:points_num %% 2), y=log(abs(rcauchy(points_num))))
gg <- ggplot(df, aes(x=x, y=y)) + scale_color_discrete(guide=FALSE)

gg_box_vec <- gg + geom_boxplot_jitter(outlier.size=0.1, outlier.jitter.width=0.3, outlier.alpha=0.5)
print(gg_box_vec)

## ---- fig.width=4, fig.height=3-----------------------------------------------
gg_box_rast <- gg + geom_boxplot_jitter(outlier.size=0.1, outlier.jitter.width=0.3, outlier.alpha=0.5, raster=TRUE, raster.dpi=200)
print(gg_box_rast)

## -----------------------------------------------------------------------------
PrintFileSize(gg_box_rast, 'Raster')
PrintFileSize(gg_box_vec, 'Vector')

## -----------------------------------------------------------------------------
library(ggplot2)
library(ggrastr)

ggplot(mtcars) + geom_beeswarm_rast(aes(x = factor(cyl), y=mpg), raster.dpi=600, cex=1.5)

## -----------------------------------------------------------------------------
library(ggplot2)
library(ggrastr)

ggplot(mtcars) + geom_quasirandom_rast(aes(x = factor(cyl), y=mpg), raster.dpi=600)

## ---- fig.width=3, fig.height=4-----------------------------------------------
points_num <- 10
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
ggplot(df, aes(x=x, y=y, color=c)) + geom_point_rast(size=0.5)

## ---- fig.width=3, fig.height=4-----------------------------------------------
points_num <- 10
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
ggplot(df, aes(x=x, y=y, color=c)) + geom_point_rast(size=0.5, raster.width = 1)

