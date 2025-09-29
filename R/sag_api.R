#' Build a SAG web service url
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
#' @importFrom curl curl_parse_url
#' @importFrom curl curl_escape
sag_api <- function(service, ...) {

  url <- paste0(api_url(), "/", service)

  dots <- list(...)
  dots <- dots[sapply(dots, length) > 0]

  if (length(dots)) {
    names <- curl_escape(names(dots))
    values <- vapply(dots, curl_escape, character(1))
    query <- paste0(names, "=", values, collapse = "&")
  } else {
    query <- NULL
  }

  if (!is.null(query) && nzchar(query)) {
    stopifnot(is.character(query), length(query) == 1)
    query <- paste0("?", query)
  }

  paste0(url, query)
}


api_url <- function() {
  "https://sag.ices.dk/SAG_API/api"
}

api_documentation <- function() {
  "https://sag.ices.dk/sag_api/docs/swagger/index.html"
}
