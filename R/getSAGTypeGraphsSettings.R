#' Get Details on SAG Charts and Settings
#'
#' List all possible chart settings for each chart type (0 = general, 1 = Landings, ...).
#'
#' @param SAGChartKey the type identifier of the SAG chart, e.g. 0, 1, 2, ...
#' @param ... arguments passed to \code{\link{sag_get}}.
#'
#' @return a data frame with SAG chart type IDs and settings IDs.
#'
#' @examples
#' \dontrun{
#' getSAGTypeGraphs()
#'
#' getSAGTypeSettings(0)[-4]
#' }
#' @rdname getSAGSettings
#' @name getSAGGTypegraphsandSettings
NULL

#' @rdname getSAGSettings
#' @export
getSAGTypeGraphs <- function(...) {
  # call webservice
  old_value <- sag_use_token(TRUE)
  out <-
    sag_get_cached(
      sag_api("SAGTypeCharts"), ...
    )

  sag_use_token(old_value)
  out
}

#' @rdname getSAGSettings
#' @export
getSAGTypeSettings <- function(SAGChartKey, ...) {
  # call webservice
  out <-
    sag_get_cached(
      sag_api("SettingsForChartType", SAGChartKey = SAGChartKey), ...
    )

  out
}
