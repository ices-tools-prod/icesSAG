

.onLoad <- function(libname, pkgname) {

  # set some default SG options
  opts <-
    c(
      icesSAG.messages = "TRUE",
      icesSAG.use_token = "FALSE",
      icesSAG.hostname = "'sg.ices.dk'",
      icesSAG.camelCase = "FALSE"
    )

  for (i in setdiff(names(opts), names(options()))) {
        eval(parse(text = paste0("options(", i, "=", opts[i], ")")))
  }

  invisible()
}
