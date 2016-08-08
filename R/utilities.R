#' @importFrom RCurl basicTextGatherer
#' @importFrom RCurl curlPerform
curlSAG <- function(url) {
  # read only XML table and return as txt string
  reader <- basicTextGatherer()
  curlPerform(url = url,
              httpheader = c('Content-Type' = "text/xml; charset=utf-8", SOAPAction=""),
              writefunction = reader$update,
              verbose = FALSE)
  # return
  reader$value()
}

#' @importFrom XML xmlParse
#' @importFrom XML xmlToDataFrame
#' @importFrom utils capture.output
parseSAG <- function(x) {
  # parse the xml text string suppplied by the SAG webservice
  # returning a dataframe
  capture.output(x <- xmlParse(x))
  # capture.output is used to stiffle the output message from xmlns:
  #   "xmlns: URI ices.dk.local/SAG is not absolute"

  # return
  xmlToDataFrame(x,
                 stringsAsFactors = FALSE)
}


checkSAGWebserviceOK <- function() {
  # return TRUE if webservice server is good, FALSE otherwise
  out <- curlSAG(url = "https://datras.ices.dk/WebServices/StandardGraphsWebServices.asmx")

  # Check the server is not down by insepcting the XML response for internal server error message.
  if(grepl("Internal Server Error", out)) {
    warning("Web service failure: the server seems to be down, please try again later.")
    FALSE
  } else {
    TRUE
  }
}

#' @importFrom XML xmlRoot
#' @importFrom XML xmlParse
#' @importFrom XML xmlSApply
#' @importFrom XML xmlParse
#' @importFrom XML xmlValue

parseSummary <- function(x) {
  #
  # Extract data
  summaryNames <-  xmlRoot(xmlParse(x))

  # Parse XML data and convert into a data frame
  xmlDat <- xmlSApply(summaryNames[["lines"]],
                      function(x) xmlSApply(x,
                                            xmlValue))

  xmlDat[sapply(xmlDat,
                function(x) length(x) == 0)] <- NA
  dimnames(xmlDat)[2] <- NULL

  summaryInfo <- data.frame(lapply(data.frame(t(xmlDat)),
                                   function(x) as.numeric(as.character(x))),
                            stringsAsFactors = FALSE)
  #
  stockList <- names(summaryNames[names(summaryNames) != "lines"])
  stockValue <-  rbind(lapply(stockList,
                              function(x) xmlSApply(summaryNames[[x]],
                                                    xmlValue)))
  stockValue[sapply(stockValue,
                    function(x) length(x) == 0)] <- NA
  dimnames(stockValue)[2] <- NULL

  stockValue <- data.frame(lapply(stockValue,
                                  function(x) as.character(x)),
                           stringsAsFactors = FALSE)
  colnames(stockValue) <- stockList
  #
  summaryInfo <- cbind(summaryInfo, stockValue)
}


