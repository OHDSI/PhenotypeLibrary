baseUrl <- "https://atlas-phenotype.ohdsi.org/WebAPI"
ROhdsiWebApi::authorizeWebApi(
  baseUrl = baseUrl,
  authMethod = "db",
  webApiUsername = keyring::key_get("ohdsiAtlasPhenotypeUser"),
  webApiPassword = keyring::key_get("ohdsiAtlasPhenotypePassword")
)



basePath <-
  file.path("D:", "git", "github", "ohdsi", "PhenotypeLibrary")
data <-
  readxl::read_excel(file.path(basePath, "inst", "Cohorts.xlsx"))

fieldsToPostInDescription <- c(
  "cohortNameLong",
  "cohortNameAtlas",
  "librarian",
  "status",
  "addedVersion",
  "logicDescription",
  "hashTag",
  "contributors",
  "contributorOrcIds",
  "contributorOrganizations",
  "peerReviewers",
  "peerReviewerOrcIds",
  "recommendedEraPersistenceDurations",
  "recommendedEraCollapseDurations",
  "recommendSubsetOperators",
  "recommendedReferentConceptIds",
  "ohdsiForumPost"
)

if (length(setdiff(fieldsToPostInDescription, colnames(data))) > 1) {
  stop("something is wrong")
}

for (i in (1:nrow(data))) {
  print(paste0(" iter = ", i, " cohort id = ", data[i, ]$cohortId))
  toPostInDescription <- ""
  for (j in (1:length(fieldsToPostInDescription))) {
    fieldName <- fieldsToPostInDescription[[j]]
    text <-
      dplyr::coalesce(data[i, ][[fieldName]], "")
    combi <- paste0(fieldName, " : ", text, ";")
    toPostInDescription <- paste(toPostInDescription,
                                 "\n",
                                 combi)
  }
  
  cohortDefinition <- NULL
  ROhdsiWebApi::authorizeWebApi(
    baseUrl = baseUrl,
    authMethod = "db",
    webApiUsername = keyring::key_get("ohdsiAtlasPhenotypeUser"),
    webApiPassword = keyring::key_get("ohdsiAtlasPhenotypePassword")
  )
  
  cohortDefinition <-
    ROhdsiWebApi::getCohortDefinition(cohortId = data[i,]$cohortId, baseUrl = baseUrl)
  cohortDefinition$description <- toPostInDescription
  
  ROhdsiWebApi::updateCohortDefinition(cohortDefinition = cohortDefinition,
                                       baseUrl = baseUrl)
}