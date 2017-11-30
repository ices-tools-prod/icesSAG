## Test environments
* local Windows 10 install, R 3.4.0
* ubuntu 12.04 (on travis-ci), (release and devel)
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 2 notes

Maintainer: 'Colin Millar <colin.millar@ices.dk>'

1.
New submission

Package was archived on CRAN

CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2017-05-06 for policy violation.


2.
Examples with CPU or elapsed time > 5s
          user system elapsed
getGraphs 1.46   0.14    5.42

## Reverse dependencies

There are no reverse dependencies yet.

## Other comments

Package previously created a file .Renviron_SG in the users home directory.  This behavious was
against CRAN policy.  In this version of the package the user must create this file
themselves.
