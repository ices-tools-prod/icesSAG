#' Get a Graph of Stock Assessment Output
#'
#' Get a graph of stock assessment output, e.g., historical stock size,
#' recruitment, and fishing pressure.
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
#' @examples
#' assessmentKeys <- findAssessmentKey("had", 2015)
#' landings_img <- getLandingsGraph(assessmentKeys[1])
#' plot(landings_img)
#'
#' landings_plots <- getLandingsGraph(assessmentKeys)
#' plot(landings_plots)
#'
#' @rdname getGraphs
#' @name getStandardAssessmentGraphs
NULL

#' @rdname getGraphs
#' @export
getLandingsGraph <- function(assessmentKey, ...) {

  if (missing(assessmentKey)){
    dots <- list(...)
    if ("key" %in% names(dots)) {
      assessmentKey <- dots$key
      warning("key argument is depreciated, use assessmentKey instead.")
    }
  }

  # get function name as a character
  # NOTE need tail(x, 1) here for when calling as icesSAG::get____(assessmentKey)
  operation <- utils::tail(as.character(match.call()[[1]]), 1)

  # call webservice for all supplied keys
  out <- lapply(assessmentKey, function(i) sag_webservice(operation, assessmentKey = i))

  # parse output
  out <- lapply(out, sag_parseGraph)

  # set class
  class(out) <- c("ices_standardgraph_list", class(out))

  # return
  out
}

#' @rdname getGraphs
#' @export
getRecruitmentGraph <- getLandingsGraph

#' @rdname getGraphs
#' @export
getFishingMortalityGraph <- getLandingsGraph

#' @rdname getGraphs
#' @export
getSpawningStockBiomassGraph <- getLandingsGraph

#' @rdname getGraphs
#' @export
getFishMortality <- getLandingsGraph

#' @rdname getGraphs
#' @export
getstock_recruitment <- getLandingsGraph

#' @rdname getGraphs
#' @export
getYSSB <- getLandingsGraph

#' @rdname getGraphs
#' @export
getSSBHistoricalPerformance <- getLandingsGraph

#' @rdname getGraphs
#' @export
getFishingMortalityHistoricalPerformance <- getLandingsGraph

#' @rdname getGraphs
#' @export
getRecruitmentHistoricalPerformance <- getLandingsGraph

#' @rdname getGraphs
#' @export
getStockStatusTable <- getLandingsGraph
