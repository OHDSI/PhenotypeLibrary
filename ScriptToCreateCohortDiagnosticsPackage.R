outputFolder <- file.path(".")

unlink(x = "extras", recursive = TRUE, force = TRUE)
unlink(x = "DESCRIPTION", recursive = TRUE, force = TRUE)
unlink(x = "inst", recursive = TRUE, force = TRUE)
unlink(x = "man", recursive = TRUE, force = TRUE)
unlink(x = "R", recursive = TRUE, force = TRUE)
unlink(x = "renv.lock", recursive = TRUE, force = TRUE)
unlink(x = "NAMESPACE", recursive = TRUE, force = TRUE)
unlink(x = ".Rproj.user", recursive = TRUE, force = TRUE)

########## Please populate the information below #####################
version <- paste0(stringr::str_replace_all(
  string = as.character(Sys.Date()),
  pattern = stringr::fixed("-"),
  replacement = ""
), ".0.1")


name <- "OHDSI Phenotype Library"
packageName <- "phenotypeLibrary"
skeletonVersion <- "v0.0.1"
createdBy <- "rao@ohdsi.org"
createdDate <- Sys.Date() # default
modifiedBy <- "rao@ohdsi.org"
modifiedDate <- Sys.Date()
skeletonType <- "CohortDiagnosticsStudy"
organizationName <- "OHDSI"
description <- "Cohort diagnostics on OHDSI Phenotype Library."

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


#### get the skeleton from github
download.file(url = "https://github.com/OHDSI/SkeletonCohortDiagnosticsStudy/archive/refs/heads/main.zip",
                         destfile = file.path(tempFolder, 'skeleton.zip'))
unzip(zipfile =  file.path(tempFolder, 'skeleton.zip'),
      overwrite = TRUE,
      exdir = file.path(tempFolder, "skeleton")
        )
fileList <- list.files(path = file.path(tempFolder, "skeleton"), full.names = TRUE, recursive = TRUE, all.files = TRUE)
DatabaseConnector::createZipFile(zipFile = file.path(tempFolder, 'skeleton.zip'),
                                 files = fileList,
                                 rootFolder = list.dirs(file.path(tempFolder, 'skeleton'), recursive = FALSE))

hydraSpecificationFromFile <- Hydra::loadSpecifications(fileName = jsonFileName)
unlink(x = outputFolder, recursive = TRUE)
dir.create(path = file.path(outputFolder), showWarnings = FALSE, recursive = TRUE)

Hydra::hydrate(specifications = hydraSpecificationFromFile,
               outputFolder = outputFolder,
               skeletonFileName = file.path(tempFolder, 'skeleton.zip')
)

unlink(x = tempFolder, recursive = TRUE, force = TRUE)


descriptionFile <- readLines("DESCRIPTION")
descriptionFile2  <-
  gsub(
    pattern = "Version: 0.0.1",
    replace = paste0(
      "Version: ",
      version
    ),
    x = descriptionFile
  )
writeLines(descriptionFile2, con="DESCRIPTION")


readr::read_csv(file = file.path(outputFolder, "inst", "settings", "CohortsToCreate.csv"),
                                col_types = readr::cols()) %>%
  dplyr::select(.data$cohortId,
                .data$cohortName) %>%
  SqlRender::camelCaseToSnakeCaseNames() %>%
  readr::write_excel_csv(file = file.path(outputFolder, "inst", "settings", "CohortsToCreate.csv"),
                         na = "")
