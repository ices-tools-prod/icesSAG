#' Get Summary Graphs of Stock Assessment Output
#'
#' Get summary graphs of catches, recruitment, fishing pressure, and spawning
#' stock biomass.
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
#' @author Colin Millar and Scott Large.
#'
#' @examples
#' key <- findAssessmentKey("cod", 2015)
#' graphs <- getSAGGraphs(key[1])
#' plot(graphs)
#'
#' @export

getSAGGraphs <- function(AssessmentKey, ...) {

  if (missing(AssessmentKey)){
    dots <- list(...)
    if ("key" %in% names(dots)) {
      AssessmentKey <- dots$key
      warning("key argument is depreciated, use AssessmentKey instead.")
    }
  }

  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # only 1 AssessmentKey can be used
  if (length(AssessmentKey) > 1) {
    AssessmentKey <- AssessmentKey[1]
    warning("AssessmentKey has length > 1 and only the first element will be used")
  }

  # check graph type requested
  types <- c("Landings",
             "Recruitment",
             "FishingMortality",
             "SpawningStockBiomass")

  # read and parse text from API
  url <-
    sprintf(
      "http://sg.ices.dk/StandardGraphsWebServices.asmx/get%sGraph?AssessmentKey=%i",
      types, AssessmentKey)

  # read urls
  out <- lapply(url, readSAG)

  # parse text
  out <- lapply(out, parseGraph)

  # drop NULLs
  out <- out[!sapply(out, is.null)]

  # set class
  class(out) <- c("ices_standardgraph_list", class(out))

  out
}
