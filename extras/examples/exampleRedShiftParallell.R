############### Note this is a custom script, a version of CodeToRun.R that may not work for everyone ##############
############### Please use CodeToRun.R as it a more generic version  ###############################################

############### This version of code will run cohort diagnostics in parallel                      ##################

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
options(andromedaTempFolder = file.path(outputFolder, "andromedaTemp"))

# lets get meta information for each of these databaseId. This includes connection information.
source("extras/examples/dataSourceInformation.R")

# cdmSources <- cdmSources2
# rm("cdmSources2")
############## databaseIds to run cohort diagnostics on that source  #################
databaseIds <-
  c(
    'truven_ccae',
    'truven_mdcd',
    'cprd',
    'jmdc',
    'optum_extended_dod',
    'optum_ehr',
    'truven_mdcr',
    'ims_australia_lpd',
    'ims_germany',
    'ims_france')

## service name for keyring for db with cdm
keyringUserService <- 'OHDSI_USER'
keyringPasswordService <- 'OHDSI_PASSWORD'




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

# use Parallel Logger to run in parallel
cluster <-
  ParallelLogger::makeCluster(numberOfThreads = as.integer(trunc(parallel::detectCores() /
                                                                   2)))

## file logger
loggerName <-
  paste0(
    "CDF_",
    stringr::str_replace_all(
      string = Sys.time(),
      pattern = ":|-|EDT| ",
      replacement = ''
    )
  )
loggerTrace <-
  ParallelLogger::addDefaultFileLogger(fileName = file.path(outputFolder, paste0(loggerName, ".txt")))


ParallelLogger::clusterApply(cluster = cluster,
                             x = x,
                             fun = executeOnMultipleDataSources)

writeLines(readChar(paste0(loggerName, ".txt"), file.info(paste0(loggerName, ".txt"))$size))
ParallelLogger::stopCluster(cluster = cluster)
