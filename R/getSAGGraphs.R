#' Get Summary Graphs of Stock Assessment Output
#'
#' Get summary graphs of catches, recruitment, fishing pressure, and spawning
#' stock biomass.
#'
#' @param key the unique identifier of the stock assessment
#'
#' @return An array representing a bitmap.
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

  # only 1 key can be used
  if (length(key) > 1) {
    key <- key[1]
    warning("key has length > 1 and only the first element will be used")
  }

  # check graph type requested
  types <- c("Landings",
             "Recruitment",
             "FishingMortality",
             "SpawningStockBiomass")

  # read and parse text from API
  url <-
    sprintf(
      "http://sg.ices.dk/StandardGraphsWebServices.asmx/get%sGraph?key=%i",
      types, key)

  # read urls
  out <- lapply(url, readSAG)

  # parse text
  out <- lapply(out, parseGraph)

  out <- out[!sapply(out, is.null)]

  # set class
  class(out) <- c("ices_standardgraph_list", class(out))

  # return
  out
}
