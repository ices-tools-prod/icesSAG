#' Get a Graph of Stock Assessment Output
#'
#' Get a graph of stock assessment output, e.g., historical stock size,
#' recruitment, and fishing pressure.
#'
#' @param AssessmentKey the unique identifier of the stock assessment
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
#' keys <- findAssessmentKey("had", 2015)
#' landings_img <- getLandingsGraph(keys[1])
#' plot(landings_img)
#'
#' landings_plots <- getLandingsGraph(keys)
#' plot(landings_plots)
#'
#' @rdname getGraphs
#' @name getStandardAssessmentGraphs
NULL

#' @rdname getGraphs
#' @export
#' @importFrom utils tail
getLandingsGraph <- function(AssessmentKey, ...) {

  if (missing(AssessmentKey)){
    dots <- list(...)
    if ("key" %in% names(dots)) {
      AssessmentKey <- dots$key
      warning("key argument is depreciated, use AssessmentKey instead.")
    }
  }

  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # get function name as a character
  # NOTE need tail(x, 1) here for when calling as icesSAG::get____(key)
  operation <- tail(as.character(match.call()[[1]]), 1)

  # read text string and parse to data frame
  url <-
    sprintf(
      "http://sg.ices.dk/StandardGraphsWebServices.asmx/%s?AssessmentKey=%i",
      operation, AssessmentKey)

  # read urls
  out <- lapply(url, readSAG)

  # parse text
  out <- lapply(out, parseGraph)

  # drop any nulls
  out <- out[!sapply(out, is.null)]

  # set class
  class(out) <- c("ices_standardgraph_list", class(out))

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

