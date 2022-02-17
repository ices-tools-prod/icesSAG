# icesSAG 1.3.8.9000

* add new function getCustomColumns()


## icesSAG 1.3-8 (2019-10-29)

* Display warning if stock name contains – and not -, and quietly fix.



## icesSAG 1.3-7 (2019-05-14)

* Allow upload to contiue if errors found by DATSU - gives warning, not error
* Add function to parse stock status table values due to change in web service
  XML data structure
* Fix name in upload format specification CatchLandingsUnits


## icesSAG 1.3-6 (2019-03-13)

* Fixed bug in parsing of XML tables.  Function now reads the WSDL data that is
  included as an internal data set (list of variable names)
* Set all examples to dontrun
* code now checked against lintr for consistent style



## icesSAG 1.3-5 (2018-06-08)

* added function getStockSourceData() to download the XML file that was
  origionally uploaded.


## icesSAG 1.3-4 (2018-05-01)

* added function getLatestStockAdviceList()
* export print methods for sag.list and sag.data.frame for fishdata and fishinfo
  objects used to upload data.
* improved personal access token logic
* improved help documentation
* Added StockCategory, Purpose, ModelType, ModelName to upload functions
* Added filter for assessment Purpose in getSAG()
* fixed bugs arising from changes to xml2 package
* fixed bug arsing from change in ICES Datsu web service


## icesSAG 1.3-2 (2017-05-06)

* User sets SAG database access token in a ~/.Renviron_SG file.
* Addressed non CRAN compliant behaviour: user must create .Renviron file
  themselves.



## icesSAG 1.3-1 (2017-05-04)

* Improved createSAGxml() internal data validation.



## icesSAG 1.3-0 (2017-04-05)

* Added function uploadStock() to upload data to SAG database via
  uploadXMLFile(). The functions readSAGxml() and createSAGxml() convert data to
  and from SAG XML upload format.

* Added functions stockInfo() and stockFishdata() to prepare data for upload.
  Uploads require user access tokens, available from the main SAG website.

* Added function getStockStatusValues() to get stock status table, and
  getYSBRSummaryTable() to get yield and SSB per recruit.

* Added functions getSAG*Settings*() and setSAG*Settings*() to get and set graph
  settings. The function getSAGTypeGraphs() lists the SAG graph types.

* Renamed findKey() to findAssessmentKey().





## icesSAG 1.2-1 (2017-03-24)

* Hotfix release to match changes in the underlying web service, regarding
  assessment keys.





## icesSAG 1.2-0 (2016-12-05)

* Added functions get*Graph() to fetch standard graph images, with a
  corresponding plot() method. The convenience function getSAGGraphs() fetches
  four commonly used graphs.

* Added argument 'regex' to findKey().

* Fixed bug in getSAG() when different column names appear in stock summaries
  and combine = TRUE.

* Removed dependency on RCurl and XML by using base functions to download and
  parse data.





## icesSAG 1.1-0 (2016-10-29)

* Added function findKey() to look up a unique stock list key.

* Added function getSAG() to import summary results and reference points,
  without finding a lookup key first.

* Changed argument in functions getSummaryTable() and
  getFishStockReferencepoints() from 'year' to 'key'.

* Improved XML parsing, so both leading and trailing white space is removed.

* Improved XML parsing, so "" and "NA" is converted to NA.

* Improved XML parsing, so data frame columns are automatically coerced to the
  appropriate storage mode (character, numeric, integer).





## icesSAG 1.0-0 (2016-08-09)

* Initial release, with functions getListStocks(), getSummaryTable(), and
  getFishStockReferencePoints().
