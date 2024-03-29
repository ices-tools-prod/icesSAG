% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getSAG.R
\name{getSAG}
\alias{getSAG}
\title{Get Any SAG Data}
\usage{
getSAG(stock, year, data = "summary", combine = TRUE, purpose = "Advice")
}
\arguments{
\item{stock}{a stock name, e.g. cod-347d, or cod to find all cod stocks, or
NULL to process all stocks.}

\item{year}{the assessment year, e.g. 2015, or 0 to process all years.}

\item{data}{the data of interest, either "summary", "refpts" or "source".}

\item{combine}{whether to combine the list output to a data frame.}

\item{purpose}{the purpose of the entry, options are "Advice", "Bench",
"InitAdvice", default is "Advice".}
}
\value{
A data frame (default) or a list if \code{combine} is \code{TRUE}.
}
\description{
This function combines the functionality of getListStocks,
getFishStockReferencePoints, and getSummaryTable.
It supports querying many stocks and years in one function call.
}
\note{
Only years with "Published" status are returned.
}
\examples{
\dontrun{
summary <- getSAG("had.27.46a20", 2022)
refpts <- getSAG("had.27.46a20", 2022, "refpts")

cod_summary <- getSAG("cod", 2022)
cod_refpts <- getSAG("cod", 2015:2016, "refpts")
cod_data <- getSAG("cod", 2017, "source-data")
}
}
\seealso{
\code{\link{StockList}}, \code{\link{SummaryTable}}, and
  \code{\link{FishStockReferencePoints}} get a list of stocks, summary
  results, and reference points.

\code{\link{findAssessmentKey}} finds lookup keys.

\code{\link{icesSAG-package}} gives an overview of the package.
}
\author{
Colin Millar.
}
