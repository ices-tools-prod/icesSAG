#' Post to a url
#'
#' Post to a url using an ICES authentication token
#'
#' @param url the url to get.
#' @param body a list of named arguments to be sent as the body of the
#'   post request.
#' @param retry should the get request be retried if first attempt
#'   fails? default TRUE.
#' @param verbose should verbose output form the http request be
#'   returned? default FALSE.
#' @param use_token should an authentication token be sent with the
#'   request? default is TRUE.
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
#' ices_get(sag_api("StockList", year = 2022))
#' }
#' @export
#'
#' @importFrom icesConnect ices_post_jwt
ices_post <- function(url, body = list(), retry = TRUE, verbose = FALSE, use_token = TRUE) {
  out <-
    ices_post_jwt(
      url,
      body,
      encode = "multipart",
      retry = retry,
      verbose = verbose,
      jwt = if (use_token) NULL else ""
    )

  return(out)
}
