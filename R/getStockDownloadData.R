#' Get Source Data
#'
#' Get a copy of the source data for the specified stocks.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param ... to allow scope for back compatibility
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSAG}} supports querying many years in one function call.
#'
#' \code{\link{getListStocks}} and \code{\link{getFishStockReferencePoints}} get
#'   a list of stocks and reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' assessmentKey <- findAssessmentKey("cod-2224", year = 2016)
#' sourcedat <- getStockDownloadData(assessmentKey)
#' head(sourcedat[[1]])
#'
#' @rdname getStockDownloadData
#' @name getStockSourceData
NULL

#' @rdname getStockDownloadData
#' @export
getStockDownloadData <- function(assessmentKey, ...) {
  assessmentKey <- checkKeyArg(assessmentKey = assessmentKey, ...)

  # call web service for all supplied keys
  out <- lapply(assessmentKey, function(i) sag_webservice("getStockDownloadData", assessmentKey = i))

  # parse output
  lapply(out, sag_parse, type = "table")
}

#' @rdname getStockDownloadData
#' @export
getStockSourceData <- function(assessmentKey, ...) {
  assessmentKey <- checkKeyArg(assessmentKey = assessmentKey, ...)

  # get uri all supplied keys
  out <- sapply(assessmentKey, function(i) sag_documentService_uri("XMLDownload", assessmentKey = i))

  # read and parse output
  out <- lapply(out, function(x) {
    message("Reading, ", x)
    readSAGxml(x)
    })

  # add stock code names
  names(out) <- sapply(out, function(x) paste0(x$info$StockCode, "_", x$info$AssessmentYear))

  # return
  out
}
