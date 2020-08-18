#' Rasterise ggplot layers
#' Takes a ggplot layer as input and renders their graphical output as a raster.
#'
#' @author Teun van den Brand <t.vd.brand@nki.nl>
#' @param layer A \code{Layer} object, typically constructed with a call to a
#'   \code{geom_*()} or \code{stat_*()} function.
#' @param dpi An integer of length one setting the desired resolution in dots per inch. (default=NULL)
#' @param dev A character specifying a device. Can be one of: \code{"cairo"}, \code{"ragg"} or \code{"ragg_png"}. (default="cairo")
#'
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
#' @export
rasterise <- function(layer, dpi = NULL, dev = "cairo") {
  dev <- match.arg(dev, c("cairo", "ragg", "ragg_png"))

  if (!inherits(layer, "Layer")) {
    stop("Cannot rasterise an object of class `", class(layer)[1], "`. Must be either 'cairo', 'ragg', or 'ragg_png'.", call. = FALSE)
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
  vp <- if(is.null(x$vp)) grid::viewport() else x$vp
  width <- grid::convertWidth(unit(1, "npc"), "inch", valueOnly = TRUE)
  height <- grid::convertHeight(unit(1, "npc"), "inch", valueOnly = TRUE)

  # Grab grob metadata
  dpi <- x$dpi
  if (is.null(dpi)) {
    # If missing, take current DPI
    dpi <- grid::convertWidth(unit(1, "inch"), "pt", valueOnly = TRUE)
  }
  dev <- x$dev

  # Clean up grob
  x$dev <- NULL
  x$dpi <- NULL
  class(x) <- setdiff(class(x), "rasteriser")

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
    height = unit(height, "inch"),
    width = unit(width, "inch"),
    default.units = "npc",
    just = "center"
  )
}
