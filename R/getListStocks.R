#' Get a List of Fish Stocks
#'
#' Get a list of fish stocks for a given assessment year.
#'
#' @param year the assessment year, e.g. 2015, or 0 to process all years.
#' @param stock a stock name, e.g. cod-347d, or NULL to process all stocks.
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
#' cod.347d <- getListStocks(2015, "cod-347d")
#' print.simple.list(cod.347d)
#'
#' @export

getListStocks <- function(year, stock = NULL) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # read and parse XML from API
  url <-
    sprintf(
      "https://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/getListStocks?year=%i",
      year)
  out <- parseSAG(curlSAG(url = url))

  # filter by stock
  if (!is.null(stock)) {
    out <- out[out$FishStockName == stock,]
    row.names(out) <- NULL
  }

  # return
  simplify(out)
}
