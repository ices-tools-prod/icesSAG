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
  # only 1 key can be used
  if (length(key) > 1) {
    key <- key[1]
    warning("key has length > 1 and only the first key will be used")
  }

  # which graph types to get
  types <- c("Landings",
             "Recruitment",
             "FishingMortality",
             "SpawningStockBiomass")

  # call webservices, built as: get<types>Graph
  out <-
    sapply(types,
           function(x)
             do.call(sprintf("get%sGraph", x),
                     args = list(key = key)))

  # set class
  class(out) <- c("ices_standardgraph_list", class(out))

  # return
  out
}
