oldCohortDefinitions <- PhenotypeLibrary::listPhenotypes()
oldCohortDefinitionSet <-
  PhenotypeLibrary::getPlCohortDefinitionSet(cohortIds = oldCohortDefinitions$cohortId)






for (i in (1:nrow(oldCohortDefinitions))) {
  
  
  description <- paste0(
    "cohortNameLong : ",
    oldCohortDefinitions[i, ]$cohortNameLong,
    ";\n",
    "librarian : rao@ohdsi.org",
    ";\n",
    "status : ",
    oldCohortDefinitions[i, ]$status,
    ";\n",
    "addedVersion : ",
    oldCohortDefinitions[i, ]$addedVersion,
    ";\n",
    "logicDescription : ",
    oldCohortDefinitions[i, ]$logicDescription,
    ";\n",
    "hashTag : ",
    oldCohortDefinitions[i, ]$hashTag,
    ";\n",
    "contributors : ",
    oldCohortDefinitions[i, ]$contributors,
    ";\n",
    "contributorOrcIds : ",
    oldCohortDefinitions[i, ]$contributorOrcIds,
    ";\n",
    "contributorOrganizations : ",
    oldCohortDefinitions[i, ]$contributorOrganizations,
    ";\n",
    "peerReviewers : ",
    oldCohortDefinitions[i, ]$peerReviewerOrcIds,
    ";\n",
    "recommendedReferentConceptIds : ",
    oldCohortDefinitions[i, ]$recommendedReferentConceptIds,
    ";\n",
    "ohdsiForumPost : ",
    oldCohortDefinitions[i, ]$ohdsiForumPost,
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
