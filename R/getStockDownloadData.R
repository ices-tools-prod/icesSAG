#' Get Source Data
#'
#' Get a copy of the source data for the specified stocks.
#'
#' @param assessmentKey the unique identifier of the stock assessment,
#' can be a vector
#' @param ... arguments passed to \code{\link{sag_get}}.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSAG}} supports querying many years in one function call.
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
#' assessmentKey <- findAssessmentKey("cod-2224", year = 2016)
#' sourcedat <- getStockDownloadData(assessmentKey)
#' head(sourcedat[[1]])
#' }
#'
#' @rdname getStockDownloadData
#' @name getStockSourceData
NULL

#' @rdname getStockDownloadData
#' @export
getStockDownloadData <- function(assessmentKey, ...) {
  # call web service for all supplied keys

  out <-
    lapply(
      assessmentKey,
      function(i) {
        sag_get(
          sag_api("StockDownload", assessmentKey = i), ...
        )
      }
    )

  # rbind output
  out <- do.call(rbind, out)

  sag_clean(out)
}
