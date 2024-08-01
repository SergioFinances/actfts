
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

``` r
library(actfts)
data <- actfts::GDPEEUU
```

- **Example 1** It shows the ACF, PAC, and Pv Ljung plots and a list of
  two elements, the ACF-PACF Test and the Stationary test, with the
  default arguments.

``` r
result <- actfts::acfinter(data)
print(result)
#> $`ACF-PACF Test`
#>    lag       acf          pacf Box_Pierce Pv_Box Ljung_Box Pv_Ljung
#> 1    1 0.9853471  9.853471e-01   300.9818      0  303.9039        0
#> 2    2 0.9709040 -1.677573e-04   593.2047      0  599.9219        0
#> 3    3 0.9565352 -4.724237e-03   876.8421      0  888.1789        0
#> 4    4 0.9422924 -2.974572e-03  1152.0958      0 1168.8297        0
#> 5    5 0.9284525  6.581585e-03  1419.3232      0 1442.1902        0
#> 6    6 0.9146149 -6.882306e-03  1678.6445      0 1708.3357        0
#> 7    7 0.9010486  2.190614e-03  1930.3300      0 1967.4970        0
#> 8    8 0.8877256  1.467800e-03  2174.6276      0 2219.8839        0
#> 9    9 0.8747132  3.969140e-03  2411.8158      0 2465.7401        0
#> 10  10 0.8620923  6.780086e-03  2642.2087      0 2705.3488        0
#> 11  11 0.8496976  1.546945e-03  2866.0243      0 2938.8955        0
#> 12  12 0.8380870  2.073693e-02  3083.7652      0 3166.8658        0
#> 13  13 0.8268790  8.397617e-03  3295.7211      0 3389.5266        0
#> 14  14 0.8163257  1.725496e-02  3502.3013      0 3607.2733        0
#> 15  15 0.8062809  1.273089e-02  3703.8289      0 3820.4143        0
#> 16  16 0.7964968  4.983722e-03  3900.4951      0 4029.1213        0
#> 17  17 0.7886462  6.232031e-02  4093.3035      0 4234.4327        0
#> 18  18 0.7784253 -8.367989e-02  4281.1468      0 4435.1419        0
#> 19  19 0.7677586 -2.008731e-02  4463.8773      0 4631.0591        0
#> 20  20 0.7571473 -2.451563e-03  4641.5916      0 4822.2552        0
#> 21  21 0.7467256  3.305633e-03  4814.4473      0 5008.8676        0
#> 22  22 0.7364485 -1.350664e-03  4982.5778      0 5191.0090        0
#> 23  23 0.7262156 -1.563461e-03  5146.0684      0 5368.7409        0
#> 24  24 0.7159663 -4.742656e-03  5304.9768      0 5542.0955        0
#> 25  25 0.7057935 -1.272239e-03  5459.4016      0 5711.1501        0
#> 26  26 0.6957078 -1.092960e-03  5609.4445      0 5875.9859        0
#> 27  27 0.6858074  9.843523e-04  5755.2474      0 6036.7298        0
#> 28  28 0.6761336  5.400986e-03  5896.9660      0 6193.5248        0
#> 29  29 0.6665658 -3.282423e-03  6034.7020      0 6346.4559        0
#> 30  30 0.6570151 -4.295442e-03  6168.5194      0 6495.5667        0
#> 31  31 0.6474978 -5.395362e-03  6298.4879      0 6640.9079        0
#> 32  32 0.6380463 -4.655845e-03  6424.6899      0 6782.5446        0
#> 33  33 0.6286451 -6.795341e-04  6547.2002      0 6920.5346        0
#> 34  34 0.6193089 -1.333901e-02  6666.0987      0 7054.9416        0
#> 35  35 0.6099188 -2.153745e-03  6781.4190      0 7185.7777        0
#> 36  36 0.6003983 -6.493141e-03  6893.1672      0 7313.0238        0
#> 37  37 0.5908763 -4.182462e-03  7001.3990      0 7436.7173        0
#> 38  38 0.5814360 -2.958108e-03  7106.2000      0 7556.9302        0
#> 39  39 0.5720286 -4.256400e-03  7207.6372      0 7673.7140        0
#> 40  40 0.5625910 -6.598211e-03  7305.7549      0 7787.0944        0
#> 41  41 0.5533428  1.979546e-03  7400.6732      0 7897.1856        0
#> 42  42 0.5443238  2.861791e-03  7492.5226      0 8004.1147        0
#> 43  43 0.5351626 -1.006855e-02  7581.3063      0 8107.8620        0
#> 44  44 0.5261133 -1.566355e-03  7667.1128      0 8208.5072        0
#> 45  45 0.5171509 -3.797766e-03  7750.0208      0 8306.1196        0
#> 46  46 0.5081043 -8.933051e-03  7830.0535      0 8400.7037        0
#> 47  47 0.4991636 -2.268563e-03  7907.2944      0 8492.3355        0
#> 48  48 0.4902296 -5.056503e-03  7981.7952      0 8581.0540        0
#> 49  49 0.4813077 -4.954150e-03  8053.6089      0 8666.9003        0
#> 50  50 0.4724102 -5.660171e-03  8122.7920      0 8749.9200        0
#> 51  51 0.4636808  8.438027e-04  8189.4420      0 8830.2088        0
#> 52  52 0.4550695 -1.481652e-03  8253.6393      0 8907.8428        0
#> 53  53 0.4464540 -4.564088e-03  8315.4289      0 8982.8558        0
#> 54  54 0.4379567 -8.785929e-04  8374.8888      0 9055.3225        0
#> 55  55 0.4293781 -8.040522e-03  8432.0421      0 9125.2513        0
#> 56  56 0.4208662 -3.437919e-03  8486.9519      0 9192.6995        0
#> 57  57 0.4124194 -2.306295e-03  8539.6797      0 9257.7236        0
#> 58  58 0.4041180 -3.198863e-04  8590.3062      0 9320.4040        0
#> 59  59 0.3958178 -7.609614e-03  8638.8745      0 9380.7757        0
#> 60  60 0.3876412 -6.163042e-05  8685.4568      0 9438.9105        0
#> 61  61 0.3794132 -7.312705e-03  8730.0827      0 9494.8272        0
#> 62  62 0.3709997 -1.254488e-02  8772.7513      0 9548.5071        0
#> 63  63 0.3622311 -1.703598e-02  8813.4268      0 9599.8867        0
#> 64  64 0.3529522 -2.391924e-02  8852.0452      0 9648.8660        0
#> 65  65 0.3435607 -1.014675e-02  8888.6357      0 9695.4630        0
#> 66  66 0.3342055 -5.331364e-03  8923.2606      0 9739.7375        0
#> 67  67 0.3246970 -1.128689e-02  8955.9434      0 9781.7005        0
#> 68  68 0.3152237 -6.257603e-03  8986.7468      0 9821.4140        0
#> 69  69 0.3057848 -6.257278e-03  9015.7332      0 9858.9399        0
#> 70  70 0.2964141 -4.549997e-03  9042.9702      0 9894.3480        0
#> 71  71 0.2870980 -6.333469e-03  9068.5220      0 9927.7044        0
#> 72  72 0.2778348 -4.980027e-03  9092.4516      0 9959.0743        0
#> 
#> $`Stationary Test`
#>                ADF KPSS-Level KPSS-Trend       PP
#> Statistic 2.586751     4.7086   1.215522 3.431542
#> P_Value   0.990000     0.0100   0.010000 0.990000
```

