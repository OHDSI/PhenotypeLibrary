# @file main
#
# Copyright 2014 Observational Health Data Sciences and Informatics
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# @author Observational Health Data Sciences and Informatics
# @author Amy Matcho
# @author Chris Knoll

#' buildServer
#'
#' @details
#' Creates Server which can contain 1 or more database instances.
#'
#' @return
#' a Server instance
#'
#' @export
buildServer <- function(name, dbms, hostname, port, databases)
{
  server <- {};
  server$name = name;
  server$dbms = dbms;
  server$hostname = hostname;
  if (!missing(port) && !is.null(port))
  {
    server$port = port;
  }
  server$databases = databases;
  return (server)
}

#' buildDatabase
#'
#' @details
#' Creates a Database identified by an id, labeled by a name, and contained in a scheama. This class
#' is designed to be used as an element in the database list when calling buildServer
#'
#' @return
#' a Database instance
#'
#' @export
buildDatabase <- function(id, name, schema)
{
  dataSource <- {};
  dataSource$id = id;
  dataSource$name = name;
  dataSource$schema = schema;

  return(dataSource);
}

#' Init Tables
#'
#' @details
#' Initalizes lookup and result tables for pregnancy algorithm.
#'
#' @return
#' none
#'
#' @export
init <- function(serverList, targetDatabaseSchema, tablestem = "pa_") {

  outputFolder <- "output";

  if (!file.exists(outputFolder))
    dir.create(outputFolder);

  for (server in serverList)
  {
    serverFolder <- paste(outputFolder, server$name, sep="/");
    if (!file.exists(serverFolder))
      dir.create(serverFolder);

    connectionDetails <- createConnectionDetails(dbms=server$dbms, server=server$hostname, port=server$port);

    conn <- connect(connectionDetails);

    # Create tables that exist once per server
    initSql <- loadSql("init.sql");
    renderedSql <- renderSql(initSql, target_database_schema=targetDatabaseSchema, tablestem = tablestem)$sql;
    translatedSql <- translateSql(renderedSql, sourceDialect = "sql server", targetDialect = connectionDetails$dbms)$sql;
    writeSql(translatedSql,paste(serverFolder, "init.sql", sep="/"));
    executeSql(conn,translatedSql);
    closed <- dbDisconnect(conn);
  }
  print("Pregnancy algoritm tables initalized.");
}

#' Clean Tables
#'
#' @details
#' Removes all tables related to the pregnancy algorithm
#'
#' @return
#' none
#'
#' @export
clean <- function(serverList, targetDatabaseSchema, tablestem = "pa_") {

  outputFolder <- "output";

  if (!file.exists(outputFolder))
    dir.create(outputFolder);

  for (server in serverList)
  {
    serverFolder <- paste(outputFolder, server$name, sep="/");
    if (!file.exists(serverFolder))
      dir.create(serverFolder);

    connectionDetails <- createConnectionDetails(dbms=server$dbms, server=server$hostname, port=server$port);

    conn <- connect(connectionDetails);

    # Create tables that exist once per server
    initSql <- loadSql("clean.sql");
    renderedSql <- renderSql(initSql, target_database_schema=targetDatabaseSchema, tablestem = tablestem)$sql;
    translatedSql <- translateSql(renderedSql, sourceDialect = "sql server", targetDialect = connectionDetails$dbms)$sql;
    writeSql(translatedSql,paste(serverFolder, "clean.sql", sep="/"));
    executeSql(conn,translatedSql);
    closed <- dbDisconnect(conn);
  }
  print("Pregnancy algoritm tables removed");
}

#' Execute Algorithm
#'
#' @details
#' Executes the pregnancy identification algorithm.  init() must be called before executing this.
#'
#' @return
#' none
#'
#' @export
execute <- function(serverList, targetDatabaseSchema, tablestem = "pa_") {
  outputFolder <- "output"
  if (!file.exists(outputFolder))
    dir.create(outputFolder)

  for (server in serverList)
  {
    serverFolder <- paste(outputFolder, server$name, sep="/");
    if (!file.exists(serverFolder))
      dir.create(serverFolder);

    connectionDetails <- createConnectionDetails(dbms=server$dbms, server=server$hostname, user = server$user, domain = server$domain
                                                 , password=server$password, port=server$port);

    conn <- connect(connectionDetails);

    for (database in server$databases)
    {
      databaseOutputFolder <- paste(serverFolder, database$name, sep="/");
      if (!file.exists(databaseOutputFolder))
        dir.create(databaseOutputFolder)

      #todo: make this more cross platform
      cdmDatabaseSchema <- database$schema;
      if (str_length(database$name) > 0)
        cdmDatabaseSchema <- paste(database$name, cdmDatabaseSchema, sep=".");

      #execute algorithm
      algorithmSql <- loadSql("algorithm.sql");
      renderedSql <- renderSql(algorithmSql,
                               target_database_schema=targetDatabaseSchema,
                               cdm_database_schema = cdmDatabaseSchema,
                               db_id = database$id,
                               tablestem = tablestem
      )$sql;
      translatedSql <- translateSql(renderedSql, sourceDialect = "sql server", targetDialect = connectionDetails$dbms)$sql;
      writeSql(translatedSql,paste(databaseOutputFolder, "algorithm.sql", sep="/"));
      executeSql(conn,translatedSql);
    }
    dbDisconnect(conn);
  }

  print("Pregnancy episodes generated.")
}

