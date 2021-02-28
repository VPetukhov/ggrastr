#' Pretty theme
#'
#' @param show.ticks boolean Whether to show x- and y-ticks (default=TRUE).
#' @param legend.pos Vector with x and y position of the legend (default=NULL).
#' @return ggplot2 with plot ticks and positioned legend
#'
#' @examples
#' library(ggplot2)
#' library(ggrastr)
#' 
#' data = rnorm(100)
#' colors = (1:100/100)
#' ggplot() + geom_point(aes(x=data, y=data, color=colors)) + theme_pdf(FALSE, legend.pos=c(1, 1))
#'
#' @export
theme_pdf <- function(show.ticks=TRUE, legend.pos=NULL) {
  r <- ggplot2::theme(axis.line = ggplot2::element_line(size=0.7, color = "black"),
                      axis.text=ggplot2::element_text(size=12),
                      axis.title.x=ggplot2::element_text(margin=ggplot2::margin(t=3, unit='pt')),
                      axis.title.y=ggplot2::element_text(margin=ggplot2::margin(r=3, unit='pt')),
                      legend.background = ggplot2::element_rect(fill="transparent"),
                      legend.box.background = ggplot2::element_rect(fill=ggplot2::alpha('white', 0.7),
                                                                    color=ggplot2::alpha('black', 0.3)),
                      legend.box.margin = ggplot2::margin(t=3, r=3, b=3, l=3, unit='pt'),
                      legend.key.size = ggplot2::unit(12, "pt"),
                      legend.margin = ggplot2::margin(t=0, r=0, b=0, l=0, unit='pt'),
                      legend.text = ggplot2::element_text(size=10),
                      legend.title = ggplot2::element_text(size=12),
                      plot.margin = ggplot2::margin(t=12, r=12, b=0, l=0, unit='pt'),
                      plot.title = ggplot2::element_text(hjust=0.5, size=14))

  if (!show.ticks) {
    r <- r + ggplot2::theme(axis.ticks=ggplot2::element_blank(),
                            axis.text=ggplot2::element_blank())
  }

  if (!is.null(legend.pos)) {
    r <- r + ggplot2::theme(legend.position=legend.pos, legend.justification=legend.pos)
  }
  
  return(r)
}
