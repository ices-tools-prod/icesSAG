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
  # call webservice for all supplied keys
  out <- lapply(key, function(i) sag_webservice("getFishStockReferencePoints", key = i))

  # parse output
  lapply(out, sag_parse)
}
