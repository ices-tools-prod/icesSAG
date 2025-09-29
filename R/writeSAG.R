#' Create and read the SAG CSV data transfer file
#'
#' Convert between R data (a list and a data.frame) and the CSV format required for uploading
#' data to the SAG database.
#'
#' @param file a csv file name
#' @param info a list of stock information
#' @param fishdata a data frame of fish data
#'
#' @return a string containing the csv file.
#'
#' @seealso
#' \code{\link{stockInfo}} creates a list of stock information.
#'
#' \code{\link{stockFishdata}} creates a data frame of fish stock summary data.
#'
#' @examples
#'
#' \dontrun{
#' info <- stockInfo(StockCode = "cod.27.347d",
#'                   AssessmentYear = 2017,
#'                   StockCategory = 1,
#'                   ModelType = "A",
#'                   ModelName = "SCA",
#'                   ContactPerson = "itsme@fisheries.com")
#' fishdata <- stockFishdata(Year = 1990:2017, Catches = 100)
#' csvfile <- writeSAG(info, fishdata)
#' }
#'
#' @rdname readWriteSAG
#' @importFrom utils write.table
#' @export
writeSAG <- function(info, fishdata, file = NULL) {
  if (missing(info) || missing(fishdata)) {
    stop("Both info and fishdata must be provided.")
  }

  info <- do.call(stockInfo, info)
  fishdata <- do.call(stockFishdata, fishdata)

  if (is.null(file)) {
    file <- paste0(info$StockCode, ".csv")
  }

  # Write the info and fishdata to a CSV file
  write.table(cbind("AA", info), file = file, sep = ",", col.names = FALSE)
  write.table(cbind("AF", fishdata), file = file, sep = ",", col.names = FALSE)

  # Return the file name
  invisible(file)
}

#' @rdname readWriteSAG
#' @export
readSAGxml <- function(file) {
  # read in ragged csv file....

  NULL
}
