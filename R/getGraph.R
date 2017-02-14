#' Get graphs of stock assessment output
#'
#' Get summary graphs of, e.g., historical stock size, recruitment, and fishing pressure.
#'
#' @param key the unique identifier of the stock assessment
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
#' @examples
#' keys <- findKey("had", 2015)
#' landings_img <- getLandingsGraph(keys[1])
#' plot(landings_img)
#'
#' landings_plots <- getLandingsGraph(keys)
#' plot(landings_plots)
#'
#' @rdname getGraphs
#' @name getStandardAssessmentGraps
NULL

#' @rdname getGraphs
#' @export
getLandingsGraph <- function(key) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # get function name as a character
  # NOTE need tail(x, 1) here for when calling as icesSAG::get____(key)
  operation <- utils::tail(as.character(match.call()[[1]]), 1)

  # read text string and parse to data frame
  url <-
    sprintf(
      "http://sg.ices.dk/StandardGraphsWebServices.asmx/%s?key=%i",
      operation, key)

  # read urls
  out <- lapply(url, readSAG)

  # parse text
  out <- lapply(out, parseGraph)

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

