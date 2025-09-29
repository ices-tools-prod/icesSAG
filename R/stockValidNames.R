validNames <- function(type = c("stockInfo", "stockFishdata")) {
  # taken from:
  # http://datsu.ices.dk/web/selRep.aspx?Dataset=126
  switch(type,
    stockInfo =
      c(
        "StockCode",
        "AssessmentYear",
        "AssessmentComponent",
        "StockCategory",
        "BMGT_lower",
        "BMGT",
        "BMGT_upper",
        "BMGTrange_low",
        "BMGTrange_high",
        "FMGTrange_low",
        "FMGTrange_high",
        "FMGT_lower",
        "FMGT",
        "FMGT_upper",
        "HRMGT",
        "MSYBtrigger",
        "FMSY",
        "MSYBesc",
        "Fcap",
        "Blim",
        "Bpa",
        "Flim",
        "Fpa",
        "Fage",
        "Flength",
        "RecruitmentLength",
        "CatchesLandingsUnits",
        "ConfidenceIntervalDefinition",
        "RecruitmentAge",
        "CatchesLandingsUnits",
        "RecruitmentDescription",
        "RecruitmentUnits",
        "FishingPressureDescription",
        "FishingPressureUnits",
        "StockSizeDescription",
        "StockSizeUnits",
        "NameSystemProducedFile",
        "ContactPerson",
        paste0("CustomLimitValue", 1:5),
        paste0("CustomLimitName", 1:5),
        paste0("CustomLimitNotes", 1:5),
        paste0("CustomSeriesName", 1:20),
        paste0("CustomSeriesUnits", 1:20),
        "Purpose",
        "ModelType",
        "ModelName"
      ),
    stockFishdata =
      c(
        "Year",
        "Low_Recruitment",
        "Recruitment",
        "High_Recruitment",
        "Low_TBiomass",
        "TBiomass",
        "High_TBiomass",
        "Low_StockSize",
        "StockSize",
        "High_StockSize",
        "Catches",
        "Landings",
        "LandingsBMS",
        "Discards",
        "LogbookRegisteredDiscards",
        "IBC",
        "Unallocated_Removals",
        "Low_FishingPressure",
        "FishingPressure",
        "High_FishingPressure",
        "FishingPressure_Landings",
        "FishingPressure_Discards",
        "FishingPressure_IBC",
        "FishingPressure_Unallocated",
        paste0("CustomSeries", 1:20)
      )
  )
}


checkStockInfo <- function(info) {
  errors <- list()
  # check Stock Code
  x <- icesVocab::findCode("ICES_StockCode", info$StockCode, full = TRUE)
  if (length(x) == 0) {
    part1 <- paste(strsplit(info$StockCode, "[.]")[[1]][1:2], collapse = ".")
    maybe <- icesVocab::findCode("ICES_StockCode", part1)$ICES_StockCode
    maybe <- sapply(strsplit(maybe, "[.]"), "[", 3)
    ending <- strsplit(info$StockCode, "[.]")[[1]][3]
    ending <- strsplit(ending, "")[[1]]
    loc1 <- grep("[1-9]", ending)
    loc2 <- c(loc1[-1] - 1, length(ending))
    ending <- sapply(seq_len(length(loc1)), function(i) paste(ending[loc1[i]:loc2[i]], collapse = ""))
    maybeid <- unique(unlist(sapply(ending, grep, x = maybe)))
    errors$StockCode <-
      paste0(
        "non valid stock code (",
        info$StockCode,
        "). Did you mean on of these: ",
        paste(part1, maybe[maybeid], sep = ".", collapse = ", "), "?"
      )
  }


  # return
  if (length(errors)) {
    errors <- c(errors = length(errors), errors)
  } else {
    errors <- c(errors = 0, errors)
  }
  errors
}

checkStockFishdata <- function(fishdata) {
  errors <- list()

  # checks here
  # None yet!

  # return
  if (length(errors)) {
    errors <- c(errors = length(errors), errors)
  } else {
    errors <- c(errors = 0, errors)
  }
  errors
}
