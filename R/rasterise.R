#' Rasterise ggplot layers
#' Takes a ggplot layer as input and renders their graphical output as a raster.
#'
#' @author Teun van den Brand <t.vd.brand@nki.nl>
#' @param layer A \code{Layer} object, typically constructed with a call to a
#'   \code{geom_*()} or \code{stat_*()} function.
#' @param dpi integer Sets the desired resolution in dots per inch (default=NULL).
#' @param dev string Specifies the device used, which can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"} (default="cairo").
#' @param scale numeric Scaling factor to modify the raster object size (default=1). The parameter 'scale=1' results in an object size that is unchanged, 'scale'>1 increase the size, and 'scale'<1 decreases the size. These parameters are passed to 'height' and 'width' of grid::grid.raster(). Please refer to 'rasterise()' and 'grid::grid.raster()' for more details.
#' @details The default \code{dpi} (\code{NULL} (i.e. let the device decide)) can conveniently be controlled by setting the option \code{"ggrastr.default.dpi"} (e.g. \code{option("ggrastr.default.dpi", 30)} for drafting).
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
#'
#' @export

rasterise <- function(layer, dpi = getOption("ggrastr.default.dpi"), dev = "cairo", scale = 1) {
  
  dev <- match.arg(dev, c("cairo", "ragg", "ragg_png"))

  # geom_sf returns a list and requires extra logic here to handle gracefully
  if (is.list(layer)) {
    # Check if list contains layers
    has_layer <- rapply(layer, is.layer, how = "list")
    has_layer <- vapply(has_layer, function(x) {any(unlist(x))}, logical(1))
    if (any(has_layer)) {
      # Recurse through list elements that contain layers
      layer[has_layer] <- lapply(layer[has_layer], rasterise,
                                dpi = dpi, dev = dev)
      return(layer)
    } # Will hit next error if list doesn't contain layers
  }

  if (!is.layer(layer)) {
    stop("Cannot rasterise an object of class `", class(layer)[1], "`.",
         call. = FALSE)
  }

  # Take geom from input layer
  old_geom <- layer$geom
  # Reconstruct input layer
  ggproto(
    NULL, layer,
    # Let the new geom inherit from the old geom
    geom = ggproto(
      NULL, old_geom,
      # draw_panel draws like old geom, but appends info to graphical object
      draw_panel = function(...) {
        grob <- old_geom$draw_panel(...)
        class(grob) <- c("rasteriser", class(grob))
        grob$dpi <- dpi
        grob$dev <- dev
        grob$scale <- scale
        return(grob)
      }
    )
  )
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
  inherits(x, "LayerInstance")
}
