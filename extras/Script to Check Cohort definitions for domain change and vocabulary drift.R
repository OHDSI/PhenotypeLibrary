# cohortDefinitionSet <- PhenotypeLibrary::getPlCohortDefinitionSet(cohortIds = PhenotypeLibrary::getPhenotypeLog()$cohortId)
# saveRDS(object = cohortDefinitionSet, "cohortDefinitionSet.RDS")
cohortDefinitionSet <- readRDS("cohortDefinitionSet.RDS")

# 1: retrieve concept sets from cohort definition set -----
cohortDefinitionsToCheckIfUpdateIsNeeded <- cohortDefinitionSet |>
  dplyr::select(
    cohortId,
    cohortName,
    sql,
    json
  ) |>
  dplyr::arrange(cohortId)

# conceptSetsInAllCohortDefinition <-
#   ConceptSetDiagnostics::extractConceptSetsInCohortDefinitionSet(cohortDefinitionSet = cohortDefinitionsToCheckIfUpdateIsNeeded)
#
# saveRDS(object = conceptSetsInAllCohortDefinition,
#         file = "conceptSetsInAllCohortDefinition.RDS")

conceptSetsInAllCohortDefinition <-
  readRDS("conceptSetsInAllCohortDefinition.RDS")


# 2: identify all unique concept sets -----
uniqueConceptSets <- conceptSetsInAllCohortDefinition |>
  dplyr::select(
    uniqueConceptSetId,
    conceptSetSql
  ) |>
  dplyr::distinct()


# 3: resolve concept set by vocabulary version
resolvedConceptIdsOldVocabulary <- c()
resolvedConceptIdsNewVocabulary <- c()

# old vocabulary
oldCdmSource <-
  OhdsiHelpers::getCdmSource(cdmSources = cdmSources, sequence = 3, database = "optum_extended_dod")
oldConnectionDetails <-
  OhdsiHelpers::createConnectionDetails(cdmSources = cdmSources, sequence = 3, database = "optum_extended_dod")

# new vocabulary
newCdmSource <-
  OhdsiHelpers::getCdmSource(cdmSources = cdmSources, database = "optum_extended_dod")
newConnectionDetails <-
  OhdsiHelpers::createConnectionDetails(cdmSources = cdmSources, database = "optum_extended_dod")


# for (i in (1:nrow(uniqueConceptSets))) {
#   writeLines(
#     paste0(
#       "working on ",
#       OhdsiHelpers::formatIntegerWithComma(i),
#       " out of ",
#       OhdsiHelpers::formatIntegerWithComma(nrow(uniqueConceptSets)),
#       " at ",
#       as.character(Sys.Date()),
#       " ",
#       as.character(Sys.time())
#     )
#   )
#
#   dir.create("resolvedConceptIdsVocabulary",
#              showWarnings = FALSE,
#              recursive = TRUE)
#
#
#   if (!file.exists(file.path(
#     "resolvedConceptIdsVocabulary",
#     paste0("resolvedConceptIdsOldVocabulary",
#            i,
#            ".RDS")
#   ))) {
#     # resolve using old vocabulary
#     resolvedConceptIdsOldVocabulary <-
#       DatabaseConnector::renderTranslateQuerySql(
#         sql = uniqueConceptSets[i, ]$conceptSetSql,
#         connection = DatabaseConnector::connect(connectionDetails = oldConnectionDetails),
#         vocabulary_database_schema = oldCdmSource$vocabDatabaseSchemaFinal,
#         snakeCaseToCamelCase = TRUE
#       ) |>
#       dplyr::mutate(uniqueConceptSetId = uniqueConceptSets[i, ]$uniqueConceptSetId) |>
#       dplyr::tibble()
#
#     saveRDS(object = resolvedConceptIdsOldVocabulary,
#             file.path(
#               "resolvedConceptIdsVocabulary",
#               paste0("resolvedConceptIdsOldVocabulary",
#                      i,
#                      ".RDS")
#             ))
#
#     # resolve using new vocabulary
#     resolvedConceptIdsNewVocabulary <-
#       DatabaseConnector::renderTranslateQuerySql(
#         sql = uniqueConceptSets[i, ]$conceptSetSql,
#         connection = DatabaseConnector::connect(connectionDetails = newConnectionDetails),
#         vocabulary_database_schema = newCdmSource$vocabDatabaseSchemaFinal,
#         snakeCaseToCamelCase = TRUE
#       ) |>
#       dplyr::mutate(uniqueConceptSetId = uniqueConceptSets[i, ]$uniqueConceptSetId) |>
#       dplyr::tibble()
#
#     saveRDS(object = resolvedConceptIdsNewVocabulary,
#             file.path(
#               "resolvedConceptIdsVocabulary",
#               paste0("resolvedConceptIdsNewVocabulary",
#                      i,
#                      ".RDS")
#             ))
#   } else {
#     writeLines(paste0("Skipping ",
#                       OhdsiHelpers::formatIntegerWithComma(i)))
#   }
#
# }


