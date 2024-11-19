test_that("data available", {
	data("GDPEEUU")
	expect_true( exists("GDPEEUU"))
	expect_equal(ncol(GDPEEUU), 1)
	expect_true(is.xts(GDPEEUU$GDP))
})
