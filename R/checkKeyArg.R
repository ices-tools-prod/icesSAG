checkKeyArg <- function(assessmentKey, ...)
{
  if (missing(assessmentKey))
  {
    dots <- list(...)
    if ("key" %in% names(dots))
    {
      assessmentKey <- dots$key
      warning("key argument is depreciated, use assessmentKey instead.", call. = FALSE)
    }
  }
  assessmentKey
}
