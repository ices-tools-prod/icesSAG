
uploadXMLFile <- function(txt) {

    uri <- sag_uri("uploadXMLFile", token = "test")
    uri <- gsub("[?]token=test", "", uri)
    message("POSTing ... ", uri)

    body <- sprintf("f=%s&token=%s",
                    openssl::base64_encode(utils::URLencode(txt)),
                    sg_pat())

    x <- httr::POST(uri,
                    body = body,
                    httr::content_type("application/x-www-form-urlencoded"),
                    `Content-Length` = nchar(body))
    message(httr::http_status(x)$message)
    unlist(xml2::as_list(httr::content(x)))
}

