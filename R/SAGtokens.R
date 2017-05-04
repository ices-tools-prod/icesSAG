
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
  if (file.exists(.sg_renviron)) readRenviron(.sg_renviron)
  pat <- Sys.getenv('SG_PAT')
  if (identical(pat, "")) {
    # SAG_PAT environment variable is not set
    set_sg_pat()
    pat <- Sys.getenv('SG_PAT')
  }

  pat
}

set_sg_pat <- function(pat = NULL) {
  # permanently set the SAG_PAT environment variable

  if (is.null(pat)) { # and is interactive?
    cat("Invalid or missing token. Please browse to:\n",
        "    https://standardgraphs.ices.dk/manage/CreateToken.aspx\n",
        "to create your personal access token and paste it below",
        sep = "")
    pat <- readline("Token : ")
  }

  #
  if (!file.exists(.sg_renviron)) {
    message("Creating file:\n\t",
            path.expand(.sg_renviron))
    file.create(.sg_renviron)
  }
  # add SG_PAT to .Renviron_SG
  message("Adding SG_PAT environment variable to:\n\t",
          path.expand(.sg_renviron))
  cat("# Standard Graphs personal access token\n",
      "SG_PAT=", pat, "\n",
      file = .sg_renviron, sep = "")

  # check validity
  check_sg_pat()
}

check_sg_pat <- function() {
  # read environment file
  readRenviron(.sg_renviron)

  # check PAT
  if (getTokenExpiration() <= 0) {
    set_sg_pat()
  }

  invisible(TRUE)
}

