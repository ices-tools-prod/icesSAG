#' Create a list of retrospective bias information
#'
#' Creates the assessment retro-bias record required for the SAG upload file.
#' Since 2026 this record is mandatory for category 1 and 2 stocks.
#'
#' Rho values should be given as decimals, not percentages (e.g. -0.19, not -19).
#'
#' @param TerminalYear terminal year of the catch data.
#' @param RetroAssessment the number of retrospective assessments (peels) used.
#' @param Fbarrho Mohn's rho for mean F.
#' @param SSBrhoYear was the intermediate year used as the terminal year for SSB rho?
#'                   "Y" or "N" (TRUE/FALSE and "Yes"/"No" are converted).
#' @param SSBrho Mohn's rho for SSB.
#' @param RecruitmentrhoYear was the intermediate year used as the terminal year for
#'                           recruitment rho? "Y" or "N" (TRUE/FALSE and "Yes"/"No" are converted).
#' @param Recruitmentrho Mohn's rho for recruitment, 0 if not applicable.
#' @param Comments optional expert opinion on the cause of any retrospective bias,
#'                 or additional information.
#'
#' @return A named sag.retro list.
#'
#' @seealso
#' \code{\link{stockInfo}}, \code{\link{stockFishdata}}, \code{\link{writeSAGxml}}
#'
#' @examples
#' retro <-
#'   stockRetroBias(
#'     TerminalYear = 2025,
#'     RetroAssessment = 5,
#'     Fbarrho = -0.1877,
#'     SSBrhoYear = "N",
#'     SSBrho = 0.0667,
#'     RecruitmentrhoYear = "N",
#'     Recruitmentrho = 0.0398
#'   )
#' retro
#' @export

stockRetroBias <- function(TerminalYear, RetroAssessment, Fbarrho = NA,
                           SSBrhoYear = NA, SSBrho = NA,
                           RecruitmentrhoYear = NA, Recruitmentrho = NA,
                           Comments = NA) {
  val <- list(
    TerminalYear = TerminalYear,
    RetroAssessment = RetroAssessment,
    Fbarrho = Fbarrho,
    SSBrhoYear = yesNo(SSBrhoYear),
    SSBrho = SSBrho,
    RecruitmentrhoYear = yesNo(RecruitmentrhoYear),
    Recruitmentrho = Recruitmentrho,
    Comments = Comments
  )
  class(val) <- c("sag.retro", "list")
  val
}

# convert yes / no style entries to the Y / N codes used in the upload file
yesNo <- function(x) {
  if (length(x) != 1 || is.na(x)) {
    return(x)
  }
  if (is.logical(x)) {
    return(if (x) "Y" else "N")
  }
  y <- toupper(trimws(as.character(x)))
  if (y %in% c("Y", "YES")) {
    "Y"
  } else if (y %in% c("N", "NO")) {
    "N"
  } else {
    x
  }
}

#' @export
print.sag.retro <- function(x, ...) {
  x <- unclass(x)
  x <- x[!sapply(x, function(y) length(y) == 1 && is.na(y))]
  print.default(x, ...)
  invisible(x)
}
