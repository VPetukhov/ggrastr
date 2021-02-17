[![Build Status](https://travis-ci.com/VPetukhov/ggrastr.svg?branch=master)](https://travis-ci.com/VPetukhov/ggrastr)
[![CRAN status](https://www.r-pkg.org/badges/version/ggrastr)](https://cran.r-project.org/package=ggrastr)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/ggrastr)](https://cran.r-project.org/package=ggrastr)

# ggrastr

Provides a set of ggplot2 [geoms](https://ggplot2.tidyverse.org/reference/#section-geoms) to rasterize only specific layers of the plot (e.g. large scatter plots with many points), while keeping all labels and text in vector format. This allows users to keep plots within a reasonable size limit without losing the vector properties of scale-sensitive information. 

## Installation

To install the stable version from CRAN, use:

```r
install.packages('ggrastr')
```

To install the latest version, use:

```r
install.packages('devtools')
devtools::install_github('VPetukhov/ggrastr', build_vignettes = TRUE)
```

## Rasterize any ggplot2 layer

Note that with `ggrastr` version 0.2.0, any ggplot2 geom provided by the user can be rasterized with the function `rasterise()`. Furthermore, when the aspect ratio is distorted, points are rendered without distortion. 

For more details and examples, see the **vignettes:**
* [HTML version](https://htmlpreview.github.io/?https://raw.githubusercontent.com/VPetukhov/ggrastr/master/doc/Raster_geoms.html) 
* [Markdown version](https://github.com/VPetukhov/ggrastr/blob/master/vignettes/Raster_geoms.md)

## Geoms provided

We alo provide wrappers for several geoms to guarantee compatibility with an older version of `ggrastr`. However, we encourage users to use the `rasterise()` function instead.

* `geom_point_rast`: raster scatter plots
* `geom_jitter_rast`: raster jittered scatter plots
* `geom_boxplot_jitter`: boxplots that allows to jitter and rasterize outlier points
* `geom_tile_rast`: raster heatmap
* `geom_beeswarm_rast`: raster [bee swarm plots](https://github.com/eclarke/ggbeeswarm#geom_beeswarm)
* `geom_quasirandom_rast`: raster [quasirandom scatter plot](https://github.com/eclarke/ggbeeswarm#geom_quasirandom)


## Troubleshooting

If your R session crashes when you try to render a rasterized plot, it's probably the case that your version of Cairo was built for another 
version of R (see [Upgrading to a new version of R](https://shiny.rstudio.com/articles/upgrade-R.html)). To check if 
you are using a proper version, run the command below and ensure that the "Built" version is the same as your R version.
```r
pkgs <- as.data.frame(installed.packages(), stringsAsFactors = FALSE, row.names = FALSE)
pkgs[pkgs$Package == 'Cairo', c("Package", "LibPath", "Version", "Built")]
```

To ensure that Cairo works, try running `Cairo::Cairo(type='raster'); dev.off()` and check if it crashes your R session.

## Citation

If you find `ggrastr` useful for your publication, please cite:

```
Viktor Petukhov, Teun van den Brand and Evan Biederstedt (2020).
ggrastr: Raster Layers for 'ggplot2'. R package version 0.2.1.
https://CRAN.R-project.org/package=ggrastr
```
