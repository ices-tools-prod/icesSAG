#' Upload New or Updated Fish Stock Assessment Results
#'
#' Get summary results of historical stock size, recruitment, and fishing
#' pressure.
#'
#' @param file the xml file to check and upload
#' @param upload should the file be uploaded to the database? Default is FALSE.
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
#' @examples
#' \dontrun{
#' info <-
#' stockInfo(
#'   StockCode = "whb-comb",
#'   AssessmentYear = 1996,
#'   ContactPerson = "its_me@somewhere.gov",
#'   StockCategory = 3,
#'   Purpose = "InitAdvice",
#'   ModelType = "A",
#'   ModelName = "XSA"
#' )
#' fishdata <- stockFishdata(1950:1996)

#' # simulate some landings for something a bit intesting
#' set.seed(1232)
#' fishdata$Landings <- 10^6 * exp(cumsum(cumsum(rnorm(nrow(fishdata), 0, 0.1))))
#'
#' # You should write out to an xml file and then upload that file
#' tempfile <- tempfile(fileext = ".xml")
#' writeSAGxml(info, fishdata, file = tempfile)
#'
#' # you can check the file is formatted correctly
#' uploadStock(tempfile, upload = FALSE)
#'
#' # and if all checks pass, the file can be uploaded
#' uploadStock(tempfile, upload = TRUE)
#' }
#'
#'
#' @importFrom icesDatsu getScreeningSessionMessages uploadDatsuFile
#' @export
uploadStock <- function(file, upload = FALSE, verbose = FALSE) {

  if (!is.character(file) || length(file) != 1) {
    stop("file must be a single character string")
  }

  if (!file.exists(file)) {
    stop("File does not exist: ", file)
  }

  sagmessage <- function(...) {
    message(..., appendLF = FALSE)
  }
  done <- function() message("Done")

  # check that token is set
  opts <- options(icesSAG.use_token = TRUE)
  on.exit(options(opts))

  # upload to DATSU and check file is formatted correctly
  sagmessage("Screening file           ... ")
  datsu_resp <- suppressMessages(uploadDatsuFile(file, 126))

  errors <- suppressMessages(getScreeningSessionMessages(datsu_resp))

  if (is.data.frame(errors)) {
    warning(" Errors were found in the upload.  See\n\t https://datsu.ices.dk/web/ScreenResult.aspx?sessionid=", datsu_resp, "\n\tfor details")
    return(errors)
  } else {
    sagmessage(" No errors found :)")
  }

  if (upload) {
    # call upload service
    message("Importing to database    ... ", appendLF = getOption("icesSAG.messages"))

    out <- sag_post(
      sag_api("uploadStock", sessionId = datsu_resp)
    )

    if (getOption("icesSAG.messages")) {
      message("                         ... Done")
    } else {
      done()
    }

    xml <- readSAGxml(file)
    assessmentKey <- type.convert(unlist(out), as.is = TRUE)
    message("Upload complete! New assessmentKey is: ", assessmentKey)
    message(
      sprintf(
        "To check upload run (with 'options(icesSAG.use_token = TRUE)'): \n  findAssessmentKey('%s', %s, full = TRUE)",
        xml$info$StockCode,
        xml$info$AssessmentYear
      )
    )

    message(
      "To view on sag.ices.dk:\n",
      sprintf(
        "browseURL('https://standardgraphs.ices.dk/manage/ViewGraphsAndTables.aspx?key=%s')",
        assessmentKey
      )
    )

    assessmentKey
  }
}
