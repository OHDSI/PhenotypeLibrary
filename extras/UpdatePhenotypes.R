# Import phenotypes from ATLAS -------------------------------------------------

library(magrittr)
oldCohortDefinitions <- PhenotypeLibrary::listPhenotypes()
oldCohortDefinitionSet <- PhenotypeLibrary::getPlCohortDefinitionSet(cohortIds = oldCohortDefinitions$cohortId)

# Delete existing cohorts--------------------------------------------
unlink(x = "inst/Cohorts.csv", recursive = TRUE, force = TRUE)
unlink(x = "inst/cohorts", recursive = TRUE, force = TRUE)
unlink(x = "inst/sql", recursive = TRUE, force = TRUE)

# Fetch approved cohort definition----------------------------------
# from atlas-phenotype.ohdsi.org (note: approved phenotypes do not have '[')
baseUrl <- "https://atlas-phenotype.ohdsi.org/WebAPI"
ROhdsiWebApi::authorizeWebApi(baseUrl = baseUrl, 
                              authMethod = "db", 
                              webApiUsername = keyring::key_get("ohdsiAtlasPhenotypeUser"),
                              webApiPassword = keyring::key_get("ohdsiAtlasPhenotypePassword"))

webApiCohorts <- ROhdsiWebApi::getCohortDefinitionsMetaData(baseUrl = baseUrl)

exportableCohorts <- webApiCohorts %>%
  dplyr::filter(stringr::str_detect(
    string = .data$name,
    pattern = stringr::fixed('['),
    negate = TRUE
  )) %>%
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

ROhdsiWebApi::insertCohortDefinitionSetInPackage(fileName = "inst/Cohorts.csv", 
                                                 baseUrl = baseUrl, 
                                                 jsonFolder = "inst/cohorts", 
                                                 sqlFolder = "inst/sql/sql_server", 
                                                 generateStats = TRUE)

# doing this again, because atlasId is not required for CohortDefinitionSet
exportableCohorts  %>% 
  dplyr::select(.data$cohortId,
                .data$cohortName) %>% 
  readr::write_excel_csv(file = "inst/Cohorts.csv", 
                         append = FALSE, 
                         quote = "all")

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
description[dateLineNr]  <- sprintf("Date: %s", format(Sys.Date(),"%Y-%m-%d"))

writeLines(description, con = "DESCRIPTION")


# Update news -----------------------------------------------------------
news <- readLines("NEWS.md")
newCohorts <- setdiff(x = sort(exportableCohorts$cohortId), 
                      y = sort(oldCohortDefinitionSet$cohortId))

messages <- c("")
if (length(newCohorts) == 0) {
  messages <- c(messages, "New Cohorts: No new cohorts were added in this release.")
} else {
  messages <- c(messages, paste0("New Cohorts: ", length(newCohorts), " were added."))
  for (i in (1:length(newCohorts))) {
    messages <- c(messages, paste0("    ", exportableCohorts[i,]$cohortId, ": ", exportableCohorts[i,]$cohortName))
  }
}

news <- c(paste0("PhenotypeLibrary ", newVersion),
          "======================",
          messages,
          "",
          news)
writeLines(news, con = "NEWS.md")


#TO DO : check if json changed. and if changed add to NEWS.md
