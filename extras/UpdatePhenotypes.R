# Import phenotypes from ATLAS -------------------------------------------------

library(magrittr)
oldCohortDefinitions <- PhenotypeLibrary::listPhenotypes()
oldCohortDefinitionSet <-
  PhenotypeLibrary::getPlCohortDefinitionSet(cohortIds = oldCohortDefinitions$cohortId)

# Delete existing cohorts--------------------------------------------
unlink(x = "inst/Cohorts.csv",
       recursive = TRUE,
       force = TRUE)
unlink(x = "inst/cohorts",
       recursive = TRUE,
       force = TRUE)
unlink(x = "inst/sql",
       recursive = TRUE,
       force = TRUE)

# Fetch approved cohort definition----------------------------------
# from atlas-phenotype.ohdsi.org (note: approved phenotypes do not have '[')
baseUrl <- "https://atlas-phenotype.ohdsi.org/WebAPI"
ROhdsiWebApi::authorizeWebApi(
  baseUrl = baseUrl,
  authMethod = "db",
  webApiUsername = keyring::key_get("ohdsiAtlasPhenotypeUser"),
  webApiPassword = keyring::key_get("ohdsiAtlasPhenotypePassword")
)

webApiCohorts <-
  ROhdsiWebApi::getCohortDefinitionsMetaData(baseUrl = baseUrl)

exportableCohorts <-
  dplyr::bind_rows(
    webApiCohorts %>%
      dplyr::filter(
        stringr::str_detect(
          string = .data$name,
          pattern = stringr::fixed('['),
          # Cohorts without prefix
          negate = TRUE
        )
      ),
    webApiCohorts %>%
      dplyr::filter(
        stringr::str_detect(
          string = .data$name,
          pattern = stringr::fixed('[D]'),
          # Deprecated cohorts, as another cohort definition subsumes the cohort definitions intent
          negate = FALSE
        )
      ),
    webApiCohorts %>%
      dplyr::filter(
        stringr::str_detect(
          string = .data$name,
          pattern = stringr::fixed('[P]'),
          # Cohorts under consideration for peer review
          negate = FALSE
        )
      ),
    webApiCohorts %>%
      dplyr::filter(
        stringr::str_detect(
          string = .data$name,
          pattern = stringr::fixed('[E]'),
          # Cohorts that have errors and should not be used
          negate = FALSE
        )
      ),
    webApiCohorts %>%
      dplyr::filter(
        stringr::str_detect(
          string = .data$name,
          pattern = stringr::fixed('[W]'),
          # Cohorts that have been withdrawn
          negate = FALSE
        )
      )
  ) %>%
  dplyr::distinct() %>%
  dplyr::select(.data$id,
                .data$name) %>%
  dplyr::mutate(
    cohortId = .data$id,
    atlasId = .data$id,
    cohortName = .data$name
  ) %>%
  dplyr::arrange(.data$cohortId) %>%
  dplyr::select(.data$cohortId,
                .data$atlasId,
                .data$cohortName)

exportableCohorts %>%
  readr::write_excel_csv(file = "inst/Cohorts.csv",
                         append = FALSE,
                         quote = "all")

try(ROhdsiWebApi::insertCohortDefinitionSetInPackage(
  fileName = "inst/Cohorts.csv",
  baseUrl = baseUrl,
  jsonFolder = "inst/cohorts",
  sqlFolder = "inst/sql/sql_server",
  generateStats = TRUE
),
silent = TRUE)

# doing this again, because atlasId is not required for CohortDefinitionSet
exportableCohorts  %>%
  dplyr::select(.data$cohortId,
                .data$cohortName) %>%
  dplyr::arrange(.data$cohortId) %>%
  readr::write_excel_csv(file = "inst/Cohorts.csv",
                         append = FALSE,
                         quote = "all")

newLogSource <- webApiCohorts %>%
  dplyr::filter(.data$id %in% c(exportableCohorts  %>%
                                  dplyr::pull(.data$cohortId)))

oldLogFile <- PhenotypeLibrary::getPhenotypeLog()
newLogFile <- PhenotypeLibrary::updatePhenotypeLog(updates = newLogSource)

needToUpdate <- TRUE
if (identical(x = oldLogFile, y = newLogFile)) {
  needToUpdate <- FALSE
  writeLines("No changes to cohort definitions. No update to version needed.")
}

