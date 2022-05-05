#' Find Details on SAG Charts and Settings
#'
#' Provide the settings for a SAG graph given a textual name of
#' the graph.
#'
#' @param SAGChartKey the type identifier of the SAG chart, e.g. 0, 1, 2, ...
#'
#' @return a data frame with SAG chart type IDs and settings IDs.
#'
#' @examples
#' \dontrun{
#' getSAGTypeGraphs()
#'
#' getSAGTypeSettings(0)[-4]
#'
#' key <- findAssessmentKey("cod.27.47d20", 2021)
#' getSAGSettingsForAStock(key[1])
#' }
#' @rdname getSAGSettings
#' @name getSAGGTypegraphsandSettings
NULL

findGraphSettings <- function() {
  chartType <- "recruitment"
  assessmentKey <- 14324
  chartKeys <- getSAGTypeGraphs()

  chartKey <- chartKeys[grepl(tolower(chartType), tolower(chartKeys$ChartName)),]$SAGChartKey

  if (length(chartKey) != 1) {
    message("chartType argument results in more than one chart")
    return(NULL)
  }

  settings <- getSAGSettingsForAStock(assessmentKey)

}
