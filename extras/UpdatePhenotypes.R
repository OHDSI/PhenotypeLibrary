# Import phenotypes from ATLAS -------------------------------------------------
oldCohortDefinitions <- PhenotypeLibrary::listPhenotypes()
oldCohortDefinitionSet <-
  PhenotypeLibrary::getPlCohortDefinitionSet(cohortIds = oldCohortDefinitions$cohortId)

# Delete existing cohorts--------------------------------------------
unlink(x = "inst/Cohorts.csv",
       recursive = TRUE,
       force = TRUE)
unlink(x = "inst/cohorts",
       recursive = TRUE,
       force = TRUE)
unlink(x = "inst/sql",
       recursive = TRUE,
       force = TRUE)

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
          pattern = stringr::fixed('['),
          # Cohorts without prefix
          negate = TRUE
        )
      ),
    webApiCohorts |>
      dplyr::filter(
        stringr::str_detect(
          string = name,
          pattern = stringr::fixed('[D]'),
          # Deprecated cohorts, as another cohort definition subsumes the cohort definitions intent
          negate = FALSE
        )
      ),
    webApiCohorts |>
      dplyr::filter(
        stringr::str_detect(
          string = name,
          pattern = stringr::fixed('[P]'),
          # Cohorts under consideration for peer review
          negate = FALSE
        )
      ),
    webApiCohorts |>
      dplyr::filter(
        stringr::str_detect(
          string = name,
          pattern = stringr::fixed('[E]'),
          # Cohorts that have errors and should not be used
          negate = FALSE
        )
      ),
    webApiCohorts |>
      dplyr::filter(
        stringr::str_detect(
          string = name,
          pattern = stringr::fixed('[W]'),
          # Cohorts that have been withdrawn
          negate = FALSE
        )
      )
  ) |>
  dplyr::distinct() |>
  dplyr::select(id,
                name,
                description,
                createdDate,
                modifiedDate,
                createdBy,
                modifiedBy) |>
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
  
  if (all(!is.na(cohortRecord[[i]]$description),
          nchar(cohortRecord[[i]]$description) > 5)) {
    textInDescription <-
      cohortRecord[[i]]$description |>
      stringr::str_replace_all(pattern = ";", replacement = "") |>
      stringr::str_split(pattern = "\n")
    strings <- textInDescription[[1]]
    textInDescription <- NULL
    
    strings <-
      stringr::str_split(string = strings, pattern = stringr::fixed(": "))
    
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
            name = strings[[j]][[1]],
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
            tidyr::crossing(data)
        }
      }
    }
  }
}
cohortRecord <- dplyr::bind_rows(cohortRecord) |>
  dplyr::select(-createdBy,-modifiedBy) |>
  dplyr::mutate(id = cohortId,
                name = id) |>
  dplyr::relocate(cohortId, cohortName)

cohortRecord |>
  readr::write_excel_csv(
    file = "inst/Cohorts.csv",
    append = FALSE,
    na = "",
    quote = "all"
  )

try(ROhdsiWebApi::insertCohortDefinitionSetInPackage(
  fileName = "inst/Cohorts.csv",
  baseUrl = baseUrl,
  jsonFolder = "inst/cohorts",
  sqlFolder = "inst/sql/sql_server",
  generateStats = TRUE
),
silent = TRUE)

# generate cohort sql using latest version of circeR
remotes::install_github("OHDSI/circeR")
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
  SqlRender::writeSql(sql = sql,
                      targetFile = file.path("inst", "sql", sqlFileName))
}



# write Cohorts.csv
if ('atlasId' %in% colnames(cohortRecord)) {
  cohortRecord$atlasId <- NULL
}
if ('id' %in% colnames(cohortRecord)) {
  cohortRecord$id <- NULL
}
if ('name' %in% colnames(cohortRecord)) {
  cohortRecord$name <- NULL
}
if ('Version' %in% colnames(cohortRecord)) {
  cohortRecord <- cohortRecord |> 
    dplyr::rename(addedVersion = Version)
}
if ('Peer' %in% colnames(cohortRecord)) {
  cohortRecord <- cohortRecord |> 
    dplyr::rename(peer = Peer)
}
if ('Logic' %in% colnames(cohortRecord)) {
  cohortRecord <- cohortRecord |> 
    dplyr::rename(logicDescription = Logic)
}
if ('Contributor' %in% colnames(cohortRecord)) {
  cohortRecord <- cohortRecord |> 
    dplyr::rename(contributor = Contributor)
}
if ('Status' %in% colnames(cohortRecord)) {
  cohortRecord <- cohortRecord |> 
    dplyr::rename(status = Status)
}
readr::write_excel_csv(
  x = cohortRecord |> 
    dplyr::arrange(cohortId),
  file = "inst/Cohorts.csv",
  append = FALSE,
  na = "",
  quote = "all"
)


