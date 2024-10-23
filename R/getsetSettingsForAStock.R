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
getSAGSettingsForAStock <- function(assessmentKey, ...) {
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

#' @rdname getsetStockSettings
#' @export
setSAGSettingForAStock <- function(assessmentKey, chartKey, settingKey, settingValue, copyNextYear, ...) {
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
  invisible(type.convert(unlist(out), as.is = TRUE))
}
