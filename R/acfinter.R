#' ACF and PACF Analysis with Interactive Features
#'
#' acfinter computes and visualizes the ACF and PACF of a given time series,
#' performs stationarity tests, and optionally generates interactive tables and plots.
#'
#' @param datag A numeric vector or a time series object.
#' @param lag Maximum number of lags for the ACF and PACF. Default is 72.
#' @param ci.method Method for confidence intervals: "white" (default) or "ma".
#' @param ci Confidence level for confidence intervals. Default is 0.95.
#' @param interactive Character string specifying whether to create an interactive table:
#' "acftable" for the ACF-PACF table, "stattable" for the stationarity tests table. Default is NULL.
#' @param delta Transformation of the data: "levels" (default), "diff1", "diff2", or "diff3".
#' @param download Logical indicating whether to save the results as files. Default is FALSE.
#'
#' @return A list with two elements: "ACF-PACF Test" and "Stationary Test".
#' The function also creates interactive plots and tables if specified.
#'
#' @examples
#' data <- actfts::GDPEEUU
#' result <- actfts::acfinter(data, lag = 20, ci.method = "white", interactive = "acftable")
#' print(result)
#'
#' @import xts
#' @import tseries
#' @import reactable
#' @import openxlsx
#' @import plotly
#' @importFrom forecast BoxCox.lambda
#' @importFrom stats acf pacf Box.test na.omit qnorm is.ts setNames sd shapiro.test
#' @importFrom graphics par
#'
#' @export
acfinter <- function(datag, lag = 72, ci.method = "white", ci = 0.95, interactive = NULL,
				 delta = "levels", download = FALSE){

	# Init
	gen <- function(datag, delta = "levels") {
		if (!is.numeric(datag) && !is.ts(datag) && !is.xts(datag)) {
			stop("The input must be a numeric vector or a time series object.")
		}

		if (!delta %in% c("levels", "diff1", "diff2", "diff3")) {
			stop('The argument "diff" must be one of "levels", "diff1", "diff2", or "diff3".')
		}

		data <- switch(delta,
					levels = datag,
					diff1 = stats::na.omit(diff(datag, differences = 1)),
					diff2 = stats::na.omit(diff(datag, differences = 2)),
					diff3 = stats::na.omit(diff(datag, differences = 3)))
	}

	data <- gen(datag, delta)
	ldata = stats::na.omit(NROW(data))

	if (ldata <= lag) {
		stop("Error: the dataset must be greater than the number of lags")
	}

	# ACF-PACF test
	acf_vals <- (stats::acf(data, plot = FALSE, lag.max = lag)$acf)[-1]
	pacf_vals <- (stats::pacf(data, plot = FALSE, lag.max = lag)$acf)

	portest <- lapply(seq(1:lag), function(s) suppressWarnings(stats::Box.test(data, lag = s, type = "Box-Pierce")))
	pstat <- sapply(portest, function(test) unname(test$statistic))
	ppval <- sapply(portest, function(test) test$p.value)

	lbtest <- lapply(seq(1:lag), function(s) suppressWarnings(stats::Box.test(data, lag = s, type = "Ljung-Box")))
	stat <- sapply(lbtest, function(test) unname(test$statistic))
	pval <- sapply(lbtest, function(test) test$p.value)

	# Table ACF-PACF
	table <- data.frame(lag = seq(1:lag), acf = acf_vals, pacf = pacf_vals,
					Box_Pierce = pstat, Pv_Box = ppval, Ljung_Box = stat, Pv_Ljung = pval)

	# Stationarity test
	stationarity_tests <- function(data) {
		adf <- suppressWarnings(tseries::adf.test(data))
		kpss_level <- suppressWarnings(tseries::kpss.test(data))
		kpss_trend <- suppressWarnings(tseries::kpss.test(data, null = "Trend"))
		pp <- suppressWarnings(tseries::pp.test(data))

		data.frame(
			Statistic = c(adf$statistic, kpss_level$statistic, kpss_trend$statistic, pp$statistic),
			P_Value = c(adf$p.value, kpss_level$p.value, kpss_trend$p.value, pp$p.value),
			row.names = c("ADF", "KPSS-Level", "KPSS-Trend", "PP")
		)
	}

	statt <- stationarity_tests(data)

	# Normality Tests

	normality_tests <- function(data) {
		# Verificar si el data contiene solo valores positivos
		if (any(data <= 0, na.rm = TRUE)) {
			# Si hay valores negativos o cero, no se aplica Box-Cox
			resultados <- data.frame(
				Statistic = c(round(stats::shapiro.test(as.vector(data))$statistic, 5), suppressWarnings(round(stats::ks.test(as.vector(data), 'pnorm',mean(data), sd(data))$statistic, 5))),
				P_Value = c(round(stats::shapiro.test(as.vector(data))$p.value, 5), suppressWarnings(round(stats::ks.test(as.vector(data), 'pnorm',mean(data), sd(data))$p.value, 5))),
				row.names = c("Shapiro Wilks", "Kolmogorov Smirnov")
			)
		} else {
			# Si todos los valores son positivos, aplicar Box-Cox
			bc1t <- suppressWarnings(forecast::BoxCox.lambda(data, method = "loglik"))
			bc2t <- suppressWarnings(forecast::BoxCox.lambda(data, method = "guerrero"))

			resultados <- data.frame(
				Statistic = c(round(stats::shapiro.test(as.vector(data))$statistic, 5), suppressWarnings(round(stats::ks.test(as.vector(data), 'pnorm',mean(data), sd(data))$statistic, 5)),
						    round(bc1t, 5), round(bc2t, 5)),
				P_Value = c(round(shapiro.test(as.vector(data))$p.value, 5), suppressWarnings(round(stats::ks.test(as.vector(data), 'pnorm',mean(data), sd(data))$p.value, 5)), NA, NA),
				row.names = c("Shapiro Wilks", "Kolmogorov Smirnov", "Box Cox", "Box Cox Guerrero")
			)
		}

		return(resultados)
	}

	normt <- normality_tests(data)

	# ACF-PACF result for console
	multi_return <- function() {
		tlist <- list(table = table, statt = statt, normt = normt)
		return(tlist)
	}
	tablef <- multi_return()
	tablef <- setNames(tablef, c("ACF-PACF Test", "Stationary Test", "Normality Test"))

	#--------------------plots------------------------------------------------
	get_clim1 <- function(x, ci=0.95, ci.type="white"){
		if (!ci.type %in% c("white", "ma")) stop('`ci.type` must be "white" or "ma"')
		clim0 <- qnorm((1 + ci)/2) / sqrt(ldata)
		if (ci.type == "ma") {
			clim <- clim0 * sqrt(cumsum(c(1, 2 * table$acf^2)))
			return(clim[-length(clim)])
		} else {
			lineci1 <- rep(clim0, NROW(table$acf))
			return(lineci1)
		}
	}

	get_clim2 <- function(x, ci=0.95, ci.type="white"){
		if (!ci.type %in% c("white", "ma")) stop('`ci.type` must be "white" or "ma"')
		clim0 <- qnorm((1 + ci)/2) / sqrt(ldata)
		if (ci.type == "ma") {
			clim <- clim0 * sqrt(cumsum(c(1, 2 * table$pacf^2)))
			return(clim[-length(clim)])
		} else {
			lineci2 <- rep(clim0, NROW(table$pacf))
			return(lineci2)
		}
	}

	saveci1 <- get_clim1(table$acf, ci = ci, ci.type = ci.method)
	saveci2 <- get_clim2(table$pacf, ci = ci, ci.type = ci.method)

	fig1 <- plotly::plot_ly(
		x = table$lag,
		y = table$acf,
		type = "bar",
		name = "acf",
		color = I("slategray"),
		cliponaxis = FALSE,
		showlegend = FALSE
	) %>%
		plotly::layout(bargap = 0.7,
					xaxis = list(range = c(1,lag)))
	fig1 <- fig1 %>% plotly::add_trace(saveci1,
								y = saveci1,
								type = 'scatter',
								mode = 'lines',
								showlegend = FALSE,
								cliponaxis = FALSE,
								line = list(width = 0.8, dash = "dash", color="black"))
	fig1 <- fig1 %>% plotly::add_trace(saveci1,
								y = -saveci1,
								type = 'scatter',
								mode = 'lines',
								showlegend = FALSE,
								cliponaxis = FALSE,
								line = list(width = 0.8, dash = "dash", color="black"))

	fig2 <- plotly::plot_ly(
		x = table$lag,
		y = table$pacf,
		type = "bar",
		name = "pacf",
		color = I("dimgrey"),
		cliponaxis = FALSE,
		showlegend = FALSE
	) %>%
		plotly::layout(bargap = 0.7,
					xaxis = list(range = c(1,lag)))
	fig2 <- fig2 %>% plotly::add_trace(saveci2,
								y = saveci2,
								type = 'scatter',
								mode = 'lines',
								showlegend = FALSE,
								cliponaxis = FALSE,
								line = list(width = 0.8, dash = "dash", color="black"))
	fig2 <- fig2 %>% plotly::add_trace(saveci2,
								y = -saveci2,
								type = 'scatter',
								mode = 'lines',
								showlegend = FALSE,
								cliponaxis = FALSE,
								line = list(width = 0.8, dash = "dash", color="black", showlegend = F))

	hline <- function(y = 0, color = "black") {
		list(type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = y, y1 = y,
			line = list(color = color, dash = "dash")
		)
	}

	fig3 <- plotly::plot_ly(
		x = table$lag,
		y = table$Pv_Ljung,
		type = "scatter",
		mode = "markers",
		name = "Pv Ljung Box",
		color = I("lightslategrey"),
		cliponaxis = FALSE,
		showlegend = FALSE
	) %>%
		plotly::layout(shapes = hline(0.05),
					xaxis = list(range = c(0.5,lag+0.5)))
	fig <- plotly::subplot(fig1, fig2, fig3, nrows = 3, shareX = TRUE, margin = 0.07) %>%
		plotly::layout(
			xaxis = list(
				title = "lags",
				dtick = 1,
				tick0 = 1,
				tickmode = "linear"
			))

	# Update title
	annotations = list(
		list(x = 0.5, y = 1, text = "<b>ACF</b>", xref = "paper", yref = "paper",
			xanchor = "center", yanchor = "bottom", showarrow = FALSE),
		list(x = 0.5, y = 0.6, text = "<b>PACF</b>", xref = "paper", yref = "paper",
			xanchor = "center", yanchor = "bottom", showarrow = FALSE),
		list(x = 0.5, y = 0.3, text = "<b>Pv Ljung</b>", xref = "paper", yref = "paper",
			xanchor = "center", yanchor = "bottom", showarrow = FALSE
		))

	fig <- fig %>% plotly::layout(annotations = annotations)
	print(fig)

	#-------------------download------------------------------

	if (download == TRUE) {

		dpi = 300
		grDevices::tiff("acfpacf.tif", width = 6 * dpi, height = 5 * dpi, res = dpi)

		oldpar <- par(no.readonly = TRUE)
		on.exit(par(oldpar))

		graphics::par(mfrow = c(3, 1), bty = "n", mar = c(4, 3, 3, 2), xpd = FALSE)

		if (max(table$acf) <= 0.6) {
			bp1 <- graphics::barplot(table$acf, ylim = c(-max(saveci1) - 0.05, max(saveci1) + 0.05),
								main = "ACF", width = 0.5, space = 3, border = "slategray", col = I("slategrey"))
			graphics::abline(h = 0, col = "black")
			graphics::abline(h = seq(-max(table$acf), max(table$acf), 0.4), col = 'lightgray', lty = 3)
			graphics::lines(bp1, saveci1, col = "black", lwd = 1, lty = 2)
			graphics::lines(bp1, -saveci1, col = "black", lwd = 1, lty = 2)
		} else {
			bp1 <- graphics::barplot(table$acf, ylim = c(-max(table$acf) - 0.05, max(table$acf) + 0.05),
								main = "ACF", width = 0.5, space = 3, border = "slategray", col = I("slategrey"))
			graphics::abline(h = 0, col = "black")
			graphics::abline(h = seq(-max(table$acf), max(table$acf), 0.4), col = 'lightgray', lty = 3)
			graphics::lines(bp1, saveci1, col = "black", lwd = 1, lty = 2)
			graphics::lines(bp1, -saveci1, col = "black", lwd = 1, lty = 2)
		}

		if (max(table$pacf) <= 0.6) {
			bp2 <- graphics::barplot(table$pacf, ylim = c(-max(saveci2) - 0.05, max(saveci2) + 0.05),
								main = "PACF", width = 0.5, space = 3, border = "dimgray", col = I("dimgray"))
			graphics::abline(h = seq(-max(table$pacf), max(table$pacf), 0.4), col = 'lightgray', lty = 3)
			graphics::abline(h = 0, col = "black")
			graphics::lines(bp2, saveci2, col = "black", lwd = 1, lty = 2)
			graphics::lines(bp2, -saveci2, col = "black", lwd = 1, lty = 2)
		} else {
			bp2 <- graphics::barplot(table$pacf, ylim = c(-max(table$pacf) - 0.05, max(table$pacf) + 0.05),
								main = "PACF", width = 0.5, space = 3, border = "dimgray", col = I("dimgray"))
			graphics::abline(h = seq(-max(table$pacf), max(table$pacf), 0.4), col = 'lightgray', lty = 3)
			graphics::abline(h = 0, col = "black")
			graphics::lines(bp2, saveci2, col = "black", lwd = 1, lty = 2)
			graphics::lines(bp2, -saveci2, col = "black", lwd = 1, lty = 2)
		}

		if (max(table$Pv_Ljung) <= 0.05) {
			graphics::plot(table$Pv_Ljung, ylim = c(0, max(table$Pv_Ljung) + 0.01), main = "Pv Ljung Box",
						col = "lightslategrey", pch = 16, ylab = "", xlab = "lags", xaxt = "n")
			graphics::abline(h = seq(-max(table$Pv_Ljung), max(table$Pv_Ljung), 0.01), col = 'lightgray', lty = 3)
			graphics::abline(h = max(table$Pv_Ljung) + 0.01, col = "black", lwd = 1, lty = 2)
			graphics::axis(1, at = seq(1, lag, by = 1))
			grDevices::dev.off()

		} else {
			graphics::plot(table$Pv_Ljung, ylim = c(0, max(table$Pv_Ljung)), main = "Pv Ljung Box",
						col = "lightslategrey", pch = 16, ylab = "", xlab = "lags", xaxt = "n")
			graphics::abline(h = seq(-max(table$Pv_Ljung), max(table$Pv_Ljung), 0.2), col = 'lightgray', lty = 3)
			graphics::abline(h = 0.05, col = "black", lwd = 1, lty = 2)
			graphics::axis(1, at = seq(1, lag, by = 1))
			grDevices::dev.off()
		}

		wb <- openxlsx::createWorkbook()
		# Agregar hojas y escribir datos
		openxlsx::addWorksheet(wb, "ACF-PACF Test")
		openxlsx::writeData(wb, sheet = "ACF-PACF Test", x = table)

		openxlsx::addWorksheet(wb, "Stationary Test")
		openxlsx::writeData(wb, sheet = "Stationary Test", x = statt,rowNames=TRUE)

		openxlsx::addWorksheet(wb, "Normality Test")
		openxlsx::writeData(wb, sheet = "Normality Test", x = normt,rowNames=TRUE)

		# Guardar el archivo Excel
		openxlsx::saveWorkbook(wb, "table.xlsx", overwrite = TRUE)
		#openxlsx::writeData(wb, sheet = sh, x = tablef)
		#openxlsx::saveWorkbook(wb, "table.xlsx", overwrite = TRUE)
	} else {
		print(fig)
	}

	#---------------------------interactive---------------------------------
	if (is.null(interactive)) {
		return(tablef)
	} else if (interactive == "acftable") {
		figt1 <- reactable::reactable(round(table, 5), minRows = 40, striped = TRUE, highlight = TRUE,
								pagination = FALSE, theme = reactable::reactableTheme(style = list(fontFamily =
																					  	"-apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif")
								))

		print(figt1)

	} else if (interactive == "stattable") {

		figt <- reactable::reactable(t(round(statt, 5)), striped = TRUE, highlight = TRUE,
							    pagination = FALSE, theme = reactable::reactableTheme(style = list(fontFamily =
							    													  	"-apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif")
							    ))
		print(figt)

	} else if (interactive == "normtable") {

		figt <- reactable::reactable(t(round(normt, 5)), striped = TRUE, highlight = TRUE,
							    pagination = FALSE, theme = reactable::reactableTheme(style = list(fontFamily =
							    													  	"-apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif")
							    ))
		print(figt)
	}

	if (!interactive %in% c("acftable", "stattable", "normtable")) {
		stop('`interactive` must be "acftable", "stattable" or "normtable"')
	}
}
