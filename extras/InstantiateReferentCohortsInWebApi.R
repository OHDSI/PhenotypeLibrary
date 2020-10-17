library(magrittr)
path <- rstudioapi::getActiveProject()

phenotypeDescription <- readr::read_csv(file = file.path(path,
                                                         "extras",
                                                         "PhenotypeDescription.csv"),
                                        col_types = readr::cols(),
                                        guess_max = min(1e+07))

referentCohorts <- ROhdsiWebApi::getConcepts(conceptIds = unique(phenotypeDescription$referentConceptId),
                                             baseUrl = Sys.getenv("baseUrl")) %>% 
  dplyr::mutate(phenotypeId = .data$conceptId * 1000, 
                prevalentCohortId = .data$phenotypeId + 1, 
                incidenceCohortId = .data$phenotypeId + 2, 
                prevalentCohortName = paste0("[PL ", .data$incidenceCohortId, "] ", .data$conceptName, " referent concept prevalent cohort: First occurrence of referent concept + descendants"), 
                incidenceCohortName = paste0("[PL ", .data$prevalentCohortId, "] ", .data$conceptName, " referent concept incident cohort: First occurrence of referent concept + descendants with >=365d prior observation"))

template <- readRDS(file.path(path, "extras", "cohortTemplate.rds"))

publishedCohortDefinitions <- ROhdsiWebApi::getCohortDefinitionsMetaData(baseUrl = Sys.getenv("baseUrl"))

cohortsPosted <- tidyr::tibble()
# prevalent cohorts
for (i in 1:nrow(referentCohorts)) {
  referentCohort <- referentCohorts[i, ]
  
  # prevalent cohort
  prevalentCohortExpression <- template$prevalentCohort
  prevalentCohortExpression$expression$ConceptSets[[1]]$name <- referentCohort$conceptName
  prevalentCohortExpression$expression$ConceptSets[[1]]$expression$items[[1]]$concept$CONCEPT_ID <- referentCohort$conceptId
  prevalentCohortExpression$expression$ConceptSets[[1]]$expression$items[[1]]$concept$CONCEPT_NAME <- referentCohort$conceptName
  prevalentCohortExpression$expression$ConceptSets[[1]]$expression$items[[1]]$concept$CONCEPT_CODE <- referentCohort$conceptCode
  prevalentCohortExpression$expression$ConceptSets[[1]]$expression$items[[1]]$concept$DOMAIN_ID <- referentCohort$domainId
  prevalentCohortExpression$expression$ConceptSets[[1]]$expression$items[[1]]$concept$VOCABULARY_ID <- referentCohort$vocabularyId
  prevalentCohortExpression$id <- referentCohort$prevalentCohortId
  prevalentCohortExpression$name <- referentCohort$prevalentCohortName
  prevalentCohortExpression$description <- stringr::str_replace(string = prevalentCohortExpression$description,
                                                                pattern = "(141933)",
                                                                replacement = paste0("(",
                                                                                     referentCohort$conceptId,
                                                                                     ")"))
  prevalentCohortExpression$createdBy <- "OHDSI Phenotype Library"
  prevalentCohortExpression$createdDate <- as.character(Sys.time())
  prevalentCohortExpression$modifiedBy <- ""
  prevalentCohortExpression$modifiedDate <- ""
  
  
  # incident cohort
  incidentCohortExpression <- template$incidentCohort
  incidentCohortExpression$expression$ConceptSets[[1]]$name <- referentCohort$conceptName
  incidentCohortExpression$expression$ConceptSets[[1]]$expression$items[[1]]$concept$CONCEPT_ID <- referentCohort$conceptId
  incidentCohortExpression$expression$ConceptSets[[1]]$expression$items[[1]]$concept$CONCEPT_NAME <- referentCohort$conceptName
  incidentCohortExpression$expression$ConceptSets[[1]]$expression$items[[1]]$concept$CONCEPT_CODE <- referentCohort$conceptCode
  incidentCohortExpression$expression$ConceptSets[[1]]$expression$items[[1]]$concept$DOMAIN_ID <- referentCohort$domainId
  incidentCohortExpression$expression$ConceptSets[[1]]$expression$items[[1]]$concept$VOCABULARY_ID <- referentCohort$vocabularyId
  incidentCohortExpression$id <- referentCohort$incidenceCohortId
  incidentCohortExpression$name <- referentCohort$incidenceCohortName
  incidentCohortExpression$description <- stringr::str_replace(string = incidentCohortExpression$description,
                                                               pattern = "(141933)",
                                                               replacement = paste0("(",
                                                                                    referentCohort$conceptId,
                                                                                    ")"))
  incidentCohortExpression$createdBy <- "OHDSI Phenotype Library"
  incidentCohortExpression$createdDate <- as.character(Sys.time())
  incidentCohortExpression$modifiedBy <- ""
  incidentCohortExpression$modifiedDate <- ""
  
  if (!prevalentCohortExpression$name %in% publishedCohortDefinitions$name) {
    return1 <- ROhdsiWebApi::postCohortDefinition(name = prevalentCohortExpression$name,
                                                  cohortDefinition = prevalentCohortExpression$expression,
                                                  baseUrl = Sys.getenv("baseUrl")) %>% dplyr::mutate(cohortType = "prevalence", phenotypeId = referentCohort$phenotypeId, referentConceptId = referentCohort$conceptId, newlyCreated = TRUE, logDateTime = Sys.time())
  } else {
    return1 <- publishedCohortDefinitions %>% dplyr::filter(prevalentCohortExpression$name == publishedCohortDefinitions$name) %>%
      dplyr::mutate(cohortType = "prevalence",
                    phenotypeId = referentCohort$phenotypeId,
                    referentConceptId = referentCohort$conceptId,
                    newlyCreated = FALSE,
                    logDateTime = Sys.time())
  }
  cohortsPosted <- dplyr::bind_rows(cohortsPosted, return1)
  
  
  if (!incidentCohortExpression$name %in% publishedCohortDefinitions$name) {
    return2 <- ROhdsiWebApi::postCohortDefinition(name = incidentCohortExpression$name,
                                                  cohortDefinition = incidentCohortExpression$expression,
                                                  baseUrl = Sys.getenv("baseUrl")) %>% dplyr::mutate(cohortType = "incidence", phenotypeId = referentCohort$phenotypeId, referentConceptId = referentCohort$conceptId, newlyCreated = TRUE, logDateTime = Sys.time())
  } else {
    return2 <- publishedCohortDefinitions %>% dplyr::filter(incidentCohortExpression$name == publishedCohortDefinitions$name) %>%
      dplyr::mutate(cohortType = "incidence",
                    phenotypeId = referentCohort$phenotypeId,
                    referentConceptId = referentCohort$conceptId,
                    newlyCreated = FALSE,
                    logDateTime = Sys.time())
  }
  cohortsPosted <- dplyr::bind_rows(cohortsPosted, return2)
}

