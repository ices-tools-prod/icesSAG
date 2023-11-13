#' Build a DATSU web service url
#'
#' utility to build a url with optional query arguments
#'
#' @param service the name of the service
#' @param ... name arguments will be added as queries
#'
#' @return a complete url as a character string
#'
#' @examples
#'
#' sag_api("hi", bye = 21)
#' sag_api("StockList", year = 2021)
#'
#' @export
#' @importFrom httr parse_url build_url GET
sag_api <- function(service, ...) {
  url <- paste0(api_url(), "/", service)
  url <- parse_url(url)
  url$query <- list(...)
  url <- build_url(url)

  url
}
