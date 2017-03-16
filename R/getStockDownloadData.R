

getStockDownloadData <- function(key) {
  # call webservice
  out <- sag_webservice("getStockDownloadData", key = key)

  # parse output
  sag_parse(out)
}
