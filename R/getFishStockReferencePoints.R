#' Get Reference Points
#'
#' Get biological reference points for all stocks in a given assessment year.
#'
#' @param key the unique identifier of the stock assessment
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSAG}} supports querying many years and quarters in one
#'   function call.
#'
#' \code{\link{getListStocks}} and \code{\link{getSummaryTable}} get a list of
#'   stocks and summary results.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar and Scott Large.
#'
#' @examples
#' stocklist <- getListStocks(2016)
#' id <- grep("cod-2224", stocklist$FishStockName)
#' stocklist[id,]
#' key <- stocklist$key[id]
#' refpts <- getFishStockReferencePoints(key)
#' refpts
#'
#' @export

getFishStockReferencePoints <- function(key) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # only 1 key can be used
  if (length(key) > 1) {
    key <- key[1]
    warning("key has length > 1 and only the first element will be used")
  }

  # read XML string and parse to data frame
  url <-
    sprintf(
      "https://sg.ices.dk/StandardGraphsWebServices.asmx/getFishStockReferencePoints?key=%s",
      key)
  out <- curlSAG(url)
  out <- parseSAG(out)

  out
}
