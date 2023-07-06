#' Get Details on SAG Charts and Settings
#'
#' List all possible chart settings for each chart type (0 = general, 1 = Landings etc.).
#'
#' @param SAGChartKey the type identifier of the SAG chart, e.g. 0, 1, 2, ...
#' @param camel.case should the column names be capitalized like previous
#'                versions of icesSAG, or use the new camelCase.
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
getSAGTypeGraphs <- function(camel.case = getOption("icesSAG.camelCase")) {
  out <- ices_get(sag_api("SAGTypeCharts"), use_token = TRUE)

  if (!camel.case) {
    # change case of output
    names(out) <- firstCap(names(out))
  }

  out
}

#' @rdname getSAGSettings
#' @export
getSAGTypeSettings <- function(SAGChartKey, camel.case = getOption("icesSAG.camelCase")) {
  out <- ices_get(sag_api("SettingsForChartType", SAGChartKey = SAGChartKey), use_token = TRUE)

  if (!camel.case) {
    # change case of output
    names(out) <- firstCap(names(out))
  }

  out
}
