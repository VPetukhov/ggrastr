% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom-point-rast.R
\name{geom_point_rast}
\alias{geom_point_rast}
\title{This geom is similar to \code{\link[ggplot2]{geom_point}}, but creates a raster layer}
\usage{
geom_point_rast(
  ...,
  raster.dpi = getOption("ggrastr.default.dpi", 300),
  dev = "cairo",
  scale = 1
)
}
\arguments{
\item{...}{Other arguments passed on to \code{\link[ggplot2:layer]{layer()}}. These are
often aesthetics, used to set an aesthetic to a fixed value, like
\code{colour = "red"} or \code{size = 3}. They may also be parameters
to the paired geom/stat.}

\item{raster.dpi}{integer Resolution of the rastered image in dots per inch (default=300).}

\item{dev}{string Specifies the device used, which can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"} (default="cairo").}

\item{scale}{numeric Scaling factor to modify the raster object size (default=1). The parameter 'scale=1' results in an object size that is unchanged, 'scale'>1 increase the size, and 'scale'<1 decreases the size. These parameters are passed to 'height' and 'width' of grid::grid.raster(). Please refer to 'rasterise()' and 'grid::grid.raster()' for more details.}
}
\value{
geom_point plot with rasterized layer
}
\description{
This geom is similar to \code{\link[ggplot2]{geom_point}}, but creates a raster layer
}
\section{Aesthetics}{


\code{geom_point()} understands the following aesthetics (required aesthetics are in bold):
\itemize{
\item \strong{\code{x}}
\item \strong{\code{y}}
\item \code{alpha}
\item \code{colour}
\item \code{fill}
\item \code{group}
\item \code{shape}
\item \code{size}
\item \code{stroke}
}
Learn more about setting these aesthetics in \code{vignette("ggplot2-specs")}.

}

\examples{
library(ggplot2)
library(ggrastr)

ggplot() + geom_point_rast(aes(x=rnorm(1000), y=rnorm(1000)), raster.dpi=600)

}
