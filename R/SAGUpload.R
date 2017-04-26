
#' @export
stockInfo <- function(StockCode, AssessmentYear, ContactPerson, ...) {
  # create default info list
  validNames <-
    c("StockCode",
      "AssessmentYear",
      "StockCategory",
      "BMGT_lower",
      "BMGT",
      "BMGT_upper",
      "FMGT_lower",
      "FMGT",
      "FMGT_upper",
      "HRMGT",
      "MSYBtrigger",
      "FMSY",
      "MSYBesc",
      "Fcap",
      "Blim",
      "Bpa",
      "Flim",
      "Fpa",
      "Fage",
      "RecruitmentAge",
      "CatchesLandingsUnits",
      "RecruitmentDescription",
      "RecruitmentUnits",
      "FishingPressureDescription",
      "FishingPressureUnits",
      "StockSizeDescription",
      "StockSizeUnits",
      "NameSystemProducedFile",
      "ContactPerson",
      paste0("CustomLimitValue", 1:5),
      paste0("CustomLimitName", 1:5),
      paste0("CustomLimitNotes", 1:5),
      paste0("CustomSeriesName", 1:20),
      paste0("CustomSeriesUnits", 1:20))

  val <- c(list(StockCode = StockCode,
                AssessmentYear = AssessmentYear,
                ContactPerson = ContactPerson),
           list(...))
  # warn about possibly misspelt names?
  if (any(!names(val) %in% validNames)) {
    stop("The following argument(s) are invalid:\n",
         utils::capture.output(noquote(names(val))[!names(val) %in% validNames]),
         "\n")
  }
  val$NameSystemProducedFile <- "icesSAG R package"
  val[names(val) %in% validNames]
}



#' @export
stockFishdata <- function(Year, ...) {
  # create default info list
  # http://dome.ices.dk/datsu/selRep.aspx?Dataset=126
  validnames <-
    c("Year",
      "Low_Recruitment",
      "Recruitment",
      "High_Recruitment",
      "Low_TBiomass",
      "TBiomass",
      "High_TBiomass",
      "Low_StockSize",
      "StockSize",
      "High_StockSize",
      "Catches",
      "Landings",
      "LandingsBMS",
      "Discards",
      "LogbookRegisteredDiscards",
      "IBC",
      "Unallocated_Removals",
      "Low_FishingPressure",
      "FishingPressure",
      "High_FishingPressure",
      "FishingPressure_Landings",
      "FishingPressure_Discards",
      "FishingPressure_IBC",
      "FishingPressure_Unallocated",
      paste0("CustomSeries", 1:20)
   )

  val <- c(list(Year = Year), list(...))
  # warn about possibly misspelt names?
  if (any(!names(val) %in% validnames)) {
    stop("The following argument(s) are invalid:\n",
         utils::capture.output(noquote(names(val))[!names(val) %in% validnames]),
         "\n")
  }
  val <- val[names(val) %in% validnames]
  val$stringsAsFactors <- FALSE
  do.call(data.frame, val)
}





#' @export
readSAGxml <- function(file) {
  # read in xml file, and convert to list
  out <- xml2::as_list(xml2::read_xml(file))

  sag_parse(out, type = "upload")
}



#' @export
createSAGxml <- function(info, fishdata) {
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
