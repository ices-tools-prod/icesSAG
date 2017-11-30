
# the sag personal access togen
.sg_renviron <- "~/.Renviron_SG"
.sg_envir <- new.env()
.sg_envir$.sg_tokenOK <- NA

getTokenExpiration <- function() {
  # call webservice
  if (file.exists(.sg_renviron)) readRenviron(.sg_renviron)
  uri <- sag_uri("getTokenExpiration", token = Sys.getenv('SG_PAT'))
  out <- sag_get(uri)

  # parse output
  as.numeric(out[[1]])
}


sg_pat <- function() {

  if (is.na(.sg_envir$.sg_tokenOK)) {
    assign(".sg_tokenOK", getTokenExpiration() > 0, envir = .sg_envir)
  }
  while(!.sg_envir$.sg_tokenOK) {
    cat("Invalid or missing token. Please browse to:\n",
         "    https://standardgraphs.ices.dk/manage/CreateToken.aspx\n",
         "to create your personal access token.\n",
         "Then create/modify the file:\n\t",
             path.expand(.sg_renviron),
         "\nwith contents:\n\n",
         "# Standard Graphs personal access token\n",
         "SG_PAT=blahblahblahblahblah\n\n",
         sep = "")
    tmp <- readline("Press return when this is done ...")
    assign(".sg_tokenOK", getTokenExpiration() > 0, envir = .sg_envir)
  }

  Sys.getenv('SG_PAT')
}

