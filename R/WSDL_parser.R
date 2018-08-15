
# get all available webservices and arguments
getWebServiceDescription <- function(secure = FALSE) {

  # get webservice descriptions
  if (!secure) {
    out <- sag_get(httr::modify_url(sag_uri(), query = "WSDL"))
  } else {
    out <- sag_get(httr::modify_url(sag_uri(token = ""), query = "WSDL"))
  }

  # parse output
  sag_parse(out, type = "WSDL")
}


sag_getXmlDataType <- function(which, secure = FALSE) {
  # get webservice descriptions
  if (!secure) {
    out <- sag_get(httr::modify_url(sag_uri(), query = "WSDL"))
  } else {
    out <- sag_get(httr::modify_url(sag_uri(token = ""), query = "WSDL"))
  }

  # extract schema information
  schema <- out[[1]]$types$schema
  names(schema) <- unname(sapply(schema, function(x) attr(x, "name")))

  # select one data-type
  sequence <- schema[[which]]$sequence

  # assume table structure and return
  unname(sapply(sequence, function(x) attr(x, "name")))
}


checkWebServices <- function(secure = FALSE, show = TRUE) {
  # check for new webservices
  services <- names(getWebServiceDescription(secure = secure))
  missing_services <- setdiff(services, ls("package:icesSAG"))
  linked_services <- intersect(services, ls("package:icesSAG"))

  if (length(missing_services) && show) {
    message("\nThe following webservices are not interfaced with:\n\t",
            paste(missing_services, collapse = "\n\t"))
  }
  if (length(linked_services) && show) {
    message("\nThe following webservices *are* interfaced with:\n\t",
            paste(linked_services, collapse = "\n\t"))
  }

  invisible(list(missing = missing_services, linked = linked_services))
}

