## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- fig.width=4, fig.height=4------------------------------------------
library(ggplot2)
library(ggrastr)

points_num <- 500000
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
gg <- ggplot(df, aes(x=x, y=y, color=c)) + scale_color_discrete(guide=F)

(gg_vec <- gg + geom_point(size=0.5))

## ---- fig.width=4, fig.height=4------------------------------------------
(gg_rast <- gg + geom_point_rast(size=0.5))

## ------------------------------------------------------------------------
PrintFileSize <- function(gg, name) {
  invisible(ggsave('tmp.pdf', gg, width = 4, height = 4))
  cat(name, ': ', file.info('tmp.pdf')$size / 1024, ' Kb.\n', sep = '')
  unlink('tmp.pdf')
}

PrintFileSize(gg_rast, 'Raster')
PrintFileSize(gg_vec, 'Vector')

## ------------------------------------------------------------------------
points_num <- 1000000
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
gg <- ggplot(df, aes(x=x, y=y, color=c)) + scale_color_discrete(guide=F)

gg_vec <- gg + geom_point(size=0.5)
gg_rast <- gg + geom_point_rast(size=0.5)

PrintFileSize(gg_rast, 'Raster')
PrintFileSize(gg_vec, 'Vector')

## ------------------------------------------------------------------------
coords <- expand.grid(1:100, 1:100)
coords$Value <- 1 / apply(as.matrix(coords), 1, function(x) sum((x - c(50, 50))^2)^0.01)
ggplot(coords) + geom_tile(aes(x=Var1, y=Var2, fill=Value))
ggplot(coords) + geom_tile_rast(aes(x=Var1, y=Var2, fill=Value))

## ---- fig.width=5, fig.height=4------------------------------------------
points_num <- 1000000
df <- data.frame(x=as.factor(1:points_num %% 2), y=log(abs(rcauchy(points_num))))
gg <- ggplot(df, aes(x=x, y=y)) + scale_color_discrete(guide=F)

gg + geom_boxplot()

## ---- fig.width=4, fig.height=3------------------------------------------
gg_vec <- gg + geom_boxplot_jitter(outlier.size=0.1, outlier.jitter.width = 0.3, outlier.alpha=0.5)
gg_vec

## ---- fig.width=4, fig.height=3------------------------------------------
gg_rast <- gg + geom_boxplot_jitter(outlier.size=0.1, outlier.jitter.width = 0.3, outlier.alpha=0.5, raster=T, raster.dpi = 200)
gg_rast

## ------------------------------------------------------------------------
PrintFileSize(gg_rast, 'Raster')
PrintFileSize(gg_vec, 'Vector')

## ---- fig.width=2, fig.height=4------------------------------------------
points_num <- 10000
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
ggplot(df, aes(x=x, y=y, color=c)) + geom_point_rast(size=0.5)

## ---- fig.width=2, fig.height=4------------------------------------------
points_num <- 10000
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
ggplot(df, aes(x=x, y=y, color=c)) + geom_point_rast(size=0.5, width = 1)

