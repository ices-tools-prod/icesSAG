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
#' stocks <- getListStocks(2015)
#'
#' @export

getListStocks <- function(year) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # read XML string and parse to data frame
  url <-
    sprintf(
      "https://sg.ices.dk/StandardGraphsWebServices.asmx/getListStocks?year=%i",
      year)
  out <- readSAG(url)
  out <- parseSAG(out)

  out
}
