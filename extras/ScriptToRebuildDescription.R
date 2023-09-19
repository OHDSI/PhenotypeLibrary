oldCohortDefinitions <- PhenotypeLibrary::listPhenotypes()
oldCohortDefinitionSet <-
  PhenotypeLibrary::getPlCohortDefinitionSet(cohortIds = oldCohortDefinitions$cohortId)






for (i in (1:nrow(oldCohortDefinitions))) {
  
  replaceStringIfNa <- function(string) {
    if (is.na(string)) {
      output <- ""
    } else {
      output <- stringr::str_squish(stringr::str_trim(string))
    }
    return(output)
  }
  
  description <- paste0(
    "cohortNameLong : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$cohortNameLong),
    ";\n",
    "librarian : rao@ohdsi.org",
    ";\n",
    "status : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$status),
    ";\n",
    "addedVersion : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$addedVersion),
    ";\n",
    "logicDescription : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$logicDescription),
    ";\n",
    "hashTag : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$hashTag),
    ";\n",
    "contributors : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$contributors),
    ";\n",
    "contributorOrcIds : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$contributorOrcIds),
    ";\n",
    "contributorOrganizations : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$contributorOrganizations),
    ";\n",
    "peerReviewers : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$peerReviewers),
    ";\n",
    "peerReviewerOrcIds : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$peerReviewerOrcIds),
    ";\n",
    "recommendedReferentConceptIds : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$recommendedReferentConceptIds),
    ";\n",
    "ohdsiForumPost : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$ohdsiForumPost),
    ";\n",
    "replaces : ",
    replaceStringIfNa(oldCohortDefinitions[i, ]$replaces),
    ";\n"
  )
  
  baseUrl <- "https://atlas-phenotype.ohdsi.org/WebAPI"
  ROhdsiWebApi::authorizeWebApi(
    baseUrl = baseUrl,
    authMethod = "db",
    webApiUsername = keyring::key_get("ohdsiAtlasPhenotypeUser"),
    webApiPassword = keyring::key_get("ohdsiAtlasPhenotypePassword")
  )
  
  webApiInf <- ROhdsiWebApi::getCohortDefinition(
    cohortId = oldCohortDefinitions[i,]$cohortId,
    baseUrl = baseUrl
  )
  
  webApiInf$description <- description
  
  ROhdsiWebApi::updateCohortDefinition(
    cohortDefinition = webApiInf,
    baseUrl = baseUrl
  )
}
