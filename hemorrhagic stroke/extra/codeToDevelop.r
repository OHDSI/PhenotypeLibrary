setwd("~/git/ABMI/PhenotypeLibrary/hemorrhagic stroke")

OhdsiRTools::insertCohortDefinitionSetInPackage(fileName = "settings.csv",
                                                baseUrl = "http://.../WebAPI",
                                                insertTableSql = TRUE,
                                                insertCohortCreationR = TRUE,
                                                generateStats = FALSE,
                                                packageName="hemorrhagicStrokePhenotype")