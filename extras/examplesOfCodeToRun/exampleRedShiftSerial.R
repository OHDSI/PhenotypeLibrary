############### Note this is a custom script, a version of CodeToRun.R that may not work for everyone ##############
############### Please use CodeToRun.R as it a more generic version  ###############################################

############### This version of code will loop over each database ids in serial                      ###############

############### processes to run Cohort Diagnostics ################################################################
library(magrittr)

################################################################################
# VARIABLES - please change
################################################################################
# The folder where the study intermediate and result files will be written:
outputFolder <- "D:/studyResults/phenotypeLibrary"
# create output directory if it does not exist
if (!dir.exists(outputFolder)) {
  dir.create(outputFolder,
             showWarnings = FALSE,
             recursive = TRUE)
}
# Optional: specify a location on your disk drive that has sufficient space.
# options(andromedaTempFolder = "s:/andromedaTemp")

############## databaseIds to run cohort diagnostics on that source  #################
databaseIds <-
  c(
    'truven_ccae',
    'truven_mdcd',
    'truven_mdcr',
    'cprd',
    'jmdc',
    'optum_extended_dod',
    'optum_ehr',
    'ims_australia_lpd',
    'ims_germany',
    'ims_france'
  )

## service name for keyring for db with cdm
keyringUserService <- 'OHDSI_USER'
keyringPasswordService <- 'OHDSI_PASSWORD'

# lets get meta information for each of these databaseId. This includes connection information.
source("extras/examplesOfCodeToRun/dataSourceInformation.R")
cdmSources <- cdmSources2
rm("cdmSources2")

###### create a list object that contain connection and meta information for each data source
x <- list()
for (i in (1:length(databaseIds))) {
  cdmSource <- cdmSources %>%
    dplyr::filter(.data$sequence == 1) %>%
    dplyr::filter(database == databaseIds[[i]])
  
  x[[i]] <- list(
    cdmSource = cdmSource,
    generateCohortTableName = TRUE,
    verifyDependencies = FALSE,
    databaseId = databaseIds[[i]],
    outputFolder = file.path(outputFolder, databaseIds[[i]]),
    userService = keyringUserService,
    passwordService = keyringPasswordService,
    preMergeDiagnosticsFiles = TRUE
  )
}


############ executeOnMultipleDataSources #################
# x <- x[1:2]
for (i in (1:length(x))) {
  i = 1
  debug(executeOnMultipleDataSources)
  executeOnMultipleDataSources(x[[i]])
}
#
# # launch cohort explorer
# for (i in (1:length(x))) {
#   cohortTableName <- paste0(
#     stringr::str_squish(x$databaseId),
#     stringr::str_squish("phenotypeLibrary")
#   )
#   # Details for connecting to the server:
#   connectionDetails <-
#     DatabaseConnector::createConnectionDetails(
#       dbms = x$cdmSource$dbms,
#       server = x$cdmSource$server,
#       user = keyring::key_get(service = x$userService),
#       password =  keyring::key_get(service = x$passwordService),
#       port = x$cdmSource$port
#     )
#   cdmDatabaseSchema <- x$cdmSource$cdmDatabaseSchema
#   cohortDatabaseSchema <- x$cdmSource$cohortDatabaseSchema
#   CohortDiagnostics::launchCohortExplorer(connectionDetails = connectionDetails,
#                                           cdmDatabaseSchema = cdmDatabaseSchema,
#                                           cohortDatabaseSchema = cohortDatabaseSchema,
#                                           cohortTable = cohortTable,
#                                           cohortId = -1
#   )
# }
#
#