old <- list.files(
  path = "resolvedConceptIdsVocabulary",
  pattern = "resolvedConceptIdsOldVocabulary",
  recursive = TRUE,
  all.files = TRUE,
  full.names = TRUE
)
new <- list.files(
  path = "resolvedConceptIdsVocabulary",
  pattern = "resolvedConceptIdsNewVocabulary",
  recursive = TRUE,
  all.files = TRUE,
  full.names = TRUE
)

resolvedConceptIdsOldVocabulary <- c()
resolvedConceptIdsNewVocabulary <- c()
for (i in (1:length(old))) {
  resolvedConceptIdsOldVocabulary[[i]] <- readRDS(old[[i]])
}
for (i in (1:length(new))) {
  resolvedConceptIdsNewVocabulary[[i]] <- readRDS(new[[i]])
}
# save in each iteration
resolvedConceptIdsOldVocabulary |>
  dplyr::bind_rows() |>
  saveRDS(file = "resolvedConceptIdsOldVocabulary.RDS")
resolvedConceptIdsNewVocabulary |>
  dplyr::bind_rows() |>
  saveRDS(file = "resolvedConceptIdsNewVocabulary.RDS")

# read resolved set
resolvedConceptIdsOldVocabulary <-
  readRDS("resolvedConceptIdsOldVocabulary.RDS")
resolvedConceptIdsNewVocabulary <-
  readRDS("resolvedConceptIdsNewVocabulary.RDS")

# #get mapped concept set
# mappedConceptsOldVocabulary <-
#   ConceptSetDiagnostics::getMappedSourceConcepts(
#     conceptIds = c(
#       resolvedConceptIdsOldVocabulary$conceptId,
#       resolvedConceptIdsNewVocabulary$conceptId
#     ) |>
#       unique() |>
#       sort(),
#     connection = DatabaseConnector::connect(connectionDetails = oldConnectionDetails),
#     vocabularyDatabaseSchema = oldCdmSource$vocabDatabaseSchemaFinal
#   )
# saveRDS(object = mappedConceptsOldVocabulary, file = "mappedConceptsOldVocabulary.RDS")
mappedConceptsOldVocabulary <- readRDS("mappedConceptsOldVocabulary.RDS")


# mappedConceptsNewVocabulary <-
#   ConceptSetDiagnostics::getMappedSourceConcepts(
#     conceptIds = c(
#       resolvedConceptIdsOldVocabulary$conceptId,
#       resolvedConceptIdsNewVocabulary$conceptId
#     ) |>
#       unique() |>
#       sort(),
#     connection = DatabaseConnector::connect(connectionDetails = newConnectionDetails),
#     vocabularyDatabaseSchema = newCdmSource$vocabDatabaseSchemaFinal
#   )
# saveRDS(object = mappedConceptsNewVocabulary, file = "mappedConceptsNewVocabulary.RDS")
mappedConceptsNewVocabulary <- readRDS("mappedConceptsNewVocabulary.RDS")

# #get concept id details
# conceptIdDetailsNew <- ConceptSetDiagnostics::getConceptIdDetails(
#   conceptIds = c(
#     resolvedConceptIdsOldVocabulary$conceptId,
#     resolvedConceptIdsNewVocabulary$conceptId,
#     mappedConceptsNewVocabulary$conceptId,
#     mappedConceptsOldVocabulary$conceptId
#   ) |>
#     unique() |>
#     sort(),
#   connection = DatabaseConnector::connect(connectionDetails = newConnectionDetails),
#   vocabularyDatabaseSchema = newCdmSource$vocabDatabaseSchemaFinal
# )
# saveRDS(object = conceptIdDetailsNew, file = "conceptIdDetailsNew.RDS")
conceptIdDetailsNew <- readRDS("conceptIdDetailsNew.RDS")

