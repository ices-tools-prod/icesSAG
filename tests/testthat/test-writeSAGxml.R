ref_file <- test_path("aru.27.5b6a_2026.xml")

write_ref <- function(...) {
  inputs <- sag_inputs_from_xml(ref_file)
  out <- tempfile(fileext = ".xml")
  writeSAGxml(
    do.call(stockInfo, inputs$info),
    do.call(stockFishdata, inputs$fishdata),
    do.call(stockRetroBias, inputs$retrobias),
    file = out, ...
  )
  out
}

test_that("written file reproduces the Excel template export", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  out <- write_ref(sameRefPoints = TRUE)

  ref <- read_sag_xml(ref_file)
  new <- read_sag_xml(out)

  drop <- "NameSystemProducedFile"
  expect_setequal(setdiff(names(new$info), drop), setdiff(names(ref$info), drop))
  expect_equal(new$info[setdiff(names(ref$info), drop)], ref$info[setdiff(names(ref$info), drop)])
  expect_equal(new$fishdata, ref$fishdata)
  expect_equal(new$retrobias, ref$retrobias)
  expect_equal(new$chart_settings, ref$chart_settings)
})

test_that("root element and processing instructions match the template", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  out <- write_ref(sameRefPoints = TRUE)
  txt <- readLines(out)

  expect_match(txt[1], "^<\\?xml version=\"1.0\" encoding=\"(UTF|utf)-8\" standalone=\"no\"\\?>$")
  expect_match(txt[2], "^<\\?xml-stylesheet type=['\"]text/xsl['\"] href=['\"]StandrdGraphsStyle.xsl['\"]\\?>$")
  doc <- xml2::read_xml(out)
  expect_equal(xml2::xml_name(doc), "Assessment")
  expect_equal(
    unname(xml2::xml_attr(doc, "xsi:noNamespaceSchemaLocation", ns = xml2::xml_ns(doc))),
    "ICES_Standard_Graphs.xsd"
  )
})

test_that("Chart_Settings only written when sameRefPoints = TRUE", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  out <- write_ref()
  expect_length(read_sag_xml(out)$chart_settings, 0)
})

test_that("BMSY is written and Flim is dropped", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  inputs <- sag_inputs_from_xml(ref_file)
  info <- do.call(stockInfo, c(inputs$info, list(BMSY = 25000)))
  expect_warning(info2 <- do.call(stockInfo, c(inputs$info, list(Flim = 0.5))), "Flim")
  expect_false("Flim" %in% names(info2))

  out <- tempfile(fileext = ".xml")
  writeSAGxml(info, inputs$fishdata, inputs$retrobias, file = out)
  expect_equal(read_sag_xml(out)$info[["BMSY"]], "25000")
})

test_that("numbers are not written in scientific notation and text is escaped", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  inputs <- sag_inputs_from_xml(ref_file)
  inputs$fishdata$Catches[1] <- 12345678901
  inputs$fishdata$Landings[1] <- 0.00001
  inputs$retrobias$Comments <- "bias due to F & M < expected"

  out <- tempfile(fileext = ".xml")
  writeSAGxml(inputs$info, inputs$fishdata, inputs$retrobias, file = out)
  new <- read_sag_xml(out)
  expect_equal(new$fishdata[[1]][["Catches"]], "12345678901")
  expect_equal(new$fishdata[[1]][["Landings"]], "0.00001")
  expect_equal(new$retrobias[[1]][["Comments"]], "bias due to F & M < expected")
})

test_that("errors stop the file being written", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  inputs <- sag_inputs_from_xml(ref_file)
  out <- tempfile(fileext = ".xml")
  expect_error(
    writeSAGxml(inputs$info, inputs$fishdata, file = out),
    "retro-bias record is mandatory"
  )
  expect_false(file.exists(out))
})
