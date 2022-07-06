# Import phenotypes from ATLAS -------------------------------------------------

# Gowtham: I have not touched this code. It should:
# 2. Fetch approved cohorts from ATLAS, and store them in inst/cohorts, inst/sql, and Cohorts.csv
# please make sure Cohorts.csv used camelCase.
#
# We probably want to auto-generate entries for the NEWS.md file as well. Maybe with
# statistics on changed phenotypes?

library(magrittr)
# Set up

# Delete existing cohorts
unlink(x = "inst/Cohorts.csv", recursive = TRUE, force = TRUE)
unlink(x = "inst/cohorts", recursive = TRUE, force = TRUE)
unlink(x = "inst/sql", recursive = TRUE, force = TRUE)

# Fetch approved cohort definition from atlas-phenotype.ohdsi.org (note: approved phenotypes do not have '[')
baseUrl <- "https://atlas-phenotype.ohdsi.org/WebAPI"
ROhdsiWebApi::authorizeWebApi(baseUrl = baseUrl, 
                              authMethod = "db", 
                              webApiUsername = keyring::key_get("ohdsiAtlasPhenotypeUser"),
                              webApiPassword = keyring::key_get("ohdsiAtlasPhenotypePassword"))

webApiCohorts <- ROhdsiWebApi::getCohortDefinitionsMetaData(baseUrl = baseUrl)

webApiCohorts %>% 
  dplyr::filter(stringr::str_detect(string = .data$name, 
                                    pattern = stringr::fixed('['), 
                                    negate = TRUE)) %>% 
  dplyr::select(.data$id,
                .data$name) %>% 
  dplyr::rename(cohortId = .data$id,
                atlasId = .data$id,
                cohortName = .data$name) %>% 
  readr::write_excel_csv(file = "inst/Cohorts.csv", 
                         append = FALSE, 
                         quote = "all")

ROhdsiWebApi::insertCohortDefinitionSetInPackage(fileName = "inst/Cohorts.csv", 
                                                 baseUrl = baseUrl, 
                                                 jsonFolder = "inst/cohorts", 
                                                 sqlFolder = "inst/sql/sql_server", 
                                                 generateStats = TRUE)

# doing this again, because atlasId is not required for CohortDefinitionSet
webApiCohorts %>% 
  dplyr::filter(stringr::str_detect(string = .data$name, 
                                    pattern = stringr::fixed('['), 
                                    negate = TRUE)) %>% 
  dplyr::select(.data$id,
                .data$name) %>% 
  dplyr::rename(cohortId = .data$id,
                cohortName = .data$name) %>% 
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
