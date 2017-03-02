#' Get a Summary Table of Historical Stock Size
#'
#' Get summary results of historical stock size, recruitment, and fishing
#' pressure.
#'
#' @param key the unique identifier of the stock assessment
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSAG}} supports querying many years and quarters in one
#'   function call.
#'
#' \code{\link{getListStocks}} and \code{\link{getFishStockReferencePoints}} get
#'   a list of stocks and reference points.
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
#' sumtab <- getSummaryTable(key)
#' head(sumtab)
#' attributes(sumtab)$notes
#'
#' @export

getSummaryTable <- function(key) {
  # call webservice for all supplied keys
  out <- lapply(key, function(i) sag_webservice("getSummaryTable", key = i))

  # parse output
  lapply(out, sag_parseSummary)
}
