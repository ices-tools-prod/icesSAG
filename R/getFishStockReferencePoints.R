#' Get Reference Points
#'
#' Get biological reference points for all stocks in a given assessment year.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param camel.case should the column names be capitalized like previous
#'                versions of icesSAG, or use the new camelCase.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSAG}} supports querying many years and quarters in one
#'   function call.
#'
#' \code{\link{getListStocks}} and \code{\link{getSummaryTable}} get a list of
#'   stocks and summary results.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' \dontrun{
#' assessmentKey <- findAssessmentKey("cod-2224", year = 2016)
#' refpts <- getFishStockReferencePoints(assessmentKey)
#' refpts
#'
#' #To get all reference points in a given assessment year:
#' keys2016 <- findAssessmentKey(year = 2016)
#' refpts2016 <- getFishStockReferencePoints(keys2016)
#' refpts2016
#' }
#' @export

getFishStockReferencePoints <- function(assessmentKey, camel.case = getOption("icesSAG.camelCase")) {

  # call webservice for all supplied years
  out <-
    lapply(
      assessmentKey,
      function(i) {
        ices_get(
          sag_api("FishStockReferencePoints", assessmentKey = i),
          use_token = getOption("icesSAG.use_token")
        )
      }
    )

  # combine output
  out <- do.call(rbind, out)

  if (!camel.case) {
    # change case of output
    names(out) <- firstCap(names(out))
  }

  out
}
