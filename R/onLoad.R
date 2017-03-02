

.onLoad <- function(libname, pkgname) {
  # load standard graphs token
  if (file.exists(.sg_renviron)) {
    readRenviron(.sg_renviron)
  }

  # set some SG options
  opts <-
    c(icesSAG.messages = "TRUE",
      icesSAG.use_token = "FALSE",
      icesSAG.hostname = "'sg.ices.dk'")
  for (i in setdiff(names(opts), names(options()))) {
        eval(parse(text = paste0("options(", i, "=", opts[i], ")")))
  }

  invisible()
}
