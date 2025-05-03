
get_plot_path <- function(assessmentKey, type = 1, ...) {
    # call webservice for all supplied keys
    old_value <- sag_use_token(TRUE)
    ret <-
      sapply(
        assessmentKey,
        function(i) {
          try(
            sag_get(
              sag_api("get_plot_path", assessmentKey = i, sgKey = type), content = FALSE, ...
            )
          )
        }
      )
    sag_use_token(old_value)

  status <- apply(ret, 2, "[[", "status_code")

  out <- character(length(assessmentKey))
  ok_status <- c("200")
  if (any(status %in% ok_status)) {
    out[status %in% ok_status] <-
      apply(
        ret[,  status %in% ok_status, drop = FALSE],
        2,
        function(x) rawToChar(x$content)
      )
  }

  out
}

get_image_internal <- function(paths, ...) {

  # call webservice for all supplied keys
  old_value <- sag_use_token(TRUE)
  out <- lapply(paths, sag_get, ...)
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
