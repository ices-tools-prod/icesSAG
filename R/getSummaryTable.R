#' Query fish stock reference points for a stock
#'
#' Returns stock assessment summary table of all published stocks for a given year
#'
#' @param year the numeric year of the stock assessment summary output, e.g. 2010. All assessment years can be queried with 0.
#'
#'
#' @return A data.frame.
#'
#' @seealso
#' \code{\link{getListStocks}} returns data frame of fish stocks for a given year
#'
#' \code{\link{getFishStockReferencePoints}} Returns the biological reference points for all published stocks in a year.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar and Scott Large
#'
#' @examples
#' \dontrun{getSummaryTable(year = 2015)}
#'
#'
#' @export
#'
#' @importFrom dplyr bind_rows

getSummaryTable <- function(year) {

  # check websevices are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # check year
  if (!checkYearOK(year)) return (FALSE)

  # get keys for year
  all_years <- getListStocks(year = year)
  published_keys <- unique(all_years$key[!grepl("Not", all_years$Status)])

  # read and parse XML from api
  url <-
    sprintf(
      "https://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/getSummaryTable?key=%s",
      published_keys)


  out <- do.call(bind_rows,
                 lapply(url,
                        function(x)
                          parseSummary(curlSAG(url = x))))

  # return
  out
}
