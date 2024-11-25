#' Get a url
#'
#' Get a url, optionally using an ICES authentication token
#'
#' @param url the url to get.
#' @param retry should the get request be retried if first attempt
#'   fails? default TRUE.
#' @param quiet should all messages be suppressed, default FALSE.
#' @param verbose should verbose output form the http request be
#'   returned? default FALSE.
#' @param content should content be returned, or the full http response?
#'   default TRUE, i.e. content is returned by default.
#' @param use_token should an authentication token be sent with the
#'   request? default is the value of the option icesSAG.use_token.
#'
#' @return content or an http response.
#'
#' @seealso
#' \code{\link{sag_api}} builds a SAG web service url.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' sag_get(sag_api("StockList", year = 2022))
#' }
#' @export
#'
#' @importFrom icesConnect ices_get
#' @importFrom httr content
sag_get <- function(url, retry = TRUE, quiet = !getOption("icesSAG.messages"), verbose = FALSE, content = TRUE, use_token = getOption("icesSAG.use_token")) {
  ices_get(url, retry, quiet, verbose, content, use_token)
}

#' @describeIn sag_get cached version of sag_get
sag_get_cached <- sag_get
