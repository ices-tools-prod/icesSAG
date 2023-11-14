#' Get a List of the Latest Fish Stock Assessments
#'
#' Get a list of the latest fish stock assessments.
#' Only published stocks are returned.
#'
#' @param ... arguments passed to \code{\link{ices_get}}.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{StockList}} Get a list of fish stock assessments.
#'
#' \code{\link{getFishStockReferencePoints}} gets biological reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' stock_list <- LatestStockAdviceList()
#' }
#' @export

LatestStockAdviceList <- function(...) {
  ices_get_cached(sag_api("LatestStockAdviceList"), ...)
}
