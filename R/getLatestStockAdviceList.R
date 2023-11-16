#' Get List of Most Recent Advice
#'
#' Get a list of the most recent advice for all fish stocks.
#'
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSummaryTable}} gets a summary table of historical stock size.
#'
#' \code{\link{getFishStockReferencePoints}} gets biological reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar, Scott Large, and Arni Magnusson.
#'
#' @examples
#' \dontrun{
#' stocks <- getLatestStockAdviceList()
#'}
#' @export

getLatestStockAdviceList <- function() {
  .Deprecated("LatestStockAdviceList")
  # call webservice
  out <- sag_webservice("getLatestStockAdviceList")

  # parse output
  sag_parse(x = out, type = "table")
}
