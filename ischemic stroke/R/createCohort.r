##settings

setwd("~/git/ABMI/PhenotypeLibrary/ischemic stroke")

connectionDetails<-DatabaseConnector::createConnectionDetails(dbms="sql server",
                                                              server="",
                                                              schema="",
                                                              user="",
                                                              password="")
cdmDatabaseSchema <- ""
resultsDatabaseSchema <- ""
cdmVersion <- "5" 
connection<-DatabaseConnector::connect(connectionDetails)
cohortTable = "ischemic_stroke_phenotypes"
######################################################################

#read cohort setting
cohortSettings<-read.csv(file.path("inst","settings","settings.csv"))

#create cohort table
sql <- SqlRender::readSql(file.path("inst","sql","sql_server", "CreateCohortTable.sql"))
sql <- SqlRender::renderSql(sql,
                 cohort_database_schema=resultsDatabaseSchema,
                 cohort_table=cohortTable)$sql
sql <- SqlRender::translateSql(sql,
                               targetDialect=connectionDetails$dbms)$sql
DatabaseConnector::executeSql(connection, sql)

#generate cohort
for (i in seq(cohortSettings$cohortId)){
        cohortId<-cohortSettings$cohortId[i]
        cohortName<-cohortSettings$name[i]
        
        sql <- SqlRender::readSql(file.path("inst","sql","sql_server",paste0(cohortName,".sql")))
        sql <- SqlRender::renderSql(sql,
                                    cdm_database_schema=cdmDatabaseSchema,
                                    vocabulary_database_schema = cdmDatabaseSchema,
                                    target_database_schema=resultsDatabaseSchema,
                                    target_cohort_table=cohortTable,
                                    target_cohort_id=cohortId)$sql
        sql <- SqlRender::translateSql(sql,
                                       targetDialect=connectionDetails$dbms)$sql
        writeLines(paste("generate", cohortName, "cohort"))
        DatabaseConnector::executeSql(connection, sql)
}

