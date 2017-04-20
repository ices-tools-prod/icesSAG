#' Get Reference Points
#'
#' Get biological reference points for all stocks in a given assessment year.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param ... to allow scope for back compatability
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSAG}} supports querying many years and quarters in one
#'   function call.
#'
#' \code{\link{getListStocks}} and \code{\link{getSummaryTable}} get a list of
#'   stocks and summary results.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar and Scott Large.
#'
#' @examples
#' assessmentKey <- findAssessmentKey("cod-2224", year = 2016)
#' refpts <- getFishStockReferencePoints(assessmentKey)
#' refpts
#'
#' @export

getFishStockReferencePoints <- function(assessmentKey, ...) {

  assessmentKey <- checkKeyArg(assessmentKey = assessmentKey, ...)

  # call webservice for all supplied keys
  out <- lapply(assessmentKey, function(i) sag_webservice("getFishStockReferencePoints", assessmentKey = i))

  # parse output
  lapply(out, sag_parse)
}
