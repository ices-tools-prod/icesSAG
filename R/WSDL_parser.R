
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
  services <- names(getWebServiceDescription())
  missing_services <- setdiff(services, ls("package:icesSAG"))
  linked_services <- intersect(services, ls("package:icesSAG"))

  if (length(missing_services)) {
    message("\nThe following webservices are not interfaced with:\n\t",
            paste(missing_services, collapse = "\n\t"))
  }
  if (length(linked_services)) {
    message("\nThe following webservices *are* interfaced with:\n\t",
            paste(linked_services, collapse = "\n\t"))
  }
}

