#' Get a List of Fish Stocks
#'
#' Get a list of fish stocks for a given assessment year.
#'
#' @param year the assessment year, e.g. 2010. All years can be queried with 0.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getFishStockReferencePoints}} gets biological reference points.
#'
#' \code{\link{getSummaryTable}} gets a summary table of historical stock size.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar and Scott Large.
#'
#' @examples
#' stocks <- getListStocks(2015)
#'
#' @export

getListStocks <- function(year) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # read and parse XML from API
  url <-
    sprintf(
      "https://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/getListStocks?year=%i",
      year)
  out <- parseSAG(curlSAG(url = url))

  # return
  simplify(out)
}
