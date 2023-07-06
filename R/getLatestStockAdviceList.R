#' Get List of Most Recent Advice
#'
#' Get a list of the most recent advice for all fish stocks.
#'
#' @param camel.case should the column names be capitalized like previous
#'                versions of icesSAG, or use the new camelCase.
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

getLatestStockAdviceList <- function(camel.case = getOption("icesSAG.camelCase")) {

  out <- ices_get(sag_api("LatestStockAdviceList"), use_token = getOption("icesSAG.use_token"))

  if (!camel.case) {
    # change case of output
    names(out) <- firstCap(names(out))
  }

  out
}
