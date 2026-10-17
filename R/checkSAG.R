#' Check stock data before writing the SAG upload file
#'
#' Checks the stock information, yearly results and retrospective bias record
#' against the ICES vocabularies (using \pkg{icesVocab}) and against the checks
#' applied by DATSU and the SAG Excel template.
#'
#' Vocabulary checks need an internet connection.  If a vocabulary cannot be
#' downloaded, a warning is given and that check is skipped.
#'
#' @param info a list of stock information, see \code{\link{stockInfo}}.
#' @param fishdata a data frame of yearly results, see \code{\link{stockFishdata}}.
#' @param retrobias a list of retrospective bias information, see
#'                  \code{\link{stockRetroBias}}, or NULL.
#'
#' @return a list with two character vectors: \code{errors} and \code{warnings}.
#'
#' @seealso
#' \code{\link{writeSAGxml}} runs these checks before writing the file.
#'
#' @examples
#' \dontrun{
#' info <- stockInfo(
#'   StockCode = "aru.27.5b6a", AssessmentYear = 2026, StockCategory = 1,
#'   ModelType = "A", ModelName = "SAM", ContactPerson = "itsme@fisheries.com"
#' )
#' fishdata <- stockFishdata(Year = 1990:2025, Catches = 100)
#' checkSAG(info, fishdata)
#' }
#' @export
checkSAG <- function(info, fishdata, retrobias = NULL) {
  info <- do.call(stockInfo, unclass(info))
  fishdata <- as.data.frame(do.call(stockFishdata, as.list(fishdata)))

  errors <- character(0)
  warnings <- character(0)
  addError <- function(...) errors <<- c(errors, paste0(...))
  addWarning <- function(...) warnings <<- c(warnings, paste0(...))

  hasData <- function(cols) any(!is.na(as.matrix(fishdata[cols])))
  isBlank <- function(x) length(x) != 1 || is.na(x) || !nzchar(trimws(as.character(x)))

  # ---- vocabularies ----
  vocabFields <- c(
    StockCode = "ICES_StockCode",
    StockCategory = "StockCategory",
    Purpose = "AssessmentPurpose",
    ModelType = "AssessmentModelType",
    ModelName = "AssessmentModelName",
    CatchesLandingsUnits = "MUNIT",
    RecruitmentUnits = "MUNIT",
    FishingPressureUnits = "MUNIT",
    StockSizeUnits = "MUNIT",
    stats::setNames(rep("StockDataType", 20), paste0("CustomSeriesType", 1:20)),
    stats::setNames(rep("MUNIT", 20), paste0("CustomSeriesUnits", 1:20))
  )
  for (field in names(vocabFields)) {
    value <- info[[field]]
    if (isBlank(value)) next
    keys <- sag_vocab_keys(vocabFields[[field]])
    if (is.null(keys)) {
      addWarning(
        "could not download the ", vocabFields[[field]],
        " vocabulary, ", field, " was not checked"
      )
    } else if (!trimws(as.character(value)) %in% keys) {
      addError(
        field, " '", value, "' is not a valid code in the ICES ",
        vocabFields[[field]], " vocabulary"
      )
    }
  }

  # ---- assessment year ----
  if (!isBlank(info$AssessmentYear) &&
      as.numeric(info$AssessmentYear) > as.numeric(format(Sys.Date(), "%Y"))) {
    addError("AssessmentYear (", info$AssessmentYear, ") is later than the present year")
  }

  # ---- confidence intervals ----
  ciCols <- grep("^(Low|High)_", names(fishdata), value = TRUE)
  if (hasData(ciCols) && isBlank(info$ConfidenceIntervalDefinition)) {
    addError("ConfidenceIntervalDefinition is needed when Low_ / High_ values are given")
  }
  if (!hasData(ciCols) && !isBlank(info$ConfidenceIntervalDefinition)) {
    addWarning("ConfidenceIntervalDefinition is given but there are no Low_ / High_ values")
  }

  # ---- descriptions and units of the standard series ----
  if (hasData("Recruitment")) {
    if (isBlank(info$RecruitmentDescription)) addError("RecruitmentDescription is needed when Recruitment is given")
    if (isBlank(info$RecruitmentUnits)) addError("RecruitmentUnits is needed when Recruitment is given")
  }
  if (hasData("StockSize")) {
    if (isBlank(info$StockSizeDescription)) addError("StockSizeDescription is needed when StockSize is given")
    if (isBlank(info$StockSizeUnits)) addError("StockSizeUnits is needed when StockSize is given")
  }
  if (hasData("FishingPressure") && isBlank(info$FishingPressureDescription)) {
    addError("FishingPressureDescription is needed when FishingPressure is given")
  }
  catchCols <- c(
    "Catches", "Landings", "LandingsBMS", "Discards",
    "LogbookRegisteredDiscards", "IBC", "Unallocated_Removals"
  )
  if (hasData(catchCols) && isBlank(info$CatchesLandingsUnits)) {
    addError("CatchesLandingsUnits is needed when catch, landings or discard values are given")
  }

  # ---- custom series ----
  for (i in 1:20) {
    data <- hasData(paste0("CustomSeries", i))
    name <- !isBlank(info[[paste0("CustomSeriesName", i)]])
    if (data && !name) addError("CustomSeries", i, " has data but CustomSeriesName", i, " is empty")
    if (name && !data) addError("CustomSeriesName", i, " is given but CustomSeries", i, " has no data")
    if (data && isBlank(info[[paste0("CustomSeriesType", i)]])) addWarning("CustomSeries", i, " has data but CustomSeriesType", i, " is empty")
    if (data && isBlank(info[[paste0("CustomSeriesUnits", i)]])) addWarning("CustomSeries", i, " has data but CustomSeriesUnits", i, " is empty")
  }

  # ---- retrospective bias ----
  category <- suppressWarnings(floor(as.numeric(info$StockCategory)))
  retroGiven <- !is.null(retrobias) && !all(sapply(retrobias, isBlank))
  if (!is.na(category) && category %in% 1:2 && !retroGiven) {
    addError("the retro-bias record is mandatory for category 1 and 2 stocks, see stockRetroBias()")
  }
  if (retroGiven) {
    for (field in c("SSBrhoYear", "RecruitmentrhoYear")) {
      value <- retrobias[[field]]
      if (!isBlank(value) && !value %in% c("Y", "N")) {
        addError(field, " must be 'Y' or 'N', not '", value, "'")
      }
    }
    for (field in c("Fbarrho", "SSBrho", "Recruitmentrho")) {
      value <- suppressWarnings(as.numeric(retrobias[[field]]))
      if (length(value) == 1 && !is.na(value) && abs(value) > 1) {
        addWarning(field, " is ", value, ", rho should be a decimal, not a percentage")
      }
    }
  }

  list(errors = errors, warnings = warnings)
}

# valid codes for an ICES vocabulary code type, NULL if it cannot be downloaded
sag_vocab_keys <- function(code_type) {
  out <- tryCatch(
    suppressMessages(icesVocab::getCodeList(code_type)),
    error = function(e) NULL
  )
  if (is.null(out) || !is.data.frame(out) || !"Key" %in% names(out)) {
    return(NULL)
  }
  trimws(as.character(out$Key))
}
