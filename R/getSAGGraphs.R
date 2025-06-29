#' Get Summary Graphs of Stock Assessment Output
#'
#' Get summary graphs of catches, recruitment, fishing pressure, and spawning
#' stock biomass.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param ... to allow scope for back compatibility
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
#' \dontrun{
#' assessmentKey <- findAssessmentKey("cod", 2015)
#' graphs <- getSAGGraphs(assessmentKey[1])
#' plot(graphs)
#' # note this stock only has one graph see:
#' # http://standardgraphs.ices.dk/ViewCharts.aspx?key=8309
#' }
#' @export

getSAGGraphs <- function(assessmentKey, ...) {
  assessmentKey <- checkKeyArg(assessmentKey = assessmentKey, ...)

  # only 1 key can be used
  if (length(assessmentKey) > 1) {
    assessmentKey <- assessmentKey[1]
    warning("assessmentKey has length > 1 and only the first key will be used")
  }

  # which graph types to get
  types <- c(
    "Landings",
    "Recruitment",
    "FishingMortality",
    "SpawningStockBiomass"
  )

  # call webservices, built as: get<types>Graph
  out <-
    sapply(
      types,
      function(x) {
        do.call(sprintf("get%sGraph", x),
          args = list(assessmentKey = assessmentKey)
        )
      },
      simplify = FALSE
    )

  nulls <- which(sapply(out, is.null))
  empty <- list(array(0, c(641, 1152, 4)))
  class(empty) <- "ices_standardgraph_list"
  for (i in nulls) {
    out[[i]] <- empty
  }
  out <- simplify2array(out)

  # set class
  class(out) <- c("ices_standardgraph_list", class(out))

  # return
  out
}
