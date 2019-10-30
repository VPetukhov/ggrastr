# ggrastr package
Provides set of geoms to rasterize only specific layers of the plot (e.g. large scatterplots) keeping all labels and text in vector format. Allows to keep your plots within the reasonable size limit without loosing vector properties of the scale-sensitive information.

## Installation
```r
install.packages('devtools')
devtools::install_github('VPetukhov/ggrastr')
```

## New geoms:
* `geom_point_rast`: raster scatterplots
* `geom_boxplot_jitter`: boxplots that allows to jitter and rasterize outlier points
* `geom_tile_rast`: raster heatmap
* `geom_beeswarm_rast`: raster [bee swarm plots](https://github.com/eclarke/ggbeeswarm#geom_beeswarm)
* `geom_quasirandom`: raster [quasirandom scatterplot](https://github.com/eclarke/ggbeeswarm#geom_quasirandom)

For more details see [vignette](https://htmlpreview.github.io/?https://raw.githubusercontent.com/VPetukhov/ggrastr/master/inst/doc/Raster_geoms.html).

## Troubleshooting
If your rsession crashes when you try to render rasterized plot, probably your version of Cairo was built for another 
version of R (see [Upgrading to a new version of R](http://shiny.rstudio.com/articles/upgrade-R.html)). To check if 
you use a proper version run the command below and ensure that "Built" version is the same as your R version.
```r
pkgs <- as.data.frame(installed.packages(), stringsAsFactors = F, row.names = F)
pkgs[pkgs$Package == 'Cairo', c("Package", "LibPath", "Version", "Built")]
```

To ensure that your Cairo works, just run `Cairo::Cairo(type='raster'); dev.off()` and check if it crashes R session.
