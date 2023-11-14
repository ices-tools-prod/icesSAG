api_url <- function() {
  "https://sag.ices.dk/SAG_API/api"
}

#' @importFrom icesConnect ices_post_jwt
ices_post <- function(url, body = list(), retry = TRUE, verbose = FALSE, use_token = FALSE) {
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
