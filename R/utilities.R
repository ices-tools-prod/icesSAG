# webservice utilities

sag_webservice <- function(service, ..., check = TRUE) {
  # check web services are running
  if (check && !sag_checkWebserviceOK()) return (NULL)

  # form uri of webservice
  if (getOption("icesSAG.use_token")) {
    uri <- sag_uri(service, ..., token = sg_pat())
  } else {
    uri <- sag_uri(service, ...)
  }

  # preform request
  sag_get(uri)
}

sag_checkWebserviceOK <- function() {
  # return TRUE if web service is active, FALSE otherwise
  out <- try(httr::GET(sag_uri("getSummaryTable", key = -1)), silent = TRUE)

  # if this errored then there is probably no internet connection
  if (inherits(out, "try-error")) {
    warning("Attempt to access webservice failed:\n", attr(out, "condition"))
    FALSE
  } else
  # check server is not down by inspecting response for internal server error message
  if(httr::http_error(out)) {
    warning("Web service failure: the server seems to be down, please try again later.\n",
            "http status message: ", httr::http_status(out)$message)
    FALSE
  } else {
    TRUE
  }
}


sag_uri <- function(service, ...) {
  # set up api url
  query <- list(...)

  # which api are we using
  if ("token" %in% names(query)) {
    scheme <- "https"
    api <- "Manage/StockAssessmentGraphsWithToken.asmx"
    # keep for debuging
    if (grepl("localhost", getOption("icesSAG.hostname"))) scheme <- "http"
  } else {
    scheme <- "http"
    api <- "StandardGraphsWebServices.asmx"
  }

  path <- if (!missing(service)) paste(api, service, sep = "/") else api

  # return url
  httr::modify_url("",
                   scheme = scheme,
                   hostname = getOption("icesSAG.hostname"),
                   path = path,
                   query = if (length(query) == 0) NULL else query)
}


sag_get <- function(uri) {
  if (getOption("icesSAG.messages"))
    message("GETing ... ", uri)

  # read url contents
  resp <- httr::GET(uri)

  # return as list
  if (httr::http_type(resp) == "text/xml") {
    xml2::as_list(httr::content(resp))
  } else {
    warning("in SAG API - ", httr::content(resp), call. = FALSE)
  }
}





sag_parse <- function(x) {
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

  simplify(x)
}



sag_parseSummary <- function(x) {
  # get auxilliary info
  info <- sag_parse(list(x[names(x) != "lines"]))

  # parse summary table
  x <- sag_parse(x[["lines"]])

  # tag on info and return
  cbind(x, info, stringsAsFactors = FALSE)
}


sag_parseGraph <- function(x) {
  # get png file info
  fileurl <- unlist(x)
  size <- 2^16

  # try read raw data
  out <- try(readBin(con = fileurl, what = raw(0), n = size), silent = TRUE)
  if (inherits(out, "try-error")) {
    return(NULL)
  }

  # read as png
  png::readPNG(out)
}


sag_parseWSDL <- function(x) {
  x <- x$types$schema[names(x$types$schema) == "element"]
  types <- lapply(x, function(x) attributes(x)$names)
  keep <- sapply(types, function(x) identical(x == "complexType", TRUE))
  keep <- which(keep)[seq(1,sum(keep), by = 2)]

  # strip out only webservice calls
  x <- x[keep]
  names(x) <- unname(sapply(x, function(x) attributes(x)$name))

  # simplify a little
  x <- lapply(x, function(x) x$complexType$sequence)

  # extract parameter info
  lapply(x,
      function(x)
          unname(sapply(x, function(y) attributes(y)$name))
          )
}



sag_parseUpload <- function(x) {
  # parse header information
  info <- sag_parse(list(x[names(x) != "Fish_Data"]))

  # tidy fish data
  fishdata <- sag_parse(x[names(x) == "Fish_Data"])

  list(info = info, fishdata = fishdata)
}



#' @export
plot.ices_standardgraph_list <- function(x, y = NULL, ...) {
  # clear the page
  grid::grid.newpage()

  # find best plot layout (stolen from Simon Wood!)
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
    if (!is.null(x[[i]]))
      grid::grid.raster(x[[i]], x = x_loc[i], y = y_loc[i], width = 1/r, height = 1/c)
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