- **Example 2** Shows the ACF, PAC, and Pv Ljung plots and a list with
  two elements, ACF-PACF Test and Stationary test with 25 lags, method
  of moviles average to calculate the confidence interval and
  confidential interval equals to 98%.

``` r
result <- actfts::acfinter(data, lag = 15, ci.method = "ma", ci = 0.98)
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
#>                ADF KPSS-Level KPSS-Trend       PP
#> Statistic 2.586751     4.7086   1.215522 3.431542
#> P_Value   0.990000     0.0100   0.010000 0.990000
```

- **Example 3** The time series transformation’s first difference shows
  the ACF, PAC, and Pv Ljung plots and a list with two elements: the
  ACF-PACF Test and the Stationary Test.

``` r
result <- actfts::acfinter(data, lag = 15, delta = "diff1")
print(result)
#> $`ACF-PACF Test`
#>    lag       acf         pacf Box_Pierce       Pv_Box  Ljung_Box     Pv_Ljung
#> 1    1 0.1312146  0.131214621   5.320139 2.108034e-02   5.371958 2.046299e-02
#> 2    2 0.2621484  0.249222071  26.555173 1.712448e-06  26.883671 1.453065e-06
#> 3    3 0.2523588  0.210289294  46.233823 5.058002e-10  46.883867 3.679027e-10
#> 4    4 0.1955710  0.109469830  58.052459 7.439938e-12  58.935000 4.855782e-12
#> 5    5 0.2656124  0.162653332  79.852400 8.881784e-16  81.236914 4.440892e-16
#> 6    6 0.1344658  0.008612336  85.439441 2.220446e-16  86.971468 1.110223e-16
#> 7    7 0.1972724  0.057082491  97.464612 0.000000e+00  99.355004 0.000000e+00
#> 8    8 0.1575084  0.029384349 105.130559 0.000000e+00 107.275635 0.000000e+00
#> 9    9 0.1578995  0.037367489 112.834624 0.000000e+00 115.262182 0.000000e+00
#> 10  10 0.1563879  0.029506147 120.391895 0.000000e+00 123.122754 0.000000e+00
#> 11  11 0.1376692  0.029070032 126.248310 0.000000e+00 129.234651 0.000000e+00
#> 12  12 0.2039234  0.094583732 139.097999 0.000000e+00 142.690049 0.000000e+00
#> 13  13 0.1025867 -0.011282673 142.349926 0.000000e+00 146.106770 0.000000e+00
#> 14  14 0.1213209 -0.013721330 146.898023 0.000000e+00 150.901543 0.000000e+00
#> 15  15 0.1334143  0.016219846 152.398034 0.000000e+00 156.719582 0.000000e+00
#> 
#> $`Stationary Test`
#>                 ADF KPSS-Level KPSS-Trend        PP
#> Statistic -5.464131   2.761664 0.19985982 -375.4593
#> P_Value    0.010000   0.010000 0.01605257    0.0100
```

- **Example 4** When we use the interactive argument with a value equal
  to “stattable”, the function interactively shows the ACF-PACF Test,
  the Stationary Test, and the plot. Additionally, with the argument
  download equals true, the function saves the results in an xlsx
  format.

## References

- U.S. Bureau of Economic Analysis, Personal Consumption Expenditures
  (PCEC), retrieved from FRED, Federal Reserve Bank of St. Louis;
  <https://fred.stlouisfed.org/series/PCEC>.
- U.S. Bureau of Economic Analysis, Gross Domestic Product (GDP),
  retrieved from FRED, Federal Reserve Bank of St. Louis;
  <https://fred.stlouisfed.org/series/GDP>.
- U.S. Bureau of Economic Analysis, Disposable Personal Income (DPI),
  retrieved from FRED, Federal Reserve Bank of St. Louis;
  <https://fred.stlouisfed.org/series/DPI>.
