#' Upload New or Updated Fish Stock Assessment Results
#'
#' Get summary results of historical stock size, recruitment, and fishing
#' pressure.
#'
#' @param info a list of stock information
#' @param fishdata a data.frame of fish data
#' @param verbose if TRUE more verbose messages are reported
#'
#' @return The database key of the new / updated stock, or 0 if there was an error.
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

uploadStock <- function(info, fishdata, verbose = FALSE) {

  sagmessage <- function(...) {
    message(..., appendLF = FALSE)
  }
  done <- function() message("Done")

  # check that token is set
  opts <- options(icesSAG.use_token = TRUE)
  on.exit(options(opts))

  # convert info and fishdata to xml format
  sagmessage("Converting to XML format ... ")
  stkxml <- createSAGxml(info, fishdata)
  done()

  # write to online location to pass to DATSU
  sagmessage("Uploading                ... ")
  file <- uploadXMLFile(stkxml)
  if (verbose)
    message("\tFile location: ", file)
  file <- gsub("http[s]://", "", file)

  # upload to DATSU and check file is formatted correctly
  uri <- sprintf("http://datsu.ices.dk/DatsuRest/api/ScreenFile/%s/%s/SAG",
                 gsub("/", "!", utils::URLencode(file)),
                 utils::URLencode(info$ContactPerson, reserved = TRUE))
  # need some ewrror trapping here
  max_datsu_tries <- 2
  for (datsu_tries in 1:max_datsu_tries) {
    if (datsu_tries > 1) message("trying again (", datsu_tries + 1, " of ", max_datsu_tries, " attempts)")
    sagmessage("Screening file           ... ")
    datsu_resp <- httr::GET(uri)
    message(httr::http_status(datsu_resp)$message)
    if (!httr::http_error(datsu_resp)) break
    # wait and try again
    Sys.sleep(2)
  }
  if (httr::http_error(datsu_resp)) {
    stop("There was a problem with the screening utility.  Check input data, and try again.")
  }
  datsu_resp <- httr::content(datsu_resp)

  if (verbose)
    message("\tResults: http://", datsu_resp$ScreenResultURL)

  if (datsu_resp$NumberOfErrors > 0) {
    stop(" Errors were found in the upload.  See\n\t http://", datsu_resp$ScreenResultURL, "\n\tfor details")
  }

  # call webservice
  message("Importing to database    ... ", appendLF = getOption("icesSAG.messages"))
  out <- sag_webservice("uploadStock", strSessionID = datsu_resp$SessionID)

  if (out[[1]] == 0) {
    stop("there was a problem uploading the file, please do something ...")
  }
  if (getOption("icesSAG.messages")) {
    message("                         ... Done")
  } else {
    done()
  }

  assessmentKey <- simplify(unlist(out))
  message("Upload complete! New assessmentKey is: ", assessmentKey)
  message(sprintf("To check upload run (with 'options(icesSAG.use_token = TRUE)'): \n  findAssessmentKey('%s', %s, full = TRUE)", info$StockCode, info$AssessmentYear))
  #res <- capture.output(findAssessmentKey(info$StockCode, info$AssessmentYear, full = TRUE))
  #message("\n", paste(res, collapse = "\n"))

  assessmentKey
}
