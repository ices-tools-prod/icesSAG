#' Get Any SAG Data
#'
#' This function combines the functionality of getListStocks,
#' getFishStockReferencePoints, and getSummaryTable.
#' It supports querying many stocks and years in one function call.
#'
#' @param stock a stock name, e.g. cod-347d, or cod to find all cod stocks, or
#'        NULL to process all stocks.
#' @param year the assessment year, e.g. 2015, or 0 to process all years.
#' @param data the data of interest, either "summary", "refpts" or "source".
#' @param combine whether to combine the list output to a data frame.
#' @param purpose the purpose of the entry, options are "Advice", "Bench",
#'                "InitAdvice", default is "Advice".
#'
#' @note Only years with "Published" status are returned.
#'
#' @return A data frame (default) or a list if \code{combine} is \code{TRUE}.
#'
#' @seealso
#' \code{\link{getListStocks}}, \code{\link{getSummaryTable}}, and
#'   \code{\link{getFishStockReferencePoints}} get a list of stocks, summary
#'   results, and reference points.
#'
#' \code{\link{findAssessmentKey}} finds lookup keys.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' \dontrun{
#' summary <- getSAG("had.27.46a20", 2022)
#' refpts <- getSAG("had.27.46a20", 2022, "refpts")
#'
#' cod_summary <- getSAG("cod", 2022)
#' cod_refpts <- getSAG("cod", 2015:2016, "refpts")
#' cod_data <- getSAG("cod", 2017, "source-data")
#' }
#' @export

getSAG <- function(stock, year, data = "summary", combine = TRUE, purpose = "Advice") {
  # select web service operation
  data <- match.arg(data, c("summary", "refpts", "source-data"))
  service <- switch(data,
                    summary = "getSummaryTable",
                    refpts = "getFishStockReferencePoints",
                    `source-data` = "getStockDownloadData")

  # find lookup key
  assessmentKey <- findAssessmentKey(stock, year, regex = TRUE, full = TRUE)
  assessmentKey <- assessmentKey[assessmentKey$Purpose == purpose,"AssessmentKey"]

  # get data requested by user
  do.call(service, list(assessmentKey = assessmentKey))
}
