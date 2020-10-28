suppressPackageStartupMessages(library(dplyr))

pkgDir <- system.file(package = "PhenotypeLibrary")
phenotypeIds <- list.files(pkgDir) %>%
  stringr::str_subset("\\d+")
print(pkgDir)
print(length(phenotypeIds))
