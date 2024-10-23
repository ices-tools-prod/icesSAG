#' Get and Set icesSAG package options
#'
#' There are two options of interest, 1) switch on or off the use off
#' authenticated web service calls, and 2) switch on or off the display of
#' messages to the console.
#'
#' @param value TRUE or FALSE
#'
#' @return invisible return of the old value.
#'
#' @examples
#' \dontrun{
#' sag_use_token(TRUE)
#' sag_messages(TRUE)
#' }
#'
#' @rdname setPackageOptions
#' @name setPackageOptions
NULL

#' @rdname setPackageOptions
#' @export
sag_use_token <- function(value) {
  old_value <- getOption("icesSAG.use_token")
  options(icesSAG.use_token = identical(value, TRUE))

  invisible(old_value)
}

#' @rdname setPackageOptions
#' @export
sag_messages <- function(value) {
  old_value <- getOption("icesSAG.messages")
  options(icesSAG.messages = identical(value, TRUE))

  invisible(old_value)
}
