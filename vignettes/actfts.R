## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----include = FALSE----------------------------------------------------------
library(actfts)

## -----------------------------------------------------------------------------
GDP_data <- actfts::GDPEEUU
head(GDP_data)

## -----------------------------------------------------------------------------
PCEC_data <- actfts::PCECEEUU
head(PCEC_data)

## -----------------------------------------------------------------------------
DPI_data <- actfts::DPIEEUU
head(DPI_data)

## -----------------------------------------------------------------------------
result <- acfinter(GDP_data, lag = 10)
print(result)

## ----echo=FALSE, fig.align='center', message=FALSE, warning=FALSE, , fig.dim=c(7.6, 4)----
library(dplyr)
library(plotly)

ldata <- nrow(GDP_data)
result <- acfinter(GDP_data, lag = 10)
table <- result$`ACF-PACF Test`

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

saveci1 <- get_clim1(table$acf)
saveci2 <- get_clim2(table$pacf)

lag <- 10

fig1 <- plot_ly(
  x = table$lag,
  y = table$acf,
  type = "bar",
  name = "acf",
  color = I("slategray"),
  cliponaxis = FALSE,
  showlegend = FALSE
) %>%
  layout(bargap = 0.7,
         xaxis = list(range = c(1,lag)))

fig1 <- fig1 %>% add_trace(
  y = saveci1,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

fig1 <- fig1 %>% add_trace(
  y = -saveci1,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

fig2 <- plot_ly(
  x = table$lag,
  y = table$pacf,
  type = "bar",
  name = "pacf",
  color = I("dimgrey"),
  cliponaxis = FALSE,
  showlegend = FALSE
) %>%
  layout(bargap = 0.7,
         xaxis = list(range = c(1,lag)))

fig2 <- fig2 %>% add_trace(
  y = saveci2,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

fig2 <- fig2 %>% add_trace(
  y = -saveci2,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

hline <- function(y = 0, color = "black") {
  list(type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = y, y1 = y,
       line = list(color = color, dash = "dash")
  )
}

fig3 <- plot_ly(
  x = table$lag,
  y = table$Pv_Ljung,
  type = "scatter",
  mode = "markers",
  name = "Pv Ljung Box",
  color = I("lightslategrey"),
  cliponaxis = FALSE,
  showlegend = FALSE
) %>%
  layout(shapes = hline(0.05),
         xaxis = list(range = c(0.5,lag+0.5)))

fig <- subplot(fig1, fig2, fig3, nrows = 3, shareX = TRUE, margin = 0.07) %>%
  layout(
    xaxis = list(
      title = "lags",
      dtick = 1,
      tick0 = 1,
      tickmode = "linear"
    )
  )

#htmltools::tagList(fig)
fig

## -----------------------------------------------------------------------------
result <- acfinter(GDP_data, lag = 10, ci.method = "ma", ci = 0.98)
print(result)

## ----echo=FALSE, fig.align='center', message=FALSE, warning=FALSE, , fig.dim=c(7.6, 4)----
library(dplyr)
library(plotly)

ldata <- nrow(GDP_data)
result <- acfinter(GDP_data, lag = 10, ci.method = "ma", ci = 0.98)
table <- result$`ACF-PACF Test`

get_clim1 <- function(x, ci=0.95, ci.type="ma"){
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

get_clim2 <- function(x, ci=0.95, ci.type="ma"){
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

saveci1 <- get_clim1(table$acf)
saveci2 <- get_clim2(table$pacf)

lag <- 10

fig1 <- plot_ly(
  x = table$lag,
  y = table$acf,
  type = "bar",
  name = "acf",
  color = I("slategray"),
  cliponaxis = FALSE,
  showlegend = FALSE
) %>%
  layout(bargap = 0.7,
         xaxis = list(range = c(1,lag)))

fig1 <- fig1 %>% add_trace(
  y = saveci1,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

fig1 <- fig1 %>% add_trace(
  y = -saveci1,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

fig2 <- plot_ly(
  x = table$lag,
  y = table$pacf,
  type = "bar",
  name = "pacf",
  color = I("dimgrey"),
  cliponaxis = FALSE,
  showlegend = FALSE
) %>%
  layout(bargap = 0.7,
         xaxis = list(range = c(1,lag)))

fig2 <- fig2 %>% add_trace(
  y = saveci2,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

fig2 <- fig2 %>% add_trace(
  y = -saveci2,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

hline <- function(y = 0, color = "black") {
  list(type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = y, y1 = y,
       line = list(color = color, dash = "dash")
  )
}

fig3 <- plot_ly(
  x = table$lag,
  y = table$Pv_Ljung,
  type = "scatter",
  mode = "markers",
  name = "Pv Ljung Box",
  color = I("lightslategrey"),
  cliponaxis = FALSE,
  showlegend = FALSE
) %>%
  layout(shapes = hline(0.05),
         xaxis = list(range = c(0.5,lag+0.5)))

fig <- subplot(fig1, fig2, fig3, nrows = 3, shareX = TRUE, margin = 0.07) %>%
  layout(
    xaxis = list(
      title = "lags",
      dtick = 1,
      tick0 = 1,
      tickmode = "linear"
    )
  )

#htmltools::tagList(fig)
fig

## -----------------------------------------------------------------------------
result <- acfinter(GDP_data, lag = 10, delta = "diff1")
print(result)

## ----echo=FALSE, fig.align='center', message=FALSE, warning=FALSE, , fig.dim=c(7.6, 4)----
library(dplyr)
library(plotly)

ldata <- nrow(GDP_data)
result <- acfinter(GDP_data, lag = 10, delta = "diff1")
table <- result$`ACF-PACF Test`

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

saveci1 <- get_clim1(table$acf)
saveci2 <- get_clim2(table$pacf)

lag <- 10

fig1 <- plot_ly(
  x = table$lag,
  y = table$acf,
  type = "bar",
  name = "acf",
  color = I("slategray"),
  cliponaxis = FALSE,
  showlegend = FALSE
) %>%
  layout(bargap = 0.7,
         xaxis = list(range = c(1,lag)))

fig1 <- fig1 %>% add_trace(
  y = saveci1,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

fig1 <- fig1 %>% add_trace(
  y = -saveci1,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

fig2 <- plot_ly(
  x = table$lag,
  y = table$pacf,
  type = "bar",
  name = "pacf",
  color = I("dimgrey"),
  cliponaxis = FALSE,
  showlegend = FALSE
) %>%
  layout(bargap = 0.7,
         xaxis = list(range = c(1,lag)))

fig2 <- fig2 %>% add_trace(
  y = saveci2,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

fig2 <- fig2 %>% add_trace(
  y = -saveci2,
  type = 'scatter',
  mode = 'lines',
  showlegend = FALSE,
  cliponaxis = FALSE,
  line = list(width = 0.8, dash = "dash", color="black")
)

hline <- function(y = 0, color = "black") {
  list(type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = y, y1 = y,
       line = list(color = color, dash = "dash")
  )
}

fig3 <- plot_ly(
  x = table$lag,
  y = table$Pv_Ljung,
  type = "scatter",
  mode = "markers",
  name = "Pv Ljung Box",
  color = I("lightslategrey"),
  cliponaxis = FALSE,
  showlegend = FALSE
) %>%
  layout(shapes = hline(0.05),
         xaxis = list(range = c(0.5,lag+0.5)))

fig <- subplot(fig1, fig2, fig3, nrows = 3, shareX = TRUE, margin = 0.07) %>%
  layout(
    xaxis = list(
      title = "lags",
      dtick = 1,
      tick0 = 1,
      tickmode = "linear"
    )
  )

#htmltools::tagList(fig)
fig

