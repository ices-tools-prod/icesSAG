#' Get the Values in a Stock Status Table
#'
#' Get summary results of historical stock size, recruitment, and fishing
#' pressure.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param ... to allow scope for back compatibility
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSAG}} supports querying many years and quarters in one
#'   function call.
#'
#' \code{\link{getListStocks}} and \code{\link{getFishStockReferencePoints}} get
#'   a list of stocks and reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' \dontrun{
#' assessmentKey <- findAssessmentKey("cod-2224", year = 2016)
#' status <- getStockStatusValues(assessmentKey)
#' status
#' }
#'
#' @export

getStockStatusValues <- function(assessmentKey, ...) {

  assessmentKey <- checkKeyArg(assessmentKey = assessmentKey, ...)

  # call webservice for all supplied keys
  out <- lapply(assessmentKey, function(i) sag_webservice("getStockStatusValues", assessmentKey = i))

  # parse output
  lapply(out, sag_parse, type = "table")
}
