#' Get and Set SAG Chart Settings
#'
#' details
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param chartKey the type identifier of the SAG chart, e.g. 0, 1, 2, ...
#' @param settingKey the type identifier of the SAG chart setting, e.g. 0, 1, 2, ...
#' @param settingValue the vale of the setting
#' @param copyNextYear should the settings be copied to next year (TRUE) or not (FALSE)
#'
#' @return A data frame with SAG chart type IDs, settings IDs and setting values.
#'
#' @examples
#' \donttest{
#' key <- findAssessmentKey("cod.21.1", 2017)
#' graphs <- getSAGGraphs(key[1])
#' plot(graphs)
#' getSAGSettingsForAStock(key [1])
#' chart1 <- getLandingsGraph(key [1])
#' setSAGSettingForAStock(key [2], 1, 1, "Catches of cod.21.1 in 2017",
#' FALSE)
#' setSAGSettingForAStock(key [2], 1, 11, 10,
#' FALSE)
#' plot(chart1)
#' chart2 <- getSpawningStockBiomassGraph(key [1])
#' plot(chart2)
#' setSAGSettingForAStock(key [1], 4, 1, "SSB of cod.21.1 in 2017",
#' FALSE)
#' plot(chart2)
#' }
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
#' @export
setSAGSettingForAStock <- function(assessmentKey, chartKey, settingKey, settingValue, copyNextYear) {
  # call webservice
  out <- sag_webservice("setSAGSettingForAStock",
                        assessmentKey = assessmentKey,
                        chartKey = chartKey, settingKey = settingKey,
                        settingValue = settingValue, copyNextYear = copyNextYear)

  # parse and return
  invisible(simplify(unlist(out)))
}
