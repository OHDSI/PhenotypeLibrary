readCensorWindow <- function(cohortDefinition) {
  censorWindowStartDate <-
    as.Date(cohortDefinition$CensorWindow[["StartDate"]])
  censorWindowStartDate <-
    as.Date(cohortDefinition$CensorWindow[["EndDate"]])
  output <- c()
  output$censorWindowStartDate <- censorWindowStartDate
  output$censorWindowEndDateDate <- censorWindowStartDate
  return(output)
}

modifyCensorWindow <- function(cohortDefinition,
                               startDate,
                               endDate) {
  cohortDefinition$CensorWindow <- as.character()
  cohortDefinition$CensorWindow[["StartDate"]] <-
    as.character(startDate)
  cohortDefinition$CensorWindow[["EndDate"]] <-
    as.character(endDate)
  return(cohortDefinition)
}


readCollapseSettings <- function(cohortDefinition) {
  output <- c()
  output$collapseType <-
    cohortDefinition$CollapseSettings$CollapseType
  output$eraPad <- cohortDefinition$CollapseSettings$EraPad
  return(output)
}


modifyCollapseSettings <- function(cohortDefinition,
                                   eraPad) {
  cohortDefinition$CollapseSettings$CollapseType <-
    "ERA"
  cohortDefinition$CollapseSettings$EraPad  <-
    eraPad
  return(cohortDefinition)
}

readCohortExit <- function(cohortDefinition) {
  output <- c()
  if (is.null(cohortDefinition$EndStrategy)) {
    output$exitStrategy <- "end of continuous observation"
  } else if (!is.null(cohortDefinition$EndStrategy$DateOffset)) {
    output$exitStrategy <- "fixed duration relative to initial event"
    output$dateOffSetField <-
      cohortDefinition$EndStrategy$DateOffset$DateField
    output$dateOffSet <-
      cohortDefinition$EndStrategy$DateOffset$Offset
  } else if (!is.null(cohortDefinition$EndStrategy$CustomEra)) {
    output$exitStrategy <- "end of continuous drug exposure"
    output$drugCodeSetId <-
      cohortDefinition$EndStrategy$CustomEra[["DrugCodesetId"]]
    output$persistenceWindow <-
      cohortDefinition$EndStrategy$CustomEra[["GapDays"]]
    output$surveillanceWindow <-
      cohortDefinition$EndStrategy$CustomEra[["offset"]]
  }
  return(output)
}


modifyCohortExit <- function(cohortDefinition,
                             exitStrategy = "end of continuous observation",
                             dateOffSetField = NULL,
                             dateOffSet = NULL,
                             drugCodeSetId = NULL,
                             persistenceWindow = 0,
                             surveillanceWindow = 0) {
  if (exitStrategy = "end of continuous observation") {
    cohortDefinition$EndStrategy <- NULL
  } else if (exitStrategy = "fixed duration relative to initial event") {
    cohortDefinition$EndStrategy <- NULL
    cohortDefinition$EndStrategy <- list()
    cohortDefinition$EndStrategy$DateOffset <- list()
    if (dateOffSetField %in% c("StartDate", "EndDate")) {
      cohortDefinition$EndStrategy$DateOffset$DateField <- dateOffSetField
      cohortDefinition$EndStrategy$DateOffset$Offset <-
        as.numeric(dateOffSet)
    } else {
      stop(
        paste0(
          "dateOffset given value: '",
          DateOffset,
          "' does not match expected 'StartDate', 'EndDate'"
        )
      )
    }
  } else if (exitStrategy = "end of continuous drug exposure") {
    cohortDefinition$EndStrategy <- NULL
    cohortDefinition$EndStrategy <- list()
    cohortDefinition$EndStrategy$CustomEra <- numeric()
    if (is.null(drugCodeSetId)) {
      stop("drugCodeSetId is NULL")
    }
    cohortDefinition$EndStrategy$CustomEra[["DrugCodesetId"]] <-
      as.numeric(drugCodeSetId)
    cohortDefinition$EndStrategy$CustomEra[["GapDays"]] <-
      as.numeric(persistenceWindow)
    cohortDefinition$EndStrategy$CustomEra[["offset"]] <-
      as.numeric(surveillanceWindow)
  } else {
    stop(
      paste0(
        "Please check specified exit strategy. Given strategy ",
        exitStrategy,
        " does not match 'end of continuous observation', 'end of continuous observation', 'end of continuous drug exposure'."
      )
    )
  }
  return(output)
}




parsePhenotypeLibraryDescription <- function(cohortDefinition) {
  output <- dplyr::tibble()
  librarian <-     stringr::str_replace(
    string = cohortDefinition$createdBy$name,
    pattern = "na\\\\",
    replacement = ""
  )
  cohortName <- cohortDefinition$name
  cohortNameFormatted <- gsub(
    pattern = "_",
    replacement = " ",
    x = gsub("\\[(.*?)\\]_", "", gsub(" ", "_", cohortName))
  ) |>
    stringr::str_squish() |>
    stringr::str_trim()
  
  if (length(cohortDefinition$modifiedBy) > 1) {
    lastModifiedBy <-
      cohortDefinition$modifiedBy$name
  }
  
  output <- output |>
    dplyr::mutate(
      librarian = librarian,
      cohortName = cohortName,
      cohortNameLong = cohortNameFormatted,
      lastModifiedBy = lastModifiedBy
    )
  
  if (all(!is.na(cohortDefinition$description),
          nchar(cohortDefinition$description) > 5)) {
    textInDescription <-
      cohortDefinition$description |>
      stringr::str_replace_all(pattern = ";", replacement = "") |>
      stringr::str_split(pattern = "\n")
    strings <- textInDescription[[1]]
    textInDescription <- NULL
    
    strings <-
      stringr::str_split(string = strings, pattern = stringr::fixed(":"))
    
    if (all(
      !is.na(cohortDefinition$description[[1]]),
      stringr::str_detect(
        string = cohortDefinition$description,
        pattern = stringr::fixed(":")
      )
    )) {
      stringValues <- c()
      for (j in (1:length(strings))) {
        stringValues[[j]] <- dplyr::tibble()
        if (length(strings[[j]]) == 2) {
          stringValues[[j]] <- dplyr::tibble(
            name = strings[[j]][[1]] |> stringr::str_squish() |> stringr::str_trim(),
            value = strings[[j]][[2]] |>
              stringr::str_squish() |>
              stringr::str_trim()
          )
        }
      }
      
      stringValues <- dplyr::bind_rows(stringValues)
      
      if (nrow(stringValues) > 0) {
        data <- stringValues |>
          tidyr::pivot_wider()
        stringValues <- NULL
        
        output <- output |>
          tidyr::crossing(data)
      }
    }
  }
  return(output)
}