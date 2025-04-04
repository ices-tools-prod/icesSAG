#' Get Reference Points
#'
#' Get biological reference points for all stocks in a given assessment year.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param ... arguments passed to \code{\link{sag_get}}.
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
#' assessmentKey <- findAssessmentKey("cod.27.21", year = 2023)
#' refpts <- getFishStockReferencePoints(assessmentKey)
#' refpts
#'
#' # To get all reference points in a given assessment year:
#' keys2022 <- findAssessmentKey(year = 2022, full = TRUE)
#' keys2022 <- keys2022[keys2022$Purpose == "Advice",]
#' refpts2022 <- getFishStockReferencePoints(keys2022$AssessmentKey)
#' refpts2022
#' }
#' @export

getFishStockReferencePoints <- function(assessmentKey, ...) {
  # call webservice for all supplied keys
  out <-
    lapply(
      assessmentKey,
      function(i) {
        sag_get(
          sag_api("FishStockReferencePoints", assessmentKey = i), ...
        )
      }
    )

  # parse output
  out <- do.call(rbind, out)

  sag_clean(out)
}
