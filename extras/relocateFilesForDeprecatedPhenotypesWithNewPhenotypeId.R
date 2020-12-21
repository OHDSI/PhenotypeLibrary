library(magrittr)
path <- rstudioapi::getActiveProject()

phenotypeDescription <- readxl::read_excel(path = file.path(path, "extras", "PhenotypeDescription.xlsx"), trim_ws = TRUE)

deprecatedPhenotypes <- phenotypeDescription %>%
  dplyr::filter(deprecate == 'Y')




files <- list.files(path = file.path(path, "inst"), pattern = ".xlsx", full.names = TRUE, recursive = TRUE)

for (i in (1:length(files))) {
  if (any(stringr::str_detect(string = files[[i]], pattern = as.character(deprecatedPhenotypes$oldPhenotypeId)))) {
    print(i)
    from = files[[i]]
    oldPhenotype = basename(dirname(dirname(files[[i]])))
    newPhenotype = deprecatedPhenotypes %>%
      dplyr::filter(oldPhenotypeId == oldPhenotype) %>%
      dplyr::pull(newPhenotypeId) %>%
      as.character()
    to = stringr::str_replace(string = files[[i]],
                              pattern = stringr::fixed(paste0(oldPhenotype,"/")),
                              replacement =
                                stringr::fixed(paste0(newPhenotype,"/")))

    file.copy(from = from, to = to, overwrite = TRUE, copy.date = TRUE)
    unlink(from, recursive = TRUE, force = TRUE)

  }
}



files <- list.files(path = file.path(path, "inst"), pattern = ".json", full.names = TRUE, recursive = TRUE)

for (i in (1:length(files))) {
  if (any(stringr::str_detect(string = files[[i]], pattern = as.character(deprecatedPhenotypes$oldPhenotypeId)))) {
    print(i)
    from = files[[i]]
    oldPhenotype = basename((dirname(files[[i]])))
    newPhenotype = deprecatedPhenotypes %>%
      dplyr::filter(oldPhenotypeId == oldPhenotype) %>%
      dplyr::pull(newPhenotypeId) %>%
      as.character()
    to = stringr::str_replace(string = files[[i]],
                              pattern = stringr::fixed(paste0(oldPhenotype,"/")),
                              replacement =
                                stringr::fixed(paste0(newPhenotype,"/")))

    file.copy(from = from, to = to, overwrite = TRUE, copy.date = TRUE)
    unlink(from, recursive = TRUE, force = TRUE)

  }
}









files <- list.files(path = file.path(path, "inst"), pattern = ".sql", full.names = TRUE, recursive = TRUE)

for (i in (1:length(files))) {
  if (any(stringr::str_detect(string = files[[i]], pattern = as.character(deprecatedPhenotypes$oldPhenotypeId)))) {
    print(i)
    from = files[[i]]
    oldPhenotype = basename((dirname(files[[i]])))
    newPhenotype = deprecatedPhenotypes %>%
      dplyr::filter(oldPhenotypeId == oldPhenotype) %>%
      dplyr::pull(newPhenotypeId) %>%
      as.character()
    to = stringr::str_replace(string = files[[i]],
                              pattern = stringr::fixed(paste0(oldPhenotype,"/")),
                                                                            replacement =
                                                                              stringr::fixed(paste0(newPhenotype,"/")))

    file.copy(from = from, to = to, overwrite = TRUE, copy.date = TRUE)
      unlink(from, recursive = TRUE, force = TRUE)

  }
}

(stringr::str_detect(string = files[[i]], pattern = "132702"))
