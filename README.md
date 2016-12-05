[![Build Status](https://travis-ci.org/ices-tools-prod/icesSAG.svg?branch=release)](https://travis-ci.org/ices-tools-prod/icesSAG)
[![codecov](https://codecov.io/gh/ices-tools-prod/icesSAG/branch/master/graph/badge.svg)](https://codecov.io/gh/ices-tools-prod/icesSAG)
[![GitHub release](https://img.shields.io/github/release/ices-tools-prod/icesSAG.svg?maxAge=2592000)]()
[![CRAN Status](http://www.r-pkg.org/badges/version/icesSAG)](https://cran.r-project.org/package=icesSAG)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/icesSAG)](https://cran.r-project.org/package=icesSAG)
[![License](https://img.shields.io/badge/license-GPL%20(%3E%3D%202)-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)

[<img align="right" alt="ICES Logo" width="17%" height="17%" src="http://www.ices.dk/_layouts/15/1033/images/icesimg/iceslogo.png">](http://www.ices.dk/Pages/default.aspx)

icesSAG
======

icesSAG provides R functions that access the
[web services](https://datras.ices.dk/WebServices/Webservices.aspx) of the
[ICES (International Council for the Exploration of the Sea)](http://www.ices.dk/Pages/default.aspx)
[Stock Assessment Graphs Database](http://ices.dk/marine-data/tools/Pages/stock-assessment-graphs.aspx).

icesSAG is implemented as an [R](https://www.r-project.org) package and
available on [CRAN](https://cran.r-project.org/package=icesSAG).

Installation
------------

icesSAG can be installed from CRAN using the `install.packages` command:

```R
install.packages('icesSAG')
```

Usage
-----

For a summary of the package:

```R
library(icesSAG)
?icesSAG
```

References
----------

ICES Stock Assessment Graphs database:

[http://standardgraphs.ices.dk/](http://standardgraphs.ices.dk/)

ICES Stock Assessment Graphs database web services:

[http://standardgraphs.ices.dk/webservices.aspx](http://standardgraphs.ices.dk/webservices.aspx)

Development
-----------

icesSAG is developed openly on
[GitHub](https://github.com/ices-tools-prod/icesSAG).

Feel free to open an [issue](https://github.com/ices-tools-prod/icesSAG/issues)
there if you encounter problems or have suggestions for future versions.

The current development version can be installed using:

```R
devtools::install_github('ices-tools-prod/icesSAG')
```
