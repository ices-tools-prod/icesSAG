

.onLoad <- function(libname, pkgname) {

  # read environ file
  readRenviron(.sg_renviron)

  # set some default SG options
  opts <-
    c(icesSAG.messages = "TRUE",
      icesSAG.use_token = "FALSE",
      #icesSAG.hostname = "'iistest01/standardgraphs'")
      icesSAG.hostname = "'sg.ices.dk'")

  for (i in setdiff(names(opts), names(options()))) {
        eval(parse(text = paste0("options(", i, "=", opts[i], ")")))
  }

  invisible()
}
