#' Get Details on SAG Charts and Settings
#'
#' List all possible chart settings for each chart type (0 = general, 1 = Landings etc.).
#'
#' @param SAGChartKey the type identifier of the SAG chart, e.g. 0, 1, 2, ...
#' @param ... arguments passed to \code{\link{ices_get}}.
#'
#' @return a data frame with SAG chart type IDs and settings IDs.
#'
#' @examples
#' \dontrun{
#' SAGTypeCharts()
#'
#' SettingsForChartType(0)[-4]
#' }
#' @rdname SAGSettings
#' @name SAGTypeChartsandSettings
NULL

#' @rdname SAGSettings
#' @export
SAGTypeCharts <- function(...) {
  # call webservice
  old_value <- sag_use_token(TRUE)
  out <-
    ices_get_cached(
      sag_api("SAGTypeCharts"), ...
    )

  sag_use_token(old_value)
  out
}

#' @rdname SAGSettings
#' @export
SettingsForChartType <- function(SAGChartKey, ...) {
  # call webservice
  out <-
    ices_get_cached(
      sag_api("SettingsForChartType", SAGChartKey = SAGChartKey), ...
    )

  out
}




# findChartKey <- function()
