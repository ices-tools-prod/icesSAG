

#url <- httr::modify_url("https://",
#                        host = "sg.ices.dk/manage/StockAssessmentGraphsWithToken.asmx", 
#                        path = "getListAvailableSAGSettingsPerChart",
#                        query = list(SAGChartKey = 1, token = SAG_pat()))

#x <- readSAG(url)

readSAG <- function(url) {
  # read url contents
  resp <- httr::GET(url)
  if (httr::http_type(resp) != "text/xml") {
    stop("API did not return xml", call. = FALSE)
  }

  # return as list
  resp <-httr::content(resp)
  xml2::as_list(resp)
}


parseSAG <- function(x) {
  # assume x is a table structure
  xrow <- structure(rep(NA, length(x[[1]])), names = names(x[[1]]))
  x <- lapply(unname(x), unlist)
  # add NAs to empty columns
  bool <- sapply(x, length) < length(xrow)
  x[bool] <- lapply(x[bool], function(y) {out <- xrow; out[names(y)] <- y; out})
  # rbind into a matrix
  x <- do.call(rbind, x)

  # remove any html tags
  x <- gsub("<.*?>", "", x)
  
  # trim white space
  x <- trimws(x)
  
  # SAG uses "" and "NA" to indicate NA
  x[x == ""] <- NA
  x[x == "NA"] <- NA
    
  # make into a data.frame
  x <- as.data.frame(x, stringsAsFactors = FALSE)


  # simplify and return
  simplify(x)
}



parseSummary <- function(x) {

  # get auxilliary info
  info <- as.data.frame(lapply(x[names(x) != "lines"], "[[", 1), stringsAsFactors = FALSE)
  # tidy
  x[x == ""] <- NA
  x[x == "NA"] <- NA
  # simplify
  info <- simplify(info)

  # check for not published:
  if (info$StockPublishNote == "Stock not published") {
    return(NULL)
  }
  if (info$StockPublishNote != "Stock published") {
    stop("Something went wrong")
  }

  # parse summary table  
  x <- parseSAG(x[["lines"]])
  
  # tag on info and return
  cbind(x, info, stringsAsFactors = FALSE)
}


parseGraph <- function(x) {

  fileurl <- unlist(x)

  tmp <- tempfile(fileext = ".png")
  utils::download.file(fileurl, tmp, mode="wb", quiet=TRUE)

  out <- png::readPNG(tmp)

  class(out) <- c("ices_standardgraph", class(out))
  out
}


#' @export
plot.ices_standardgraph <- function(x, y = NULL, ...) {
  grid::grid.raster(x)
}

#' @export
plot.ices_standardgraph_list <- function(x, y = NULL, ...) {
  # find best plot layout
  n.plots <- length(x)
  c <- r <- trunc(sqrt(n.plots))
  if (c < 1) r <- c <- 1
  if (c * r < n.plots) c <- c + 1
  if (c * r < n.plots) r <- r + 1
  # calculate x and y locations for plots -
  # plot like a table: from top to bottom and left to right
  x_loc <- rep((1:r)/r - 1/(2*r), c)
  y_loc <- rep((c:1)/c  - 1/(2*c), each = r)
  for (i in seq_along(x)) {
    grid::grid.raster(x[[i]], x = x_loc[i], y = y_loc[i], width = 1/r, height = 1/c)
  }
}



checkSAGWebserviceOK <- function() {
  # return TRUE if web service is active, FALSE otherwise
  out <- httr::GET("https://sg.ices.dk/StandardGraphsWebServices.asmx/getSummaryTable?key=-1")

  # check server is not down by inspecting XML response for internal server error message
  if(httr::http_error(out)) {
    warning("Web service failure: the server seems to be down, please try again later.\n",
            "http status message: ", httr::http_status(out)$message)
    FALSE
  } else {
    TRUE
  }
}


checkYearOK <- function(year) {
  # check year against available years
  all_years <- getListStocks(year = 0)
  published_years <- unique(as.numeric(all_years$AssessmentYear[!grepl("Not", all_years$Status)]))

  if (!year %in% published_years) {
    message("Supplied year (", year, ") is not available.\n  Available options are:\n",
            paste(utils::capture.output(print(sort(published_years))), collapse = "\n"))
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
    for (i in seq_len(length(x)))
      x[[i]] <- simplify(x[[i]])
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



# returns TRUE if correct operating system is passed as an argument
os.type <- function (type = c("unix", "windows", "other"))
{
  type <- match.arg(type)
  if (type %in% c("windows", "unix")) {
    .Platform$OS.type == type
  } else {
    TRUE
  }
}

