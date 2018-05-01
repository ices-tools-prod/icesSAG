#' Get Any SAG Data
#'
#' This function combines the functionality of getListStocks,
#' getFishStockReferencePoints, and getSummaryTable.
#' It supports querying many stocks and years in one function call.
#'
#' @param stock a stock name, e.g. cod-347d, or cod to find all cod stocks, or
#'        NULL to process all stocks.
#' @param year the assessment year, e.g. 2015, or 0 to process all years.
#' @param data the data of interest, either "summary" or "refpts".
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
#' @author Arni Magnusson and Colin Millar.
#'
#' @examples
#' \dontrun{
#' summary <- getSAG("cod-347d", 2015)
#' refpts <- getSAG("cod-347d", 2015, "refpts")
#'
#' getSAG("her.27.3a47d", 2017, "refpts", purpose = "Benchmark")
#'
#' cod_summary <- getSAG("cod", 2015)
#' cod_refpts <- getSAG("cod", 2015:2016, "refpts")
#' }
#' @export

getSAG <- function(stock, year, data = "summary", combine = TRUE, purpose = "Advice") {
  # select web service operation and parser
  data <- match.arg(data, c("summary", "refpts"))
  service <- switch(data,
                    summary = "getSummaryTable",
                    refpts = "getFishStockReferencePoints")

  # find lookup key
  assessmentKey <- findAssessmentKey(stock, year, regex = TRUE, full = FALSE)

  # get data requested by user
  out <- do.call(service, list(assessmentKey = assessmentKey))

  # drop any null entries (happens when not published stocks creep in)
  out <- out[!sapply(out, is.null)]

  # combine tables
  if (length(out) > 1 && combine) {
    # form new column names for combined data frame
    outNames <- unique(unlist(lapply(out, names)))

    # rbind, adding in missing columns as characters
    out <-
      do.call(rbind,
        lapply(unname(out), function(x) {
          # are any columns missing?
          missing.cols <- !outNames %in% names(x)
          if (any(missing.cols)) {
            # add on missing columns as characters
            x[outNames[missing.cols]] <- ""
          }
          # reorder columns
          x[outNames]
        }))

    # finally resimplify
    out <- simplify(out)
  } else if (length(out) == 1) {
    out <- out[[1]]
  }

  # return
  out
}
