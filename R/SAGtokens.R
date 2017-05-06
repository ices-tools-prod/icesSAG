
# the sag personal access togen
.sg_renviron <- "~/.Renviron_SG"


getTokenExpiration <- function() {
  # call webservice
  out <- sag_webservice("getTokenExpiration")

  # parse output
  as.numeric(out[[1]])
}


sg_pat <- function() {
  # get value of environment variable SG_PAT
  pat <- Sys.getenv('SG_PAT')
  if (identical(pat, "")) {
    # SAG_PAT environment variable is not set
    while(!file.exists(.sg_renviron) || getTokenExpiration() <= 0) {
      cat("Invalid or missing token. Please browse to:\n",
          "    https://standardgraphs.ices.dk/manage/CreateToken.aspx\n",
          "to create your personal access token.\n",
          "Then create/modify the file:\n\t",
              path.expand(.sg_renviron),
          "\nwith contents:\n\n",
          "# Standard Graphs personal access token\n",
          "SG_PAT=blahblahblahblahblah\n\n",
#          "For more information see ?getTokenExpiration",
          sep = "")
      tmp <- readline("Press return when this is done ...")
      # read environment file
      if (file.exists(.sg_renviron)) readRenviron(.sg_renviron)
    }
    pat <- Sys.getenv('SG_PAT')
  }

  pat
}
