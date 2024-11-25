#' Get the Custom Columns for SAG records
#'
#' Get custom columns, such as alternative biomass series or Fproxy
#'   reference points for records in the SAG database.
#'
#' @param assessmentKey the unique identifier of the stock assessment
#' @param ... arguments passed to \code{\link{sag_get}}.
#'
#' @return A data frame.
#'
#' @seealso
#' \code{\link{getSAG}} supports querying many years and quarters in one
#'   function call.
#'
#' \code{\link{getListStocks}} and \code{\link{getFishStockReferencePoints}} get
#'   a list of stocks and reference points.
#'
#' \code{\link{icesSAG-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' \dontrun{
#' assessmentKey <- findAssessmentKey("bli.27.5a14")
#' customs <- getCustomColumns(assessmentKey)
#' head(customs)
#' }
#' @export

getCustomColumns <- function(assessmentKey, ...) {

  df <- getStockDownloadData(assessmentKey, ...)
  df <- by(df, df$AssessmentKey, function(x) x)

  out <-
      lapply(
        df,
        function(x) {
          id <- grep("CustomName*", names(x))

          id <- id[apply(x[, id], 2, function(y) all(!is.na(y)))]
          if (!length(id)) {
            return(NULL)
          }

          # get stock level stuff
          out <- as.list(x[1, c("AssessmentKey", "AssessmentYear", "StockKeyLabel", "Purpose")])

          customIds <- as.numeric(gsub("CustomName", "", names(x)[id]))

          customs <-
            do.call(
              rbind,
              lapply(customIds, function(i) {
                data.frame(
                  Year = x$Year,
                  customValue = x[[paste0("Custom", i)]],
                  customName = x[[paste0("CustomName", i)]],
                  # customType = x[[paste0("CustomType", i)]],
                  customUnit = x[[paste0("CustomUnits", i)]],
                  customColumnId = i
                )
              })
            )

          cbind(out, customs)
        }
      )

  out <-
    do.call(
      rbind,
      out
    )
  rownames(out) <- NULL

  sag_clean(out)
}
