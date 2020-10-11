library(magrittr)
path <- rstudioapi::getActiveProject()
phenotypeFolders <-
  list.files(file.path(path, "inst"),
             pattern = "[0-9]+",
             full.names = TRUE)

#Phenotype description
phenotypeDescription <-
  readr::read_csv(
    file = file.path(path, "extras",
                     "PhenotypeDescription.csv"),
    col_types = readr::cols(),
    guess_max = min(1e+07)
  ) %>%
  dplyr::arrange(.data$phenotypeId)

phenotypeFoldersDf <- dplyr::tibble(path = phenotypeFolders) %>%
  dplyr::mutate(phenotypeId = basename(.data$path)) %>%
  dplyr::arrange(.data$phenotypeId)

#Cohort description
cohortDescription <-
  dplyr::bind_rows(readr::read_csv(
    file = file.path(path,
                     "extras",
                     "CohortDescription.csv"),
    col_types = readr::cols(),
    guess_max = min(1e+07)
  )) %>%
  dplyr::arrange(.data$phenotypeId, .data$cohortId)
cohortFiles <-
  dplyr::bind_rows(
    dplyr::tibble(
      file = list.files(
        file.path(path, "inst"),
        pattern = ".sql",
        full.names = TRUE,
        recursive = TRUE
      ),
      type = 'sql'
    ),
    dplyr::tibble(
      file = list.files(
        file.path(path, "inst"),
        pattern = ".json",
        full.names = TRUE,
        recursive = TRUE
      ),
      type = 'json'
    )
  ) %>%
  dplyr::filter(stringr::str_detect(
    string = file,
    pattern = "package",
    negate = TRUE
  )) %>%
  dplyr::mutate(
    cohortId = basename(file) %>%
      stringr::str_replace_all(pattern = ".json|.sql",
                               replacement = "") %>%
      type.convert()
  ) %>%
  dplyr::arrange(.data$cohortId)

#Manage phenotypes
phenotypesToAdd <-
  setdiff(phenotypeDescription$phenotypeId,
          phenotypeFoldersDf$phenotypeId)
phenotypesToRemove <-
  setdiff(phenotypeFoldersDf$phenotypeId,
          phenotypeDescription$phenotypeId)
if (length(phenotypesToAdd) > 0) {
  warning(paste0(
    "The following phenotypes will need to be ADDED to the library:",
    paste0(phenotypesToAdd, collapse = "\n")
  ))
  for (i in (1:length(phenotypesToAdd))) {
    print(i)
    dir.create(
      path = file.path(path, "inst", phenotypesToAdd[[i]], 'literature'),
      showWarnings = FALSE,
      recursive = TRUE
    )
    file.create(file.path(path, "inst", phenotypesToAdd[[i]], 'literature', ".empty"))
    dir.create(
      path = file.path(path, "inst", phenotypesToAdd[[i]], 'notes'),
      showWarnings = FALSE,
      recursive = TRUE
    )
    file.create(file.path(path, "inst", phenotypesToAdd[[i]], 'notes', ".empty"))
    dir.create(
      path = file.path(path, "inst", phenotypesToAdd[[i]], 'evaluation'),
      showWarnings = FALSE,
      recursive = TRUE
    )
    file.create(file.path(path, "inst", phenotypesToAdd[[i]], 'evaluation', ".empty"))
    phenotypeDescription %>%
      dplyr::filter(.data$phenotypeId == phenotypesToAdd[[i]]) %>%
      readr::write_excel_csv(file.path(path, "inst", phenotypesToAdd[[i]], 'phenotypeDescription.csv'))
  }
}
if (length(phenotypesToRemove) > 0) {
  warning(paste0(
    "The following phenotypes will need to be REMOVED to the library:",
    paste0(phenotypesToRemove, collapse = " ")
  ))
  for (i in (1:length(phenotypeFolders))) {
    unlink(
      phenotypeFolders %>% dplyr::filter(.data$phenotypeId == phenotypesToAdd[[i]]) %>% dplyr::pull(path)
    )
  }
}


#Manage cohorts
cohortsToAdd <-
  setdiff(cohortDescription$cohortId %>% unique(),
          cohortFiles$cohortId %>% unique())
cohortsToRemove <-
  setdiff(cohortFiles$cohortId %>% unique(),
          cohortDescription$cohortId %>% unique())
if (length(cohortsToAdd) > 0) {
  warning(paste(
    "The following cohorts will need to be ADDED to the library:",
    paste0(cohortsToAdd, collapse = "\n")
  ))
  webApiCohortIds <- cohortDescription %>%
    dplyr::filter(.data$cohortId %in% cohortsToAdd) %>%
    dplyr::distinct()
  webApiCohortIds$json <- ''
  webApiCohortIds$sql <- ''

  for (i in (1:nrow(webApiCohortIds))) {
    print(i)
    cohortDefinition <-
      ROhdsiWebApi::getCohortDefinition(cohortId = webApiCohortIds[i, ]$webApiCohortId,
                                        baseUrl = Sys.getenv("baseUrl"))
    if (webApiCohortIds[i, ]$cohortName != cohortDefinition$name) {
      warning(
        paste0(
          "Cohort id names dont match. Please consider renaming the cohort in Atlas for Atlas cohort id:",
          webApiCohortIds[i, ]$webApiCohortId,
          " to \n",
          webApiCohortIds[i, ]$cohortName
        )
      )
    }
    webApiCohortIds[i, ]$json <-
      RJSONIO::toJSON(x = cohortDefinition$expression,
                      pretty = TRUE,
                      digits = 23)
    SqlRender::writeSql(
      sql = webApiCohortIds[i, ]$json,
      targetFile = file.path(
        path,
        "inst",
        webApiCohortIds[i, ]$phenotypeId,
        paste0(webApiCohortIds[i, ]$cohortId, ".json")
      )
    )
    webApiCohortIds[i, ]$sql <-
      ROhdsiWebApi::getCohortSql(
        cohortDefinition = cohortDefinition$expression,
        baseUrl = Sys.getenv("baseUrl"),
        generateStats = TRUE
      )
    SqlRender::writeSql(
      sql = webApiCohortIds[i, ]$sql,
      targetFile = file.path(
        path,
        "inst",
        webApiCohortIds[i, ]$phenotypeId,
        paste0(webApiCohortIds[i, ]$cohortId, ".sql")
      )
    )
    f <- cohortDescription %>%
      dplyr::filter(.data$phenotypeId == webApiCohortIds[i, ]$phenotypeId)
    readr::write_excel_csv(
      x = f,
      file = file.path(
        path,
        "inst",
        webApiCohortIds[i, ]$phenotypeId,
        "cohortDescription.csv"
      )
    )
  }
}
if (length(cohortsToRemove) > 0) {
  warning(
    paste0(
      "The following cohorts will need to be REMOVED to the library:",
      cohortsToRemove
    )
  )
  unlink(
    cohortFiles %>% dplyr::filter(cohortId %in% cohortsToRemove) %>% dplyr::pull(.data$cohortId)
  )
}