# conceptIdDetailsOld <- ConceptSetDiagnostics::getConceptIdDetails(
#   conceptIds = c(
#     resolvedConceptIdsOldVocabulary$conceptId,
#     resolvedConceptIdsNewVocabulary$conceptId,
#     mappedConceptsNewVocabulary$conceptId,
#     mappedConceptsOldVocabulary$conceptId
#   ) |>
#     unique() |>
#     sort(),
#   connection = DatabaseConnector::connect(connectionDetails = oldConnectionDetails),
#   vocabularyDatabaseSchema = oldCdmSource$vocabDatabaseSchemaFinal
# )
# saveRDS(object = conceptIdDetailsOld, file = "conceptIdDetailsOld.RDS")
conceptIdDetailsOld <- readRDS("conceptIdDetailsOld.RDS")

# conceptCount <-
#   ConceptSetDiagnostics::getConceptRecordCount(
#     connectionDetails = OhdsiHelpers::createConnectionDetails(cdmSources = cdmSources, database = "health_verity"),
#     cdmDatabaseSchema = OhdsiHelpers::getCdmSource(cdmSources = cdmSources, database = "health_verity") |>
#       dplyr::pull(cdmDatabaseSchemaFinal),
#     minCellCount = 0,
#     conceptIds = conceptIdDetailsNew$conceptId
#   )
# saveRDS(object = conceptCount, file = "conceptCount.RDS")
conceptCount <- readRDS("conceptCount.RDS") |>
  dplyr::group_by(conceptId) |>
  dplyr::summarise(
    countCount = max(conceptCount),
    subjectCount = max(subjectCount)
  ) |>
  dplyr::ungroup()


conceptIdCompare <- dplyr::bind_rows(
  conceptIdDetailsNew |>
    dplyr::select(conceptId),
  conceptIdDetailsOld |>
    dplyr::select(conceptId)
) |>
  dplyr::distinct() |>
  dplyr::left_join(
    conceptIdDetailsNew |>
      dplyr::select(
        conceptId,
        domainId,
        standardConcept
      ) |>
      dplyr::rename(
        newDomainId = domainId,
        newStandardConcept = standardConcept
      ) |>
      dplyr::distinct() |>
      dplyr::mutate(presentInNew = 1) |>
      tidyr::replace_na(list(newStandardConcept = "N"))
  ) |>
  dplyr::left_join(
    conceptIdDetailsOld |>
      dplyr::select(
        conceptId,
        domainId,
        standardConcept
      ) |>
      dplyr::distinct() |>
      dplyr::rename(
        oldDomainId = domainId,
        oldStandardConcept = standardConcept
      ) |>
      dplyr::mutate(presentInOld = 1) |>
      tidyr::replace_na(list(oldStandardConcept = "N"))
  ) |>
  dplyr::mutate(presentIn = presentInOld + presentInNew) |>
  dplyr::mutate(domainChange = dplyr::if_else(newDomainId == oldDomainId, 0, 1)) |>
  dplyr::mutate(standardChange = dplyr::if_else(newStandardConcept == oldStandardConcept, 0, 1)) |>
  dplyr::left_join(conceptIdDetailsNew |>
    dplyr::select(
      conceptId,
      conceptName,
      vocabularyId
    )) |>
  dplyr::select(
    conceptId,
    conceptName,
    vocabularyId,
    oldDomainId,
    oldStandardConcept,
    newDomainId,
    newStandardConcept,
    domainChange,
    standardChange,
    presentIn
  ) |>
  dplyr::left_join(conceptCount) |>
  dplyr::arrange(dplyr::desc(subjectCount))


# read original concept set
conceptSetsInAllCohortDefinition <-
  readRDS("conceptSetsInAllCohortDefinition.RDS")


# compare output of old and new vocabulary
uniqueConceptSetIds <-
  resolvedConceptIdsOldVocabulary$uniqueConceptSetId |>
  unique() |>
  sort()

onlyInOld <- c()
onlyInNew <- c()


