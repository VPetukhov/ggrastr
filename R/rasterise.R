#' @import ggplot2
NULL

#' Rasterise ggplot layers
#' Takes a ggplot object or a layer as input and renders their graphical output as a raster.
#'
#' @param dpi integer Sets the desired resolution in dots per inch (default=NULL).
#' @param dev string Specifies the device used, which can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"} (default="cairo").
#' @param scale numeric Scaling factor to modify the raster object size (default=1). The parameter 'scale=1' results in an object size that is unchanged, 'scale'>1 increase the size, and 'scale'<1 decreases the size. These parameters are passed to 'height' and 'width' of grid::grid.raster(). Please refer to 'rasterise()' and 'grid::grid.raster()' for more details.
#' @param ... other arguments
#' @details The default \code{dpi} (\code{NULL} (i.e. let the device decide)) can conveniently be controlled by setting the option \code{"ggrastr.default.dpi"} (e.g. \code{options("ggrastr.default.dpi" = 30)} for drafting).
#' @return A modified \code{Layer} object.
#' @examples
#' require(ggplot2)
#' # `rasterise()` is used to wrap layers
#' ggplot(pressure, aes(temperature, pressure)) +
#'   rasterise(geom_line())
#'
#' # The `dpi` argument controls resolution
#' ggplot(faithful, aes(eruptions, waiting)) +
#'   rasterise(geom_point(), dpi = 5)
#'
#' # The `dev` argument offers a few options for devices
#' require(ragg)
#' ggplot(diamonds, aes(carat, depth, z = price)) +
#'   rasterise(stat_summary_hex(), dev = "ragg")
#'
#' # The `scale` argument allows you to render a 'big' plot in small window, or vice versa.
#' ggplot(faithful, aes(eruptions, waiting)) +
#'   rasterise(geom_point(), scale = 4)
#' @rdname rasterise
#' @export
rasterise <- function(input, ...) UseMethod("rasterise", input)

#' @rdname rasterise
#' @param input A \code{Layer} object, typically constructed with a call to a
#'   \code{geom_*()} or \code{stat_*()} function.
#' @author Teun van den Brand <t.vd.brand@nki.nl>
#' @export
rasterise.Layer <- function(input, dpi=NULL, dev="cairo", scale=1, ...) {
  dev <- match.arg(dev, c("cairo", "ragg", "ragg_png"))
  if (is.null(dpi)) {
    dpi <- getOption("ggrastr.default.dpi")
  }

  # Take geom from input layer
  old.geom <- input$geom
  # Reconstruct input layer
  ggproto(
    NULL, input,
    # Let the new geom inherit from the old geom
    geom = ggproto(
      NULL, old.geom,
      # draw_panel draws like old geom, but appends info to graphical object
      draw_panel = function(...) {
        grob <- old.geom$draw_panel(...)
        class(grob) <- c("rasteriser", class(grob))
        grob$dpi <- dpi
        grob$dev <- dev
        grob$scale <- scale
        return(grob)
      }
    )
  )
}

#' @param input input list with rasterizable ggplot objects
#' @rdname rasterise
#' @export
rasterise.list <- function(input, dpi=NULL, dev="cairo", scale=1, ...) {
  # geom_sf returns a list and requires extra logic here to handle gracefully
  # Check if list contains layers
  has.layer <- rapply(input, is.layer, how = "list")
  has.layer <- vapply(has.layer, function(x) {any(unlist(x))}, logical(1))
  if (!any(has.layer)) {
    stop("The input list doesn't contain any ggplot layers", call.=FALSE)
  }
  
  # Recurse through list elements that contain layers
  input[has.layer] <- lapply(input[has.layer], rasterise, dpi=dpi, dev=dev)
  return(input)
}

#' @param input ggplot plot object to rasterize
#' @param layers list of layer types that should be rasterized
#' @rdname rasterise
#' @export
rasterise.ggplot <- function(input, layers=c('Point', 'Tile'), dpi=NULL, dev="cairo", scale=1, ...) {
  input$layers <- lapply(input$layers, function(lay) {
    if (inherits(lay$geom, paste0('Geom', layers))) {
      rasterise(lay, dpi=dpi, dev=dev, scale=scale)
    } else{
      lay
    }
  })
  return(input)
}


#' @rdname rasterise
#' @export
rasterize <- rasterise

#' @export
#' @noRd
#' @importFrom grid makeContext
#' @method makeContext rasteriser
makeContext.rasteriser <- function(x) {
  # Grab viewport information
  vp <- if (is.null(x$vp)){
    grid::viewport()
  } else{
    x$vp
  }
  width <- grid::convertWidth(unit(1, "npc"), "inch", valueOnly = TRUE)
  height <- grid::convertHeight(unit(1, "npc"), "inch", valueOnly = TRUE)

  # Grab grob metadata
  dpi <- x$dpi
  if (is.null(dpi)) {
    # If missing, take current DPI
    dpi <- grid::convertWidth(unit(1, "inch"), "pt", valueOnly = TRUE)
  }
  dev <- x$dev
  scale <- x$scale

  # Clean up grob
  x$dev <- NULL
  x$dpi <- NULL
  x$scale <- NULL
  class(x) <- setdiff(class(x), "rasteriser")

  # Rescale height and width
  if (scale <= 0 || !is.numeric(scale)) {
    stop("The parameter 'scale' must be set to a numeric greater than 0")
  }

  width <- width / scale
  height <- height / scale

  # Track current device
  dev_cur <- grDevices::dev.cur()
  # Reset current device upon function exit
  on.exit(grDevices::dev.set(dev_cur), add = TRUE)

  # Setup temporary device for capture
  if (dev == "cairo") {
    dev_id <- Cairo::Cairo(
      type = 'raster',
      width = width, height = height,
      units = "in", dpi = dpi, bg = NA
    )[1]
  } else if (dev == "ragg") {
    dev_id <- ragg::agg_capture(
      width = width, height = height,
      units = "in", res = dpi,
      background = NA
    )
  } else {
    # Temporarily make a file to write png to
    file <- tempfile(fileext = ".png")
    # Destroy temporary file upon function exit
    on.exit(unlink(file), add = TRUE)
    ragg::agg_png(
      file,
      width = width, height = height,
      units = "in", res = dpi,
      background = NA
    )
  }

  # Render layer
  grid::pushViewport(vp)
  grid::grid.draw(x)
  grid::popViewport()

  # Capture raster
  if (dev != "ragg_png") {
    cap <- grid::grid.cap()
  }
  grDevices::dev.off()

  if (dev == "ragg_png") {
    # Read in the png file
    cap <- png::readPNG(file, native = FALSE)
    dim <- dim(cap)
    cap <- matrix(
      grDevices::rgb(
        red   = as.vector(cap[, , 1]),
        green = as.vector(cap[, , 2]),
        blue  = as.vector(cap[, , 3]),
        alpha = as.vector(cap[, , 4])
      ),
      dim[1], dim[2]
    )
  }

  # Forward raster grob
  grid::rasterGrob(
    cap, x = 0.5, y = 0.5,
    height = unit(height * scale, "inch"),
    width = unit(width * scale, "inch"),
    default.units = "npc",
    just = "center"
  )
}


# Small helper function to test if x is a ggplot2 layer
#' @keywords internal
is.layer <- function(x) {
  # duplicate of hidden ggplot2:::is.layer
  inherits(x, "Layer")
}
