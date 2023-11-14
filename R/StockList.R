#' Get a List of Fish Stock Assessments
#'
#' Get a list of fish stock assessments for a given assessment year.
#' If an authentication token is not provided, only published stocks
#' are returned.
#'
#' @param year the assessment year, e.g. 2022, or 0 to process all years.
#' @param modifiedAfter date-time parameter in the format "". If set
#'   will only return stocks assessments modified after the provided date.
#' @param ... arguments passed to \code{\link{ices_get}}.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSummaryTable}} gets a summary table of historical stock size.
#'
#' \code{\link{getFishStockReferencePoints}} gets biological reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#'  stock_list <- StockList(year = 2022)
#' }
#' @export

StockList <- function(year, modifiedAfter = NULL, ...) {
  # call webservice for all supplied years
  if (year == 0) {
    year <- 2015:as.numeric(format(Sys.Date(), "%Y"))
  }
  out <-
    lapply(
      year,
      function(i) {
        ices_get_cached(
          sag_api("StockList", year = i, modifiedAfter = modifiedAfter), ...
        )
      }
    )

  # parse output
  do.call(rbind, out)
}
