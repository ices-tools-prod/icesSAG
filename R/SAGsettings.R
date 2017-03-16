


getSAGTypeGraphs <- function() {
  # call webservice
  out <- sag_webservice("getSAGTypeGraphs")

  # parse output
  sag_parse(out)
}

getSAGTypeSettings <- function(SAGChartKey) {
  # call webservice
  out <- sag_webservice("getSAGTypeSettings", SAGChartKey = SAGChartKey)

  # parse output
  sag_parse(out)
}


getSAGSettingsForAStock <- function(key) {
  # call webservice
  out <- sag_webservice("getSAGSettingsForAStock", key = key)

  # parse output
  if (length(out) == 0) {
    list()
  } else {
    sag_parse(out)
  }
}


setSAGSettingForAStock <- function(key, chartKey, settingKey, settingValue, copyNextYear) {
  # call webservice
  out <- sag_webservice("setSAGSettingForAStock",
                        key = key, chartKey = chartKey, settingKey = settingKey,
                        settingValue = settingValue, copyNextYear = copyNextYear)

  # parse and return
  simplify(unlist(out))
}



#findChartKey <- function()
