#' Find a Key
#'
#' Find a lookup key corresponding to a stock in a given assessment year.
#'
#' @param stock a stock name, e.g. cod-347d, or cod to find all cod stocks, or
#'        NULL to process all stocks.
#' @param year the assessment year, e.g. 2015, or 0 to process all years.
#' @param published whether to include only years where status is "Published".
#' @param regex whether to match the stock name as a regular expression.
#' @param full whether to return a data frame with all stock list columns.
#'
#' @return A vector of keys (default) or a data frame if full is TRUE.
#'
#' @seealso
#' \code{\link{getListStocks}} gets a list of stocks.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Arni Magnusson and Colin Millar.
#'
#' @examples
#' findKey("cod-347d", 2015, full = TRUE)
#'
#' @export

findKey <- function(stock, year = 0, published = TRUE, regex = TRUE,
                    full = FALSE)
{
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # get stock list
  url <-
    sprintf(
      "https://sg.ices.dk/StandardGraphsWebServices.asmx/getListStocks?year=%i",
      year)
  out <- lapply(url,
                function(u) {
                  out <- readSAG(u)
                  parseSAG(out)
                })
  out <- do.call(rbind, out)

  # apply filters
  if (published) {
    out <- out[out$Status == "Published",]
  }

  if (!is.null(stock)) {
    stock <- tolower(stock)
    if (!regex) stock <- paste0("^", stock, "$")
    select <- unlist(lapply(stock, grep, tolower(out$FishStockName)))
    out <- out[select,]
  }

  if (full) {
    out
  } else {
    out$key
  }
}
