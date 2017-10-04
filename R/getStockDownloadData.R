getStockDownloadData <- function(assessmentKey, ...) {
  warning("Use with caution!\n",
          "  getStockDownloadData accesses a table that is updated every 12 hours and may\n",
          "  not reflect the current state of the database.")

  assessmentKey <- checkKeyArg(assessmentKey = assessmentKey, ...)

  # call web service for all supplied keys
  out <- lapply(assessmentKey, function(i) sag_webservice("getStockDownloadData", assessmentKey = i))

  # parse output
  lapply(out, sag_parse, type = "table")
}
