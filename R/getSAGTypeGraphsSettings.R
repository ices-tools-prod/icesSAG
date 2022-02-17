#' Get Details on SAG Charts and Settings
#'
#' List all possible chart settings for each chart type (0 = general, 1 = Landings etc.).
#'
#' @param SAGChartKey the type identifier of the SAG chart, e.g. 0, 1, 2, ...
#'
#' @return a data frame with SAG chart type IDs and settings IDs.
#'
#' @examples
#' \donttest{
#' getSAGTypeGraphs()
#'
#' getSAGTypeSettings(0)[-4]
#' }
#' @rdname getSAGSettings
#' @name getSAGGTypegraphsandSettings
NULL

#' @rdname getSAGSettings
#' @export
getSAGTypeGraphs <- function() {
  # call webservice
  out <- sag_webservice("getSAGTypeGraphs")

  # parse output
  sag_parse(out)
}

#' @rdname getSAGSettings
#' @export
getSAGTypeSettings <- function(SAGChartKey) {
  # call webservice
  out <- sag_webservice("getSAGTypeSettings", SAGChartKey = SAGChartKey)

  # parse output
  sag_parse(out)
}




#findChartKey <- function()