if (file.exists(file.path(path, "extras", "referentCohortsPostedToWebApi.csv"))) {
  referentCohortsPostedToWebApi <- readr::read_csv(file = file.path("inst",
                                                                    "settings",
                                                                    "referentCohortsPostedToWebApi.csv"),
                                                   col_types = readr::cols())
  cohortsPosted <- dplyr::bind_rows(cohortsPosted,
                                    referentCohortsPostedToWebApi) %>% dplyr::arrange(.data$phenotypeId)
}


cohortsPosted %>%
  dplyr::inner_join(
    dplyr::bind_rows(
      dplyr::tibble(cohortType = "incidence",
                    logicDescription = template$incidentCohort$description %>%
                      stringr::str_squish()), 
      dplyr::tibble(cohortType = "prevalence",
                    logicDescription = template$prevalentCohort$description %>%
                      stringr::str_squish()))) %>% 
  dplyr::mutate(logicDescription = stringr::str_replace(string = .data$logicDescription,
                                                        pattern = "(141933)",
                                                        replacement = paste0(.data$referentConceptId))) %>% 
  dplyr::select(.data$phenotypeId,.data$id,.data$name,.data$logicDescription) %>% 
  dplyr::rename(cohortName = .data$name, webApiCohortId = .data$id) %>%
  dplyr::mutate(cohortId = gsub("\\].*",
                                "]",
                                .data$cohortName) %>% 
                  stringr::str_replace_all(pattern = "\\[|\\]",
                                           replacement = "") %>% 
                  stringr::str_replace(pattern = "PL ", replacement = "") %>% 
                  trimws() %>%
                  as.double()) %>% 
  readr::write_excel_csv(file = file.path(path,
                                          "extras",
                                          "ReferentCohortsToCreate.csv"), na = "")
