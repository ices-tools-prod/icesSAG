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
#' stocklist <- getListStocks(2016)
#' id <- grep("cod-2224", stocklist$FishStockName)
#' stocklist[id,]
#' key <- stocklist$AssessmentKey[id]
#' sumtab <- getSummaryTable(key)
#' head(sumtab)
#' attributes(sumtab)$notes
#'
#' @export

getSummaryTable <- function(AssessmentKey, ...) {

  if (missing(AssessmentKey)){
    dots <- list(...)
    if ("key" %in% names(dots)) {
      AssessmentKey <- dots$key
      warning("key argument is depreciated, use AssessmentKey instead.")
    }
  }

  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # read XML string and parse to data frame
  url <-
    sprintf(
      "https://sg.ices.dk/StandardGraphsWebServices.asmx/getSummaryTable?AssessmentKey=%s",
      AssessmentKey)
  out <- readSAG(url)
  out <- parseSummary(out)

  out
}
