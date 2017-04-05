#' Get Summary Graphs of Stock Assessment Output
#'
#' Get summary graphs of catches, recruitment, fishing pressure, and spawning
#' stock biomass.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param ... to allow scope for back compatability
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
#' assessmentKey <- findAssessmentKey("cod", 2015)
#' graphs <- getSAGGraphs(assessmentKey[1])
#' plot(graphs)
#'
#' @export

getSAGGraphs <- function(assessmentKey) {
  # only 1 key can be used
  if (length(assessmentKey) > 1) {
    assessmentKey <- assessmentKey[1]
    warning("assessmentKey has length > 1 and only the first key will be used")
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
                     args = list(assessmentKey = assessmentKey)))

  # set class
  class(out) <- c("ices_standardgraph_list", class(out))

  # return
  out
}
