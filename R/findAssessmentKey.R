#' Find a Key
#'
#' Find a lookup key corresponding to a stock in a given assessment year.
#'
#' @param stock a stock name, e.g. cod-347d, or cod to find all cod stocks, or NULL to process all stocks.
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
#' findAssessmentKey("cod-347d", 2015, full = TRUE)
#'
#' @rdname findAssessmentKeydocs
#' @name findAssessmentKey
NULL

#' @rdname findAssessmentKeydocs
#' @export
findAssessmentKey <- function(stock, year = 0, regex = TRUE, full = FALSE) {
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
    select <- c(unlist(lapply(stock, grep, tolower(out$StockKeyLabel))),
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

#' @rdname findAssessmentKeydocs
#' @export
findKey <- function(stock, year = 0, published = TRUE, regex = TRUE, full = FALSE) {
  warning("findKey() is depreciated, please use findAssessmentKey() instead.")
  findAssessmentKey(stock = stock, year = year, regex = regex, full = full)
}