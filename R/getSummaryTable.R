#' Get a Summary Table of Historical Stock Size
#'
#' Get a summary table of historical stock size, recruitment, and fishing pressure.
#'
#' @param key the unique identifier of the stock assessment
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getListStocks}} gets a list of stocks.
#'
#' \code{\link{getFishStockReferencePoints}} gets biological reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar and Scott Large.
#'
#' @examples
#' sumtab <- getSummaryTable(2015, "cod-347d")
#'
#' @export
#'
#' @importFrom dplyr bind_rows

getSummaryTable <- function(key) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # read and parse XML from API
  url <-
    sprintf(
      "https://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/getSummaryTable?key=%s",
      key)

  out <- curlSAG(url = url)
  out <- parseSummary(out)

  out
}
