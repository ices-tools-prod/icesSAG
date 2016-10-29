#' Find a Key
#'
#' Find a lookup key corresponding to a stock in a given assessment year.
#'
#' @param stock a stock name, e.g. cod-347d, or NULL to process all stocks.
#' @param year the assessment year, e.g. 2015, or 0 to process all years.
#' @param published whether to include only years where status is "Published".
#' @param full whether to return a data frame with all stock list columns.
#'
#' @return A vector of keys (default) or a data frame if full is TRUE.
#'
#' @seealso
#' \code{\link{getListStocks}} gets a list of stocks.
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

findKey <- function(stock, year, published = TRUE, full = FALSE)
{
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # get stock list
  url <-
    sprintf(
      "https://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/getListStocks?year=%i",
      year)
  out <- lapply(url,
                function(u) {
                  out <- curlSAG(u)
                  parseSAG(out)
                })
  out <- do.call(rbind, out)

  # filter and format
  if (!is.null(stock)) out <- out[out$FishStockName %in% stock,]
  if (published) out <- out[out$Status == "Published",]
  if (!full) out <- out$key

  out
}
