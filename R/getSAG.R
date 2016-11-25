#' Get Any SAG Data
#'
#' This function combines the functionality of getListStocks,
#' getFishStockReferencePoints, and getSummaryTable.
#' It supports querying many years and quarters in one function call.
#'
#' @param stock a stock name, e.g. cod-347d, or NULL to process all stocks.
#' @param year the assessment year, e.g. 2015, or 0 to process all years.
#' @param data the data of interest, either "summary" or "refpts".
#' @param combine whether to combine the list output to a data frame.
#'
#' @note Only years with "Published" status are returned.
#'
#' @return A data frame (default) or a list if \code{combine} is \code{TRUE}.
#'
#' @seealso
#' \code{\link{getListStocks}}, \code{\link{getSummaryTable}}, and
#'   \code{\link{getFishStockReferencePoints}} get a list of stocks, summary
#'   results, and reference points.
#'
#' \code{\link{findKey}} finds lookup keys.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Arni Magnusson.
#'
#' @examples
#' summary <- getSAG("cod-347d", 2015)
#' refpts <- getSAG("cod-347d", 2015, "refpts")
#'
#' @export

getSAG <- function(stock, year, data = "summary", combine = TRUE) {
  # select web service operation and parser
  data <- match.arg(data, c("summary", "refpts"))
  operation <- switch(data,
                      summary = "getSummaryTable",
                      refpts = "getFishStockReferencePoints")
  parseFunction <- switch(data,
                          summary = parseSummary,
                          refpts = parseSAG)

  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # find lookup key
  key <- findKey(stock, year)

  # get data requested by user
  url <-
    sprintf(
      "https://sg.ices.dk/StandardGraphsWebServices.asmx/%s?key=%i",
      operation, key)
  out <- lapply(url,
                function(u) {
                  out <- curlSAG(u)
                  parseFunction(out)
                })
  if (combine) out <- do.call(rbind, out)

  out
}
