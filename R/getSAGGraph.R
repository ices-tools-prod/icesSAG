#' Get a Summary Table of Historical Stock Size
#'
#' Get a summary table of historical stock size, recruitment, and fishing pressure.
#'
#' @param key the unique identifier of the stock assessment
#'
#' @param type the type of plot requested, e.g. "Landings", "Recruitment", ...
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
#' @author Colin Millar and Scott Large.
#'
#' @examples
#' stocklist <- getListStocks(2016)
#' id <- grep("cod-347d", stocklist$FishStockName)
#' stocklist[id,]
#' key <- stocklist$key[id]
#' rec_img <- getSAGGraph(key, type = "Recruitment")
#' plot.new()
#' plot(rec_img)
#'
#' @export

getSAGGraph <- function(key, type) {
  # check web services are running
  if (!checkSAGWebserviceOK()) return (FALSE)

  # check graph type requested
  type <- match.arg(type,
                    c("Landings",
                      "Recruitment",
                      "FishingMortality",
                      "SpawningStockBiomass"))

  # read and parse XML from API
  url <-
    sprintf(
      "http://standardgraphs.ices.dk/StandardGraphsWebServices.asmx/get%sGraph?key=%i",
      type, key)

  out <- curlSAG(url = url)
  out <- parseGraph(out)

  out
}
