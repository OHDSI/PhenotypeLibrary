
#' @export
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

#' @export
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

#' @export
readCollapseSettings <- function(cohortDefinition) {
  output <- c()
  output$collapseType <-
    cohortDefinition$CollapseSettings$CollapseType
  output$eraPad <- cohortDefinition$CollapseSettings$EraPad
  return(output)
}

#' @export
modifyCollapseSettings <- function(cohortDefinition,
                                   eraPad) {
  cohortDefinition$CollapseSettings$CollapseType <-
    "ERA"
  cohortDefinition$CollapseSettings$EraPad  <-
    eraPad
  return(cohortDefinition)
}

#' @export
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
      cohortDefinition$EndStrategy$CustomEra[["Offset"]]
  }
  return(output)
}

#' @export
modifyCohortExit <- function(cohortDefinition,
                             exitStrategy = "end of continuous observation",
                             dateOffSetField = NULL,
                             dateOffSet = NULL,
                             drugCodeSetId = NULL,
                             persistenceWindow = 0,
                             surveillanceWindow = 0) {
  if (exitStrategy == "end of continuous observation") {
    cohortDefinition$EndStrategy <- NULL
  } else if (exitStrategy == "fixed duration relative to initial event") {
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
  } else if (exitStrategy == "end of continuous drug exposure") {
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
  return(cohortDefinition)
}

#' @export
getNumberOfInclusionRules <- function(cohortDefinition) {
  length(cohortDefinition$InclusionRules)
}

#' @export
getInitialEventRestrictionAdditionalCriteriaLimit <- function(cohortDefinition) {
  # default Value is 'All' . It is only run if 'AdditionalCriteria' rule exits.
  if (hasInitialEventRestrictionAdditionalCriteria(cohortDefinition = cohortDefinition)) {
    limitValue <- cohortDefinition$QualifiedLimit |> as.character()
  } else {
    limitValue <- 'All'
  }
  return(limitValue)
}

#' @export
getInclusionRuleQualifyingEventLimit <- function(cohortDefinition) {
  cohortDefinition$ExpressionLimit |> as.character()
}


#' @export
getInitialEventLimit <- function(cohortDefinition) {
  # this is the limit used first part of entry event criteria
  cohortDefinition$PrimaryCriteria$PrimaryCriteriaLimit |> as.character()
}

#' @export
hasInitialEventRestrictionAdditionalCriteria <- function(cohortDefinition) {
  # this is the second or additional criteria that are part of entry event criteria
  checkIfObjectExistsInNestedList(nestedList = cohortDefinition, object = 'AdditionalCriteria')
}

#' @export
getNumberOfCohortEntryEvents <- function(cohortDefinition) {
  cohortDefinition$PrimaryCriteria$CriteriaList |> length()
}

#' @export
getNumberOfConceptSets <- function(cohortDefinition) {
  length(cohortDefinition$ConceptSets) |> as.integer()
}

#' @export
checkIfObjectExistsInNestedList <- function(nestedList,
                                            object) {
  if (is.list(nestedList)) {
    if (object %in% names(nestedList)) {
      return(TRUE)
    } else {
      for (subList in nestedList) {
        if (checkIfObjectExistsInNestedList(nestedList = subList, object = object)) {
          return(TRUE)
        }
      }
    }
  }
  return(FALSE)
}

#' @export
getWhereAnObjectExistsInNestedList <- function(nestedList,
                                               object) {
  namedItems <- c()
  for (i in (1:length(nestedList))) {
    if (checkIfObjectExistsInNestedList(nestedList = nestedList[[i]], object = object)) {
      namedItems <- c(namedItems, names(nestedList)[[i]])
    }
  }
  
  namedItemsDf <- dplyr::tibble()
  
  if (length(namedItems) > 0) {
    namedItemsDf <-
      dplyr::tibble(namedItems = namedItems |> unique() |> sort()) |>
      dplyr::mutate(value = 1) |>
      dplyr::mutate(newName = paste0("criteriaLocation",
                                     object,
                                     namedItems)) |>
      dplyr::select(newName,
                    value) |>
      tidyr::pivot_wider(
        names_from  = "newName",
        values_from = "value",
        values_fill = 0
      )
  }
  return(namedItemsDf)
}

#' @export
getContinuousPriorObservationPeriodRequirement <-
  function(cohortDefinition) {
    priorDays <-
      as.integer(cohortDefinition$PrimaryCriteria$ObservationWindow[["PriorDays"]])
    postDays <-
      as.integer(cohortDefinition$PrimaryCriteria$ObservationWindow[["PostDays"]])
    output <- c()
    output$priorDays <- priorDays
    output$postDays <- postDays
    return(output)
  }

#' @export
areCohortEventsRestrictedByVisit <-
  function(cohortDefinition) {
    if (!'VisitOccurrence' %in% getDomainsInEntryEvents(cohortDefinition = cohortDefinition)) {
      checkIfObjectExistsInNestedList(nestedList = cohortDefinition,
                                      object = 'VisitOccurrence')
    } else {
      FALSE
    }
  }

#' @export
stringPresentInCohortDefinitionText <-
  function(cohortDefinition,
           textToSearch) {
    cohortDefinition |> 
      RJSONIO::toJSON(digits = 23) |> 
      tolower()  |> 
      stringr::str_trim() |> 
      stringr::str_squish() |> 
      stringr::str_detect(pattern = textToSearch |> 
                            tolower() |> 
                            stringr::str_trim() |> 
                            stringr::str_squish())
  }

#' @export
getDomainsInEntryEvents <- function(cohortDefinition) {
  cohortEntryEvents <-
    getNumberOfCohortEntryEvents(cohortDefinition = cohortDefinition)
  
  domains <- c()
  for (i in (1:cohortEntryEvents)) {
    domains[i] <-
      names(cohortDefinition$PrimaryCriteria$CriteriaList[[i]])
  }
  
  uniqueDomains <- unique(domains) |> sort()
  
  output <- c()
  output$uniqueDomains <- uniqueDomains
  output$numberOfUniqueDomains <- length(uniqueDomains)
  output$domains <-
    dplyr::tibble(uniqueDomains) |>
    dplyr::mutate(value = 1) |>
    tidyr::pivot_wider(
      names_from  = "uniqueDomains",
      names_prefix = "domain",
      values_from = "value",
      values_fill = 0
    )
  return(output)
}


#' @export
parseCohortDefinitionSpecifications <- function(cohortDefinition) {
  censorWindow <-
    readCensorWindow(cohortDefinition = cohortDefinition)
  collapseSettings <-
    readCollapseSettings(cohortDefinition = cohortDefinition)
  cohortExit <- readCohortExit(cohortDefinition = cohortDefinition)
  numberOfInclusionRules <-
    getNumberOfInclusionRules(cohortDefinition = cohortDefinition)
  
  initialEventLimit <-
    getInitialEventLimit(cohortDefinition = cohortDefinition)
  
  initialEventRestrictionAdditionalCriteria <- hasInitialEventRestrictionAdditionalCriteria(cohortDefinition = cohortDefinition)
  # qualifying limit is part of entry event criteria. Its the second limit if initialEventRestrictionAdditionalCriteria Exits
  # this is the restrict initial events part of entry event criteria
  initialEventRestrictionAdditionalCriteriaLimit <-
    getInitialEventRestrictionAdditionalCriteriaLimit(cohortDefinition = cohortDefinition)
  
  numberOfCohortEntryEvents <-
    getNumberOfCohortEntryEvents(cohortDefinition = cohortDefinition)
  domainsInEntryEventCriteria <-
    getDomainsInEntryEvents(cohortDefinition = cohortDefinition)
  continousObservationRequirement <-
    getContinuousPriorObservationPeriodRequirement(cohortDefinition = cohortDefinition)
  numberOfConceptSets <-
    getNumberOfConceptSets(cohortDefinition = cohortDefinition)
  
  demographicCriteria <-
    checkIfObjectExistsInNestedList(nestedList = cohortDefinition, object = "DemographicCriteriaList") |> as.integer()
  demographicCriteriaAge <-
    checkIfObjectExistsInNestedList(nestedList = cohortDefinition, object = "Age") |> as.integer()
  demographicCriteriaGender <-
    checkIfObjectExistsInNestedList(nestedList = cohortDefinition, object = "Gender") |> as.integer()
  domainsInEntryEvents <-
    paste0(domainsInEntryEventCriteria$uniqueDomains, collapse = ", ")
  useOfObservationPeriodInclusionRule <-
    checkIfObjectExistsInNestedList(nestedList = cohortDefinition,
                                    object = 'ObservationPeriod') |> as.integer()
  restrictedByVisit <-
    areCohortEventsRestrictedByVisit(cohortDefinition = cohortDefinition) |> as.integer()
  
  hasWashoutInText <-
    stringPresentInCohortDefinitionText(cohortDefinition = cohortDefinition,
                                        textToSearch = "washout") |> as.integer()
  
  inclusionRuleQualifyingEventLimit <- getInclusionRuleQualifyingEventLimit(cohortDefinition = cohortDefinition)
  
  report <- dplyr::tibble(
    censorWindowStartDate =
      (if (length(censorWindow$censorWindowStartDate) > 0) {
        censorWindow$censorWindowStartDate
      } else
        NA),
    censorWindowEndDate =
      (if (length(censorWindow$censorWindowEndDateDate) > 0) {
        censorWindow$censorWindowEndDateDate
      } else
        NA),
    collapseSettingsType = collapseSettings$collapseType,
    collapseEraPad = collapseSettings$eraPad,
    exitStrategy = cohortExit$exitStrategy,
    exitDateOffSetField = cohortExit$dateOffSetField,
    exitDateOffSet = cohortExit$dateOffSet,
    exitDrugCodeSetId = cohortExit$drugCodeSetId,
    exitPersistenceWindow = cohortExit$persistenceWindow,
    exitSurveillanceWindow = cohortExit$surveillanceWindow,
    numberOfInclusionRules = numberOfInclusionRules,
    initialEventLimit = initialEventLimit,
    initialEventRestrictionAdditionalCriteria = initialEventRestrictionAdditionalCriteria,
    initialEventRestrictionAdditionalCriteriaLimit = initialEventRestrictionAdditionalCriteriaLimit, # this is the restrict initial events part of entry event criteria
    inclusionRuleQualifyingEventLimit = inclusionRuleQualifyingEventLimit,
    numberOfCohortEntryEvents = numberOfCohortEntryEvents,
    numberOfDomainsInEntryEvents = domainsInEntryEventCriteria$numberOfUniqueDomains,
    domainsInEntryEvents = domainsInEntryEvents,
    continousObservationWindowPrior = continousObservationRequirement$priorDays,
    continousObservationWindowPost = continousObservationRequirement$postDays,
    numberOfConceptSets = numberOfConceptSets,
    demographicCriteria = demographicCriteria,
    demographicCriteriaAge = demographicCriteriaAge,
    demographicCriteriaGender = demographicCriteriaGender,
    useOfObservationPeriodInclusionRule = useOfObservationPeriodInclusionRule,
    restrictedByVisit = restrictedByVisit,
    hasWashoutInText = hasWashoutInText
  )
  
  if (nrow(domainsInEntryEventCriteria$domains) > 0) {
    report <- report |>
      tidyr::crossing(domainsInEntryEventCriteria$domains)
  }
  
  sourceDomains <-
    c(
      'ProcedureSourceConcept',
      'ConditionSourceConcept',
      'ObservationSourceConcept',
      'VisitSourceConcept',
      'DrugSourceConcept',
      'DeviceSourceConcept',
      'DeathSourceConcept',
      'MeasurementSourceConcept'
    )
  demographics <- c('Age',
                    'Gender')
  typeConcepts <- c('VisitType')
  measureMent <-
    c(
      'ValueAsConcept',
      'Operator',
      'ValueAsNumber',
      'Op',
      'RangeLow',
      'RangeHigh',
      'RangeLowRatio',
      'RangeHighRatio'
    )
  other <- c('PlaceOfServiceCS', 'ProviderSpecialty', 'First')
  
  combined <-
    c(sourceDomains, demographics, typeConcepts, other) |> unique()
  for (i in (1:length(combined))) {
    whereExists <-
      getWhereAnObjectExistsInNestedList(nestedList = cohortDefinition, object = combined[[i]])
    if (nrow(whereExists) > 0) {
      report <- report |>
        tidyr::crossing(whereExists)
    }
  }
  
  report <- report |>
    dplyr::mutate(eventCohort =
                    dplyr::if_else(
                      condition = (
                        initialEventLimit == 'All' &
                          initialEventRestrictionAdditionalCriteriaLimit == 'All' &
                          inclusionRuleQualifyingEventLimit == 'All'
                      ),
                      true = 1,
                      false = 0
                    ))
  
  return(report)
}

#' @export
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



# Function to get name from ORCID ID
#' @export
getOrcidDetails <- function(orcidId) {
  # Create the URL for the API request
  url <- paste0("https://pub.orcid.org/v3.0/", orcidId)
  
  # Make the API request
  res <-
    httr::GET(url, httr::add_headers('Accept' = 'application/json'))
  
  # Parse the JSON response
  parsedRes <- RJSONIO::fromJSON(httr::content(res, "text"))
  
  details <- c()
  # Extract the name
  details$givenName <-
    paste0(as.character(parsedRes$person$name$`given-names`),"")
  details$familyName <-
    paste0(as.character(parsedRes$person$name$`family-name`),"")
  details$email <- paste0(parsedRes$person$emails$email |> as.character(),"")
  
  return(details)
}

# Function to get log based on OrcId
#' @export
getOrcidFromPhenotypeLog <-
  function(log = PhenotypeLibrary::getPhenotypeLog()) {
    # Process the data
    uniqueOrcIds <- log |>
      dplyr::mutate(
        contributorOrcIds = stringr::str_replace(
          string = contributorOrcIds,
          pattern = stringr::fixed("."),
          replacement = ","
        )
      ) |>
      tidyr::separate_rows(contributorOrcIds, sep = ",") |>   # Split by comma
      dplyr::mutate(contributorOrcIds = stringr::str_trim(contributorOrcIds, side = "both")) |>   # Trim whitespace
      dplyr::filter(contributorOrcIds != "") |>  # Remove empty strings
      dplyr::filter(contributorOrcIds != "''") |>  # Remove empty strings
      dplyr::filter(contributorOrcIds != "'") |>  # Remove empty strings
      dplyr::mutate(contributorOrcIds = stringr::str_replace_all(contributorOrcIds, "'", "")) |>  # Remove quotations
      dplyr::distinct(contributorOrcIds) |>  # Get unique ORCIDs
      dplyr::arrange(contributorOrcIds) |>
      dplyr::pull(contributorOrcIds)
    
    orcidLog <- c()
    for (i in (1:length(uniqueOrcIds))) {
      orcIdDetails <- NULL
      orcIdDetails <- getOrcidDetails(uniqueOrcIds[[i]])
      orcidLog[[i]] <- dplyr::tibble(
        orcId = uniqueOrcIds[[i]],
        givenName = orcIdDetails$givenName,
        lastName = orcIdDetails$familyName,
        email = orcIdDetails$email
      )
    }
    orcidLog <- dplyr::bind_rows(orcidLog)
    
    orcidLogWithContributions <- c()
    for (i in (1:nrow(orcidLog))) {
      numberOfCohorts <- log |>
        dplyr::filter(
          stringr::str_detect(
            string = .data$contributorOrcIds,
            pattern = orcidLog[i, ]$orcId |> stringr::fixed()
          )
        ) |>
        dplyr::pull(cohortId) |>
        unique() |>
        length()
      
      numberOfCohortsAccepted <- log |>
        dplyr::filter(stringr::str_detect(string = tolower(status),
                                          pattern = "accepted")) |>
        dplyr::filter(
          stringr::str_detect(
            string = .data$contributorOrcIds,
            pattern = orcidLog[i, ]$orcId |> stringr::fixed()
          )
        ) |>
        dplyr::pull(cohortId) |>
        unique() |>
        length()
      
      orcidLogWithContributions[[i]] <- orcidLog[i,] |> 
        dplyr::mutate(
          contributions = numberOfCohorts,
          accepted = numberOfCohortsAccepted
        )
    }
    return(dplyr::bind_rows(orcidLogWithContributions))
  }



# Function to Fetch Tags, Version Numbers, and Release Dates
#' @export
fetchGitHubRepoReleaseInfo <- function(repoOwner, repoName) {
  # Fetch release data from GitHub API
  releaseData <-
    gh::gh("GET /repos/:owner/:repo/releases",
           owner = repoOwner,
           repo = repoName)
  
  # Initialize empty data frame
  repoInfo <- dplyr::tibble(
    tag = character(0),
    version = character(0),
    releaseDate = character(0),
    stringsAsFactors = FALSE
  )
  
  # Loop through each release
  for (i in 1:length(releaseData)) {
    tag <- releaseData[[i]]$tag_name
    version <-
      ifelse(is.null(releaseData[[i]]$name), NA, releaseData[[i]]$name)
    releaseDate <- releaseData[[i]]$created_at |> as.Date()
    
    # Append to data frame
    repoInfo <-
      rbind(repoInfo,
            dplyr::tibble(
              tag = tag,
              version = version,
              releaseDate = releaseDate
            ))
  }
  
  return(repoInfo)
}

# Function to plot smoothed trend curve
#' @export
plotSmoothedTrendCurve <- function(data, 
                                   dateColumn = "createdDate",
                                   smoothingMethod = "loess",
                                   showStandardError = FALSE,
                                   outputFilename = "smoothed_trend_curve.png",
                                   plotTitle = "Smoothed Trend Curve of Cohort Records Over Time",
                                   xAxisLabel = "Created Date",
                                   yAxisLabel = "Volume") {
  
  # Aggregate data by dateColumn to find the volume for each date
  aggregatedData <- data %>%
    group_by(.data[[dateColumn]]) %>%
    summarise(volume = n())
  
  # Create the ggplot
  plot <- ggplot(aggregatedData, aes(x = .data[[dateColumn]], y = volume)) +
    geom_point() +
    geom_smooth(method = smoothingMethod, se = showStandardError) +
    labs(
      title = plotTitle,
      x = xAxisLabel,
      y = yAxisLabel
    )
  
  # Save the plot as a PNG
  ggsave(outputFilename, plot)
  
  return(paste("Plot saved as '", outputFilename, "'", sep = ""))
}