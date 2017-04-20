# #' @export
readSAGUpload <- function(file) {
  # read in xml file, and convert to list
  out <- xml2::as_list(xml2::read_xml(file))

  sag_parse(out, type = "upload")
}



# #' @export
writeSAGUpload <- function(info, fishdata) {
  # handy function to convert a list into an xml row
  list2xml <- function(x, xnames = NULL, sep = "") {
    if (!is.null(xnames)) {
      names(x) <- rep(xnames, length = length(x))
    }
    out <-
      paste(paste0("<", names(x), ">"),
      paste0(x),
      paste0("</", names(x), ">"),
      collapse = "\r\n", sep = sep)
    gsub(">NA</", "></", out)
  }

  # head plus top level node
  header <- paste("<?xml version='1.0' encoding='utf-8' standalone='no'?>",
                  "<?xml-stylesheet type='text/xsl' href='StandrdGraphsStyle.xsl'?>",
                  "<Assessment xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:noNamespaceSchemaLocation='ICES_Standard_Graphs.xsd'>",
                  sep = "\r\n")

  # paste together and return as text
  paste0(header, "\r\n",
         list2xml(info), "\r\n",
         list2xml(apply(fishdata, 1, list2xml), xnames = "Fish_Data", sep = "\r\n"),
         "</Assessment>\r\n")
}

# #' @export
uploadStock <- function(info, fishdata) {

  # convert info and fishdata to xml format
  stkxml <- writeSAGUpload(info, fishdata)

  # write to online location to pass to DATSU
  writeLines(stkxml, con = "S:/test/sag_upload.xml")

  # upload to DATSU and check file is formatted correctly
  file <- "ecosystemdata.ices.dk/download/test/sag_upload.xml"
  uri <- sprintf("http://datsu.ices.dk/DatsuRest/api/ScreenFile/%s/%s/SAG",
                 gsub("/", "!", utils::URLencode(file)),
                 utils::URLencode(info$ContactPerson, reserved = TRUE))
  resp <- httr::GET(uri)
  resp <- httr::content(resp)

  message("View results at: \n\thttps://", getOption("icesSAG.hostname"), "/manage/viewScreenResult.aspx?SessionID=",
          resp$SessionID)

  if (resp$NoErrors != -1) {
    stop(" Errors were found in the upload.  See\n\t http://", resp$ScreenResultURL, "\n\tfor details")
  }

  # call webservice for all supplied keys
  out <- sag_webservice("uploadStock", strSessionID = resp$SessionID)

  if (out[[1]] == 0) {
    stop("there was a problem uploading the file, please do something ...")
  }

  # parse and return
  simplify(unlist(out))
}
