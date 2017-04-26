

getStockDownloadData <- function(assessmentKey, ...) {
  warning("Use with caution!\n",
          "  getStockDownloadData accesses a table that is updated every 12 hours and may\n",
          "  not reflect the current state of the data held in the databse.")

  assessmentKey <- checkKeyArg(assessmentKey = assessmentKey, ...)

  # call webservice
  out <- sag_webservice("getStockDownloadData", assessmentKey = assessmentKey)

  # parse output
  sag_parse(out)
}
