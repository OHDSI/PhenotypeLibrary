# Import phenotypes from ATLAS -------------------------------------------------
cohortDefinitions <- PhenotypeLibrary::listPhenotypes()
referenceConcepts <- paste0(cohortDefinitions$recommendedReferentConceptIds, collapse = ",") |>
  stringr::str_replace_all(pattern = " ", replacement = "") |>
  strsplit(split = ",") |>
  unique()

postedReferenceCohorts <- cohortDefinitions |>
  dplyr::filter(stringr::str_detect(pattern = stringr::fixed("[P][R]"), string = cohortName)) |>
  dplyr::pull(recommendedReferentConceptIds) |>
  paste0(collapse = ",") |>
  stringr::str_replace_all(pattern = " ", replacement = "") |>
  strsplit(split = ",") |>
  unique()

missing <- setdiff(referenceConcepts, postedReferenceCohorts)
