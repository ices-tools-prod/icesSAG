#' @importFrom utils capture.output

checkYearOK <- function(year) {
  # check year against available years
  all_years <- getListStocks(year = 0)
  published_years <- unique(as.numeric(all_years$AssessmentYear[!grepl("Not", all_years$Status)]))
  
  
  if (!year %in% published_years) {
    message("Supplied year (", year, ") is not available.\n  Available options are:\n",
            paste(capture.output(print(sort(published_years))), collapse = "\n"))
    FALSE
  } else {
    TRUE
  }
}