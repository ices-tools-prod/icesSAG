[![Build
Status](https://travis-ci.org/ices-tools-prod/icesSAG.svg?branch=release)](https://travis-ci.org/ices-tools-prod/icesSAG)
[![codecov](https://codecov.io/gh/ices-tools-prod/icesSAG/branch/master/graph/badge.svg)](https://codecov.io/gh/ices-tools-prod/icesSAG)
[![GitHub
release](https://img.shields.io/github/release/ices-tools-prod/icesSAG.svg?maxAge=6000)]()
[![CRAN
Status](http://r-pkg.org/badges/version/icesSAG)](https://cran.r-project.org/package=icesSAG)
[![CRAN
Monthly](http://cranlogs.r-pkg.org/badges/icesSAG)](https://cran.r-project.org/package=icesSAG)
[![CRAN
Total](http://cranlogs.r-pkg.org/badges/grand-total/icesSAG)](https://cran.r-project.org/package=icesSAG)
[![License](https://img.shields.io/badge/license-GPL%20\(%3E%3D%202\)-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)

[<img align="right" alt="ICES Logo" width="17%" height="17%" src="http://ices.dk/_layouts/15/1033/images/icesimg/iceslogo.png">](http://ices.dk)

### icesSAG

icesSAG provides R functions that access the [web
services](http://sg.ices.dk/webservices.aspx) of the
[ICES](http://ices.dk) [Stock Assessment Graphs](http://sg.ices.dk)
database.

icesSAG is implemented as an [R](https://www.r-project.org) package and
available on [CRAN](https://cran.r-project.org/package=icesSAG).

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

To download the summary data for all sandeel stocks published in 2018
use:

``` r
summary_data <- getSAG(stock = "sandeel", year = 2018)
head(summary_data)
```

    ##   Year recruitment high_recruitment low_recruitment low_SSB SSB high_SSB
    ## 1 1970          NA               NA              NA      NA  NA       NA
    ## 2 1971          NA               NA              NA      NA  NA       NA
    ## 3 1972          NA               NA              NA      NA  NA       NA
    ## 4 1973          NA               NA              NA      NA  NA       NA
    ## 5 1974          NA               NA              NA      NA  NA       NA
    ## 6 1975          NA               NA              NA      NA  NA       NA
    ##   catches landings discards low_F  F high_F StockPublishNote Purpose Fage
    ## 1      NA        0       NA    NA NA     NA  Stock published  Advice <NA>
    ## 2      NA        0       NA    NA NA     NA  Stock published  Advice <NA>
    ## 3      NA        0       NA    NA NA     NA  Stock published  Advice <NA>
    ## 4      NA        0       NA    NA NA     NA  Stock published  Advice <NA>
    ## 5      NA        0       NA    NA NA     NA  Stock published  Advice <NA>
    ## 6      NA        0       NA    NA NA     NA  Stock published  Advice <NA>
    ##   fishstock recruitment_age AssessmentYear  units stockSizeDescription
    ## 1 san.27.6a              NA           2018 tonnes                 <NA>
    ## 2 san.27.6a              NA           2018 tonnes                 <NA>
    ## 3 san.27.6a              NA           2018 tonnes                 <NA>
    ## 4 san.27.6a              NA           2018 tonnes                 <NA>
    ## 5 san.27.6a              NA           2018 tonnes                 <NA>
    ## 6 san.27.6a              NA           2018 tonnes                 <NA>
    ##   stockSizeUnits fishingPressureDescription fishingPressureUnits
    ## 1           <NA>                       <NA>                 <NA>
    ## 2           <NA>                       <NA>                 <NA>
    ## 3           <NA>                       <NA>                 <NA>
    ## 4           <NA>                       <NA>                 <NA>
    ## 5           <NA>                       <NA>                 <NA>
    ## 6           <NA>                       <NA>                 <NA>

``` r
ggplot(summary_data[complete.cases(summary_data[c("Year", "recruitment")]),], 
       aes(x=Year, y=recruitment, group = fishstock, colour = fishstock)) +
    geom_line()
```

![](README_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

#### verbose web service calls

If you want to see all the web service calls being made set this option

``` r
options(icesSAG.messages = TRUE)
```

The result will
    be

``` r
codKeys <- findAssessmentKey("cod", year = 2017)
```

    ## GETing ... http://sg.ices.dk/StandardGraphsWebServices.asmx/getListStocks?year=2017

which allows you to investigate the actual web service data if you are
interested:
<http://sg.ices.dk/StandardGraphsWebServices.asmx/getListStocks?year=2017>

#### Authorised access via tokens

ICES provides public access to the results of published stock
assessments. If you are an ICES stock assessor and wish to access
unpublished results, or to upload your results, this can be done using
token authentication.

You can generate a token from
[sg.ices.dk/manage/CreateToken.aspx](https://sg.ices.dk/manage/CreateToken.aspx),
which will be something like `e9351534-20ac-4ad4-9752-98923e011213`

Then create a file with the following contents (substitute the access
token with your own)

    # Standard Graphs personal access token
    SG_PAT=e9351534-20ac-4ad4-9752-98923e011213

this should be saved in your home directory in a file called
`.Renviron_SG`.

A quick way to do this from R is

``` r
cat("# Standard Graphs personal access token",
    "SG_PAT=e9351534-20ac-4ad4-9752-98923e011213",
    sep = "\n",
    file = "~/.Renviron_SG")
```

Once you have created this file, you should be able to access
unpublished results and upload data to the SAG database. To switch to
using authorised access run set the following flag

``` r
options(icesSAG.use_token = TRUE)
```

#### uploading data

To upload the results of a stock assessment to SAG you must provide two
pieces of information, Stock information, such as stock code, assessment
year and reference points, and yearly results, such as landings and
estimated fishing mortality. There are two helper functions to create
the required objects.

``` r
stockInfo()
```

returns a `list` (it requires a stock code, assessment year and contact
email as a minimum), with the correctly named elements. And,

``` r
stockFishdata()
```

returns a `data.frame` (it requires year as default) with the correctly
named columns

A simple (almost) minimal example
is:

``` r
info <- stockInfo("whb-comb", 1996, "colin.millar@ices.dk", Purpose = "")
fishdata <- stockFishdata(1950:1996)

# simulate some landings for something a bit intesting
set.seed(1232)
fishdata$Landings <- 10^6 * exp(cumsum(cumsum(rnorm(nrow(fishdata), 0, 0.1))))

key <- icesSAG::uploadStock(info, fishdata)
```

You can check that the data was uploaded by searching for our stock.
Note you will need to make sure the icesSAG.use\_token option is set to
TRUE

``` r
options(icesSAG.use_token = TRUE)
findAssessmentKey('whb-comb', 1996, full = TRUE)
```

    ##   AssessmentKey StockKeyLabel    Purpose StockDatabaseID StockKey
    ## 1          9331      whb-comb InitAdvice              NA   136737
    ## 2          9344      whb-comb      Bench              NA   136737
    ## 3         10081      whb-comb     Advice              NA   136737
    ##                                              StockDescription
    ## 1 Blue whiting in Subareas I-IX, XII and XIV (Combined stock)
    ## 2 Blue whiting in Subareas I-IX, XII and XIV (Combined stock)
    ## 3 Blue whiting in Subareas I-IX, XII and XIV (Combined stock)
    ##          Status AssessmentYear              SpeciesName ModifiedDate
    ## 1 Not Published           1996 Micromesistius poutassou   12/03/2019
    ## 2 Not Published           1996 Micromesistius poutassou   12/03/2019
    ## 3 Not Published           1996 Micromesistius poutassou   12/03/2019
    ##                            SAGStamp
    ## 1  whb-comb_1996_9331_2019312010643
    ## 2  whb-comb_1996_9344_2019312010643
    ## 3 whb-comb_1996_10081_2019312010643

We can also look at the landings graph created from the data that were
uploaded

``` r
plot(getLandingsGraph(key))
```

![](README_files/figure-gfm/landings-plot-1.png)<!-- -->

### References

ICES Stock Assessment Graphs database: <http://sg.ices.dk>

ICES Stock Assessment Graphs web services:
<http://sg.ices.dk/webservices.aspx>

### Development

icesSAG is developed openly on
[GitHub](https://github.com/ices-tools-prod/icesSAG).

Feel free to open an
[issue](https://github.com/ices-tools-prod/icesSAG/issues) there if you
encounter problems or have suggestions for future versions.

The current development version can be installed using:

``` r
library(devtools)
install_github("ices-tools-prod/icesSAG")
```
