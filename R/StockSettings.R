#' Get and Set SAG Chart Settings
#'
#' details
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param chartKey the type identifier of the SAG chart, e.g. 0, 1, 2, ...
#' @param settingKey the type identifier of the SAG chart setting, e.g. 0, 1, 2, ...
#' @param settingValue the vale of the setting
#' @param copyNextYear should the settings be copied to next year (TRUE) or not (FALSE)
#' @param ... arguments passed to \code{\link{ices_get}}.
#'
#' @return A data frame with SAG chart type IDs, settings IDs and setting values.
#'
#' @examples
#' \dontrun{
#' assessmentKey <- findAssessmentKey("had.27.46a20", year = 2022)
#'
#' StockSettings(assessmentKey)
#'}
#' @rdname StockSettings
#' @name getsetStockChartSettings
NULL

#' @rdname StockSettings
#' @export
StockSettings <- function(assessmentKey, ...) {
  # call webservice
  out <-
    lapply(
      assessmentKey,
      function(i) {
        ices_get(
          sag_api("StockSettings", assessmentKey = i), ...
        )
      }
    )

  # rbind output
  do.call(rbind, out)
}

#' @rdname StockSettings
#' @export
setStockSettings <- function(assessmentKey, chartKey, settingKey, settingValue, copyNextYear, ...) {
  # call webservice
  old_value <- sag_use_token(TRUE)
  out <-
    ices_get(
      sag_api("setSAGSettingForAStock",
        assessmentKey = assessmentKey,
        chartKey = chartKey, settingKey = settingKey,
        settingValue = settingValue, copyNextYear = copyNextYear
      ),
      ...
    )

  sag_use_token(old_value)

  # parse and return
  invisible(simplify(unlist(out)))
}
