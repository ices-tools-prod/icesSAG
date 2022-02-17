#' Create a data.frame of fish stock data
#'
#' This function is a wrapper to \code{data.frame(...)} in which the names are forced to match with
#' the names required for the SAG database.  See http://dome.ices.dk/datsu/selRep.aspx?Dataset=126
#' for more details.
#'
#' @param Year a vector of years.
#' @param ... additional information, e.g. Recruitment, StockSize, Landings, ...
#'
#'
#' @return A data.frame, where all names are valid column names in the SAG database.
#'
#' @author Colin Millar.
#'
#' @examples
#' stockFishdata(Year = 1990:2017, Catches = 100)
#' @export

stockFishdata <- function(Year, ...) {
  # create default data.frame
  val <- c(list(Year = Year), list(...))
  # warn about possibly misspelt names?
  if (any(!names(val) %in% validNames("stockFishdata"))) {
    warning(
      "The following argument(s) are invalid and will be ignored:\n",
      utils::capture.output(noquote(names(val))[!names(val) %in% validNames("stockFishdata")]),
      "\n"
    )
  }
  val <- val[names(val) %in% validNames("stockFishdata")]
  val$stringsAsFactors <- FALSE
  val <- do.call(data.frame, val)
  val[setdiff(validNames("stockFishdata"), names(val))] <- NA
  class(val) <- c("sag.data.frame", class(val))
  val
}