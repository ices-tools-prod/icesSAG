[![Build Status](https://travis-ci.org/ices-tools-prod/icesSAG.svg?branch=release)](https://travis-ci.org/ices-tools-prod/icesSAG) [![codecov](https://codecov.io/gh/ices-tools-prod/icesSAG/branch/master/graph/badge.svg)](https://codecov.io/gh/ices-tools-prod/icesSAG) [![GitHub release](https://img.shields.io/github/release/ices-tools-prod/icesSAG.svg?maxAge=6000)]() [![CRAN Status](http://r-pkg.org/badges/version/icesSAG)](https://cran.r-project.org/package=icesSAG) [![CRAN Downloads](http://cranlogs.r-pkg.org/badges/icesSAG)](https://cran.r-project.org/package=icesSAG) [![License](https://img.shields.io/badge/license-GPL%20(%3E%3D%202)-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)

[<img align="right" alt="ICES Logo" width="17%" height="17%" src="http://ices.dk/_layouts/15/1033/images/icesimg/iceslogo.png">](http://ices.dk)

### icesSAG

icesSAG provides R functions that access the [web services](http://sg.ices.dk/webservices.aspx) of the [ICES](http://ices.dk) [Stock Assessment Graphs](http://sg.ices.dk) database.

icesSAG is implemented as an [R](https://www.r-project.org) package and available on [CRAN](https://cran.r-project.org/package=icesSAG).

### Installation

icesSAG can be installed from CRAN using the `install.packages` command:

``` r
install.packages("icesSAG")
```

### Usage

For a summary of the package:

``` r
library(icesSAG)
?icesSAG
```

### Examples

To download the summary data for all stocks published so far in 2017 use:

``` r
summary_data <- getSAG(stock = NULL, year = 2018)
head(summary_data)
```

    ##   Year recruitment high_recruitment low_recruitment low_SSB    SSB
    ## 1 1983   305664912        419413371       222765998  333683 475442
    ## 2 1984    76515202        105588421        55447142  146691 204638
    ## 3 1985   520343641        705099201       383999166  338797 460469
    ## 4 1986    77593949        107332767        56094900  214789 277618
    ## 5 1987    47157329         66359796        33511461  742378 995500
    ## 6 1988   204279559        279162440       149483355  443526 595407
    ##   high_SSB catches landings discards low_F     F high_F StockPublishNote
    ## 1   677425  378795   378795       NA 0.473 0.583  0.719  Stock published
    ## 2   285477  498626   498626       NA 0.535 0.659  0.811  Stock published
    ## 3   625836  437114   437114       NA 0.571 0.704  0.867  Stock published
    ## 4   358824  382844   382844       NA 0.385 0.472  0.578  Stock published
    ## 5  1334927  373021   373021       NA 0.299 0.369  0.455  Stock published
    ## 6   799298  413646   413646       NA 0.417 0.511  0.625  Stock published
    ##   Fage fishstock recruitment_age AssessmentYear  units
    ## 1  1-2 san.sa.1r               0           2018 tonnes
    ## 2  1-2 san.sa.1r               0           2018 tonnes
    ## 3  1-2 san.sa.1r               0           2018 tonnes
    ## 4  1-2 san.sa.1r               0           2018 tonnes
    ## 5  1-2 san.sa.1r               0           2018 tonnes
    ## 6  1-2 san.sa.1r               0           2018 tonnes
    ##   stockSizeDescription stockSizeUnits fishingPressureDescription
    ## 1                  SSB         tonnes                          F
    ## 2                  SSB         tonnes                          F
    ## 3                  SSB         tonnes                          F
    ## 4                  SSB         tonnes                          F
    ## 5                  SSB         tonnes                          F
    ## 6                  SSB         tonnes                          F
    ##   fishingPressureUnits
    ## 1               Year-1
    ## 2               Year-1
    ## 3               Year-1
    ## 4               Year-1
    ## 5               Year-1
    ## 6               Year-1

#### Authorised access via tokens

ICES provides public access to the results of published stock assessments. If you are an ICES stock assessor and wish to access unpublished results, or to upload your results, this can be done using token authentication.

You can generate a token from [sg.ices.dk/manage/CreateToken.aspx](https://sg.ices.dk/manage/CreateToken.aspx), which will be something like 'e9351534-20ac-4ad4-9752-98923e011213'

Then create a file with the following contents (substitute the access token with your own)

    # Standard Graphs personal access token
    SG_PAT=e9351534-20ac-4ad4-9752-98923e011213

this should be saved in your home directory in a file called `.Renviron_SG`.

A quick way to do this from R is

``` r
pat <- "e9351534-20ac-4ad4-9752-98923e011213"
cat("# Standard Graphs personal access token\nSG_PAT=", pat, sep = "", 
    file = "~/.Renviron_SG_")
```

### References

ICES Stock Assessment Graphs database: <http://sg.ices.dk>

ICES Stock Assessment Graphs web services: <http://sg.ices.dk/webservices.aspx>

### Development

icesSAG is developed openly on [GitHub](https://github.com/ices-tools-prod/icesSAG).

Feel free to open an [issue](https://github.com/ices-tools-prod/icesSAG/issues) there if you encounter problems or have suggestions for future versions.

The current development version can be installed using:

``` r
library(devtools)
install_github("ices-tools-prod/icesSAG")
```
