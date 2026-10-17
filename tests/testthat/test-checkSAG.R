ref_file <- test_path("aru.27.5b6a_2026.xml")

check_ref <- function(info = list(), fishdata = list(), retrobias = list(), drop_retro = FALSE) {
  inputs <- sag_inputs_from_xml(ref_file)
  inputs$info[names(info)] <- info
  inputs$fishdata[names(fishdata)] <- fishdata
  inputs$retrobias[names(retrobias)] <- retrobias
  checkSAG(
    inputs$info,
    inputs$fishdata,
    if (drop_retro) NULL else do.call(stockRetroBias, inputs$retrobias)
  )
}

test_that("reference file passes all checks", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  res <- check_ref()
  expect_length(res$errors, 0)
  expect_length(res$warnings, 0)
})

test_that("invalid vocabulary codes are errors", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  expect_match(check_ref(info = list(StockCode = "aru.27.xx"))$errors, "StockCode", all = FALSE)
  expect_match(check_ref(info = list(ModelName = "NotAModel"))$errors, "AssessmentModelName", all = FALSE)
  expect_match(check_ref(info = list(StockSizeUnits = "tonnes"))$errors, "MUNIT", all = FALSE)
  expect_match(check_ref(info = list(CustomSeriesType1 = "Bad"))$errors, "StockDataType", all = FALSE)
})

test_that("vocabulary that cannot be downloaded is a warning", {
  local_mocked_bindings(sag_vocab_keys = function(code_type) NULL)
  res <- check_ref()
  expect_length(res$errors, 0)
  expect_match(res$warnings, "could not download", all = FALSE)
})

test_that("retro-bias is mandatory for category 1 and 2 only", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  expect_match(check_ref(drop_retro = TRUE)$errors, "retro-bias", all = FALSE)
  expect_match(check_ref(info = list(StockCategory = 2.11), drop_retro = TRUE)$errors, "retro-bias", all = FALSE)
  expect_length(check_ref(info = list(StockCategory = 3.2), drop_retro = TRUE)$errors, 0)
})

test_that("retro-bias values are checked", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  expect_match(check_ref(retrobias = list(SSBrhoYear = "maybe"))$errors, "SSBrhoYear")
  expect_match(check_ref(retrobias = list(Fbarrho = -18.77))$warnings, "percentage")
  expect_equal(stockRetroBias(2025, 5, SSBrhoYear = "Yes", RecruitmentrhoYear = FALSE)[c("SSBrhoYear", "RecruitmentrhoYear")],
               list(SSBrhoYear = "Y", RecruitmentrhoYear = "N"))
})

test_that("confidence interval definition is checked", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  expect_match(check_ref(info = list(ConfidenceIntervalDefinition = NA))$errors, "ConfidenceIntervalDefinition")
})

test_that("descriptions and units of standard series are checked", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  expect_match(check_ref(info = list(RecruitmentUnits = NA))$errors, "RecruitmentUnits")
  expect_match(check_ref(info = list(StockSizeDescription = NA))$errors, "StockSizeDescription")
  expect_match(check_ref(info = list(CatchesLandingsUnits = NA))$errors, "CatchesLandingsUnits")
  # fishing pressure units can be blank (unitless)
  expect_length(check_ref(info = list(FishingPressureUnits = NA))$errors, 0)
})

test_that("custom series names, types and units are checked", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  n <- length(sag_inputs_from_xml(ref_file)$fishdata$Year)
  expect_match(check_ref(fishdata = list(CustomSeries1 = rep(1, n)))$errors, "CustomSeriesName1 is empty", all = FALSE)
  expect_match(check_ref(info = list(CustomSeriesName2 = "survey"))$errors, "CustomSeries2 has no data")
  res <- check_ref(info = list(CustomSeriesName1 = "survey"), fishdata = list(CustomSeries1 = rep(1, n)))
  expect_length(res$errors, 0)
  expect_match(res$warnings, "CustomSeriesType1", all = FALSE)
  expect_match(res$warnings, "CustomSeriesUnits1", all = FALSE)
})

test_that("future assessment year is an error", {
  local_mocked_bindings(sag_vocab_keys = mock_vocab)
  next_year <- as.numeric(format(Sys.Date(), "%Y")) + 1
  expect_match(check_ref(info = list(AssessmentYear = next_year))$errors, "later than the present year")
})
