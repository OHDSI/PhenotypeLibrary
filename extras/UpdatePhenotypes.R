# Import phenotypes from ATLAS -------------------------------------------------
oldCohortDefinitions <- PhenotypeLibrary::getPhenotypeLog(showHidden = TRUE)
oldCohortDefinitionSet <-
  PhenotypeLibrary::getPlCohortDefinitionSet(cohortIds = oldCohortDefinitions$cohortId)

# Delete existing cohorts--------------------------------------------
unlink(
  x = "inst/Cohorts.csv",
  recursive = TRUE,
  force = TRUE
)
unlink(
  x = "inst/cohorts",
  recursive = TRUE,
  force = TRUE
)
unlink(
  x = "inst/sql",
  recursive = TRUE,
  force = TRUE
)

# Fetch approved cohort definition----------------------------------
# from atlas-phenotype.ohdsi.org (note: approved phenotypes do not have '[')
baseUrl <- "https://atlas-phenotype.ohdsi.org/WebAPI"
ROhdsiWebApi::authorizeWebApi(
  baseUrl = baseUrl,
  authMethod = "db",
  webApiUsername = keyring::key_get("ohdsiAtlasPhenotypeUser"),
  webApiPassword = keyring::key_get("ohdsiAtlasPhenotypePassword")
)

webApiCohorts <-
  ROhdsiWebApi::getCohortDefinitionsMetaData(baseUrl = baseUrl)

exportableCohorts <-
  dplyr::bind_rows(
    webApiCohorts |>
      dplyr::filter(
        stringr::str_detect(
          string = name,
          pattern = stringr::fixed("["),
          # Cohorts without prefix
          negate = TRUE
        )
      ),
    webApiCohorts |>
      dplyr::filter(
        stringr::str_detect(
          string = name,
          pattern = stringr::fixed("[D]"),
          # Deprecated cohorts, as another cohort definition subsumes the cohort definitions intent
          negate = FALSE
        )
      ),
    webApiCohorts |>
      dplyr::filter(
        stringr::str_detect(
          string = name,
          pattern = stringr::fixed("[P]"),
          # Cohorts under consideration for peer review
          negate = FALSE
        )
      ),
    webApiCohorts |>
      dplyr::filter(
        stringr::str_detect(
          string = name,
          pattern = stringr::fixed("[E]"),
          # Cohorts that have errors and should not be used
          negate = FALSE
        )
      ),
    webApiCohorts |>
      dplyr::filter(
        stringr::str_detect(
          string = name,
          pattern = stringr::fixed("[W]"),
          # Cohorts that have been withdrawn
          negate = FALSE
        )
      )
  ) |>
  dplyr::distinct() |>
  dplyr::select(
    id,
    name,
    description,
    createdDate,
    modifiedDate,
    createdBy,
    modifiedBy
  ) |>
  dplyr::mutate(
    cohortId = id,
    atlasId = id,
    cohortName = name,
    createdDate = as.Date(createdDate),
    modifiedDate = as.Date(modifiedDate)
  ) |>
  dplyr::arrange(cohortId) |>
  dplyr::select(
    cohortId,
    atlasId,
    cohortName,
    description,
    createdDate,
    modifiedDate,
    createdBy,
    modifiedBy
  )

