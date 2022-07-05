# Using the official uploading functions to get data from zip files into the postgres database
library(CohortDiagnostics)

# OHDSI's server:
connectionDetails <- createConnectionDetails(
  dbms = Sys.getenv("shinydbDbms", unset = "postgresql"),
  server = paste(
    Sys.getenv("shinydbServer"),
    Sys.getenv("shinydbDatabase"),
    sep = "/"
  ),
  port = Sys.getenv("shinydbPort"),
  user = Sys.getenv("shinydbUser"),
  password = Sys.getenv("shinydbPW")
)
resultsSchema <- 'phenotype_phebruary'

# commenting this function as it maybe accidentally run - loosing data.
# createResultsDataModel(connectionDetails = connectionDetails, schema = resultsSchema)

Sys.setenv("POSTGRES_PATH" = Sys.getenv('POSTGRES_PATH'))

folderWithZipFilesToUpload <- "D:\\studyResults\\phenotypeLibrary"
listOfZipFilesToUpload <-
  list.files(
    path = folderWithZipFilesToUpload,
    pattern = ".zip",
    full.names = TRUE,
    recursive = TRUE
  )

for (i in (1:length(listOfZipFilesToUpload))) {
  CohortDiagnostics::uploadResults(
    connectionDetails = connectionDetails,
    schema = resultsSchema,
    zipFileName = listOfZipFilesToUpload[[i]]
  )
}

# uploadPrintFriendly was removed in version 2.1
# uploadPrintFriendly(connectionDetails = connectionDetails,
#                     schema = resultsSchema)

launchDiagnosticsExplorer(connectionDetails = connectionDetails,
                          resultsDatabaseSchema = resultsSchema)
