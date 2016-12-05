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
#' key <- findKey("cod-scow", 2015)
#' landings_img <- getLandingsGraph(key)
#' plot(landings_img)
#'
#' keys <- findKey("had", 2015)
#'
#' landings_plots <- getLandingsGraph(keys)
#' plot(landings_plots)
#'
#' @export

getLandingsGraph <- function(key) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # get function name as a character
  operation <- tail(as.character(match.call()[[1]]), 1)

  # read text string and parse to data frame
  url <-
    sprintf(
      "http://sg.ices.dk/StandardGraphsWebServices.asmx/%s?key=%i",
      operation, key)

  # read urls
  out <- lapply(url, curlSAG)

  # parse text
  out <- lapply(out, parseGraph)

  # drop any nulls
  out <- out[!sapply(out, is.null)]

  # set class
  class(out) <- c("ices_standardgraph_list", class(out))

  # return
  out
}

#' @export
getRecruitmentGraph <- getLandingsGraph

#' @export
getFishingMortalityGraph <- getLandingsGraph

#' @export
getSpawningStockBiomassGraph <- getLandingsGraph

#' @export
getFishMortality <- getLandingsGraph

#' @export
getstock_recruitment <- getLandingsGraph

#' @export
getYSSB <- getLandingsGraph

#' @export
getSSBHistoricalPerformance <- getLandingsGraph

#' @export
getFishingMortalityHistoricalPerformance <- getLandingsGraph

#' @export
getRecruitmentHistoricalPerformance <- getLandingsGraph

