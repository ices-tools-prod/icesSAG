#' Get a Summary Table of Historical Stock Size
#'
#' Get summary results of historical stock size, recruitment, and fishing
#' pressure.
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
#' \code{\link{getListStocks}} and \code{\link{getFishStockReferencePoints}} get
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
          sag_get(
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

  # temporary fix, untill webservice is reverted
  new_names <-
    c(
      "Year", "Recruitment", "High_Recruitment", "Low_Recruitment",
      "Low_SSB", "SSB", "High_SSB",
      "Low_F", "F", "High_F",
      "Catches", "Landings", "Discards",
      "IBC", "Unallocated_Removals",
      "LandingsBMS", "TBiomass", "LogbookRegisteredDiscards",
      "StockPublishNote", "Purpose", "FAge",
      "FishStock", "RecruitmentAge", "AssessmentYear",
      "Units", "StockSizeDescription", "StockSizeUnits",
      "FishingPressureDescription", "FishingPressureUnits",
      "AssessmentKey", "AssessmentComponent"
    )

  old_names <-
    c(
      "Year", "recruitment", "high_recruitment", "low_recruitment",
      "low_SSB", "SSB", "high_SSB",
      "low_F", "F", "high_F",
      "catches", "landings", "discards",
      "IBC", "Unallocated_Removals",
      "LandingsBMS", "TBiomass", "LogbookRegisteredDiscards",
      "StockPublishNote", "Purpose", "Fage",
      "fishstock", "recruitment_age", "AssessmentYear",
      "units", "stockSizeDescription", "stockSizeUnits",
      "fishingPressureDescription", "fishingPressureUnits",
      "AssessmentKey", "AssessmentComponent"
    )

  out <- out[new_names]
  names(out) <- old_names

  sag_clean(out)
}
