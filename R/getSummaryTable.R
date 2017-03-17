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
#' key <- stocklist$AssessmentKey[id]
#' sumtab <- getSummaryTable(key)
#' head(sumtab)
#' attributes(sumtab)$notes
#'
#' @export

getSummaryTable <- function(key) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # read XML string and parse to data frame
  url <-
    sprintf(
      "https://sg.ices.dk/StandardGraphsWebServices.asmx/getSummaryTable?key=%s",
      key)
  out <- readSAG(url)
  out <- parseSummary(out)

  out
}
