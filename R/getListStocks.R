#' Get a List of Fish Stocks
#'
#' Get a list of fish stocks for a given assessment year.
#'
#' @param year the assessment year, e.g. 2015, or 0 to process all years.
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
#' @author Colin Millar, Scott Large, and Arni Magnusson.
#'
#' @examples
#' \dontrun{
#' stocks <- getListStocks(2015)
#' }
#' @export

getListStocks <- function(year) {
  # call webservice for all supplied years
  out <- lapply(year, function(i) sag_webservice("getListStocks", year = i))

  # parse output
  do.call(rbind, lapply(out, sag_parse))
}
