# stand-in for the ICES vocabularies so tests run offline
mock_vocab <- function(code_type) {
  switch(code_type,
    ICES_StockCode = c("aru.27.5b6a", "cod.27.47d20"),
    StockCategory = c("1", "1.2", "2", "2.11", "3", "3.2"),
    AssessmentPurpose = c("Advice", "Bench", "InitAdvice"),
    AssessmentModelType = c("A", "AL", "B", "DLS"),
    AssessmentModelName = c("SAM", "SCA", "XSA"),
    MUNIT = c("t", "NE3", "kg"),
    StockDataType = c("StockSize", "FishingPressure", "Other"),
    NULL
  )
}

# read a SAG xml file into a list of named character vectors
read_sag_xml <- function(file) {
  doc <- xml2::read_xml(file)
  values <- function(node) {
    kids <- xml2::xml_children(node)
    out <- stats::setNames(xml2::xml_text(kids), xml2::xml_name(kids))
    out[nzchar(out)]
  }
  top <- xml2::xml_children(doc)
  nms <- xml2::xml_name(top)
  single <- top[!nms %in% c("Fish_Data", "Assessment_retro-bias", "Chart_Settings")]
  info <- stats::setNames(xml2::xml_text(single), xml2::xml_name(single))
  list(
    info = info[nzchar(info)],
    fishdata = lapply(top[nms == "Fish_Data"], values),
    retrobias = lapply(top[nms == "Assessment_retro-bias"], values),
    chart_settings = lapply(top[nms == "Chart_Settings"], values)
  )
}

# convert the parsed reference file into R objects for writeSAGxml
sag_inputs_from_xml <- function(file) {
  ref <- read_sag_xml(file)
  info <- lapply(as.list(ref$info), utils::type.convert, as.is = TRUE, tryLogical = FALSE)
  info$NameSystemProducedFile <- NULL
  years <- vapply(ref$fishdata, function(x) as.numeric(x[["Year"]]), numeric(1))
  cols <- unique(unlist(lapply(ref$fishdata, names)))
  fishdata <- lapply(cols, function(col) {
    vapply(ref$fishdata, function(x) if (col %in% names(x)) as.numeric(x[[col]]) else NA_real_, numeric(1))
  })
  names(fishdata) <- cols
  fishdata$Year <- years
  retro <- lapply(as.list(ref$retrobias[[1]]), utils::type.convert, as.is = TRUE, tryLogical = FALSE)
  list(info = info, fishdata = fishdata, retrobias = retro)
}
