

getStockDownloadData <- function(assessmentKey, ...) {
  assessmentKey <- checkKeyArg(assessmentKey = assessmentKey, ...)

  # call webservice
  out <- sag_webservice("getStockDownloadData", assessmentKey = assessmentKey)

  # parse output
  sag_parse(out)
}
