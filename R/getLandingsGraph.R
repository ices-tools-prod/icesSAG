#' Get a Summary Table of Historical Stock Size
#'
#' Get a summary table of historical stock size, recruitment, and fishing pressure.
#'
#' @param key the unique identifier of the stock assessment
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getListStocks}} gets a list of stocks.
#'
#' \code{\link{getFishStockReferencePoints}} gets biological reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar and Scott Large.
#'
#' @examples
#' stocklist <- getListStocks(2015)
#' id <- grep("cod-347d", stocklist$FishStockName)
#' stocklist[id,]
#' key <- stocklist$key[id]
#' landings_img <- getLandingsGraph(key)
#' plot.new()
#' plot(landings_img)
#'
#' @export

getLandingsGraph <- function(key) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # read XML string and parse to data frame
  url <-
    sprintf(
      "http://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/getLandingsGraph?key=%i",
      key)
  out <- curlSAG(url)
  out <- parseGraph(out)

  out
}
