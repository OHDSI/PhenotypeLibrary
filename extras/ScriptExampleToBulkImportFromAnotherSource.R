


tabularData <- readxl::read_excel("AESI.xlsx")



i = 1#(/17)


for (i in (2:nrow(tabularData))) {
  toPost <- tabularData[i,]
  
  toPost$ohdsiForumPost <- "https://forums.ohdsi.org/t/15365"
  cohortJson <- SqlRender::readSql(file.path("Covid19SubjectsAesiIncidenceRate\\inst\\cohorts\\",
                                             paste0(toPost$atlasId,
                                             ".json")))
  

  cohortNameFormatted <- paste0(
    gsub(
      pattern = "_",
      replacement = " ",
      x = gsub("\\[(.*?)\\]_", "", gsub(" ", "_", toPost$cohortName))
    ) |>
      stringr::str_squish() |>
      stringr::str_trim()
  )
  print(cohortNameFormatted)
  
  
  baseUrl <- "https://atlas-phenotype.ohdsi.org/WebAPI"
  ROhdsiWebApi::authorizeWebApi(
    baseUrl = baseUrl,
    authMethod = "db",
    webApiUsername = keyring::key_get("ohdsiAtlasPhenotypeUser"),
    webApiPassword = keyring::key_get("ohdsiAtlasPhenotypePassword")
  )
  
  id <-  ROhdsiWebApi::postCohortDefinition(
    name = paste0("[P] FDA AESI ",
                  cohortNameFormatted),
    cohortDefinition = cohortJson |>
      RJSONIO::fromJSON(digits = 23),
    baseUrl = baseUrl
  )
  
  
  
  cohortDefinition <- ROhdsiWebApi::getCohortDefinition(cohortId = id$id...1,
                                                        baseUrl = baseUrl)
  
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
    replaceStringIfNa(cohortNameFormatted),
    ";\n",
    "librarian : rao@ohdsi.org",
    ";\n",
    "status : ",
    replaceStringIfNa("Pending peer review"),
    ";\n",
    "addedVersion : ",
    replaceStringIfNa(""),
    ";\n",
    "logicDescription : ",
    replaceStringIfNa(cohortNameFormatted),
    ";\n",
    "hashTag : ",
    replaceStringIfNa("#AESI, ,#FDA, #Study, #Symposium, #Covid19, #Covid19SubjectsAesiIncidenceRate"),
    ";\n",
    "contributors : ",
    replaceStringIfNa("'Azza Shoaibi','Gowtham Rao','Rupa Makadia', 'Patrick Ryan'"),
    ";\n",
    "contributorOrcIds : '0000-0002-6976-2594', '0000-0002-4949-7236','',''",
    replaceStringIfNa(""),
    ";\n",
    "contributorOrganizations : ",
    replaceStringIfNa("'Johnson and Johnson', 'OHDSI'"),
    ";\n",
    "peerReviewers : ",
    replaceStringIfNa(""),
    ";\n",
    "peerReviewerOrcIds : ",
    replaceStringIfNa(""),
    ";\n",
    "recommendedReferentConceptIds : ",
    replaceStringIfNa(""),
    ";\n",
    "ohdsiForumPost : ",
    replaceStringIfNa("https://forums.ohdsi.org/t/howoften-community-contributions-wanted/19666"),
    ";\n",
    "replaces : ",
    replaceStringIfNa(""),
    ";\n"
  )
  
  newTextDescriptionStitched <- description |>
    stringr::str_replace_all(pattern = "; ;",
                             replacement = " ; ")
  
  writeLines(newTextDescriptionStitched)
  
  cohortDefinition$description <- newTextDescriptionStitched
  
  ROhdsiWebApi::updateCohortDefinition(cohortDefinition = cohortDefinition, baseUrl = baseUrl)
  
}
    # paste0(
    #   "Imported to the OHDSI Phenotype Library. It may be expected to be found with id = ",
    #   id$id...1,
    #   " in the next release. Thank you "
    # ) |> clipr::write_clip()
  
  
# }
