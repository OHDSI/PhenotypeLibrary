loadSql <- function(sqlFilename) {
  pathToSql <- system.file("sql", sqlFilename,
                           package = "ohdsi.PregnancyEpisodeAlgorithm")
  parameterizedSql <- readChar(pathToSql, file.info(pathToSql)$size);
  return (parameterizedSql);
}
