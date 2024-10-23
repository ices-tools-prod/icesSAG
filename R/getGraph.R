#' Get a Graph of Stock Assessment Output
#'
#' Get a graph of stock assessment output, e.g., historical stock size,
#' recruitment, and fishing pressure.
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
#' @examples
#' \dontrun{
#' assessmentKeys <- findAssessmentKey("had", 2015)
#' landings_img <- getLandingsGraph(assessmentKeys[1])
#' plot(landings_img)
#'
#' landings_plots <- getLandingsGraph(assessmentKeys)
#' plot(landings_plots)
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
  #type_char <- gsub("get([a-zA-Z]+)Graph", "\\1", operation)

  types <- c(
    getLandingsGraph = 1, getRecruitmentGraph = 2,
    getFishingMortalityGraph = 3, getSpawningStockBiomassGraph = 4,
    getSSBHistoricalPerformance = 10, getFishingMortalityHistoricalPerformance = 11,
    getRecruitmentHistoricalPerformance = 12
  )

  type <- types[operation]

  if (is.na(type)) {
    .Deprecated("contact the package maintainer")
    return(NULL)
  }

  # get file paths for all assessmentKeys
  paths <- get_plot_path(assessmentKey, type)

  # download pngs
  out <- get_image_internal(paths)

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
