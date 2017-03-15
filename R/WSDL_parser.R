
# get all available webservices and arguments

getWebServiceDescription <- function() {
  # check web services are running
  if (!sag_checkWebserviceOK()) return (NULL)

  # get webservice descriptions
  out <- sag_get(httr::modify_url(sag_uri(), query = "WSDL"))
  sout <- sag_get(httr::modify_url(sag_uri(token = ""), query = "WSDL"))

  # parse output
  c(sag_parseWSDL(out),
    sag_parseWSDL(sout))
}


checkWebServices <- function() {
  # check for new webservices
  missing_services <- setdiff(names(getWebServiceDescription()), ls("package:icesSAG"))

  if (length(missing_services)) {
    message("The following webservices are not interfaced with:\n\t",
            paste(missing_services, collapse = "\n\t"))
  }
}