cohortRecord <- c()
for (i in 1:nrow(exportableCohorts)) {
  cohortRecord[[i]] <- exportableCohorts[i, ]
  librarian <-
    stringr::str_replace(
      string = exportableCohorts[i, ]$createdBy[[1]]$name,
      pattern = "na\\\\",
      replacement = ""
    )
  cohortRecord[[i]]$librarian <- librarian
  librarian <- NULL

  cohortRecord[[i]]$cohortNameFormatted <- gsub(
    pattern = "_",
    replacement = " ",
    x = gsub("\\[(.*?)\\]_", "", gsub(" ", "_", cohortRecord[[i]]$cohortName))
  ) |>
    stringr::str_squish() |>
    stringr::str_trim()

  cohortRecord[[i]]$lastModifiedBy <- NA
  if (length(cohortRecord[[i]]$modifiedBy) > 1) {
    cohortRecord[[i]]$lastModifiedBy <-
      cohortRecord[[i]]$modifiedBy[[1]]$name
  }

  if (all(
    !is.na(cohortRecord[[i]]$description),
    nchar(cohortRecord[[i]]$description) > 5
  )) {
    textInDescription <-
      cohortRecord[[i]]$description |>
      stringr::str_replace_all(pattern = ";", replacement = "") |>
      stringr::str_split(pattern = "\n")
    strings <- textInDescription[[1]]
    textInDescription <- NULL

    strings <-
      stringr::str_split(string = strings, pattern = stringr::fixed(":"))

    if (all(
      !is.na(cohortRecord[[i]]$description[[1]]),
      stringr::str_detect(
        string = cohortRecord[[i]]$description,
        pattern = stringr::fixed(":")
      )
    )) {
      stringValues <- c()
      for (j in (1:length(strings))) {
        stringValues[[j]] <- dplyr::tibble()
        if (length(strings[[j]]) == 2) {
          stringValues[[j]] <- dplyr::tibble(
            name = strings[[j]][[1]] |> stringr::str_squish() |> stringr::str_trim(),
            value = strings[[j]][[2]] |>
              stringr::str_squish() |>
              stringr::str_trim()
          )
        }
      }

      stringValues <- dplyr::bind_rows(stringValues)

      if (nrow(stringValues) > 0) {
        data <- stringValues |>
          tidyr::pivot_wider()
        stringValues <- NULL

        if (nrow(data) > 0) {
          cohortRecord[[i]] <- cohortRecord[[i]] |>
            tidyr::crossing(data |>
              dplyr::select(dplyr::all_of(
                setdiff(
                  x = colnames(data),
                  y = colnames(cohortRecord[[i]])
                )
              )))
        }
      }
    }
  }
}

cohortRecord <- dplyr::bind_rows(cohortRecord) |>
  dplyr::select(-createdBy, -modifiedBy) |>
  dplyr::mutate(
    id = cohortId,
    name = id
  ) |>
  dplyr::relocate(cohortId, cohortName)

cohortRecord |>
  readr::write_excel_csv(
    file = "inst/Cohorts.csv",
    append = FALSE,
    na = "",
    quote = "all"
  )

saveRDS(
  object = cohortRecord,
  file = "inst/CohortRecord.rds"
)

cohortRecord <- readRDS("inst/CohortRecord.rds")

try(
  ROhdsiWebApi::insertCohortDefinitionSetInPackage(
    fileName = "inst/Cohorts.csv",
    baseUrl = baseUrl,
    jsonFolder = "inst/cohorts",
    sqlFolder = "inst/sql/sql_server",
    generateStats = TRUE
  ),
  silent = TRUE
)

# generate cohort sql using latest version of circeR
# remotes::install_github("OHDSI/circeR")
circeOptions <- CirceR::createGenerateOptions(generateStats = TRUE)

cohortJsonFiles <-
  list.files(path = file.path("inst", "cohorts"), pattern = ".json") |> sort()

for (i in (1:length(cohortJsonFiles))) {
  jsonFileName <- cohortJsonFiles[i]
  sqlFileName <-
    stringr::str_replace_all(
      string = jsonFileName,
      pattern = stringr::fixed(".json"),
      replacement = ".sql"
    )

  writeLines(paste0(" - Generating ", sqlFileName))

  json <-
    SqlRender::readSql(sourceFile = file.path("inst", "cohorts", jsonFileName))
  sql <-
    CirceR::buildCohortQuery(expression = json, options = circeOptions)
  writeLines(paste0(" --", sqlFileName))
  unlink(
    x = file.path("inst", "sql", "sql_server", sqlFileName),
    recursive = TRUE,
    force = TRUE
  )
  SqlRender::writeSql(
    sql = sql,
    targetFile = file.path("inst", "sql", "sql_server", sqlFileName)
  )
}


if ("id" %in% colnames(cohortRecord)) {
  cohortRecord$id <- NULL
}
if ("atlasId" %in% colnames(cohortRecord)) {
  cohortRecord$atlasId <- NULL
}
if ("name" %in% colnames(cohortRecord)) {
  cohortRecord$name <- NULL
}
if ("description" %in% colnames(cohortRecord)) {
  cohortRecord$description <- NULL
}

cohortRecord <- cohortRecord |>
  dplyr::mutate(isCirceJson = 1)

