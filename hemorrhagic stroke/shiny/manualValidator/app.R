#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(broom) #For table

connectionDetails<-DatabaseConnector::createConnectionDetails(dbms="sql server",
                                                              server="",
                                                              schema="",
                                                              user="",
                                                              password="")
cdmDatabaseSchema <- ""
resultsDatabaseSchema <- ""
cdmVersion <- "5" 
connection<-DatabaseConnector::connect(connectionDetails)
cohortTable = "stroke_phenotypes"

ui<-fluidPage(
        titlePanel("Phenotype Validator"),
        
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
                sidebarPanel(
                        #numericInput ("seed", "random seed", value = NULL, verbatimTextOutput("value")),
                        numericInput ("samplingN", "sampling Number", value = 100),
                        numericInput ("cohortDefinitionId", "Cohort Definition Id", value = 1),
                        actionButton ("definitionEnter", "Change the setting")
                        
                ),
                mainPanel(
                        verbatimTextOutput("eventId"),
                        verbatimTextOutput("dischargeNote"),
                        #tableOutput("tab1"),
                        
                        radioButtons("result", 
                                     label = "The result of validation", 
                                     choices = c("valid", "invalid", "inconclusive")),
                        #selectInput ("result", "The result of validation", choices = c("valid", "invalid", "inconclusive")),
                        textInput ("comment", "Additional comment", verbatimTextOutput("txt")),
                        tableOutput("outputTab"),
                        actionButton("show", "Show"),
                        actionButton("validationEnter", "Enter the result of validation")
                        
                )
                
        ),
        downloadButton("downloadData", "download the validation result")
        
        ##additional information (drug, procedure, condition)
        #tableOutput("conditionTab"),
        #tableOutput("drugTab"),
        #tableOutput("procedureTab"),

)

server <-function(input,output,session){
        dfs<-data.frame()
        output$eventId<-renderText({sprintf("%d th event among %d events", input$validationEnter+1, input$samplingN)})
        
        observeEvent(input$definitionEnter,{
                sql <- "SELECT TOP @sampling_number *
                FROM @target_database_schema.@target_cohort_table co
                INNER JOIN @cdm_database_schema.visit_occurrence visit
                ON co.subject_id = visit.person_id AND co.cohort_start_date = visit.visit_start_date
                INNER JOIN CDMPv1.dbo.NOTE note
                ON co.subject_id = note.person_id AND visit.visit_end_date = note.note_date
                WHERE co.cohort_definition_id = @target_cohort_id
                ORDER BY newid()"
                
                sql <- SqlRender::renderSql(sql,
                                            cdm_database_schema=cdmDatabaseSchema,
                                            target_database_schema=resultsDatabaseSchema,
                                            target_cohort_table=cohortTable,
                                            target_cohort_id=as.numeric(input$cohortDefinitionId),
                                            sampling_number = as.numeric(input$samplingN)
                                            )$sql
                sql <- SqlRender::translateSql(sql,
                                               targetDialect=connectionDetails$dbms)$sql
                cohort<-DatabaseConnector::querySql(connection, sql)
                
                colnames(cohort)<-SqlRender::snakeCaseToCamelCase(colnames(cohort))
                cohortWithNote<<-cohort
                
                
        })
        
        outputTxt<-reactive({
                req(input$show)
                cohortWithNoteInterest<<-cohortWithNote[input$show,]
                noteText<-gsub("<[^<>]*>","\n" ,cohortWithNoteInterest$noteText)
                noteText<-gsub("EMR","",noteText)
                noteText<-gsub("&#x0D;","",noteText)
                #cohortWithNoteInterest$noteText
                
        })
        output$dischargeNote <- renderText({outputTxt()})
        
        observeEvent(input$validationEnter,{
                df<-cohortWithNoteInterest[,c("cohortDefinitionId","subjectId","noteId", "visitOccurrenceId",
                                              "cohortStartDate","visitStartDate","visitEndDate","noteDate",
                                              "visitTypeConceptId","admittingSourceConceptId","noteTypeConceptId","noteClassConceptId"
                )]
                df$validation<-input$result
                df$comment<-input$comment
                df$validation_time <- Sys.time()
                dfs<<-rbind(dfs,df)
                write.csv(dfs,paste0("result_cohortid",as.numeric(input$cohortDefinitionId),".csv"))
                
        })
        
        output$downloadData <- downloadHandler(
                filename = function(){
                        file.path("data","result.csv")
                },
                content = function(file){
                        write.csv(dfs,file)
                }
        )
        
}

shinyApp(ui,server)