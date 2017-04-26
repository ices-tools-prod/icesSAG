

#' @export
getSAGTypeGraphs <- function() {
  # call webservice
  out <- sag_webservice("getSAGTypeGraphs")

  # parse output
  sag_parse(out)
}

#' @export
getSAGTypeSettings <- function(SAGChartKey) {
  # call webservice
  out <- sag_webservice("getSAGTypeSettings", SAGChartKey = SAGChartKey)

  # parse output
  sag_parse(out)
}

#' @export
getSAGSettingsForAStock <- function(assessmentKey) {
  # call webservice
  out <- sag_webservice("getSAGSettingsForAStock", assessmentKey = assessmentKey)

  # parse output
  sag_parse(out)
}

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



#findChartKey <- function()
