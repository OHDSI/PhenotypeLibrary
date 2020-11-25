# set up connections

library(magrittr)
baseUrl <- Sys.getenv("BaseUrl")
connectionDetais <- DatabaseConnector::createConnectionDetails(dbms = "postgresql",
                                                               user = Sys.getenv("phenotypeLibraryDbUser"),
                                                               password = Sys.getenv("phenotypeLibraryDbPassword"),
                                                               server = paste(Sys.getenv("phenotypeLibraryDbServer"), Sys.getenv("phenotypeLibraryDbDatabase"), sep = "/"),
                                                               port = Sys.getenv("phenotypeLibraryDbPort"))
connection <- DatabaseConnector::connect(connectionDetails = connectionDetais)

resultsDatabaseSchema <- Sys.getenv("phenotypeLibraryDbResultsSchema")
vocabularyDatabaseSchema <- Sys.getenv("phenotypeLibraryDbVocabularySchema")




# code for concept recommender
getRecommenderStandardSql <- SqlRender::readSql(file.path(system.file(package = "CohortDiagnostics"),
                                                          "shiny/DiagnosticsExplorer/sql/RecommendationStandard.sql"))
getRecommenderSourceSql <- SqlRender::readSql(file.path(system.file(package = "CohortDiagnostics"),
                                                        "shiny/DiagnosticsExplorer/sql/RecommendationSource.sql"))
getRecommendedConcepts <- function(conceptIds,
                                   connection,
                                   vocabularyDatabaseSchema,
                                   resultsDatabaseSchema,
                                   standard = TRUE) {
  conceptSetSqlTemplate <- "SELECT DISTINCT 0 as codeset_id, c.concept_id FROM
(select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (@resolvedConceptIds)) C"

  conceptSetSql <- SqlRender::render(sql = conceptSetSqlTemplate,
                                     resolvedConceptIds = conceptIds,
                                     vocabulary_database_schema = vocabularyDatabaseSchema)
  if (standard) {
    sql <- getRecommenderStandardSql
  } else {
    sql <- getRecommenderSourceSql
  }

  data <- DatabaseConnector::renderTranslateQuerySql(sql = sql,
                                                     connection = connection,
                                                     target_database_schema = resultsDatabaseSchema,
                                                     vocabulary_database_schema = vocabularyDatabaseSchema,
                                                     concept_set_query = conceptSetSql,
                                                     snakeCaseToCamelCase = TRUE) %>%
    dplyr::tibble()
  return(data)
}

# code to create referent concept set expression
createReferentConceptSetExpression <- function(baseUrl, referentConceptId) {
  conceptSetExpression <- list()
  conceptSetExpression$items[[1]]$concept <- as.list(ROhdsiWebApi::getConcepts(conceptIds = referentConceptId, baseUrl = baseUrl, snakeCaseToCamelCase = FALSE))
  conceptSetExpression$items[[1]]$isExclude <- FALSE
  conceptSetExpression$items[[1]]$includeDescendants <- TRUE
  conceptSetExpression$items[[1]]$includeMapped <- FALSE
  return(conceptSetExpression)
}

getRecommendedConceptsFromConceptIds <- function(conceptIds,
                                                 connection,
                                                 baseUrl = NULL,
                                                 vocabularyDatabaseSchema,
                                                 resultsDatabaseSchema) {
  referentConcept <- NULL
  if (length(conceptIds) == 1 && (!is.null(baseUrl))) {
    print("Assuming this is referent concept id")
    referentConceptSetExpression <- createReferentConceptSetExpression(baseUrl = baseUrl,
                                                                       referentConceptId = conceptIds)
    conceptIds <- ROhdsiWebApi::resolveConceptSet(conceptSetDefinition = referentConceptSetExpression, baseUrl = baseUrl)
  }

  standard <- getRecommendedConcepts(conceptIds = conceptIds,
                                     connection = connection,
                                     vocabularyDatabaseSchema = vocabularyDatabaseSchema,
                                     resultsDatabaseSchema = resultsDatabaseSchema,
                                     standard = TRUE)
  nonStandard <- getRecommendedConcepts(conceptIds = conceptIds,
                                        connection = connection,
                                        vocabularyDatabaseSchema = vocabularyDatabaseSchema,
                                        resultsDatabaseSchema = resultsDatabaseSchema,
                                        standard = FALSE)
  return(dplyr::bind_rows(standard, nonStandard))
}


source(file = file.path(system.file(package = "CohortDiagnostics"),
                        "shiny/DiagnosticsExplorer/R/GitHubScraper.R"))

recommended <- list()
for (i in (1:length(listOfReferentConceptIds))) {
  referentConceptId <- listOfReferentConceptIds[[i]]
  referentConcept <- ROhdsiWebApi::getConcepts(conceptIds = referentConceptId, baseUrl = baseUrl)
  recommended[[i]] <- getRecommendedConceptsFromConceptIds(conceptIds = referentConceptId,
                                                           baseUrl = baseUrl,
                                                           connection = connection,
                                                           vocabularyDatabaseSchema = vocabularyDatabaseSchema,
                                                           resultsDatabaseSchema = resultsDatabaseSchema) %>%
    dplyr::mutate(phenotypeId = referentConceptId * 1000,
                  phenotypeName = referentConcept$conceptName,
                  referentConcept = dplyr::case_when(conceptId == referentConceptId ~ 'Y', TRUE ~ 'N')
    ) %>%
    dplyr::relocate(phenotypeId, phenotypeName, referentConcept) %>%
      dplyr::arrange(conceptId)
}
recommended <- dplyr::bind_rows(recommended) %>%
  dplyr::arrange(phenotypeId, dplyr::desc(referentConcept), conceptId)

basePath <- ""
openxlsx::write.xlsx(x = recommended, file = file.path(basePath, "extras\\DesignDiagnosticsConcepts.xlsx"), asTable = TRUE)
DatabaseConnector::disconnect(connection = connection)
