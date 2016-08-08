context('webservice access')

test_that('Webservice access is okay', {
  expect_equal(checkSAGWebserviceOK(), TRUE)
})