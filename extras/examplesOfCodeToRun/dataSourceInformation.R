source(Sys.getenv("startUpScriptLocation"))

######
executeOnMultipleDataSources <- function(x) {
  library(magrittr)
  if (x$generateCohortTableName) {
    cohortTableName <- paste0(
      stringr::str_squish(x$databaseId),
      stringr::str_squish("phenotypeLibrary")
    )
  }
  
  # this function gets details of the data source from cdm source table in omop, if populated.
  # The assumption is the cdm_source.sourceDescription has text description of data source.
  
  getDataSourceInformation <-
    function(connectionDetails,
             cdmDatabaseSchema,
             vocabDatabaseSchema,
             databaseId) {
      sqlCdmDataSource <- "select * from @cdmDatabaseSchema.cdm_source;"
      sqlVocabularyVersion <-
        "select * from @vocabDatabaseSchema.vocabulary where vocabulary_id = 'None';"
      etlVersionNumber <-
        "select * from @cdmDatabaseSchema._version;"
      sourceInfo <- list(cdmSourceName = databaseId,
                         sourceDescription = databaseId)
      
      if (!is.null(connectionDetails)) {
        connection <-
          DatabaseConnector::connect(connectionDetails = connectionDetails)
      } else {
        return(NULL)
      }
      
      vocabulary <-
        DatabaseConnector::renderTranslateQuerySql(
          connection = connection,
          sql = sqlVocabularyVersion,
          vocabDatabaseSchema = vocabDatabaseSchema,
          snakeCaseToCamelCase = TRUE
        ) %>%
        dplyr::tibble() %>%
        dplyr::rename(vocabularyVersion = .data$vocabularyVersion)
      
      tryCatch(
        expr = {
          cdmDataSource <-
            DatabaseConnector::renderTranslateQuerySql(
              connection = connection,
              sql = sqlCdmDataSource,
              cdmDatabaseSchema = cdmDatabaseSchema,
              snakeCaseToCamelCase = TRUE
            )
          if (nrow(cdmDataSource) == 0) {
            warning("cdmDataSource table has no data")
            return(sourceInfo)
          } else {
            cdmDataSource <- cdmDataSource %>%
              dplyr::tibble() %>%
              dplyr::rename(vocabularyVersionCdm = .data$vocabularyVersion)
          }
          sourceInfo$sourceDescription <- ""
          if ("sourceDescription" %in% colnames(cdmDataSource)) {
            sourceInfo$sourceDescription <- paste0(sourceInfo$sourceDescription,
                                                   " ",
                                                   cdmDataSource$sourceDescription) %>%
              stringr::str_trim()
          }
          if ("cdmSourceName" %in% colnames(cdmDataSource)) {
            sourceInfo$cdmSourceName <- cdmDataSource$cdmSourceName
          } else {
            warning("cdmSourceName column not found in cdmDataSource table")
          }
          if ("cdmEtlReference" %in% colnames(cdmDataSource)) {
            sourceInfo$sourceDescription <- paste0(
              sourceInfo$sourceDescription,
              " ETL Reference: ",
              cdmDataSource$cdmEtlReference
            ) %>%
              stringr::str_trim()
          } else {
            warning("cdmEtlReference column not found in cdmDataSource table")
            sourceInfo$sourceDescription <-
              paste0(sourceInfo$sourceDescription,
                     " ETL Reference: None") %>%
              stringr::str_trim()
          }
          if ("cdmReleaseDate" %in% colnames(cdmDataSource)) {
            sourceInfo$sourceDescription <- paste0(
              sourceInfo$sourceDescription,
              " CDM release date: ",
              as.character(cdmDataSource$cdmReleaseDate)
            ) %>%
              stringr::str_trim()
          } else {
            warning("cdmReleaseDate column not found in cdmDataSource table")
            sourceInfo$sourceDescription <-
              paste0(sourceInfo$sourceDescription,
                     " CDM release date: None") %>%
              stringr::str_trim()
          }
          if ("sourceReleaseDate" %in% colnames(cdmDataSource)) {
            sourceInfo$sourceDescription <- paste0(
              sourceInfo$sourceDescription,
              " Source release date: ",
              as.character(cdmDataSource$sourceReleaseDate)
            ) %>%
              stringr::str_trim()
          } else {
            warning("sourceReleaseDate column not found in cdmDataSource table")
            sourceInfo$sourceDescription <-
              paste0(sourceInfo$sourceDescription,
                     " Source release date: None") %>%
              stringr::str_trim()
          }
          if ("sourceDocumentationReference" %in% colnames(cdmDataSource)) {
            sourceInfo$sourceDescription <- paste0(
              sourceInfo$sourceDescription,
              " Source Documentation Reference: ",
              as.character(cdmDataSource$sourceDocumentationReference)
            ) %>%
              stringr::str_trim()
          } else {
            warning("sourceDocumentationReference column not found in cdmDataSource table")
            sourceInfo$sourceDescription <-
              paste0(sourceInfo$sourceDescription,
                     " Source Documentation Reference: None") %>%
              stringr::str_trim()
          }
        },
        error = function(...) {
          return(sourceInfo)
        }
      )
      
      version <- dplyr::tibble()
      tryCatch(
        expr = {
          version <-
            DatabaseConnector::renderTranslateQuerySql(
              connection = connection,
              sql = etlVersionNumber,
              cdmDatabaseSchema = cdmDatabaseSchema,
              snakeCaseToCamelCase = TRUE
            ) %>%
            dplyr::tibble() %>%
            dplyr::mutate(rn = dplyr::row_number()) %>%
            dplyr::filter(.data$rn == 1) %>%
            dplyr::select(-.data$rn)
        },
        error = function(...) {
          warning("_version table not found")
          return(NULL)
        }
      )
      
      if (nrow(version) == 1) {
        if (all('versionId' %in% colnames(version),
                'versionDate' %in% colnames(version))) {
          cdmDataSource <- cdmDataSource %>%
            dplyr::mutate(
              cdmSourceAbbreviation = paste0(
                .data$cdmSourceAbbreviation,
                " (v",
                version$versionId,
                " ",
                as.character(version$versionDate),
                ")"
              )
            ) %>%
            dplyr::mutate(
              cdmSourceName = paste0(
                .data$cdmSourceName,
                " (v",
                version$versionId,
                " ",
                as.character(version$versionDate),
                ")"
              )
            ) %>%
            dplyr::mutate(
              sourceDescription = paste0(
                .data$sourceDescription,
                " (v",
                version$versionId,
                " ",
                as.character(version$versionDate),
                ")"
              )
            )
        }
      }
      
      DatabaseConnector::disconnect(connection = connection)
      return(if (nrow(cdmDataSource) > 0) {
        tidyr::crossing(cdmDataSource, vocabulary, version) %>%
          dplyr::mutate(databaseDescription =
                          .data$sourceDescription)
      } else {
        warning("cdmDataSource table has no data")
        vocabulary
      })
    }
  
  
  # Details for connecting to the server:
  connectionDetails <-
    DatabaseConnector::createConnectionDetails(
      dbms = x$cdmSource$dbms,
      server = x$cdmSource$server,
      user = keyring::key_get(service = x$userService),
      password =  keyring::key_get(service = x$passwordService),
      port = x$cdmSource$port
    )
  # The name of the database schema where the CDM data can be found:
  cdmDatabaseSchema <- x$cdmSource$cdmDatabaseSchema
  vocabDatabaseSchema <- x$cdmSource$vocabDatabaseSchema
  cohortDatabaseSchema <- x$cdmSource$cohortDatabaseSchema
  
  dataSourceDetails <- getDataSourceInformation(
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema,
    vocabDatabaseSchema = vocabDatabaseSchema,
    databaseId = x$databaseId
  )
  
  if (all(!is.null(dataSourceDetails),
          nrow(dataSourceDetails) == 1,
          nchar(dataSourceDetails$versionId) > 0)) {
    databaseId <- paste0(x$databaseId, " (v",dataSourceDetails$versionId, " ", as.character(dataSourceDetails$versionDate), ")")
  } else {
    databaseId <- x$databaseId
  }
  
  phenotypeLibrary::execute(
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema,
    cohortDatabaseSchema = cohortDatabaseSchema,
    cohortTable = cohortTableName,
    verifyDependencies = x$verifyDependencies,
    outputFolder = x$outputFolder,
    databaseId = databaseId,
    databaseName = dataSourceDetails$cdmSourceName,
    databaseDescription = dataSourceDetails$sourceDescription
  )
}
