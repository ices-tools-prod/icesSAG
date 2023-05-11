#' Create and read the SAG XML data transfer file
#'
#' Convert between R data (a list and a data.frame) and the XML format required for uploading
#' data to the SAG database.
#'
#' @param file an xml file name
#' @param info a list of stock information
#' @param fishdata a data frame of fish data
#'
#' @return Either a list containing info and fishdata, or a string containing the xml file.
#'
#' @seealso
#' \code{\link{stockInfo}} creates a list of stock information.
#'
#' \code{\link{stockFishdata}} creates a data frame of fish stock summary data.
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
createSAGxml <- function(info, fishdata) {

  # quick fix! Purpose must always be supplied
  if (is.na(info$Purpose)) info$Purpose <- "Advice"

  # handy function to convert a list into an xml row
  list2xml <- function(x, xnames = NULL, sep = "") {
    if (!is.null(xnames)) {
      names(x) <- rep(xnames, length = length(x))
    }
    out <-
      paste(paste0("<", names(x), ">"),
      sapply(x, formatC, format = "fg"),
      paste0("</", names(x), ">"),
      collapse = "\r\n", sep = sep)
    gsub(">NA</", "></", out)
  }

  # head plus top level node
  header <- paste("<?xml version='1.0' encoding='utf-8' standalone='no'?>",
                  "<?xml-stylesheet type='text/xsl' href='StandrdGraphsStyle.xsl'?>",
                  "<Assessment xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:noNamespaceSchemaLocation='ICES_Standard_Graphs.xsd'>",
                  sep = "\r\n")

  info <- unclass(info)
  info <- info[names(info) %in% validNames("stockInfo")]
  info <- info[!sapply(info, is.na)]

  fishdata <- as.data.frame(fishdata)
  fishdata <- fishdata[names(fishdata) %in% validNames("stockFishdata")]
  fishdata <- fishdata[sapply(fishdata, function(x) !all(is.na(x)))]

  # paste together and return as text
  paste0(header, "\r\n",
         list2xml(info), "\r\n",
         list2xml(apply(fishdata, 1, list2xml), xnames = "Fish_Data", sep = "\r\n"),
         "</Assessment>\r\n")
}


#' @rdname readCreateSAGxml
#' @export
readSAGxml <- function(file) {
  # read in xml file, and convert to list
  out <- xml2::as_list(xml2::read_xml(file))

  sag_parse(out, type = "upload")
}