expectedFields <- c(
  "cohortId",
  "cohortName",
  "cohortNameFormatted",
  "cohortNameLong",
  "librarian",
  "status",
  "addedVersion",
  "logicDescription",
  "hashTag",
  "isCirceJson",
  "contributors",
  "contributorOrcIds",
  "contributorOrganizations",
  "peerReviewers",
  "peerReviewerOrcIds",
  "recommendedReferentConceptIds",
  "cohortNameLong",
  "ohdsiForumPost",
  "createdDate",
  "modifiedDate",
  "lastModifiedBy",
  "replaces",
  "notes"
)

presentInBoth <- intersect(
  expectedFields,
  colnames(cohortRecord)
)
new <- setdiff(
  colnames(cohortRecord),
  c(expectedFields, "atlasId")
)
missing <- setdiff(
  expectedFields,
  colnames(cohortRecord)
)

if (length(new) > 0) {
  stop(paste0(
    "The following new fields observed please check and update ",
    paste0(new, collapse = ", ")
  ))
}

if (length(missing) > 0) {
  stop(paste0(
    "The following fields were missing please check and update ",
    paste0(missing, collapse = ", ")
  ))
}

if (!all(sort(presentInBoth) |> unique() == sort(expectedFields) |> unique())) {
  stop("Something is odd. Please check.")
}

cohortRecord <- cohortRecord |>
  dplyr::select(dplyr::all_of(presentInBoth)) |>
  dplyr::arrange(cohortId)

cohortRecord <- cohortRecord |>
  dplyr::mutate(isReferenceCohort = dplyr::if_else(
    stringr::str_detect(
      string = cohortName,
      pattern = stringr::fixed("[R]")
    ),
    1,
    0
  ))

saveRDS(cohortRecord, file = "cohortRecord.rds")
cohortRecord <- readRDS("cohortRecord.rds")

cohortRecordAugmented <- c()
for (i in (1:nrow(cohortRecord))) {
  cohortRecordUnit <- cohortRecord[i, ]

  if (!file.exists(file.path(
    "inst",
    "cohorts",
    paste0(cohortRecordUnit$cohortId, ".json")
  ))) {
    stop("cant find file")
  }

  cohortJson <- SqlRender::readSql(sourceFile = file.path(
    "inst",
    "cohorts",
    paste0(cohortRecordUnit$cohortId, ".json")
  ))

  parsed <-
    CohortDefinitionReviewer::parseCohortDefinitionSpecifications(cohortDefinition = cohortJson |>
      RJSONIO::fromJSON(digits = 23))
  if (nrow(parsed) > 0) {
    cohortRecordAugmented[[i]] <- cohortRecordUnit |>
      tidyr::crossing(parsed)
  }
}

cohortRecordAugmented <- dplyr::bind_rows(cohortRecordAugmented)

## correct the url
correctUrl <- function(url) {
  # Check if the string likely represents a URL by looking for "http"
  if (grepl("http", url, ignore.case = TRUE)) {
    # Ensure the URL starts with "https://"
    if (startsWith(tolower(url), "https//")) {
      corrected_url <- sub("https//", "https://", url, ignore.case = TRUE)
      return(corrected_url)
    }
    return(url)
  }
  return(url)
}

# Function to transform the URL
transformUrl <- function(url) {
  # Check if URL exists
  if (is.na(url) || url == "" || is.na(url)) {
    return(url)
  }

  # Check if URL has the correct base
  base_url <- "https://forums.ohdsi.org/t/"
  if (!stringr::str_starts(url, base_url)) {
    return(NA)
  }

  extract_number1 <- function(url) {
    # Use a regular expression to capture the first set of numbers after '/t/' and another '/'
    match_data <- stringr::str_match(url, "/t/[^/]*/(\\d+)")
    if (!is.na(match_data[1, 2])) {
      return(match_data[1, 2])
    }
    return(NA)
  }

  # Extract the first set of numbers after the base URL
  number1 <- extract_number1(url)

  # If number1 is found, construct the new URL, else return NA
  if (!is.na(number1)) {
    new_url <- paste0(base_url, number1)
    return(new_url)
  } else {
    return(url)
  }
}

cohortRecordAugmented <- cohortRecordAugmented |>
  dplyr::mutate(ohdsiForumPost = sapply(ohdsiForumPost, FUN = correctUrl)) |>
  dplyr::mutate(ohdsiForumPost = sapply(ohdsiForumPost, FUN = transformUrl)) |>
  dplyr::arrange(cohortId)

readr::write_excel_csv(
  x = cohortRecordAugmented,
  file = "inst/Cohorts.csv",
  append = FALSE,
  na = "",
  quote = "all"
)

