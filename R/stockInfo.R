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
#' StockCode: \url{http://vocab.ices.dk/?ref=357}
#' StockCategory: \url{http://vocab.ices.dk/?ref=1526}
#' Purpose: \url{http://vocab.ices.dk/?ref=1516}
#' ModelType: \url{http://vocab.ices.dk/?ref=1524}
#' ModelName: \url{http://vocab.ices.dk/?ref=1525}
#'
#' Link to the relevant format description is \url{http://datsu.ices.dk/web/selRep.aspx?Dataset=126}
#'
#' @examples
#' info <-
#'   stockInfo(
#'     StockCode = "cod.27.47d20",
#'     AssessmentYear = 2017,
#'     StockCategory = 1,
#'     ModelType = "A",
#'     ModelName = "SCA",
#'     ContactPerson = "itsme@fisheries.com"
#'   )
#'
#' info
#' info$mistake <- "oops"
#' info
#' # should have gotten a warning message
#' \donttest{
#' # use icesVocab to list valid codes etc.
#' library(icesVocab)
#' # print the list of valid stock codes
#' stock.codes <- getCodeList("ICES_StockCode")
#' stock.codes[1:10, 1:2]
#'
#' # print the list of assessment model types in the ICES vocabulary
#' model.types <- getCodeList("AssessmentModelType")
#' model.types[1:2]
#'
#' # print the list of assessment model names in the ICES vocabulary
#' model.names <- getCodeList("AssessmentModelName")
#' model.names$Key
#' }
#' @export

stockInfo <- function(StockCode, AssessmentYear, ContactPerson, StockCategory,
                      Purpose = "Advice", ModelType, ModelName, ...) {
  # create default info list
  val <- c(
    list(
      StockCode = StockCode,
      AssessmentYear = AssessmentYear,
      ContactPerson = ContactPerson,
      Purpose = Purpose
    ),
    list(...)
  )
  # warn about possibly misspelt names?
  if (any(!names(val) %in% validNames("stockInfo"))) {
    warning(
      "The following argument(s) are invalid and will be ignored:\n",
      utils::capture.output(noquote(names(val))[!names(val) %in% validNames("stockInfo")]),
      "\n"
    )
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
