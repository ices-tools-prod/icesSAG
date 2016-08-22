#' Get Reference Points
#'
#' Get biological reference points for all stocks in a given assessment year.
#'
#' @param year the assessment year, e.g. 2010. All years can be queried with 0.
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
#' \dontrun{
#' refpts <- getFishStockReferencePoints(2015)
#' }
#'
#' @export
#'
#' @importFrom dplyr bind_rows

getFishStockReferencePoints <- function(year) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # check year
  if (!checkYearOK(year)) return (FALSE)

  # get keys for year
  all_years <- getListStocks(year = year)
  published_keys <- unique(all_years$key[!grepl("Not", all_years$Status)])

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
