context('webservice access')

options(icesSAG.messages = TRUE)
#options(icesSAG.hostname = "iistest01/standardgraphs")

test_that('SAG upload', {
  stk <- readSAGxml("http://ecosystemdata.ices.dk/download/whb_comb_1999.xml")
  stkxml <- createSAGxml(stk$info, stk$fishdata)
  expect_equal(stk, readSAGxml(stkxml))
  stk <- readSAGxml(stkxml)
  expect_equal(stkxml, createSAGxml(stk$info, stk$fishdata))
})


test_that('getTokenExpiration',
{
  options(icesSAG.use_token = FALSE)
  #expect_equal(getTokenExpiration(), NA)
  options(icesSAG.use_token = TRUE)
  expect_is(getTokenExpiration(), "numeric")
})
