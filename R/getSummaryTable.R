#' Get a Summary Table of Historical Stock Size
#'
#' Get summary results of historical stock size, recruitment, and fishing
#' pressure.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param ... arguments passed to \code{\link{ices_get}}.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSAG}} supports querying many years and quarters in one
#'   function call.
#'
#' \code{\link{StockList}} and \code{\link{FishStockReferencePoints}} get
#'   a list of stocks and reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' \dontrun{
#' assessmentKey <- findAssessmentKey("had.27.46a20", year = 2022)
#' sumtab <- getSummaryTable(assessmentKey)
#' head(sumtab)
#' }
#' @export

getSummaryTable <- function(assessmentKey, ...) {
  # call webservice for all supplied keys

  out <-
    lapply(
      assessmentKey,
      function(i) {
        x <-
          ices_get(
            sag_api("SummaryTable", assessmentKey = i), ...
          )
        # format into a data.frame
        cbind(
          lapply(x[names(x) != "Lines"], function(y) if (is.null(y)) NA else y),
          x$Lines
          )
      }
    )

  # rbind output
  out <- do.call(rbind, out)

  sag_clean(out)
}
