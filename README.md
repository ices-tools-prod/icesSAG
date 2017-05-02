[![Build Status](https://travis-ci.org/ices-tools-prod/icesSAG.svg?branch=release)](https://travis-ci.org/ices-tools-prod/icesSAG) [![codecov](https://codecov.io/gh/ices-tools-prod/icesSAG/branch/master/graph/badge.svg)](https://codecov.io/gh/ices-tools-prod/icesSAG) [![GitHub release](https://img.shields.io/github/release/ices-tools-prod/icesSAG.svg?maxAge=6000)]() [![CRAN Status](http://www.r-pkg.org/badges/version/icesSAG)](https://cran.r-project.org/package=icesSAG) [![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/icesSAG)](https://cran.r-project.org/package=icesSAG) [![License](https://img.shields.io/badge/license-GPL%20(%3E%3D%202)-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)

[<img align="right" alt="ICES Logo" width="17%" height="17%" src="http://ices.dk/_layouts/15/1033/images/icesimg/iceslogo.png">](http://ices.dk)

icesSAG
=======

icesSAG provides R functions that access the [web services](http://sg.ices.dk/webservices.aspx) of the [ICES](http://ices.dk) [Stock Assessment Graphs](http://sg.ices.dk) database.

icesSAG is implemented as an [R](https://www.r-project.org) package and available on [CRAN](https://cran.r-project.org/package=icesSAG).

Installation
------------

icesSAG can be installed from CRAN using the `install.packages` command:

``` r
install.packages("icesSAG")
```

Usage
-----

For a summary of the package:

``` r
library(icesSAG)
?icesSAG
```

Examples
--------

``` r
summary_data <- getSAG(stock = NULL, year = 2017)
head(summary_data)
```

    ##   Year recruitment high_recruitment low_recruitment low_SSB     SSB
    ## 1 1983   363882257        500964928       264310512  344716  485730
    ## 2 1984    98645782        135843627        71633764  156369  212220
    ## 3 1985   717818846        969399186       531529119  356604  484960
    ## 4 1986   108025739        149248399        78188848  244355  310240
    ## 5 1987    67748200         95561249        48030124  851024 1135900
    ## 6 1988   274136290        372843269       201561116  473496  625020
    ##   high_SSB   catches  landings discards low_F     F high_F
    ## 1   684429 378795000 378795000       NA 0.462 0.577  0.692
    ## 2   288020 498626000 498626000       NA 0.524 0.654  0.784
    ## 3   659516 437114000 437114000       NA 0.563 0.702  0.841
    ## 4   393889 382844000 382844000       NA 0.399 0.497  0.595
    ## 5  1516137 373021000 373021000       NA 0.298 0.372  0.447
    ## 6   825034 413646000 413646000       NA 0.437 0.543  0.649
    ##   StockPublishNote Fage fishstock recruitment_age AssessmentYear  units
    ## 1  Stock published  1-2 san.sa.1r               0           2017 tonnes
    ## 2  Stock published  1-2 san.sa.1r               0           2017 tonnes
    ## 3  Stock published  1-2 san.sa.1r               0           2017 tonnes
    ## 4  Stock published  1-2 san.sa.1r               0           2017 tonnes
    ## 5  Stock published  1-2 san.sa.1r               0           2017 tonnes
    ## 6  Stock published  1-2 san.sa.1r               0           2017 tonnes
    ##   stockSizeDescription stockSizeUnits fishingPressureDescription
    ## 1                  SSB         tonnes                          F
    ## 2                  SSB         tonnes                          F
    ## 3                  SSB         tonnes                          F
    ## 4                  SSB         tonnes                          F
    ## 5                  SSB         tonnes                          F
    ## 6                  SSB         tonnes                          F
    ##   fishingPressureUnits
    ## 1             per year
    ## 2             per year
    ## 3             per year
    ## 4             per year
    ## 5             per year
    ## 6             per year

References
----------

ICES Stock Assessment Graphs database: <http://sg.ices.dk>

ICES Stock Assessment Graphs web services: <http://sg.ices.dk/webservices.aspx>

Development
-----------

icesSAG is developed openly on [GitHub](https://github.com/ices-tools-prod/icesSAG).

Feel free to open an [issue](https://github.com/ices-tools-prod/icesSAG/issues) there if you encounter problems or have suggestions for future versions.

The current development version can be installed using:

``` r
library(devtools)
install_github("ices-tools-prod/icesSAG")
```

Dependencies graph (from [MRAN](https://mran.microsoft.com/package/icesSAG/#depend))
------------------------------------------------------------------------------------

[![dependencies](https://mran.microsoft.com/packagedata/graphs/icesSAG.png)](https://mran.microsoft.com/package/icesSAG/#depend)