orcidFromPhenotypeLog <- PrivateScripts::getOrcidFromPhenotypeLog(log = cohortRecordAugmented)

readr::write_excel_csv(
  x = orcidFromPhenotypeLog,
  file = "inst/OrcidLog.csv",
  append = FALSE,
  na = "",
  quote = "all"
)

if (file.exists("cohortRecord.rds")) {
  file.remove("cohortRecord.rds")
}

newCohortDefinitionSet <-
  CohortGenerator::getCohortDefinitionSet(
    settingsFileName = file.path("inst", "Cohorts.csv"),
    jsonFolder = file.path("inst", "cohorts"),
    sqlFolder = file.path("inst", "sql", "sql_server")
  ) |>
  dplyr::select(
    cohortId,
    json
  ) |>
  dplyr::tibble() |>
  dplyr::arrange(cohortId)

conceptSetsInAllCohortDefinition <- ConceptSetDiagnostics::extractConceptSetsInCohortDefinitionSet(
  cohortDefinitionSet = newCohortDefinitionSet
)

saveRDS(
  object = conceptSetsInAllCohortDefinition |>
    dplyr::arrange(
      uniqueConceptSetId,
      cohortId,
      conceptSetId
    ),
  file = file.path("inst", "ConceptSetsInCohortDefinition.RDS")
)

oldLogFile <- PhenotypeLibrary::getPhenotypeLog(showHidden = TRUE)

needToUpdate <- TRUE
if (identical(x = oldLogFile, y = cohortRecord)) {
  needToUpdate <- FALSE
  writeLines("No changes to cohort definitions. No update to version needed.")
}


if (needToUpdate) {
  # Update description -----------------------------------------------------------
  description <- readLines("DESCRIPTION")

  # Increment minor version:
  versionLineNr <- grep("Version: .*$", description)
  version <- sub("Version: ", "", description[versionLineNr])
  versionParts <- strsplit(version, "\\.")[[1]]
  versionParts[2] <- as.integer(versionParts[2]) + 1
  newVersion <- paste(versionParts, collapse = ".")
  description[versionLineNr] <- sprintf("Version: %s", newVersion)

  # Set date:
  dateLineNr <- grep("Date: .*$", description)
  description[dateLineNr] <-
    sprintf("Date: %s", format(Sys.Date(), "%Y-%m-%d"))

  writeLines(description, con = "DESCRIPTION")


  # Update news -----------------------------------------------------------
  news <- readLines("NEWS.md")
  newCohorts <- setdiff(
    x = sort(cohortRecord$cohortId),
    y = sort(oldLogFile$cohortId)
  )

  messages <- c("")
  if (length(newCohorts) == 0) {
    messages <-
      c(
        messages,
        "New Cohorts: No new cohorts were added in this release."
      )
  } else {
    messages <-
      c(messages, paste0("New Cohorts: ", length(newCohorts), " were added."))
    messages <- c(
      messages,
      ""
    )

    for (i in (1:length(newCohorts))) {
      dataCohorts <- cohortRecord |>
        dplyr::filter(cohortId %in% newCohorts[[i]])
      messages <-
        c(
          messages,
          paste0(
            "    ",
            dataCohorts$cohortId,
            ": ",
            dataCohorts$cohortName
          )
        )
    }
  }


  acceptedCohorts <- cohortRecord |>
    dplyr::filter(addedVersion == newVersion)

  if (nrow(acceptedCohorts) == 0) {
    messages <-
      c(
        "Accepted Cohorts: No cohorts were accepted in this release.",
        messages
      )
  } else {
    for (i in (1:nrow(acceptedCohorts))) {
      dataCohorts <- cohortRecord |>
        dplyr::filter(cohortId %in% acceptedCohorts[i, ]$cohortId)
      messages <-
        c(
          paste0(
            "    ",
            dataCohorts$cohortId,
            ": ",
            dataCohorts$cohortName
          ),
          messages
        )
    }

    messages <-
      c(
        paste0(
          "Accepted Cohorts: ",
          nrow(acceptedCohorts),
          " were accepted."
        ),
        messages
      )
    messages <- c(
      messages,
      ""
    )
  }

  news <- c(
    paste0("PhenotypeLibrary ", newVersion),
    "======================",
    messages,
    "",
    news
  )
  writeLines(news, con = "NEWS.md")
}


unlink("inst/CohortRecord.rds")
