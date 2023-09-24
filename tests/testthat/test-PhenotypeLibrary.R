testthat::test_that(desc = "Function listPhenotypes", code = {
  data <- PhenotypeLibrary::listPhenotypes()
  testthat::expect_true(is.data.frame(data))
  testthat::expect_gte(object = nrow(data), expected = 1)
})

testthat::test_that(desc = "Function getPlCohortDefinitionSet", code = {
  phenotypes <- PhenotypeLibrary::listPhenotypes()
  cohortDefinitionSet <-
    PhenotypeLibrary::getPlCohortDefinitionSet(cohortIds = phenotypes[1, ]$cohortId)
  testthat::expect_true(is.data.frame(cohortDefinitionSet))
  testthat::expect_equal(
    object = nrow(cohortDefinitionSet),
    expected = 1
  )
  testthat::expect_equal(
    object = colnames(cohortDefinitionSet) |> sort(),
    expected = c("cohortId", "cohortName", "json", "sql")
  )
})

testthat::test_that(desc = "Function getPhenotypeLog", code = {
  data <- PhenotypeLibrary::getPhenotypeLog()
  testthat::expect_true(is.data.frame(data))
  testthat::expect_gte(object = nrow(data), expected = 1)
})

testthat::test_that(desc = "Function getPhenotypeLog with specific cohorts", code = {
  data <- PhenotypeLibrary::getPhenotypeLog(cohortIds = c(1:100))
  testthat::expect_true(is.data.frame(data))
  testthat::expect_gte(object = nrow(data), expected = 1)
})

testthat::test_that(desc = "Function getPlConceptSetDefinition", code = {
  data <- PhenotypeLibrary::getPlConceptDefinitionSet()
  testthat::expect_true(is.data.frame(data))
  testthat::expect_gte(object = nrow(data), expected = 1)
})

testthat::test_that(desc = "Function getPlConceptSetDefinition with specific cohorts", code = {
  data <- PhenotypeLibrary::getPlConceptDefinitionSet(cohortIds = c(1:100))
  testthat::expect_true(is.data.frame(data))
  testthat::expect_gte(object = nrow(data), expected = 1)
})
