# Copyright 2022 Observational Health Data Sciences and Informatics
#
# This file is part of PhenotypeLibrary
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' List all phenotypes in the library
#'
#' @return
#' A tibble with the cohort ID and name.
#'
#' @examples
#' listPhenotypes()
#'
#' @export
listPhenotypes <- function() {
  cohorts <- readr::read_csv(system.file("Cohorts.csv", package = "PhenotypeLibrary"), col_types = readr::cols())
  return(cohorts)
}

#' Get a cohort definition set
#'
#' @param cohortIds  IDs of cohorts to extraction from the library.
#'
#' @return
#' A tibble with the cohort ID, name, sql, and JSON for the provided cohort IDs. Can be used by the
#' `CohortGenerator` package.
#'
#' @examples
#' cohorts <- listPhenotypes()
#' subsetIds <- cohorts$cohortId[1:3]
#' getPlCohortDefinitionSet(subsetIds)
#'
#' @export
getPlCohortDefinitionSet <- function(cohortIds) {
  errorMessages <- checkmate::makeAssertCollection()
  checkmate::assertIntegerish(cohortIds, min.len = 1, add = errorMessages)
  checkmate::reportAssertions(collection = errorMessages)

  cohorts <- listPhenotypes() %>%
    filter(cohortId %in% cohortIds)
  jsonFolder <- system.file("cohorts", package = "PhenotypeLibrary")
  sqlFolder <- system.file("sql", "sql_server", package = "PhenotypeLibrary")

  readFile <- function(fileName) {
    if (file.exists(fileName)) {
      return(paste(readr::read_lines(fileName), collapse = "\n"))
    }
  }

  getJsonAndSql <- function(i) {
    json <- readFile(file.path(jsonFolder, paste0(cohorts$cohortId[i], ".json")))
    sql <- readFile(file.path(sqlFolder, paste0(cohorts$cohortId[i], ".sql")))
    cohorts[i, ] %>%
      mutate(
        json = !!json,
        sql = !!sql
      ) %>%
      return()
  }

  result <- lapply(seq_len(nrow(cohorts)), getJsonAndSql) %>%
    bind_rows()

  return(result)
}


#' Get phenotype log
#'
#' @return
#' Returns a table with one row per cohort definitions with log information such as its release cycle.
#' Example, this function gives us insight on when a cohort definition was added/updated/deprecated
#' by the OHDSI PhenotypeLibrary.
#'
#' @param cohortIds  IDs of cohorts to extraction from the library.
#'
#' @return
#' A tibble.
#'
#' @examples
#' getPhenotypeLog(cohortIds = c(1, 2))
#'
#' @export
getPhenotypeLog <- function(cohortIds = listPhenotypes()$cohortId) {
  log <-
    readr::read_csv(
      system.file("PhenotypeLog.csv", package = "PhenotypeLibrary"),
      col_types = readr::cols()
    ) %>%
    dplyr::filter(cohortId %in% c(cohortIds)) %>%
    dplyr::mutate(
      addedVersion = as.character(addedVersion),
      addedDate = as.Date(addedDate),
      deprecatedVersion = as.character(deprecatedVersion),
      deprecatedDate = as.Date(deprecatedDate),
      updatedVersion = as.character(updatedVersion),
      updatedDate = as.Date(updatedDate),
      notes = as.character(notes),
    ) %>%
    tidyr::replace_na(replace = list(
      getResults = "No",
      addedVersion = "",
      deprecatedVersion = "",
      updatedVersion = "",
      notes = ""
    )) %>%
    dplyr::arrange(cohortId)
  return(log)
}


