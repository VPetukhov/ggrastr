# Changelog

## [Upcoming]
* `rasterise` function now can work with whole ggplot objects

## [1.0.0] - 2021-11-15
* `ggrastr` has gone through no major revisions in over a year. In order to avoid any confusion, this should be released with a major version.

## [0.2.3] - 2021-02-27
* Function `rasterise()` changed to work with multiple layers
* Function `rasterise()` now works with `geom_sf()`, i.e. should find any layers in a valid input list, and rasterize this. 
* Parameter `scale` added to `rasterise()`. This scales the 'height' and 'weight' of the raster objects
* Updates to roxygen2, added types

## [0.2.2] - 2021-02-10
* Add global option for `dpi` using `options(ggrastr.default.dpi=N)`. PR found here: https://github.com/VPetukhov/ggrastr/pull/21
* Slight corrections to roxygen2 docs
* Vignettes edited accordingly
* Use both html and markdown for vignettes, link to README


## [0.2.1] - 2020-09-14
* Changes to be in sync with ggrastr version 0.2.1 on CRAN: https://cran.rstudio.com/src/contrib/ggrastr_0.2.1.tar.gz
* Aesthetic revisions to the github README
* Otherwise, this version mirrors https://github.com/VPetukhov/ggrastr/releases/tag/v0.2.0


## [0.2.0] - 2020-08
* Refactor code to use rasterise()
* Added `geom_violin_rast()` as a feature request
* Updated vignettes accordingly
* Updated README
* Fixed aspect ratio problems. Consequently, `raster.width` and `raster.height` parameters were removed.

## [0.1.9] - 2020-06-19
* Added geom-jitter-rast
* Revised vignettes to detail all functions

## [0.1.8] - 2020-06-19
* Revisions for first version on CRAN. 
* Documentation revisions, changes to the vignettes

## [0.1.7] - 2018-12-02
### Fixed
* All pararmeters `width`, `hight` and `dpi` renamed to `raster.width`, `raster.hight` and `raster.dpi` correspondingly to avoid name conflicts.

## [0.1.6] - 2018-09-17
### Added
* geom_beeswarm_rast
* geom_quasirandom_rast

## [0.1.5] - 2017-12-28
### Added
* geom_tile_rast

## [0.1.0] - 2017-11-18
### Added
* geom_point_rast
* geom_boxplot_jitter
* theme_pdf
