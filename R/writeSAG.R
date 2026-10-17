#' Create the SAG XML data transfer file
#'
#' Write stock information, yearly results and the retrospective bias record
#' to the XML format required for uploading to the SAG database at
#' \url{https://standardgraphs.ices.dk}.  The layout matches the file
#' produced by the 2026 SAG Excel template.
#'
#' By default the data are checked with \code{\link{checkSAG}} before the file
#' is written.  Errors stop the file being written, warnings are reported.
#'
#' @param info a list of stock information, see \code{\link{stockInfo}}.
#' @param fishdata a data frame of yearly results, see \code{\link{stockFishdata}}.
#' @param retrobias a list of retrospective bias information, see
#'                  \code{\link{stockRetroBias}}.  Mandatory for category 1 and 2 stocks.
#' @param sameRefPoints if TRUE, the reference points from the previous assessment
#'                      are used (equivalent to the "use the same reference points
#'                      as last year" option in the Excel template).
#' @param file the name of the xml file to write.  Defaults to
#'             \code{<StockCode>_<AssessmentYear>.xml}.
#' @param check should the data be checked before writing? Default is TRUE.
#'
#' @return the file name, invisibly.
#'
#' @seealso
#' \code{\link{stockInfo}} creates a list of stock information.
#'
#' \code{\link{stockFishdata}} creates a data frame of fish stock summary data.
#'
#' \code{\link{stockRetroBias}} creates a list of retrospective bias information.
#'
#' \code{\link{checkSAG}} checks the data.
#'
#' @examples
#' \dontrun{
#' info <- stockInfo(
#'   StockCode = "aru.27.5b6a",
#'   AssessmentYear = 2026,
#'   StockCategory = 1,
#'   ModelType = "A",
#'   ModelName = "SAM",
#'   ContactPerson = "itsme@fisheries.com",
#'   CatchesLandingsUnits = "t"
#' )
#' fishdata <- stockFishdata(Year = 1990:2025, Catches = 100)
#' retro <- stockRetroBias(
#'   TerminalYear = 2025, RetroAssessment = 5, Fbarrho = -0.19,
#'   SSBrhoYear = "N", SSBrho = 0.07, RecruitmentrhoYear = "N", Recruitmentrho = 0.04
#' )
#' writeSAGxml(info, fishdata, retro, sameRefPoints = TRUE)
#' }
#'
#' @rdname readWriteSAG
#' @export
writeSAGxml <- function(info, fishdata, retrobias = NULL, sameRefPoints = FALSE,
                        file = NULL, check = TRUE) {
  if (missing(info) || missing(fishdata)) {
    stop("Both info and fishdata must be provided.")
  }

  info <- do.call(stockInfo, unclass(info))
  fishdata <- do.call(stockFishdata, as.list(fishdata))
  if (!is.null(retrobias)) {
    retrobias <- do.call(stockRetroBias, unclass(retrobias))
  }

  if (check) {
    res <- checkSAG(info, fishdata, retrobias)
    if (length(res$warnings)) {
      warning(paste0("\n  ", res$warnings, collapse = ""), call. = FALSE)
    }
    if (length(res$errors)) {
      stop(
        "The file was not written, please fix the following errors:",
        paste0("\n  ", res$errors, collapse = ""),
        call. = FALSE
      )
    }
  }

  if (is.null(file)) {
    file <- paste0(info$StockCode, "_", info$AssessmentYear, ".xml")
  }

  doc <- xml2::read_xml(
    paste0(
      "<?xml version='1.0' encoding='utf-8' standalone='no'?>",
      "<?xml-stylesheet type='text/xsl' href='StandrdGraphsStyle.xsl'?>",
      "<Assessment xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' ",
      "xsi:noNamespaceSchemaLocation='ICES_Standard_Graphs.xsd'/>"
    )
  )

  # stock information
  addValues(doc, unclass(info))

  # yearly results
  fishdata <- as.data.frame(fishdata)[validNames("stockFishdata")]
  for (i in seq_len(nrow(fishdata))) {
    row <- xml2::xml_add_child(doc, "Fish_Data")
    addValues(row, as.list(fishdata[i, , drop = FALSE]))
  }

  # retrospective bias
  if (!is.null(retrobias)) {
    retro <- xml2::xml_add_child(doc, "Assessment_retro-bias")
    addValues(retro, unclass(retrobias))
  }

  # use the reference points from the previous assessment
  if (isTRUE(sameRefPoints)) {
    settings <- xml2::xml_add_child(doc, "Chart_Settings")
    xml2::xml_add_child(settings, "GraphKey", "0")
    xml2::xml_add_child(settings, "SettingKey", "0")
    xml2::xml_add_child(settings, "SettingValue", "yes")
  }

  xml2::write_xml(doc, file, encoding = "utf-8")

  invisible(file)
}

# add one child element per non-missing value in a named list
addValues <- function(node, x) {
  for (nm in names(x)) {
    value <- x[[nm]]
    if (length(value) != 1 || is.na(value) || !nzchar(trimws(as.character(value)))) {
      next
    }
    xml2::xml_add_child(node, nm, formatValue(value))
  }
  invisible(node)
}

# write numbers in full, never in scientific notation
formatValue <- function(x) {
  if (is.numeric(x)) {
    format(x, scientific = FALSE, digits = 15, trim = TRUE)
  } else {
    trimws(as.character(x))
  }
}

#' @rdname readWriteSAG
#' @export
writeSAG <- function(info, fishdata, file = NULL) {
  .Deprecated("writeSAGxml")
  writeSAGxml(info, fishdata, file = file)
}

#' @rdname readWriteSAG
#' @export
readSAGxml <- function(file) {
  # read in ragged csv file....

  NULL
}
