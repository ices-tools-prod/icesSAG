#' @importFrom RCurl basicTextGatherer
#' @importFrom RCurl curlPerform
curlSAG <- function(url) {
  # read only XML table and return as string
  reader <- basicTextGatherer()
  curlPerform(url = url,
              httpheader = c('Content-Type' = "text/xml; charset=utf-8", SOAPAction = ""),
              writefunction = reader$update,
              verbose = FALSE)
  reader$value()
}


#' @importFrom XML xmlParse
#' @importFrom XML xmlToDataFrame
#' @importFrom utils capture.output
parseSAG <- function(x) {
  # parse XML string to data frame
  capture.output(x <- xmlParse(x))
  # capture.output is used to stiffle the output message from xmlns:
  #   "xmlns: URI ices.dk.local/SAG is not absolute"

  # convert XML to data frame
  x <- xmlToDataFrame(x, stringsAsFactors = FALSE)

  # clean trailing white space from text columns
  charcol <- which(sapply(x, is.character))
  x[charcol] <- lapply(x[charcol], trimws)

  ## SAG uses "" and "NA" to indicate NA
  x[x == ""] <- NA
  x[x == "NA"] <- NA

  simplify(x)
}


#' @importFrom XML xmlRoot
#' @importFrom XML xmlParse
#' @importFrom XML xmlSize
#' @importFrom XML xmlToDataFrame
parseSummary <- function(x) {

  # Extract data
  capture.output(x <- xmlParse(x))
  # capture.output is used to stiffle the output message from xmlns:
  #   "xmlns: URI ices.dk.local/SAG is not absolute"
  x <- xmlRoot(x)

  # get auxilliary info
  nhead <- xmlSize(x)-1
  info <- c(xmlToDataFrame(x[1:nhead])$text, stringsAsFactors = FALSE)
  names(info) <- names(x[1:nhead])

  # read summary table
  out <- xmlToDataFrame(x[[xmlSize(x)]], stringsAsFactors = FALSE)

  # tidy
  out[out == ""] <- NA

  # simplify
  out <- simplify(out)

  # add info as attribute
  attr(out, "notes") <- info
  out
}


#' @importFrom XML xmlRoot
#' @importFrom XML xmlParse
#' @importFrom XML getChildrenStrings
#' @importFrom png readPNG
#' @importFrom utils download.file
parseGraph <- function(x) {

  x <- xmlParse(x)
  x <- xmlRoot(x)
  fileurl <- unname(getChildrenStrings(x))

  tmp <- tempfile(fileext = ".png")
  download.file(fileurl, tmp, mode="wb", quiet=TRUE)

  out <- readPNG(tmp)

  class(out) <- c("ices_standardgraph", class(out))
  out
}


#' @importFrom grid grid.raster
#' @export
plot.ices_standardgraph <- function(x, y = NULL, ...) {
  grid.raster(x)
}


checkSAGWebserviceOK <- function() {
  # return TRUE if web service is active, FALSE otherwise
  out <- curlSAG("https://sg.ices.dk/StandardGraphsWebServices.asmx")

  # check server is not down by inspecting XML response for internal server error message
  if(grepl("Internal Server Error", out)) {
    warning("Web service failure: the server seems to be down, please try again later.")
    FALSE
  } else {
    TRUE
  }
}


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


simplify <- function(x) {
  # from Arni's toolbox
  # coerce object to simplest storage mode: factor > character > numeric > integer
  owarn <- options(warn = -1)
  on.exit(options(owarn))
  # list or data.frame
  if (is.list(x)) {
    if (is.data.frame(x)) {
      old.row.names <- attr(x, "row.names")
      x <- lapply(x, simplify)
      attributes(x) <- list(names = names(x), row.names = old.row.names, class = "data.frame")
    }
    else
      x <- lapply(x, simplify)
  }
  # matrix
  else if (is.matrix(x))
  {
    if (is.character(x) && sum(is.na(as.numeric(x))) == sum(is.na(x)))
      mode(x) <- "numeric"
    if (is.numeric(x))
    {
      y <- as.integer(x)
      if (sum(is.na(x)) == sum(is.na(y)) && all(x == y, na.rm = TRUE))
        mode(x) <- "integer"
    }
  }
  # vector
  else
  {
    if (is.factor(x))
      x <- as.character(x)
    if (is.character(x))
    {
      y <- as.numeric(x)
      if (sum(is.na(y)) == sum(is.na(x)))
        x <- y
    }
    if (is.numeric(x))
    {
      y <- as.integer(x)
      if (sum(is.na(x)) == sum(is.na(y)) && all(x == y, na.rm = TRUE))
        x <- y
    }
  }
  x
}
