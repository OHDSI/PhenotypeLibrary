# connection
cdmSource <-
  OhdsiHelpers::getCdmSource(cdmSources = cdmSources, database = "truven_ccae")
connectionDetails <-
  OhdsiHelpers::createConnectionDetails(cdmSources = cdmSources, database = "truven_ccae")
connection <-
  DatabaseConnector::connect(connectionDetails = connectionDetails)

phenotypeLog <- PhenotypeLibrary::getPhenotypeLog() |>
  dplyr::filter(nchar(ohdsiForumPost) > 10) |>
  dplyr::filter(stringr::str_detect(string = .data$contributors, pattern = "Gowtham")) |>
  dplyr::arrange(dplyr::desc(cohortId)) |>
  dplyr::mutate(rn = dplyr::row_number()) |>
  dplyr::filter(rn <= 5) |>
  dplyr::select(-rn) |>
  dplyr::arrange(cohortId)

conceptSetLog <-
  PhenotypeLibrary::getPlConceptDefinitionSet(cohortIds = phenotypeLog$cohortId)

uniqueConceptSetIds <- conceptSetLog |>
  dplyr::select(
    uniqueConceptSetId,
    conceptSetExpression
  ) |>
  dplyr::distinct()


sourceCodes <- c()

for (i in (1:nrow(uniqueConceptSetIds))) {
  uniqueConceptSetId <- uniqueConceptSetIds[i, ]

  conceptSetExpression <-
    uniqueConceptSetId$conceptSetExpression |>
    RJSONIO::fromJSON(digits = 23)

  resolvedConceptSets <-
    ConceptSetDiagnostics::resolveConceptSetExpression(
      conceptSetExpression = conceptSetExpression,
      connection = connection,
      vocabularyDatabaseSchema = cdmSource$vocabDatabaseSchemaFinal
    ) |>
    dplyr::mutate(uniqueConceptSetId = uniqueConceptSetId$uniqueConceptSetId)

  mappedSource <-
    ConceptSetDiagnostics::getMappedSourceConcepts(
      conceptIds = resolvedConceptSets$conceptId |> unique(),
      connection = connection,
      vocabularyDatabaseSchema = cdmSource$vocabDatabaseSchemaFinal
    ) |>
    dplyr::mutate(uniqueConceptSetId = uniqueConceptSetId$uniqueConceptSetId)

  sourceCodes <- dplyr::bind_rows(
    resolvedConceptSets |>
      dplyr::mutate(type = "resolvedConceptSets"),
    mappedSource |>
      dplyr::mutate(type = "mappedSource")
  )
}



sourceCodes <- dplyr::bind_rows(sourceCodes)

sourceCodesInEntryEvent <-
  sourceCodes |>
  dplyr::filter(type == "mappedSource") |>
  dplyr::filter(vocabularyId %in% c("ICD10CM", "ICD9CM", "ICD9Proc", "ICD10Proc")) |>
  dplyr::inner_join(
    conceptSetLog |>
      dplyr::filter(conceptSetUsedInEntryEvent == 1) |>
      dplyr::select(
        cohortId,
        uniqueConceptSetId
      ) |>
      dplyr::distinct()
  ) |>
  dplyr::select(
    cohortId,
    vocabularyId,
    conceptCode
  ) |>
  dplyr::arrange(
    cohortId,
    vocabularyId,
    conceptCode
  ) |>
  dplyr::mutate(
    conceptCode = paste0("'", conceptCode, "'"),
    vocabularyId = paste0("cipher", vocabularyId)
  ) |>
  dplyr::group_by(
    cohortId,
    vocabularyId
  ) |>
  dplyr::summarise(code = paste0(conceptCode, collapse = ", ")) |>
  dplyr::ungroup() |>
  tidyr::pivot_wider(
    id_cols = cohortId,
    names_from = vocabularyId,
    values_from = code
  )



