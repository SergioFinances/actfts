
<!-- README.md is generated from README.Rmd. Please edit that file -->

# actfts: Tools for Analysis of Time Series

<!-- badges: start -->
<!-- badges: end -->

The **actfts package** offers a flexible approach to time series
analysis, allowing users to focus on calculating Autocorrelation (ACF)
and Partial Autocorrelation (PACF) functions and stationarity tests. It
generates interactive plots to visualize these results, providing a
dynamic data view. The process begins by validating and transforming the
input data series based on the specified difference type (levels,
first-order, second-order, or third-order differences). It then
calculates the ACF and PACF functions up to a specified number of lags
and conducts Box-Pierce and Ljung-Box tests to evaluate the independence
of observations at different lags.

Additionally, the function performs stationarity tests, including ADF,
KPSS (level and trend), and PP tests, organizing the results into
tables. It also performs Box and Cox variance stabilization tests. It
generates interactive plots for the ACF, PACF, and Ljung-Box p-values,
displaying confidence lines calculated according to the specified
method. The function saves the results to a TIFF file and an Excel
spreadsheet if the download option is enabled. In interactive mode, the
function displays tables with the ACF-PACF and stationarity test
results.

## Installation

You can install the development version of actfts from:

``` r
install.packages("actfts")
devtools::install_github("SergioFinances/actfts")
```

## Example

This is a basic example which shows you how to use this actfts:

- example one

``` r
library(actfts)
#> Registered S3 method overwritten by 'quantmod':
#>   method            from
#>   as.zoo.data.frame zoo
data <- actfts::GDPEEUU
## basic example code
```
