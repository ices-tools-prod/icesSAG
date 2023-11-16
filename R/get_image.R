#' Get a Graph of Stock Assessment Output
#'
#' Get a graph of stock assessment output, e.g., historical stock size,
#' recruitment, and fishing pressure.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param type The type of plot: values can be landings, recruitment
#'   ssb, mortality, historical_mortality, historical_ssb,
#'   historical_recruitment.
#' @param width width of the image in pixels
#' @param ... to allow scope for back compatibility
#'
#' @return An array representing a bitmap.
#'
#' @seealso
#' \code{\link{getListStocks}} gets a list of stocks.
#'
#' \code{\link{getFishStockReferencePoints}} gets biological reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' assessmentKey <- findAssessmentKey("cod.27.21", year = 2023)
#' landings_img <- get_image(assessmentKey[1], "landings")
#'
#' plot(landings_img)
#'
#' landings_plots <- get_image(assessmentKey, "landings")
#' plot(landings_plots)
#' }
#'
#' @export

get_image <- function(assessmentKey, type = c("landings", "recruitment", "ssb", "mortality", "historical_mortality", "historical_ssb", "historical_recruitment"), width = 800, ...) {

  type <- match.arg(type)

  # call webservice for all supplied keys
  old_value <- sag_use_token(TRUE)
  out <-
    lapply(
      assessmentKey,
      function(i) {
        ices_get(
          sag_api("get_image", assesmentKey = i, type = type, width = width), ...
        )
      }
    )
  sag_use_token(old_value)

  # set class
  class(out) <- c("ices_standardgraph_list", class(out))

  # return
  out
}

#' @export
plot.ices_standardgraph_list <- function(x, y = NULL, ...) {
  # clear the page
  grid::grid.newpage()

  if (length(x) == 1) {
    grid::grid.raster(x[[1]])
  } else {
    # find best plot layout (stolen from Simon Wood!)
    n.plots <- length(x)
    c <- r <- trunc(sqrt(n.plots))
    if (c < 1) r <- c <- 1
    if (c * r < n.plots) c <- c + 1
    if (c * r < n.plots) r <- r + 1

    # calculate x and y locations for plots -
    # plot like a table: from top to bottom and left to right
    x_loc <- rep((1:r) / r - 1 / (2 * r), c)
    y_loc <- rep((c:1) / c - 1 / (2 * c), each = r)
    for (i in seq_along(x)) {
      if (!is.null(x[[i]])) {
        grid::grid.raster(x[[i]], x = x_loc[i], y = y_loc[i], width = 1 / r, height = 1 / c)
      }
    }
  }
}

#' @export
print.ices_standardgraph_list <- function(x, y = NULL, ...) {
  plot.ices_standardgraph_list(x, y = NULL, ...)
}
