

#' @importFrom utils download.file
readSAG <- function(url) {
  # try downloading first:
  # create file name
  tmp <- tempfile()
  on.exit(unlink(tmp))

  # download file
  ret <-
    if (os.type("windows")) {
      download.file(url, destfile = tmp, quiet = TRUE)
    } else if (os.type("unix") & Sys.which("wget") != "") {
      download.file(url, destfile = tmp, quiet = TRUE, method = "wget")
    } else if (os.type("unix") & Sys.which("curl") != "") {
      download.file(url, destfile = tmp, quiet = TRUE, method = "curl")
    } else {
      127
    }

  # check return value
  if (ret == 0) {
    # scan lines
    scan(tmp, what = "", sep = "\n", quiet = TRUE)
  } else {
    message("Unable to download file so using slower method url().\n",
            "Try setting an appropriate value via \n\toptions(download.file.method = ...)\n",
            "see ?download.file for more information.")
    # connect to url
    con <- url(url)
    on.exit(close(con))

    # scan lines
    scan(con, what = "", sep = "\n", quiet = TRUE)
  }
}



parseSAG <- function(x) {
  # simply parse using line and column separators
  type <- gsub("*<ArrayOf(.*?) .*", "\\1", x[2])
  starts <- grep(paste0("<", type, ">"), x)
  ends <- grep(paste0("</", type, ">"), x)
  ncol <- unique(ends[1] - starts[1]) - 1
  # drop everything we don't need
  x <- x[-c(1,2, starts, ends, length(x))]

  # exit if no data is being returned
  if (length(x) == 0) return(NULL)

  # match content of first <tag>
  names_x <- gsub(" *<(.*?)>.*", "\\1", x[1:ncol])

  # delete all <tags>
  x <- gsub(" *<.*?>", "", x)
  # trim white space
  x <- trimws(x)

  # SAG uses "" and "NA" to indicate NA
  x[x == ""] <- NA
  x[x == "NA"] <- NA

  # make into a data.frame
  dim(x) <- c(ncol, length(x)/ncol)
  row.names(x) <- names_x
  x <- as.data.frame(t(x), stringsAsFactors = FALSE)

  # simplify and return
  simplify(x)
}



parseSummary <- function(x) {

  # check for not published:
  if ( gsub(" *<.*?>", "", x[3]) == "Stock not published") {
    return(NULL)
  }
  if (gsub(" *<.*?>", "", x[3]) != "Stock published") {
    stop("Something went wrong")
  }

  # Extract table size
  type <- "SummaryTableLine"
  starts <- grep(paste0("<", type, ">"), x)
  ends <- grep(paste0("</", type, ">"), x)
  ncol <- unique(ends[1] - starts[1]) - 1

  # get auxilliary info
  info <- x[3:(starts[1]-2)]
  # match content of first <tag>
  names_info <- gsub(" *<(.*?)>.*", "\\1", info)
  # delete all <tags>
  info <- gsub(" *<.*?>", "", info)
  names(info) <- names_info

  # read summary table
  x <- x[-c(1:(starts[1]-1), starts, ends, length(x) + -1:0)]

  # match content of first <tag>
  names_x <- gsub(" *<(.*?)>.*", "\\1", x[1:ncol])
  # also remove xsi:nil:
  names_x <- gsub(" xsi:nil=\"true\" /", "", names_x)

  # delete all <tags>
  x <- gsub(" *<.*?>", "", x)

  # make into a data.frame
  dim(x) <- c(ncol, length(x)/ncol)
  row.names(x) <- names_x
  x <- as.data.frame(t(x), stringsAsFactors = FALSE)

  # tag on info
  x <- cbind(x, data.frame(t(info)))

  # tidy
  x[x == ""] <- NA
  x[x == "NA"] <- NA

  # simplify
  simplify(x)
}


#' @importFrom png readPNG
parseGraph <- function(x) {

  fileurl <- gsub(" *<.*?>", "", x[2])

  if (fileurl == "D:\\StandardGraphs\\Download\\notpublished.png") {
    return(NULL)
  }

  tmp <- tempfile(fileext = ".png")
  download.file(fileurl, tmp, mode="wb", quiet=TRUE)

  out <- readPNG(tmp)

  class(out) <- c("ices_standardgraph", class(out))
  out
}


#' @export
#' @importFrom grid grid.raster
plot.ices_standardgraph <- function(x, y = NULL, ...) {
  grid.raster(x)
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
    grid.raster(x[[i]], x = x_loc[i], y = y_loc[i], width = 1/r, height = 1/c)
  }
}



checkSAGWebserviceOK <- function() {
  # return TRUE if web service is active, FALSE otherwise
  out <- readSAG("https://sg.ices.dk/StandardGraphsWebServices.asmx/getSummaryTable?key=-1")

  # check server is not down by inspecting XML response for internal server error message
  if(!grepl("SummaryTable", out[2])) {
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

