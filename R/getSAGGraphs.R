#' Get a Summary Table of Historical Stock Size
#'
#' Get a summary table of historical stock size, recruitment, and fishing pressure.
#'
#' @param key the unique identifier of the stock assessment
#'
#' @param type the type of plot requested, e.g. "Landings", "Recruitment", ...
#'
#' @return An array representing a png.
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
#' key <- findKey("cod", 2015)
#' graphs <- getSAGGraphs(key[1])
#' plot(graphs)
#'
#' @export

getSAGGraphs <- function(key) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # check graph type requested
  types <- c("Landings",
             "Recruitment",
             "FishingMortality",
             "SpawningStockBiomass")

  # read and parse text from API
  url <-
    sprintf(
      "http://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/get%sGraph?key=%i",
      types, key)

  # read urls
  out <- lapply(url, curlSAG)

  # parse text
  out <- lapply(out, parseGraph)

  # set class
  class(out) <- c("ices_standardgraph_list", class(out))

  # return
  out
}
