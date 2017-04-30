#' Get and set SAG chart settings
#'
#' details
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param chartKey the type identifier of the SAG chart, e.g. 0, 1, 2, ...
#' @param settingKey the type identifier of the SAG chart setting, e.g. 0, 1, 2, ...
#' @param settingValue the vale of the setting
#' @param copyNextYear should the settings be copied to next year (TRUE) or not (FALSE)
#'
#' @return a data.frame with SAG chart type IDs, settings IDs and setting values.
#'
#' @examples
#' key <- findAssessmentKey("cod.347d", 2016)
#' getSAGSettingsForAStock(key)
#'
#' @rdname getsetStockSettings
#' @name getsetSAGSettingsForAStock
NULL

#' @rdname getsetStockSettings
#' @export
getSAGSettingsForAStock <- function(assessmentKey) {
  # call webservice
  out <- sag_webservice("getSAGSettingsForAStock", assessmentKey = assessmentKey)

  # parse output
  sag_parse(out)
}

#' @rdname getsetStockSettings
setSAGSettingForAStock <- function(assessmentKey, chartKey, settingKey, settingValue, copyNextYear) {
  # call webservice
  out <- sag_webservice("setSAGSettingForAStock",
                        assessmentKey = assessmentKey,
                        chartKey = chartKey, settingKey = settingKey,
                        settingValue = settingValue, copyNextYear = copyNextYear)

  # parse and return
  invisible(simplify(unlist(out)))
}
