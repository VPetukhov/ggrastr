# ggrastr package
Provides raster geoms for ggplot2.

## Installation
```r
install.packages('devtools')
devtools::install_github('VPetukhov/ggrastr')
```
## New geoms:
* `geom_point_rast`: raster scatterplots
* `geom_boxplot_jitter`: boxplots that allows to jitter and rasterize outlier points
* `geom_tile_rast`: raster heatmap

## Troubleshooting
### Cairo
If your rsession crashes when you try to render rasterized plot, probably your version of Cairo was built for another 
version of R (see [Upgrading to a new version of R](http://shiny.rstudio.com/articles/upgrade-R.html)). To ensure that 
you use a proper version run the command below and ensure that "Built" version is the same as your R version.
```r
pkgs <- as.data.frame(installed.packages(), stringsAsFactors = F, row.names = F)
pkgs[pkgs$Package == 'Cairo', c("Package", "LibPath", "Version", "Built")]
```

To ensure that your Cairo works just run `Cairo::Cairo(type='raster'); dev.off()` and check if it crashes R session.

### ggsave
Currently, `ggsave` isn't supproted. To save plots use graphical devices, i.e.:
```r
pdf('plot.pdf', width=5, height=4)
ggplot() + geom_point_rast(aes(x=rnorm(1000), y=rnorm(1000)))
dev.off()
```
