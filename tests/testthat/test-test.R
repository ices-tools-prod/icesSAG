context('webservice access')

test_that('Webservice access is okay', {
  expect_equal(sag_checkWebserviceOK(), TRUE)
})


test_that('SAG upload', {
  stk <- readSAGUpload("http://ecosystemdata.ices.dk/download/whb_comb_1999.xml")
  stkxml <- writeSAGUpload(stk$info, stk$fishdata)
  expect_equal(stk, readSAGUpload(stkxml))
  stk <- readSAGUpload(stkxml)
  expect_equal(stkxml, writeSAGUpload(stk$info, stk$fishdata))
})
