#' Get a List of Fish Stocks
#'
#' Get a list of fish stocks for a given assessment year.
#'
#' @param year the assessment year, e.g. 2015, or 0 to process all years.
#' @param stock a stock name, e.g. lin.27.5a.
#' @param modifiedAfter date-time parameter in the format "YYYY/MM/DD". If set
#'   will only return stocks assessments modified after the provided date.
#' @param ... arguments passed to \code{\link{sag_get}}.
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
#' @author Colin Millar.
#'
#' @examples
#' \dontrun{
#' stocks <- getListStocks(2023)
#' nshad <- getListStocks(stock = "had.27.46a20")
#' }
#' @export

getListStocks <- function(year, stock = NULL, modifiedAfter = NULL, ...) {
  # call webservice for all supplied years
  if (missing(year) || identical(year, 0)) {
    year <- 2015:as.numeric(format(Sys.Date(), "%Y"))
  }
  out <-
    lapply(
      year,
      function(i) {
        sag_get_cached(
          sag_api("StockList", year = i, fishStock = stock, modifiedAfter = modifiedAfter), ...
        )
      }
    )

  # prepare output
  out <- do.call(rbind, out)

  sag_clean(out)
}
