test_that("data available", {
	data("DPIEEUU")
	expect_true( exists("DPIEEUU") )
	expect_equal(ncol(DPIEEUU), 1)
	expect_true(is.xts(DPIEEUU$DPI))
})
