# Import phenotypes from ATLAS -------------------------------------------------

# Gowtham: I have not touched this code. It should:
# 1. Delete all from inst/cohorts, inst/sql, and Cohorts.csv
# 2. Fetch approved cohorts from ATLAS, and store them in inst/cohorts, inst/sql, and Cohorts.csv
# please make sure Cohorts.csv used camelCase.
#
# We probably want to auto-generate entries for the NEWS.md file as well. Maybe with
# statistics on changed phenotypes?

library(magrittr)
# Set up
baseUrl <- "https://atlas-phenotype.ohdsi.org/WebAPI"
ROhdsiWebApi::authorizeWebApi(baseUrl = baseUrl, 
                              authMethod = "db", 
                              webApiUsername = keyring::key_get("ohdsiAtlasPhenotypeUser"),
                              webApiPassword = keyring::key_get("ohdsiAtlasPhenotypePassword"))

webApiCohorts <- ROhdsiWebApi::getCohortDefinitionsMetaData(baseUrl = baseUrl)
studyCohorts <- webApiCohorts %>% 
  dplyr::filter(stringr::str_detect(string = .data$name, 
                                    pattern = stringr::fixed('['), 
                                    negate = TRUE))

# compile them into a data table
cohortDefinitionsArray <- list()
for (i in (1:nrow(studyCohorts))) {
        cohortDefinition <-
                ROhdsiWebApi::getCohortDefinition(cohortId = studyCohorts$id[[i]],
                                                  baseUrl = baseUrl)
        cohortDefinitionsArray[[i]] <- list(
                id = studyCohorts$id[[i]],
                createdDate = studyCohorts$createdDate[[i]],
                modifiedDate = studyCohorts$createdDate[[i]],
                logicDescription = studyCohorts$description[[i]],
                name = stringr::str_trim(stringr::str_squish(cohortDefinition$name)),
                expression = cohortDefinition$expression
        )
}

tempFolder <- tempdir()
unlink(x = tempFolder, recursive = TRUE, force = TRUE)
dir.create(path = tempFolder, showWarnings = FALSE, recursive = TRUE)

specifications <- list(id = 1,
                       version = version,
                       name = name,
                       packageName = packageName,
                       skeletonVersion = skeletonVersion,
                       createdBy = createdBy,
                       createdDate = createdDate,
                       modifiedBy = modifiedBy,
                       modifiedDate = modifiedDate,
                       skeletonType = skeletonType,
                       organizationName = organizationName,
                       description = description,
                       cohortDefinitions = cohortDefinitionsArray)

jsonFileName <- paste0(file.path(tempFolder, "CohortDiagnosticsSpecs.json"))
write(x = specifications %>% RJSONIO::toJSON(pretty = TRUE, digits = 23), file = jsonFileName)


# Update description -----------------------------------------------------------
description <- readLines("DESCRIPTION")

# Increment minor version:
versionLineNr <- grep("Version: .*$", description)
version <- sub("Version: ", "", descriptionFile[versionLineNr])
versionParts <- strsplit(version, "\\.")[[1]]
versionParts[2] <- as.integer(versionParts[2]) + 1
newVersion <- paste(versionParts, collapse = ".")
description[versionLineNr] <- sprintf("Version: %s", newVersion)

# Set date:
dateLineNr <- grep("Date: .*$", description)
descriptionFile[dateLineNr]  <- sprintf("Date: %s", format(Sys.Date(),"%Y-%m-%d"))

writeLines(description, con = "DESCRIPTION")
