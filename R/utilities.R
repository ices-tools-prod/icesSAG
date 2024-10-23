# webservice utilities

sag_webservice <- function(service, ...) {

  # form uri of webservice
  if (getOption("icesSAG.use_token")) {
    uri <- sag_uri(service, ..., token = sg_pat())
  } else {
    uri <- sag_uri(service, ...)
  }

  # preform request
  sag_get(uri)
}


sag_documentService_uri <- function(service, ...) {

  # form uri of webservice
  if (getOption("icesSAG.use_token")) {
    uri <- sag_uri(service, ..., token = sg_pat())
  } else {
    uri <- sag_uri(service, ...)
  }

  # modify url
  uri <- httr::modify_url(uri, path = paste0("download/", service, ".ashx"))

  # return uri
  uri
}

sag_uri <- function(service, ...) {
  # set up api url
  query <- list(...)

  # which api are we using
  if ("token" %in% names(query)) {
    scheme <- "https"
    api <- "Manage/StockAssessmentGraphsWithToken.asmx"
    # keep for debuging
    if (grepl("localhost|iistest01", getOption("icesSAG.hostname"))) scheme <- "http"
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
  resp <- try(httr::GET(uri))

  # if this errored then there is probably no internet connection
  if (inherits(resp, "try-error")) {
    warning("Attempt to access webservice failed:\n", attr(resp, "condition"))
    return(NULL)
  } else
  # check server is not down by inspecting response for internal server error message
  if (httr::http_error(resp)) {
    warning(#"Web service failure: the server is not accessible, please try again later.\n",
            "http status message: ", httr::http_status(resp)$message, call. = FALSE)
  }

  # return as list
  if (httr::http_type(resp) == "text/xml") {
    xml2::as_list(httr::content(resp))
  } else {
    warning("in SAG API - ", httr::content(resp), call. = FALSE)
    if (grepl("Web Service method name is not valid", httr::content(resp))) {
      NULL
    }
  }
}


sag_parse <- function(x, type = "table", ...) {
  # return NULL if empty or webservice fail
  if (length(unlist(x)) == 0 || is.null(x)) {
    return(NULL)
  }

  # otherwise parse x, first drop the root node
  x <- x[[1]]
  type <- match.arg(type, c("table", "summary", "graph", "upload", "stockStatus", "WSDL"))
  switch(type,
    table = sag_parseTable(x),
    summary = sag_parseSummary(x),
    graph = sag_parseGraph(x),
    upload = sag_parseUpload(x),
    stockStatus = sag_parseStockStatus(x)
  )
}

sag_getXmlDataType <- function(which) {
  # select one data-type - schema is package data
  schema[[which]]
}

sag_parseTable <- function(x) {
  # x is a table structure
  # get column names
  if (is.null(names(x[1]))) {
    xnames <- unique(unlist(unname(lapply(x, names))))
  } else {
    xnames <- sag_getXmlDataType(names(x[1]))
    returned_names <- unique(unlist(unname(lapply(x, names))))
    xnames <- xnames[xnames %in% returned_names]
  }

  # convert to DF
  x <- lapply(unname(x), unlist)
  # expand missing entries columns
  x <- lapply(x, function(x) {
                   x <- x[xnames]
                   names(x) <- xnames
                   x
                 })
  # rbind into a matrix
  x <- do.call(rbind, x)

  # remove any html tags - this can happen in the SAG graph settings entries!
  x[] <- gsub("<.*?>", "", x)

  # trim white space
  x[] <- trimws(x)

  # SAG uses "" and "NA" to indicate NA
  x[x %in% c("", "NA")] <- NA

  # make into a data.frame
  x <- as.data.frame(x, stringsAsFactors = FALSE)

  simplify(x)
}



sag_parseSummary <- function(x) {
  # get auxilliary info
  info <- sag_parseTable(list(SummaryTable = x[which(names(x) != "lines")]))

  # parse summary table
  x <- sag_parseTable(x[["lines"]])

  # tag on info and return
  cbind(x, info, stringsAsFactors = FALSE)
}



sag_parseGraph <- function(x, size = 2^16) {
  # get png file info
  fileurl <- unlist(x)

  # try read raw data
  out <- try(readBin(con = fileurl, what = raw(0), n = size), silent = TRUE)
  if (inherits(out, "try-error")) {
    return(NULL)
  }

  # read as png
  png::readPNG(out)
}


sag_parseStockStatus <- function(x) {
  out <-
    do.call(
      rbind,
      lapply(x, sag_parseStockStatusLine)
    )

  rownames(out) <- NULL

  out
}


sag_parseStockStatusLine <- function(x) {
  line <- as.data.frame(sapply(x[which(names(x) != "YearStatus")], c), stringsAsFactors = FALSE)
  years <- sag_parseTable(x$YearStatus)

  cbind(line, years)
}


#' @importFrom utils type.convert
sag_clean <- function(x, keep_html = FALSE) {
  x <- as.matrix(x)
  mode(x) <- "character"

  if (!keep_html) {
    # remove any html tags - this can happen in the SAG graph settings entries!
    x[] <- gsub("<.*?>", "", x)
  }

  # trim white space
  x[] <- trimws(x)

  # SAG uses "" and "NA" to indicate NA
  x[x %in% c("", "NA", "na")] <- NA

  # make into a data.frame
  x <- as.data.frame(x, stringsAsFactors = FALSE)

  type.convert(x, as.is = TRUE)
}


simplify <- function(x) {
  # from Arni's toolbox
  # coerce object to simplest storage mode: factor > character > numeric > integer
  # list or data.frame
  if (is.list(x)) {
    for (i in seq_len(length(x)))
      x[[i]] <- simplify(x[[i]])
  }
  # matrix
  else if (is.matrix(x)) {
    if (is.character(x) && sum(is.na(as.numeric(x))) == sum(is.na(x)))
      mode(x) <- "numeric"
    if (is.numeric(x)) {
      y <- as.integer(x)
      if (sum(is.na(x)) == sum(is.na(y)) && all(x == y, na.rm = TRUE))
        mode(x) <- "integer"
    }
  }
  # vector
  else {
    if (is.factor(x))
      x <- as.character(x)
    if (is.character(x)) {
      if (!any(grepl("[^0-9.]", x))) {
        y <- as.numeric(x)
        if (sum(is.na(y)) == sum(is.na(x)))
          x <- y
      }
    }
    if (is.numeric(x)) {
      y <- as.integer(x)
      if (sum(is.na(x)) == sum(is.na(y)) && all(x == y, na.rm = TRUE))
        x <- y
    }
  }
  x
}
