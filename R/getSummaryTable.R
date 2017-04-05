#' Get a Summary Table of Historical Stock Size
#'
#' Get summary results of historical stock size, recruitment, and fishing
#' pressure.
#'
#' @param AssessmentKey the unique identifier of the stock assessment
#' @param ... to allow scope for back compatability
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
#' @author Colin Millar and Scott Large.
#'
#' @examples
#' assessmentKey <- findAssessmentKey("cod-2224", year = 2016)
#' sumtab <- getSummaryTable(assessmentKey)
#' head(sumtab)
#' attributes(sumtab)$notes
#'
#' @export

getSummaryTable <- function(assessmentKey) {

  if (missing(AssessmentKey)) {
    dots <- list(...)
    if ("key" %in% names(dots)) {
      AssessmentKey <- dots$key
      warning("key argument is depreciated, use AssessmentKey instead.")
     }
  }

  # call webservice for all supplied keys
  out <- lapply(assessmentKey, function(i) sag_webservice("getSummaryTable", assessmentKey = i))

  # parse output
  lapply(out, sag_parseSummary)
}
