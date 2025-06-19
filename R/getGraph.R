#' Get a Graph of Stock Assessment Output
#'
#' Get a graph of stock assessment output, e.g., historical stock size,
#' recruitment, and fishing pressure.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param ... if using getCustomGraph, the custom_graph argument can be used to specify which custom graph to retrieve (see details)s).
#'
#' @return An array representing a bitmap.
#'
#' @details
#'
#' Some stocks have custom graphs, to access these use the function
#' \code{getCustomGraph(assessmentKey, custom_graph)}
#' where custom_graph is an integer: 1, 2, 3, or 4.
#'
#' @seealso
#' \code{\link{getListStocks}} gets a list of stocks.
#'
#' \code{\link{getFishStockReferencePoints}} gets biological reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' assessmentKeys <- findAssessmentKey("had", 2015)
#' landings_img <- getLandingsGraph(assessmentKeys[1])
#' landings_img
#'
#' landings_plots <- getLandingsGraph(assessmentKeys)
#' landings_plots
#'}
#'
#' @rdname getGraphs
#' @name getStandardAssessmentGraphs
NULL

#' @rdname getGraphs
#' @export
getLandingsGraph <- function(assessmentKey, ...) {
  assessmentKey <- checkKeyArg(assessmentKey = assessmentKey, ...)

  # get function name as a character
  # NOTE need tail(x, 1) here for when calling as icesSAG::get____(assessmentKey)
  operation <- utils::tail(as.character(match.call()[[1]]), 1)
  # type_char <- gsub("get([a-zA-Z]+)Graph", "\\1", operation)

  custom_graph <- list(...)$custom_graph

  types <- c(
    getLandingsGraph = 1, getRecruitmentGraph = 2,
    getFishingMortalityGraph = 3, getSpawningStockBiomassGraph = 4,
    getSSBHistoricalPerformance = 10, getFishingMortalityHistoricalPerformance = 11,
    getRecruitmentHistoricalPerformance = 12,
    getCustomGraph = custom_graph + 14 # custom graph types are 15, 16, 17, and 18
  )

  type <- types[operation]

  if (is.na(type)) {
    .Deprecated("contact the package maintainer")
    return(NULL)
  }

  # get file paths for all assessmentKeys
  paths <- get_plot_path(assessmentKey, type)
  if (!nzchar(paths)) {
    message("No graph available for this assessmentKey and type.")
    return(NULL)
  }

  # download pngs
  out <- vector("list", length = length(paths))
  out[nzchar(paths)] <- get_image_internal(paths[nzchar(paths)])

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

#' @rdname getGraphs
#' @export
getCustomGraph <- getLandingsGraph
