
<!-- README.md is generated from README.Rmd. Please edit that file -->

# actfts: Tools for Analysis of Time Series

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
result <- actfts::acfinter(data, lag = 15)
print(result)
#> $`ACF-PACF Test`
#>    lag       acf          pacf Box_Pierce Pv_Box Ljung_Box Pv_Ljung
#> 1    1 0.9853471  0.9853470819   300.9818      0  303.9039        0
#> 2    2 0.9709040 -0.0001677573   593.2047      0  599.9219        0
#> 3    3 0.9565352 -0.0047242367   876.8421      0  888.1789        0
#> 4    4 0.9422924 -0.0029745719  1152.0958      0 1168.8297        0
#> 5    5 0.9284525  0.0065815855  1419.3232      0 1442.1902        0
#> 6    6 0.9146149 -0.0068823059  1678.6445      0 1708.3357        0
#> 7    7 0.9010486  0.0021906137  1930.3300      0 1967.4970        0
#> 8    8 0.8877256  0.0014678003  2174.6276      0 2219.8839        0
#> 9    9 0.8747132  0.0039691400  2411.8158      0 2465.7401        0
#> 10  10 0.8620923  0.0067800862  2642.2087      0 2705.3488        0
#> 11  11 0.8496976  0.0015469450  2866.0243      0 2938.8955        0
#> 12  12 0.8380870  0.0207369256  3083.7652      0 3166.8658        0
#> 13  13 0.8268790  0.0083976165  3295.7211      0 3389.5266        0
#> 14  14 0.8163257  0.0172549567  3502.3013      0 3607.2733        0
#> 15  15 0.8062809  0.0127308937  3703.8289      0 3820.4143        0
#> 
#> $`Stationary Test`
#>            Statistic P_Value
#> ADF         2.586751    0.99
#> KPSS-Level  4.708600    0.01
#> KPSS-Trend  1.215522    0.01
#> PP          3.431542    0.99
#> 
#> $`Normality Test`
#>                    Statistic P_Value
#> Shapiro Wilks        0.84705       0
#> Kolmogorov Smirnov   0.17555       0
#> Box Cox              0.15000      NA
#> Box Cox Guerrero    -0.00578      NA
```

<img src="man/figures/README-plot_example_1.png">

## References

- U.S. Bureau of Economic Analysis, Gross Domestic Product (GDP),
  retrieved from FRED, Federal Reserve Bank of St. Louis;
  <https://fred.stlouisfed.org/series/GDP>.
