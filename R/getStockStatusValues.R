#' Get the Values in a Stock Status Table
#'
#' Get summary results of historical stock size, recruitment, and fishing
#' pressure.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param ... arguments passed to \code{\link{ices_get}}.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSAG}} supports querying many years and quarters in one
#'   function call.
#'
#' \code{\link{getListStocks}} and \code{\link{getFishStockReferencePoints}} get
#'   a list of stocks and reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' \dontrun{
#' assessmentKey <- findAssessmentKey("had.27.46a20", year = 2022)
#' status <- getStockStatusValues(assessmentKey)
#' status
#' }
#'
#' @export

getStockStatusValues <- function(assessmentKey, ...) {
  # call web service for all supplied keys

  out <-
    lapply(
      assessmentKey,
      function(i) {
        x <- ices_get(
          sag_api("StockStatusValues", assessmentKey = i), ...
        )
        # as.list removes warning about rownames
        do.call(
          rbind,
          lapply(1:nrow(x), function(i) cbind(as.list(x[i, names(x) != "YearStatus"]), x$YearStatus[[i]]))
        )
      }
    )

  # rbind output
  out <- do.call(rbind, out)

  sag_clean(out)
}
