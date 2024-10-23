sag_parseUpload <- function(x) {
  # parse header information
  info <- sag_parseTable(list(x[names(x) != "Fish_Data"]))
  info <- do.call(stockInfo, info)

  # tidy fish data
  fishdata <- sag_parseTable(unname(x[names(x) == "Fish_Data"]))
  fishdata <- do.call(stockFishdata, fishdata)

  list(info = info, fishdata = fishdata)
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

  type.convert(x, as.is = TRUE)
}

sag_getXmlDataType <- function(which) {
  # select one data-type - schema is package data
  schema[[which]]
}
