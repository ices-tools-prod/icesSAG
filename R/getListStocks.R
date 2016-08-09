#' Query list of fish stocks in the database
#'
#' Returns data frame of fish stocks for a given year (or all years when getListStocks(year = 0))
#'
#' @param year the numeric year of the stock assessment output, e.g. 2010. All assessment years can be queried with 0.
#'
#'
#' @return A data.frame.
#'
#' @seealso
#' \code{\link{getFishStockReferencePoints}} returns the biological reference points for the stock.
#'
#' \code{\link{getSummaryTable}} returns the summary table of the stock.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar and Scott Large
#'
#' @examples
#' \dontrun{getListStocks(year = 2015)}
#'
#'
#' @export

getListStocks <- function(year) {
  # get a list of survey names

  # check websevices are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # read and parse XML from api
  url <-
    sprintf(
      "https://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/getListStocks?year=%s",
      year)
  out <- curlSAG(url = url)
  out <- parseSAG(out)

  # return
  out
}
