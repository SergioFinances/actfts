test_that("data available", {
	data("PCECEEUU")
	expect_true( exists("PCECEEUU") )
	expect_equal(ncol(DPIEEUU), 1)
	expect_true(is.xts(PCECEEUU$PCEC))
})
