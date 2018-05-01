context('webservice access')

options(icesSAG.messages = TRUE)
options(icesSAG.use_token = FALSE)

#options(icesSAG.hostname = "iistest01/standardgraphs")

test_that('SAG upload',
{
  info <- stockInfo(StockCode = "cod.27.47d20", AssessmentYear = 2015, ContactPerson = "colin.millar@ices.dk")
  fishdata <- stockFishdata(Year = 2000:2015)
  stkxml <- createSAGxml(info, fishdata)
  expect_equal(list(info = info, fishdata = fishdata), readSAGxml(stkxml))
  stk <- readSAGxml(stkxml)
  expect_equal(stkxml, createSAGxml(stk$info, stk$fishdata))
})


test_that('getTokenExpiration',
{
#  options(icesSAG.use_token = TRUE)
#  expect_is(getTokenExpiration(), "numeric")
  options(icesSAG.use_token = FALSE)
  expect_is(getTokenExpiration(), "numeric")
})


test_that('getStockDownloadData',
{
#  options(icesSAG.use_token = TRUE)
#  key <- findAssessmentKey("pok.27.1-2", 2017)
#  expect_is(key, "integer")
#  x <- getStockDownloadData(key)
#  expect_is(x, "list")
###  expect_is(x[[1]], "data.frame")
  x <- expect_warning(getStockDownloadData(-1))
  expect_is(x, "list")
  expect_null(x[[1]])
#  x <- getStockDownloadData(c(key, -1))
#  expect_is(x, "list")
#  expect_is(x[[1]], "data.frame")
#  expect_null(x[[2]])
})


test_that('getSAGTypeGraphs',
{
#  options(icesSAG.use_token = TRUE)
  x <- getSAGTypeGraphs()
  expect_is(x, "data.frame")
})



test_that('findAssessmentKey',
{
  options(icesSAG.use_token = FALSE)
  keytab <- findAssessmentKey(stock = NULL, year = 2016, full = TRUE)
  expect_is(keytab, "data.frame")
})
