[![Build Status](https://travis-ci.com/VPetukhov/ggrastr.svg?branch=master)](https://travis-ci.com/VPetukhov/ggrastr)

# ggrastr

Provides a set of geoms to rasterize only specific layers of the plot (e.g. large scatterplots with many points), while keeping all labels and text in vector format. This allows users to keep plots within a reasonable size limit without loosing the vector properties of scale-sensitive information.

## Installation

To install the stable version from CRAN, use:

```r
install.packages('ggrastr')
```

To install the latest version:

```r
install.packages('devtools')
devtools::install_github('VPetukhov/ggrastr', build_vignettes = TRUE)
```

## New geoms:
* `geom_point_rast`: raster scatterplots
* `geom_jitter_rast`: raster jittered scatterplots
* `geom_boxplot_jitter`: boxplots that allows to jitter and rasterize outlier points
* `geom_tile_rast`: raster heatmap
* `geom_beeswarm_rast`: raster [bee swarm plots](https://github.com/eclarke/ggbeeswarm#geom_beeswarm)
* `geom_quasirandom`: raster [quasirandom scatterplot](https://github.com/eclarke/ggbeeswarm#geom_quasirandom)

For more details see [vignette](https://htmlpreview.github.io/?https://raw.githubusercontent.com/VPetukhov/ggrastr/master/inst/doc/Raster_geoms.html).

## Troubleshooting
If your R Session crashes when you try to render a rasterized plot, it's probably the case that your version of Cairo was built for another 
version of R (see [Upgrading to a new version of R](http://shiny.rstudio.com/articles/upgrade-R.html)). To check if 
you are using a proper version, run the command below and ensure that the "Built" version is the same as your R version.
```r
pkgs <- as.data.frame(installed.packages(), stringsAsFactors = F, row.names = F)
pkgs[pkgs$Package == 'Cairo', c("Package", "LibPath", "Version", "Built")]
```

To ensure that Cairo works, just run `Cairo::Cairo(type='raster'); dev.off()` and check if it crashes your R session.