#' Update phenotype log
#'
#' @return
#' Updates Phenotype Log related to added/updated/deprecated of the OHDSI PhenotypeLibrary.
#'
#' @param updates  Data to update to the log. This is usually the output of ROhdsiWebApi::getCohortDefinitionsMetaData(baseUrl = baseUrl)
#'
#' @return
#' A tibble.
#'
#' @export
updatePhenotypeLog <- function(updates) {
  errorMessages <- checkmate::makeAssertCollection()
  checkmate::assertDataFrame(
    x = updates,
    min.rows = 1,
    min.cols = 5,
    add = errorMessages
  )
  checkmate::reportAssertions(collection = errorMessages)

  oldLog <- getPhenotypeLog()

  phenotypeLog <- updates %>%
    dplyr::mutate(
      addedDate = as.Date(createdDate),
      updatedDate = as.Date(modifiedDate),
      cohortId = id,
      cohortName = name,
      notes = as.character(description)
    ) %>%
    dplyr::mutate( # peer evaluation
      updatedDate = dplyr::case_when(
        cohortId %in% c(
          oldLog %>%
            dplyr::filter(stringr::str_detect(
              string = cohortName,
              pattern = "[P]"
            )) %>%
            dplyr::pull(cohortId)
        ) ~ as.Date(NA)
      )
    ) %>%
    dplyr::mutate( # withdrawn
      updatedDate = dplyr::case_when(
        cohortId %in% c(
          oldLog %>%
            dplyr::filter(stringr::str_detect(
              string = cohortName,
              pattern = "[W]"
            )) %>%
            dplyr::pull(cohortId)
        ) ~ as.Date(NA)
      )
    ) %>%
    dplyr::mutate( # deprecated
      updatedDate = dplyr::case_when(
        cohortId %in% c(
          oldLog %>%
            dplyr::filter(stringr::str_detect(
              string = cohortName,
              pattern = "[D]"
            )) %>%
            dplyr::pull(cohortId)
        ) ~ as.Date(NA)
      )
    ) %>%
    dplyr::mutate( # error
      updatedDate = dplyr::case_when(
        cohortId %in% c(
          oldLog %>%
            dplyr::filter(stringr::str_detect(
              string = cohortName,
              pattern = "[E]"
            )) %>%
            dplyr::pull(cohortId)
        ) ~ as.Date(NA)
      )
    ) %>%
    tidyr::replace_na(replace = list(notes = "")) %>%
    dplyr::select(
      cohortId,
      cohortName,
      addedDate,
      updatedDate,
      notes
    ) %>%
    dplyr::arrange(cohortId)

  noChanges <- phenotypeLog %>%
    dplyr::inner_join(oldLog,
      by = c(
        "cohortId",
        "cohortName",
        "addedDate",
        "updatedDate",
        "notes"
      )
    )

  withChanges <- phenotypeLog %>%
    dplyr::anti_join(oldLog,
      by = c(
        "cohortId",
        "cohortName",
        "addedDate",
        "updatedDate",
        "notes"
      )
    )

  changes <- dplyr::tibble()

  # Peer Review-----------------------
  peerReview <- withChanges %>%
    dplyr::filter(stringr::str_detect(
      string = cohortName,
      pattern = stringr::fixed("[P]")
    )) %>%
    dplyr::mutate(
      addedVersion = "NA",
      getResults = "No"
    )

  # Deprecated
  deprecated <- withChanges %>%
    dplyr::filter(stringr::str_detect(
      string = cohortName,
      pattern = stringr::fixed("[D]")
    )) %>%
    dplyr::mutate(
      deprecatedVersion = "XX",
      deprecatedDate = updatedDate,
      getResults = "No"
    )

  # Withdrawn
  withDrawn <- withChanges %>%
    dplyr::filter(stringr::str_detect(
      string = cohortName,
      pattern = stringr::fixed("[W]")
    )) %>%
    dplyr::mutate(getResults = "No")

  # Error
  error <- withChanges %>%
    dplyr::filter(stringr::str_detect(
      string = cohortName,
      pattern = stringr::fixed("[E]")
    )) %>%
    dplyr::mutate(
      deprecatedVersion = "XX",
      deprecatedDate = updatedDate,
      getResults = "No"
    )

  # New Cohorts -----------------------
  newCohorts <- withChanges %>%
    dplyr::anti_join(dplyr::tibble(
      cohortId = c(
        peerReview$cohortId,
        deprecated$cohortId,
        withDrawn$cohortId,
        error$cohortId
      ) %>% unique() %>%
        sort()
    ),
    by = "cohortId") %>%
    dplyr::mutate(addedVersion = "XX",
                  getResults = "Yes")

  changes <-
    dplyr::bind_rows(
      peerReview,
      deprecated,
      withDrawn,
      error,
      newCohorts
    )

  log <-
    dplyr::bind_rows(noChanges, changes) %>%
    dplyr::arrange(cohortId) %>%
    dplyr::select(
      cohortId,
      cohortName,
      getResults,
      addedDate,
      addedVersion,
      deprecatedDate,
      deprecatedVersion,
      updatedDate,
      updatedVersion,
      notes
    )

  return(log)
}
