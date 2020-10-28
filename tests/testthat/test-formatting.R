test_that("phenotype directories are integers", {
  expect_true(length(phenotypeIds) > 200)
})

test_that("sql files are correctly formatted", {
  sqlFiles <- purrr::map(phenotypeIds, ~paste0(glue::glue("{pkgDir}/{.}/"), list.files(glue::glue("{pkgDir}/{.}")))) %>%
    unlist() %>%
    stringr::str_subset("\\.sql")

  df <- tibble::tibble(sqlFiles) %>%
    mutate(isutf8 = purrr::map(sqlFiles, ~stringi::stri_enc_isutf8(readr::read_lines_raw(.)))) %>%
    mutate(badLines = purrr::map_chr(isutf8, ~paste(which(!.), collapse = ",")))

  expect_true(nrow(df) >= length(phenotypeIds))

  df <- df %>%
    filter(badLines != "") %>%
    mutate(notutf8 = paste("file:", sqlFiles, "lines:", badLines)) %>%
    select(notutf8)

  expect_true(nrow(df) == 0)

})

test_that("json files are correctly formatted", {
  jsonFiles <- purrr::map(phenotypeIds, ~paste0(glue::glue("{pkgDir}/{.}/"), list.files(glue::glue("{pkgDir}/{.}")))) %>%
    unlist() %>%
    stringr::str_subset("\\.json")

  expect_true(length(jsonFiles) >= length(phenotypeIds))

  df <- tibble::tibble(jsonFiles) %>%
    mutate(isutf8 = purrr::map(jsonFiles, ~stringi::stri_enc_isutf8(readr::read_lines_raw(.)))) %>%
    mutate(badLines = purrr::map_chr(isutf8, ~paste(which(!.), collapse = ",")))

  expect_true(nrow(df) >= length(phenotypeIds))

  df <- df %>%
    filter(badLines != "") %>%
    mutate(notutf8 = paste("file:", jsonFiles, "lines:", badLines)) %>%
    select(notutf8)

  # check utf8 encoding
  expect_true(nrow(df) == 0)

  # check valid json
  df <- tibble::tibble(jsonFiles) %>%
    mutate(json = purrr::map_chr(jsonFiles, readr::read_file)) %>%
    mutate(isValid = purrr::map_lgl(json, jsonlite::validate))

  expect_true(all(df$isValid))
})
