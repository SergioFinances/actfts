# Crea un archivo de prueba para la función acfinter
test_that("Checking input data types for acfinter", {
	# Verificar si la función retorna un error cuando el input no es numérico o serie temporal
	expect_error(acfinter(datag = "non_numeric_data", lag = 10),
			   "The input must be a numeric vector or a time series object.")

	# Verificar si retorna error cuando delta no tiene valores correctos
	expect_error(acfinter(datag = rnorm(100), lag = 10, delta = "invalid_delta"),
			   'The argument "diff" must be one of "levels", "diff1", "diff2", or "diff3".')
})

test_that("Checking output type for acfinter", {
	# Verificar si la salida es una lista que incluye las tablas esperadas
	result <- acfinter(datag = rnorm(100), lag = 10)
	expect_true(is.list(result))
	expect_named(result, c("ACF-PACF Test", "Stationary Test", "Normality Test"))

	# Verificar que las tablas contengan los nombres correctos de columnas
	expect_equal(colnames(result$`ACF-PACF Test`), c("lag", "acf", "pacf", "Box_Pierce", "Pv_Box", "Ljung_Box", "Pv_Ljung"))
	expect_equal(colnames(result$`Stationary Test`), c("Statistic", "P_Value"))
	expect_equal(colnames(result$`Normality Test`), c("Statistic", "P_Value"))
})

test_that("Checking plot generation for acfinter", {
	# Verificar que no hay errores al generar los gráficos
	expect_silent(acfinter(datag = rnorm(100), lag = 10, interactive = NULL))
})

test_that("Checking null and non-null values", {
	# Asegurarse de que la función no devuelva valores nulos
	result <- acfinter(datag = rnorm(100), lag = 10)
	expect_true(all(!is.null(result$`ACF-PACF Test`)))
	expect_true(all(!is.null(result$`Stationary Test`)))
	expect_true(all(!is.null(result$`Normality Test`)))
})

test_that("Checking output values", {
	# Verificar que los valores en las tablas estén dentro de los rangos esperados
	result <- acfinter(datag = rnorm(100), lag = 10)
	expect_true(all(result$`ACF-PACF Test`$acf >= -1 & result$`ACF-PACF Test`$acf <= 1))
	expect_true(all(result$`Stationary Test`$P_Value >= 0 & result$`Stationary Test`$P_Value <= 1))
})