for (i in (1:length(uniqueConceptSetIds))) {
  uniqueConceptSetIdRowValue <- uniqueConceptSetIds[[i]]

  compareResolved <- OhdsiHelpers::compareTibbles(
    resolvedConceptIdsOldVocabulary |> dplyr::filter(uniqueConceptSetId == uniqueConceptSetIdRowValue),
    resolvedConceptIdsNewVocabulary |> dplyr::filter(uniqueConceptSetId == uniqueConceptSetIdRowValue)
  )
  onlyInOld[[i]] <- compareResolved$presentInFirstNotSecond
  onlyInNew[[i]] <- compareResolved$presentInSecondNotFirst
}

onlyInOld <- dplyr::bind_rows(onlyInOld)
onlyInNew <- dplyr::bind_rows(onlyInNew)


# check if conceptSet has conceptId's that can be removed
oldConceptSetDataFrame <- c()
newConceptSetDataFrame <- c()
conceptSetsInAllCohortDefinition <-
  conceptSetsInAllCohortDefinition |>
  dplyr::arrange(uniqueConceptSetId)

for (i in (1:nrow(conceptSetsInAllCohortDefinition))) {
  print(i)
  conceptSetExpression <-
    conceptSetsInAllCohortDefinition[i, ]$conceptSetExpression |>
    RJSONIO::fromJSON(digist = 23)

  conceptIdHasBecomeNonStandarOrDomainChange <-
    conceptSetExpression |>
    ConceptSetDiagnostics::convertConceptSetExpressionToDataFrame() |>
    dplyr::select(conceptId) |>
    dplyr::distinct() |>
    dplyr::inner_join(conceptIdCompare,
      by = "conceptId"
    ) |>
    dplyr::filter(any(
      domainChange == 1,
      standardChange == 1
    ))

  if (nrow(conceptIdHasBecomeNonStandarOrDomainChange) > 0) {
    standardChanged <- FALSE
    domainChanged <- FALSE
    conceptCleanUp <- FALSE

    writeLines(
      paste0(
        "cohort id ",
        conceptSetsInAllCohortDefinition[i, ]$cohortId,
        " (",
        OhdsiHelpers::formatIntegerWithComma(i),
        " of ",
        OhdsiHelpers::formatIntegerWithComma(nrow(conceptSetsInAllCohortDefinition)),
        ") with concept set ",
        conceptSetsInAllCohortDefinition[i, ]$conceptSetName
      )
    )

    domainChange <-
      conceptIdHasBecomeNonStandarOrDomainChange |>
      dplyr::filter(domainChange == 1)

    if (nrow(domainChange) > 0) {
      View(domainChange)
      domainChanged <- TRUE
    }

    standardChange <-
      conceptIdHasBecomeNonStandarOrDomainChange |>
      dplyr::filter(standardChange == 1)

    if (nrow(standardChange) > 0) {
      conceptCleanUp <- TRUE
    }

    standardChangeInResolvedSet <-
      resolvedConceptIdsNewVocabulary |>
      dplyr::filter(uniqueConceptSetId %in% conceptSetsInAllCohortDefinition[i, ]$uniqueConceptSetId) |>
      dplyr::select(conceptId) |>
      dplyr::distinct() |>
      dplyr::left_join(
        mappedConceptsNewVocabulary |>
          dplyr::select(
            givenConceptId,
            conceptId
          ) |>
          dplyr::rename(
            conceptId = givenConceptId,
            mappedConceptId = conceptId
          ) |>
          dplyr::distinct(),
        by = "conceptId"
      ) |>
      dplyr::filter(mappedConceptId %in% standardChange$conceptId) |>
      dplyr::pull(mappedConceptId) |>
      unique()

    if (length(standardChangeInResolvedSet) > 0) {
      View(standardChange)
      standardChanged <- TRUE
      if (length(setdiff(standardChange$conceptId, standardChangeInResolvedSet)) == 0) {
        writeLines("---------No mapping issues - JUST clean up")
      } else {
        writeLines("---------MAPPING ISSUES")
      }
    }

    if (any(
      standardChanged,
      domainChanged,
      conceptCleanUp
    )) {
      conceptSetsInAllCohortDefinition[i, ]$cohortId |>
        as.character() |>
        clipr::write_clip()
      browser()
      View(standardChange)
    }
  }
}
