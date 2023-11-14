#' Get Source Data
#'
#' Get a copy of the source data for the specified stocks.
#'
#' @param assessmentKey the unique identifier of the stock assessment,
#' can be a vector
#' @param ... arguments passed to \code{\link{ices_get}}.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSAG}} supports querying many years in one function call.
#'
#' \code{\link{StockList}} and \code{\link{getFishStockReferencePoints}} get
#'   a list of stocks and reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' \dontrun{
#' assessmentKey <- findAssessmentKey("had.27.46a20", year = 2022)
#' sourcedat <- StockDownload(assessmentKey)
#' head(sourcedat)
#' }
#'
#' @export
StockDownload <- function(assessmentKey, ...) {
  # call web service for all supplied keys

  out <-
    lapply(
      assessmentKey,
      function(i) {
        ices_get(
          sag_api("StockDownload", assessmentKey = i), ...
        )
      }
    )

  # rbind output
  do.call(rbind, out)
}