sag_parseUpload <- function(x) {
  # parse header information
  info <- sag_parseTable(list(x[names(x) != "Fish_Data"]))
  info <- do.call(stockInfo, info)

  # tidy fish data
  fishdata <- sag_parseTable(unname(x[names(x) == "Fish_Data"]))
  fishdata <- do.call(stockFishdata, fishdata)

  list(info = info, fishdata = fishdata)
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
#' @param StockCategory Category of the assessment used (see below)
#' @param Purpose the purpose of the entry, options are "Advice", "Bench",
#'                "InitAdvice", default is "Advice".
#' @param ModelType the type of the model used (see below for links to more information)
#' @param ModelName the name (acronym) of the model used if available
#'                  (see below for links to more information)
#' @param ... additional information, e.g. BMGT, FMSY, RecruitmentAge, ...
#'
#' @return A named sag.list, inheriting from a list, where all names are valid column names in the
#'         SAG database.
#'
#' @author Colin Millar.
#'
#' @seealso
#' Links to the relevant ICES vocabularies list are here
#' StockCode: \url{https://vocab.ices.dk/?ref=357}
#' StockCategory: \url{https://vocab.ices.dk/?ref=1526}
#' Purpose: \url{https://vocab.ices.dk/?ref=1516}
#' ModelType: \url{https://vocab.ices.dk/?ref=1524}
#' ModelName: \url{https://vocab.ices.dk/?ref=1525}
#'
#' Link to the relevant format description is \url{https://datsu.ices.dk/web/selRep.aspx?Dataset=126}
#'
#' @examples
#' info <-
#'   stockInfo(StockCode = "cod.27.47d20",
#'             AssessmentYear = 2017,
#'             StockCategory = 1,
#'             ModelType = "A",
#'             ModelName = "SCA",
#'             ContactPerson = "itsme@fisheries.com")
#'
#'  info
#'  info$mistake <- "oops"
#'  info
#'  # should have gotten a warning message
#'
#'  \dontrun{
#'  # use icesVocab to list valid codes etc.
#'  library(icesVocab)
#'  # print the list of valid stock codes
#'  stock.codes <- getCodeList("ICES_StockCode")
#'  stock.codes[1:10,1:2]
#'
#'  # print the list of assessment model types in the ICES vocabulary
#'  model.types <- getCodeList("AssessmentModelType")
#'  model.types[1:2]
#'
#'  # print the list of assessment model names in the ICES vocabulary
#'  model.names <- getCodeList("AssessmentModelName")
#'  model.names$Key
#'  }
#' @export

stockInfo <- function(StockCode, AssessmentYear, ContactPerson, StockCategory,
                      Purpose = "Advice", ModelType, ModelName, ...) {
  # create default info list
  val <- c(list(StockCode = StockCode,
                AssessmentYear = AssessmentYear,
                ContactPerson = ContactPerson,
                StockCategory = StockCategory,
                Purpose = Purpose,
                ModelType = ModelType,
                ModelName = ModelName
                ),
           list(...))
  # warn about possibly misspelt names?
  if (any(!names(val) %in% validNames("stockInfo"))) {
    warning("The following argument(s) are invalid and will be ignored:\n",
         utils::capture.output(noquote(names(val))[!names(val) %in% validNames("stockInfo")]),
         "\n")
  }
  val$NameSystemProducedFile <- paste("icesSAG R package version", utils::packageVersion("icesSAG"))
  val <- val[names(val) %in% validNames("stockInfo")]
  # add all relavent names to help with intelisense
  extra_cols <- setdiff(validNames("stockInfo"), names(val))
  val_extra <- lapply(seq_len(length(extra_cols)), function(x) NA)
  names(val_extra) <- extra_cols
  val <- c(val, val_extra)
  # reorder
  val <- val[validNames("stockInfo")]
  class(val) <- c("sag.list", class(val))
  val
}


#' @export
print.sag.list <- function(x, digits = NULL, quote = TRUE, right = FALSE, ...) {
  # warn about possibly misspelt names?
  if (any(!names(x) %in% validNames("stockInfo"))) {
    warning("The following entries(s) are invalid and will be ignored on upload:\n",
         utils::capture.output(noquote(names(x))[!names(x) %in% validNames("stockInfo")]),
         "\n", call. = FALSE)
  }
  x <- unclass(x)
  x <- x[names(x) %in% validNames("stockInfo")]
  x <- x[!sapply(x, is.na)]
  # call print.data.frame
  print.default(x, digits = digits, quote = quote, right = right, ...)
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
  # create default data.frame
  val <- c(list(Year = Year), list(...))
  # warn about possibly misspelt names?
  if (any(!names(val) %in% validNames("stockFishdata"))) {
    warning("The following argument(s) are invalid and will be ignored:\n",
         utils::capture.output(noquote(names(val))[!names(val) %in% validNames("stockFishdata")]),
         "\n")
  }
  val <- val[names(val) %in% validNames("stockFishdata")]
  val$stringsAsFactors <- FALSE
  val <- do.call(data.frame, val)
  val[setdiff(validNames("stockFishdata"), names(val))] <- NA
  class(val) <- c("sag.data.frame", class(val))
  val
}

#' @export
print.sag.data.frame <- function(x, ..., digits = NULL, quote = FALSE,
                              right = TRUE, row.names = TRUE) {
  # warn about possibly misspelt names?
  if (any(!names(x) %in% validNames("stockFishdata"))) {
    warning("The following column(s) are invalid and will be ignored on upload:\n",
         utils::capture.output(noquote(names(x))[!names(x) %in% validNames("stockFishdata")]),
         "\n", call. = FALSE)
  }
  x <- as.data.frame(x)
  x <- x[names(x) %in% validNames("stockFishdata")]
  x <- x[sapply(x, function(x) !all(is.na(x)))]
  # call print.data.frame
  print.data.frame(x, ..., digits = digits, quote = quote, right = right, row.names = row.names)
}


validNames <- function(type = c("stockInfo", "stockFishdata")) {
  # taken from:
  # http://datsu.ices.dk/web/selRep.aspx?Dataset=126
  switch(type,
    stockInfo =
      c("StockCode",
      "AssessmentYear",
      "StockCategory",
      "BMGT_lower",
      "BMGT",
      "BMGT_upper",
      "BMGTrange_low",
      "BMGTrange_high",
      "FMGTrange_low",
      "FMGTrange_high",
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
      "Flength",
      "RecruitmentLength",
      "CatchesLandingsUnits",
      "ConfidenceIntervalDefinition",
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
      paste0("CustomSeriesUnits", 1:20),
      "Purpose",
      "ModelType",
      "ModelName"),
    stockFishdata =
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
      ))
}


checkStockInfo <- function(info) {
  errors <- list()
  # check Stock Code
  x <- icesVocab::findCode("ICES_StockCode", info$StockCode, full = TRUE)
  if (length(x) == 0) {
    part1 <- paste(strsplit(info$StockCode, "[.]")[[1]][1:2], collapse = ".")
    maybe <- icesVocab::findCode("ICES_StockCode", part1)$ICES_StockCode
    maybe <- sapply(strsplit(maybe, "[.]"), "[", 3)
    ending <- strsplit(info$StockCode, "[.]")[[1]][3]
    ending <- strsplit(ending, "")[[1]]
    loc1 <- grep("[1-9]", ending)
    loc2 <- c(loc1[-1] - 1, length(ending))
    ending <- sapply(seq_len(length(loc1)), function(i) paste(ending[loc1[i]:loc2[i]], collapse = ""))
    maybeid <- unique(unlist(sapply(ending, grep, x = maybe)))
    errors$StockCode <-
      paste0("non valid stock code (",
             info$StockCode,
             "). Did you mean on of these: ",
             paste(part1, maybe[maybeid], sep = ".", collapse = ", "), "?")
  }


  # return
  if (length(errors)) {
    errors <- c(errors = length(errors), errors)
  } else {
    errors <- c(errors = 0, errors)
  }
  errors
}

checkStockFishdata <- function(fishdata) {
  errors <- list()

  # checks here
  # None yet!

  # return
  if (length(errors)) {
    errors <- c(errors = length(errors), errors)
  } else {
    errors <- c(errors = 0, errors)
  }
  errors
}