oldLogFile <- PhenotypeLibrary::getPhenotypeLog()

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
  description[dateLineNr]  <-
    sprintf("Date: %s", format(Sys.Date(), "%Y-%m-%d"))
  
  writeLines(description, con = "DESCRIPTION")
  
  
  # Update news -----------------------------------------------------------
  news <- readLines("NEWS.md")
  
  changes <- cohortRecord |>
    dplyr::anti_join(oldLogFile)
  
  newCohorts <- setdiff(x = sort(cohortRecord$cohortId),
                        y = sort(oldLogFile$cohortId))
  
  # deprecatedCohorts <- setdiff(
  #   x = sort(
  #     cohortRecord |>
  #       dplyr::filter(!is.na(deprecatedDate)) |>
  #       dplyr::pull(cohortId)
  #   ),
  #   y = sort(
  #     oldLogFile |>
  #       dplyr::filter(!is.na(deprecatedDate)) |>
  #       dplyr::pull(cohortId)
  #   )
  # )
  
  # modifiedCohorts <- changes |>
  #   dplyr::filter(!cohortId %in% c(newCohorts, deprecatedCohorts)) |>
  #   dplyr::pull(cohortId)
  
  messages <- c("")
  if (length(newCohorts) == 0) {
    messages <-
      c(messages,
        "New Cohorts: No new cohorts were added in this release.")
  } else {
    messages <-
      c(messages, paste0("New Cohorts: ", length(newCohorts), " were added."))
    messages <- c(messages,
                  "")
    
    for (i in (1:length(newCohorts))) {
      dataCohorts <- cohortRecord |>
        dplyr::filter(cohortId %in% newCohorts[[i]])
      messages <-
        c(messages,
          paste0("    ",
                 dataCohorts$cohortId,
                 ": ",
                 dataCohorts$cohortName))
    }
  }
  
  # if (length(deprecatedCohorts) == 0) {
  #   messages <-
  #     c(messages,
  #       "Deprecated Cohorts: No new cohorts were added in this release.")
  # } else {
  #   messages <-
  #     c(messages,
  #       "",
  #       paste0(
  #         "Deprecated Cohorts: ",
  #         length(deprecatedCohorts),
  #         " were deprecated."
  #       ))
  #   messages <- c(messages,
  #                 "")
  #   for (i in (1:length(deprecatedCohorts))) {
  #     dataCohorts <- changes |>
  #       dplyr::filter(cohortId %in% deprecatedCohorts[[i]])
  #     messages <-
  #       c(messages,
  #         paste0("    ",
  #                dataCohorts$cohortId,
  #                ": ",
  #                dataCohorts$cohortName))
  #   }
  # }
  
  # if (length(modifiedCohorts) == 0) {
  #   messages <-
  #     c(messages,
  #       "Modified Cohorts: No cohorts were modified in this release.")
  # } else {
  #   messages <-
  #     c(messages,
  #       "",
  #       paste0(
  #         "Modified Cohorts: ",
  #         length(modifiedCohorts),
  #         " were modified."
  #       ))
  #   messages <- c(messages,
  #                 "")
  #   for (i in (1:length(modifiedCohorts))) {
  #     dataCohorts <- changes |>
  #       dplyr::filter(cohortId %in% modifiedCohorts[[i]])
  #     messages <-
  #       c(messages,
  #         paste0("    ",
  #                dataCohorts$cohortId,
  #                ": ",
  #                dataCohorts$cohortName))
  #   }
  # }
  
  acceptedCohorts <- cohortRecord |> 
    dplyr::filter(addedVersion == newVersion)
  
  if (nrow(acceptedCohorts) == 0) {
    messages <-
      c("Accepted Cohorts: No cohorts were accepted in this release.",
        messages
        )
  } else {
    messages <-
      c(paste0("Accepted Cohorts: ", nrow(acceptedCohorts), " were accepted."),
        messages)
    messages <- c(messages,
                  "")
    
    for (i in (1:nrow(acceptedCohorts))) {
      dataCohorts <- cohortRecord |>
        dplyr::filter(cohortId %in% acceptedCohorts[i,]$cohortId)
      messages <-
        c(
          paste0("    ",
                 dataCohorts$cohortId,
                 ": ",
                 dataCohorts$cohortName),
          messages)
    }
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