if (needToUpdate) {
  readr::write_excel_csv(
    x = newLogFile,
    file = "inst/PhenotypeLog.csv",
    append = FALSE,
    quote = "all"
  )
  
  # Update description -----------------------------------------------------------
  description <- readLines("DESCRIPTION")
  
  # Increment minor version:
  versionLineNr <- grep("Version: .*$", description)
  version <- sub("Version: ", "", description[versionLineNr])
  versionParts <- strsplit(version, "\\.")[[1]]
  versionParts[2] <- as.integer(versionParts[2]) + 1
  newVersion <- paste(versionParts, collapse = ".")
  description[versionLineNr] <- sprintf("Version: %s", newVersion)
  
  # Set date:
  dateLineNr <- grep("Date: .*$", description)
  description[dateLineNr]  <-
    sprintf("Date: %s", format(Sys.Date(), "%Y-%m-%d"))
  
  writeLines(description, con = "DESCRIPTION")
  
  
  # Update news -----------------------------------------------------------
  news <- readLines("NEWS.md")
  
  changes <- newLogFile %>%
    dplyr::anti_join(oldLogFile,
                     by = c("cohortId", "cohortName", "getResults", "addedVersion", "addedDate", "addedNotes", "deprecatedVersion", "deprecatedDate",
                            "deprecatedNotes", "updatedVersion", "updatedDate", "updatedNotes"))
  
  newCohorts <- setdiff(x = sort(newLogFile$cohortId),
                        y = sort(oldLogFile$cohortId))
  
  deprecatedCohorts <- setdiff(
    x = sort(
      newLogFile %>%
        dplyr::filter(!is.na(.data$deprecatedDate)) %>%
        dplyr::pull(.data$cohortId)
    ),
    y = sort(
      oldLogFile %>%
        dplyr::filter(!is.na(.data$deprecatedDate)) %>%
        dplyr::pull(.data$cohortId)
    )
  )
  
  modifiedCohorts <- changes %>%
    dplyr::filter(!.data$cohortId %in% c(newCohorts, deprecatedCohorts)) %>%
    dplyr::pull(.data$cohortId)
  
  messages <- c("")
  if (length(newCohorts) == 0) {
    messages <-
      c(messages,
        "New Cohorts: No new cohorts were added in this release.")
  } else {
    messages <-
      c(messages, paste0("New Cohorts: ", length(newCohorts), " were added."))
    for (i in (1:length(newCohorts))) {
      dataCohorts <- newLogFile %>%
        dplyr::filter(.data$cohortId %in% newCohorts[[i]])
      messages <-
        c(messages,
          paste0("    ",
                 dataCohorts$cohortId,
                 ": ",
                 dataCohorts$cohortName))
    }
  }
  
  if (length(deprecatedCohorts) == 0) {
    messages <-
      c(messages,
        "Deprecated Cohorts: No new cohorts were added in this release.")
  } else {
    messages <-
      c(messages,
        "",
        paste0(
          "Deprecated Cohorts: ",
          length(deprecatedCohorts),
          " were deprecated."
        ))
    for (i in (1:length(deprecatedCohorts))) {
      dataCohorts <- changes %>%
        dplyr::filter(.data$cohortId %in% deprecatedCohorts[[i]])
      messages <-
        c(messages,
          paste0("    ",
                 dataCohorts$cohortId,
                 ": ",
                 dataCohorts$cohortName))
    }
  }
  
  if (length(modifiedCohorts) == 0) {
    messages <-
      c(messages,
        "Modified Cohorts: No cohorts were modified in this release.")
  } else {
    messages <-
      c(messages,
        "",
        paste0(
          "Modified Cohorts: ",
          length(modifiedCohorts),
          " were modified."
        ))
    for (i in (1:length(modifiedCohorts))) {
      dataCohorts <- changes %>%
        dplyr::filter(.data$cohortId %in% modifiedCohorts[[i]])
      messages <-
        c(messages,
          paste0("    ",
                 dataCohorts$cohortId,
                 ": ",
                 dataCohorts$cohortName))
    }
  }
  
  news <- c(
    paste0("PhenotypeLibrary ", newVersion),
    "======================",
    messages,
    "",
    news
  )
  writeLines(news, con = "NEWS.md")
}
