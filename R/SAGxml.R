#' Create and read the SAG XML data transfer file
#'
#' Convert between R data (a list and a data.frame) and the XML format required for uploading
#' data to the SAG database.
#'
#' @param file an xml file name
#' @param info a list of stock information
#' @param fishdata a data.frame of fish data
#'
#' @return either a list contating info and fshdata, or an string containing the xml file.
#'
#' @seealso
#' \code{\link{stockInfo}} creates a list of stock information.
#'
#' \code{\link{stockFishdata}} creates a data.frame of fish stock summary data.
#'
#' @examples
#'
#' info <- stockInfo(StockCode = "cod.27.347d",
#'                   AssessmentYear = 2017,
#'                   ContactPerson = "itsme@fisheries.com")
#' fishdata <- stockFishdata(Year = 1990:2017, Catches = 100)
#' xmlfile <- createSAGxml(info, fishdata)
#'
#' out <- readSAGxml(xmlfile)
#'
#' @rdname readCreateSAGxml
#' @name convertSAGxml
NULL

#' @rdname readCreateSAGxml
#' @export

readSAGxml <- function(file) {
  # read in xml file, and convert to list
  out <- xml2::as_list(xml2::read_xml(file))

  sag_parse(out, type = "upload")
}


#' @rdname readCreateSAGxml
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





#' Create a list of fish stock information
#'
#' This function is a wrapper to \code{list(...)} in which the names are forced to match with
#' the names required for the SAG database.  See http://dome.ices.dk/datsu/selRep.aspx?Dataset=126
#' for more details.
#'
#' @param StockCode a stock name, e.g. cod-347d.
#' @param AssessmentYear the assessment year, e.g. 2015.
#' @param ContactPerson the email for the person responsible for uploading the stock data.
#' @param ... additional information, e.g. BMGT, FMSY, RecruitmentAge, ...
#'
#' @return A named list, where all names are valid column names in the SAG database.
#'
#' @author Colin Millar.
#'
#' @examples
#' stockInfo(StockCode = "cod.27.347d",
#'           AssessmentYear = 2017,
#'           ContactPerson = "itsme@fisheries.com")
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



#' Create a data.frame of fish stock data
#'
#' This function is a wrapper to \code{data.frame(...)} in which the names are forced to match with
#' the names required for the SAG database.  See http://dome.ices.dk/datsu/selRep.aspx?Dataset=126
#' for more details.
#'
#' @param Year a vector of years.
#' @param ... additional information, e.g. Recruitment, StockSize, Landings, ...
#'
#'
#' @return A data.frame, where all names are valid column names in the SAG database.
#'
#' @author Colin Millar.
#'
#' @examples
#' stockFishdata(Year = 1990:2017, Catches = 100)
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
