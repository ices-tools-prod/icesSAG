#' Upload new or updated fish stock assessment results
#'
#' Get summary results of historical stock size, recruitment, and fishing
#' pressure.
#'
#' @param info a list of stock information
#' @param fishdata a data.frame of fish data
#'
#' @return the database key of the new / updated stock, or 0 if there was an error.
#'
#' @seealso
#' \code{\link{stockInfo}} creates a list of stock information.
#'
#' \code{\link{stockFishdata}} creates a data.frame of fish stock summary data.
#'
#' @author Colin Millar.
#'
#'
#' @export

uploadStock <- function(info, fishdata) {

  # check that token is set
  opts <- options(icesSAG.use_token = TRUE)
  on.exit(options(opts))

  # convert info and fishdata to xml format
  stkxml <- createSAGxml(info, fishdata)

  # write to online location to pass to DATSU
  file <- uploadXMLFile(stkxml)
  #message(file)
  file <- gsub("http[s]://", "", file)

  # upload to DATSU and check file is formatted correctly
  uri <- sprintf("http://datsu.ices.dk/DatsuRest/api/ScreenFile/%s/%s/SAG",
                 gsub("/", "!", utils::URLencode(file)),
                 utils::URLencode(info$ContactPerson, reserved = TRUE))
  # need some ewrror trapping here
  datsu_resp <- httr::GET(uri)
  datsu_resp <- httr::content(datsu_resp)

  message("View results at: \n\thttps://", getOption("icesSAG.hostname"), "/manage/viewScreenResult.aspx?SessionID=",
          datsu_resp$SessionID)

  if (datsu_resp$NoErrors != -1) {
    stop(" Errors were found in the upload.  See\n\t http://", datsu_resp$ScreenResultURL, "\n\tfor details")
  }

  # call webservice for all supplied keys
  out <- sag_webservice("uploadStock", strSessionID = datsu_resp$SessionID)

  if (out[[1]] == 0) {
    stop("there was a problem uploading the file, please do something ...")
  }

  # parse and return
  simplify(unlist(out))
}
