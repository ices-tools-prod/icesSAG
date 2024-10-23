
#' export
sag_use_token <- function(value) {
  old_value <- getOption("icesSAG.use_token")
  options(icesSAG.use_token = identical(value, TRUE))

  invisible(old_value)
}

#' export
sag_messages <- function(value) {
  old_value <- getOption("icesSAG.messages")
  options(icesSAG.messages = identical(value, TRUE))

  invisible(old_value)
}


#' @importFrom utils type.convert
sag_clean <- function(x, keep_html = FALSE) {
  x <- as.matrix(x)
  mode(x) <- "character"

  if (!keep_html) {
    # remove any html tags - this can happen in the SAG graph settings entries!
    x[] <- gsub("<.*?>", "", x)
  }

  # trim white space
  x[] <- trimws(x)

  # SAG uses "" and "NA" to indicate NA
  x[x %in% c("", "NA", "na")] <- NA

  # make into a data.frame
  x <- as.data.frame(x, stringsAsFactors = FALSE)

  type.convert(x, as.is = TRUE)
}
