#' Get Reference Points
#'
#' Get biological reference points for all stocks in a given assessment year.
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
#' \code{\link{getListStocks}} and \code{\link{getSummaryTable}} get a list of
#'   stocks and summary results.
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
#' refpts <- getFishStockReferencePoints(key)
#' refpts
#'
#' @export

getFishStockReferencePoints <- function(AssessmentKey, ...) {

  if (missing(AssessmentKey)){
    dots <- list(...)
    if ("key" %in% names(dots)) {
      AssessmentKey <- dots$key
      warning("key argument is depreciated, use AssessmentKey instead.")
    }
  }

  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # only 1 key can be used
  if (length(AssessmentKey) > 1) {
    AssessmentKey <- AssessmentKey[1]
    warning("AssessmentKey has length > 1 and only the first element will be used")
  }

  # read XML string and parse to data frame
  url <-
    sprintf(
      "https://sg.ices.dk/StandardGraphsWebServices.asmx/getFishStockReferencePoints?AssessmentKey=%s",
      AssessmentKey)
  out <- readSAG(url)
  out <- parseSAG(out)

  out
}
