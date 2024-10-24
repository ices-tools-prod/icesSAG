
#' @importFrom memoise memoise
#' @importFrom cachem cache_mem
#' @importFrom rlang hash

# Expire items in cache after 15 minutes
getcache <- cachem::cache_mem(max_age = 15 * 60)

.onLoad <- function(libname, pkgname) {

  # set functions to use caching
  ices_get_cached <<-
    memoise::memoise(
      ices_get_cached,
      cache = getcache,
      hash = function(x) hash(paste0(x$url, getOption("icesSAG.use_token")))
    )

  # set some default options
  opts <-
    c(
      icesSAG.messages = "TRUE",
      icesSAG.use_token = "FALSE"
    )

  for (i in setdiff(names(opts), names(options()))) {
        eval(parse(text = paste0("options(", i, "=", opts[i], ")")))
  }

  invisible()
}
