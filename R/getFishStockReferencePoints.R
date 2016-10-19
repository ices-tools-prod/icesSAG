#' Get Reference Points
#'
#' Get biological reference points for all stocks in a given assessment year.
#'
#' @param key the unique identifier of the stock assessment
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getListStocks}} gets a list of stocks.
#'
#' \code{\link{getSummaryTable}} gets a summary table of historical stock size.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar and Scott Large.
#'
#' @examples
#' stocklist <- getListStocks(2016)
#' id <- grep("cod-347d", stocklist$FishStockName)
#' stocklist[id,]
#' key <- stocklist$key[id]
#' refpts <- getFishStockReferencePoints(key)
#' refpts
#'
#' @export
#'
#' @importFrom dplyr bind_rows

getFishStockReferencePoints <- function(key) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # read and parse XML from API
  url <-
    sprintf(
      "https://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/getFishStockReferencePoints?key=%s",
      key)

  out <- curlSAG(url = url)
  out <- parseSAG(out)

  # return
  out
}
