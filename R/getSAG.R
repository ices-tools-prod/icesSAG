#' Get Any SAG Data
#'
#' This function combines the functionality of getListStocks,
#' getFishStockReferencePoints, and getSummaryTable.
#' It supports querying many years and quarters in one function call.
#'
#' @param stock a stock name, e.g. cod-347d, or cod to find all cod stocks, or NULL to process all stocks.
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
#' @examples
#' summary <- getSAG("cod-347d", 2015)
#' refpts <- getSAG("cod-347d", 2015, "refpts")
#'
#' \dontrun{
#' cod_summary <- getSAG("cod", 2015)
#' }
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
  key <- findKey(stock, year, published = TRUE, regex = TRUE, full = FALSE)

  # get data requested by user
  url <-
    sprintf(
      "https://sg.ices.dk/StandardGraphsWebServices.asmx/%s?key=%i",
      operation, key)
  # read urls
  out <- lapply(url, readSAG)
  # parse
  out <- lapply(out, parseFunction)

  # drop any null entries (happens when not published stock creep in)
  out <- out[!sapply(out, is.null)]

  # combine tables
  if (combine) {
    # form new column names for combined data frame
    outNames <- unique(unlist(lapply(out, names)))

    # rbind, adding in missing columns as characters
    out <-
      do.call(rbind,
        lapply(unname(out), function(x) {
          # are any columns missing?
          missing.cols <- !outNames %in% names(x)
          if (any(missing.cols)) {
            # add on missing columns as characters
            x[outNames[missing.cols]] <- ""
          }
          # reorder columns
          x[outNames]
        }))

    # finally resimplify
    out <- simplify(out)
  }

  # return
  out
}
