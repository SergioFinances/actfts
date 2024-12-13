
<!-- README.md is generated from README.Rmd. Please edit that file -->

# actfts: Autocorrelation Tools Featured for Time Series

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The actfts package offers a flexible approach to time series analysis by
focusing on Autocorrelation (ACF), Partial Autocorrelation (PACF), and
stationarity tests, generating interactive plots for dynamic data
visualization. It processes input data by validating and transforming it
according to specified differences. It calculates ACF and PACF up to
several lags and performs Box-Pierce, Ljung-Box, ADF, KPSS, and PP
tests. The function organizes results into tables, with options to save
them as TIFF files or Excel spreadsheets, and interactive mode provides
on-screen visualization of the ACF-PACF and stationarity test outcomes.

## Installation

You can install the development version of actfts from:

``` r
install.packages("actfts")
devtools::install_github("SergioFinances/actfts")
```

## Example

This is a basic example which shows you how to use actfts packcage:

``` r
library(actfts)
data <- actfts::GDPEEUU
result <- actfts::acfinter(data, lag = 10)
print(result)
#> $`ACF-PACF Test`
#>    lag       acf          pacf Box_Pierce Pv_Box Ljung_Box Pv_Ljung
#> 1    1 0.9849981  0.9849981360   300.7686      0  303.6887        0
#> 2    2 0.9702311  0.0003276145   592.5866      0  599.2965        0
#> 3    3 0.9555439 -0.0047507255   875.6365      0  886.9564        0
#> 4    4 0.9409487 -0.0043825005  1150.1057      0 1166.8073        0
#> 5    5 0.9267058  0.0043661368  1416.3286      0 1439.1403        0
#> 6    6 0.9125019 -0.0058830766  1674.4531      0 1704.0575        0
#> 7    7 0.8985872  0.0023755846  1924.7654      0 1961.8049        0
#> 8    8 0.8849702  0.0028907399  2167.5489      0 2212.6275        0
#> 9    9 0.8716864  0.0043086528  2403.0984      0 2456.7851        0
#> 10  10 0.8588828  0.0093318494  2631.7791      0 2694.6130        0
#> 
#> $`Stationary Test`
#>            Statistic P_Value
#> ADF         2.548975    0.99
#> KPSS-Level  4.698172    0.01
#> KPSS-Trend  1.206680    0.01
#> PP          3.713440    0.99
#> 
#> $`Normality Test`
#>                    Statistic P_Value
#> Shapiro Wilks        0.84660       0
#> Kolmogorov Smirnov   0.17612       0
#> Box Cox              0.10000      NA
#> Box Cox Guerrero    -0.00772      NA
```

<img src="https://i.ibb.co/FnLbh00/Example.png" alt="Example" width="600">

## References

- U.S. Bureau of Economic Analysis, Gross Domestic Product (GDP),
  retrieved from FRED, Federal Reserve Bank of St. Louis;
  <https://fred.stlouisfed.org/series/GDP>.
- U.S. Bureau of Economic Analysis, Personal Consumption Expenditures
  (PCEC), retrieved from FRED, Federal Reserve Bank of St. Louis;
  <https://fred.stlouisfed.org/series/PCEC>.
- U.S. Bureau of Economic Analysis, Disposable Personal Income (DPI),
  retrieved from FRED, Federal Reserve Bank of
  St. Louis;<https://fred.stlouisfed.org/series/DPI>.
