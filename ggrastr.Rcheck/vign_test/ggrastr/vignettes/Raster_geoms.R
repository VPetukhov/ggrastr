## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- fig.width=4, fig.height=4-----------------------------------------------
library(ggplot2)
library(ggrastr)

points_num <- 500000
df <- data.frame(x=rnorm(points_num), y=rnorm(points_num), c=as.factor(1:points_num %% 2))
gg <- ggplot(df, aes(x=x, y=y, color=c)) + scale_color_discrete(guide=F)

(gg_vec <- gg + geom_point(size=0.5))

## ---- fig.width=4, fig.height=4-----------------------------------------------
(gg_rast <- gg + geom_point_rast(size=0.5))

