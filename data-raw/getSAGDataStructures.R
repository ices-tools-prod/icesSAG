
# read the WSDL page for the definitions of all the data structures used

# get data structures
out <- icesSAG:::sag_get(httr::modify_url(icesSAG:::sag_uri(), query = "WSDL"))

# extract schema information
schema <- out[[1]]$types$schema
names(schema) <- unname(sapply(schema, function(x) attr(x, "name")))

# get structures
schema <-
  lapply(schema,
       function(x) {
         unname(sapply(x$sequence, function(x) attr(x, "name")))
       })

# drop functions?
schema <- schema[sapply(schema, length) > 0]

devtools::use_data(schema, internal = TRUE)
