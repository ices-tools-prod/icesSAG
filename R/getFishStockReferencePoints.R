#' Query fish stock reference points for a stock
#'
#' Returns the biological reference points for all published stocks in a year
#'
#' @param year the numeric year of the biological reference points output, e.g. 2010. All assessment years can be queried with 0.
#'
#'
#' @return A data.frame.
#'
#' @seealso
#' \code{\link{getListStocks}} returns data frame of fish stocks for a given year 
#'
#' \code{\link{getSummaryTable}} returns stock assessment summary table of all published stocks for a given year.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar and Scott Large
#'
#' @examples
#' getFishStockReferencePoints(year = 2015)
#'
#'
#' @export
#' 
#' @importFrom dplyr bind_rows

getFishStockReferencePoints <- function(year) {
  
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
      "https://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/getFishStockReferencePoints?key=%s",
      published_keys)
  
  out <- do.call(bind_rows,
                 lapply(url, 
                        function(x)
                          parseSAG(curlSAG(url = x)))) 
  
  
  # return
  out
}