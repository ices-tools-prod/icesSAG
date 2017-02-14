
SAG_pat <- function() {
  # get value of environment variable SAG_PAT
  pat <- Sys.getenv('SAG_PAT')
  if (identical(pat, "")) {
    # SAG_PAT environment variable is not set
    set_SAG_pat()
    pat <- Sys.getenv('SAG_PAT')
  }
  
  pat
}

.SAG_eviron_file <- "~/.Renviron_SAG"

set_SAG_pat <- function(pat = NULL) {
  # permanently set the SAG_PAT environment variable

  if (is.null(pat)) { # and is interactive?
    cat("Please browse to:\n",
        "    https://standardgraphs.ices.dk/manage/CreateToken.aspx\n",   
        "to create your personal access token and paste it below",
        sep = "")
    pat <- readline("Token : ")
  }
  
  #
  if (!file.exists(.SAG_eviron_file)) {
    message("Creating .Renviron_SAG file:\n\t",
            path.expand(.SAG_eviron_file))
    file.create(.SAG_eviron_file)
  }
  # add SAG_PAT to .Renviron_SAG
  message("Adding SAG_PAT environment variable to:\n\t",
          path.expand(.SAG_eviron_file))
  cat("# Standard Graphs personal access token\n",
      "SAG_PAT=", pat, "\n",
      file = .SAG_eviron_file, sep = "")
  
  # read environment file
  readRenviron(.SAG_eviron_file)
}





