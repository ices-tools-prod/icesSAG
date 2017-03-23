#' Find a assessmentKey
#'
#' Find a lookup key corresponding to a stock in a given assessment year.
#'
#' @param stock a stock name, e.g. cod-347d, or cod to find all cod stocks, or NULL to process all stocks.
#' @param year the assessment year, e.g. 2015, or 0 to process all years.
#' @param regex whether to match the stock name as a regular expression.
#' @param full whether to return a data frame with all stock list columns.
#'
#' @return A vector of assessment keys (default) or a data frame if full is TRUE.
#'
#' @seealso
#' \code{\link{getListStocks}} gets a list of stocks.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Arni Magnusson.
#'
#' @examples
#' findAssessmentKey("cod-347d", 2015, full = TRUE)
#'
#' @export

findAssessmentKey <- function(stock, year = 0, regex = TRUE, full = FALSE)
{
  # get list of all stocks for all supplied years
  out <- do.call(rbind, lapply(year, getListStocks))

  # apply filters
  if (!getOption("icesSAG.use_token")) {
    # restrict output to only published stocks
    out <- out[out$Status == "Published",]
  }

  if (!missing(stock)) {
    stock <- tolower(stock)
    if (!regex) stock <- paste0("^", stock, "$")
    select <- c(unlist(lapply(stock, grep, tolower(out$FishStockName))),
                unlist(lapply(stock, grep, tolower(out$StockDescription))),
                unlist(lapply(stock, grep, tolower(out$SpeciesName))))
    out <- out[select,]
  }

  # return
  if (full) {
    out
  } else {
    out$AssessmentKey
  }
}
