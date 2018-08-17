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
#' \dontrun{
#' assessmentKey <- findAssessmentKey("cod-2224", year = 2016)
#' sourcedat <- getStockDownloadData(assessmentKey)
#' head(sourcedat[[1]])
#' }
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

  # must use token for this service
  # check that token is set
  opts <- options(icesSAG.use_token = TRUE)
  on.exit(options(opts))

  # get uri all supplied keys
  out <- sapply(assessmentKey, function(i) sag_documentService_uri("XMLDownload", assessmentKey = i))

  # read and parse output
  out <- lapply(out, function(x) {
    message("Reading, ", x)
    # peek first
    peek <- suppressWarnings(readLines(x))
    if (length(peek) == 4 || peek[1] %in% c("Sorry stock not found", "Not autorized, please specify the token")) {
      return(NULL)
    } else {
      readSAGxml(x)
    }
  })

  # add stock code names
  notnull <- !sapply(out, is.null)
  if (any(notnull)) {
    names(out)[notnull] <- sapply(out[notnull], function(x) paste0(x$info$StockCode, "_", x$info$AssessmentYear))
  }


  # return
  out
}
