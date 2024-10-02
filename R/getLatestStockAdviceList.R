#' Get List of Most Recent Advice
#'
#' Get a list of the most recent advice for all fish stocks.
#'
#' @param ... arguments passed to \code{\link{ices_get}}.
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

getLatestStockAdviceList <- function(...) {
  ices_get_cached(sag_api("LatestStockAdviceList"), ...)
}
