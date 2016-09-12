#' Get Reference Points
#'
#' Get biological reference points for all stocks in a given assessment year.
#'
#' @param year the assessment year, e.g. 2015, or 0 to process all years.
#' @param stock a stock name, e.g. cod-347d, or NULL to process all stocks.
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
#' refpts <- getFishStockReferencePoints(2015, "cod-347d")
#'
#' @export
#'
#' @importFrom dplyr bind_rows

getFishStockReferencePoints <- function(year, stock = NULL) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # check year
  if (!checkYearOK(year)) return (FALSE)

  # get keys for year and stock
  stock_list <- getListStocks(year = year, stock = stock)
  published_keys <- unique(stock_list$key[!grepl("Not", stock_list$Status)])

  # read and parse XML from API
  url <-
    sprintf(
      "https://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/getFishStockReferencePoints?key=%s",
      published_keys)

  out <- do.call(bind_rows,
                 lapply(url,
                        function(x)
                          parseSAG(curlSAG(url = x))))

  # return
  simplify(out)
}