vaCipherMapping <- phenotypeLog |>
  dplyr::mutate(
    # cipherOhdsiPhenotypeLibraryVersion = addedVersion,
    # cipherOhdsiCohortId = cohortId,
    cipherCategory = dplyr::if_else(condition = stringr::str_detect(string = tolower(domainsInEntryEvents), pattern = "condition"),
      true = "General Phenotype",
      false = dplyr::if_else(condition = stringr::str_detect(string = tolower(domainsInEntryEvents), pattern = "drug"),
        true = "Medication",
        false = dplyr::if_else(condition = stringr::str_detect(
          string = tolower(domainsInEntryEvents),
          pattern = "measurement"
        ),
        true = "Lab",
        false = "Other"
        )
      )
    ),
    cipherFullName = cohortNameLong,
    cipherKeyWords = paste0("OHDSI Cohort ID: ", cohortId, dplyr::if_else(condition = is.na(addedVersion),
      true = "",
      false = paste0(
        " (Locked version: ",
        addedVersion,
        ")"
      )
    )), # maybe hashTag in future
    cipherClassification = dplyr::if_else(
      condition = stringr::str_detect(
        string = domainsInEntryEvents,
        pattern = "Condition"
      ),
      true = "Disease",
      false = "Other"
    ),
    cipherDiseaseDomain = "",
    # cannot systematically map because not controlled vocabulary
    cipherAuthor = contributors,
    cipherContact = "noreply@ohdsi.org", # contributorOrcIds, -- non functional email will bounce
    cipherPublication = ohdsiForumPost,
    cipherLink = ohdsiForumPost,
    cipherAcknowledgement = ohdsiForumPost,
    cipherVaDeveloped = "No",
    cipherDataSources = "OMOP (Observational Medical Outcomes Partnership)",
    cipherOtherSource = "",
    cipherContext = "Research",
    cipherOtherDescription = "",
    cipherPhenotypeUse = "Primary Outcome/Exposure",
    cipherPhenotypeDescription = paste0(cohortNameLong, ". Sourced from the OHDSI Phenotype Library. For more details please visit https://ohdsi.github.io/PhenotypeLibrary/articles/CohortDefinitionsInOhdsiPhenotypeLibrary.html"), # logicDescription,
    cipherPopulationDescription = ohdsiForumPost,
    cipherDateAlgorithmWasCreated = addedDate,
    cipherDataUsedStart = censorWindowStartDate,
    cipherDataUsedEnd = censorWindowEndDate,
    cipherMethodUsed = "Rules-Based",
    cipherAlgorithmDesc = logicDescription,
    cipherCodeSampleLink = paste0(
      "https://github.com/OHDSI/PhenotypeLibrary/blob/main/inst/sql/sql_server/",
      cohortId,
      ".sql"
    ),
    cipherCodeSampleLanguage = "SQL",
  ) |>
  dplyr::left_join(sourceCodesInEntryEvent,
    by = "cohortId"
  ) |>
  dplyr::select(dplyr::all_of(dplyr::starts_with("cipher"))) |>
  dplyr::mutate(
    cipherICD10CM = "",
    cipherICD9CM = ""
  )


readr::write_excel_csv(x = vaCipherMapping, file = "vaCipherMapping.csv")




sourceCodesLongForm <-
  sourceCodes |>
  # dplyr::filter(type == "mappedSource") |>
  # dplyr::filter(vocabularyId %in% c("ICD10CM", "ICD9CM", "ICD9Proc", "ICD10Proc")) |>
  dplyr::inner_join(
    conceptSetLog |>
      dplyr::filter(conceptSetUsedInEntryEvent == 1) |>
      dplyr::select(
        cohortId,
        uniqueConceptSetId
      ) |>
      dplyr::distinct()
  ) |>
  dplyr::select(
    cohortId,
    conceptId,
    vocabularyId,
    conceptCode,
    conceptName,
    standardConcept
  ) |>
  dplyr::arrange(
    cohortId,
    vocabularyId,
    conceptCode
  )

readr::write_excel_csv(x = sourceCodesLongForm, file = "vaCipherSourceCodesLongForm.csv")
