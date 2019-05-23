####################################################################################################################################
# Title: makeIndexFile.R
# Author: Aaron Potvien
# Purpose: This file parses this repository and assembles the Gold Standard phenotypes and validation sets (residing in many files)
# into a single file. This file is a list object containing two data frames -- one for the phenotypes and 1 for the validation sets.
# This index file is what is loaded by the Shiny viewer application on boot. The pre-processing done here improves the load time for
# the Shiny application and also provides a single object which contains all library information.
#
# Note: The Gold Standandard Phenotype Library librarians will need to rerun this file each time there is a change to the library
# to keep it up to date. TODO: Try to automate this, perhaps by using a server-side post-receive hook to detect that the library has
# changed and therefore requires an updated index file.
####################################################################################################################################

# Libraries
library(httr)
library(jsonlite)
library(igraph) # For provenance graph clusters
library(tidyr) # For unnest

# Routine to make and return the index file
makeIndexFile <- function() {

  # Get all files from the gold standard library repository
  req <- GET("https://api.github.com/repos/OHDSI/PhenotypeLibrary/git/trees/master?recursive=1")
  stop_for_status(req)
  filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = FALSE)

  # Retrieve Gold Standard phenotypes and validation sets
  phenotypes <- grep("Gold Standard/Phenotypes/.*.json", filelist, value = TRUE)
  validations <- grep("Gold Standard/Validation Sets/.*.json", filelist, value = TRUE)

  phe.jsons <- lapply(phenotypes, function(x) {
    read_json(gsub(
      " ", "%20",
      paste0("https://raw.githubusercontent.com/OHDSI/PhenotypeLibrary/master/", x)
    ))
  })

  val.jsons <- lapply(validations, function(x) {
    read_json(gsub(
      " ", "%20",
      paste0("https://raw.githubusercontent.com/OHDSI/PhenotypeLibrary/master/", x)
    ))
  })

  # Stack results from all files together
  phe.data <- data.frame(do.call("rbind", phe.jsons))
  val.data <- data.frame(do.call("rbind", val.jsons))

  # Vectorize lists with 1 element
  unlist_phe_vars <- !(names(phe.data) %in% c("Authors_And_Affiliations", "Provenance_Hashes", "Provenance_Reasons"))
  unlist_val_vars <- !(names(val.data) %in% c("Validators_And_Affiliations"))

  for (idx in 1:length(unlist_phe_vars)) {
    if (unlist_phe_vars[idx]) {
      phe.data[[idx]] <- unlist(phe.data[[idx]])
    }
  }

  for (idx in 1:length(unlist_val_vars)) {
    if (unlist_val_vars[idx]) {
      val.data[[idx]] <- unlist(val.data[[idx]])
    }
  }

  # Replace spaces with underscores
  phe.data$Title <- gsub(" ", "_", phe.data$Title, fixed = TRUE) 
  
  # In case phenotype titles aren't unique, we will make them so here (x_1, x_2, ...)
  phe.data$Title <- make.unique(phe.data$Title, sep = "_")
  
  # Add in repository relative paths (strip common prefix and json extension)
  relative_path1 <- gsub("Gold Standard/Phenotypes/", "", phenotypes, fixed = TRUE)
  relative_path2 <- gsub(".json", "", relative_path1, fixed = TRUE)
  phe.data$Relative_Path <- relative_path2
  
  # The first level folder is the broad category, which can be filtered on in the viewer application
  phe.data$Broad_Category_Name <- dirname(relative_path1)

  # Calculate and incorporate weighted averages of the four metrics for each phenotype
  calculateMetrics <- function(hash) {
    cur.metrics <- val.data[val.data$Hash == hash, ]
    avg.sensitivity <- weighted.mean(cur.metrics$True_Positives / (cur.metrics$True_Positives + cur.metrics$False_Negatives),
      cur.metrics$Sample_Size,
      na.rm = TRUE
    )
    avg.specificity <- weighted.mean(cur.metrics$True_Negatives / (cur.metrics$True_Negatives + cur.metrics$False_Positives),
      cur.metrics$Sample_Size,
      na.rm = TRUE
    )
    avg.ppv <- weighted.mean(cur.metrics$True_Positives / (cur.metrics$True_Positives + cur.metrics$False_Positives),
      cur.metrics$Sample_Size,
      na.rm = TRUE
    )
    avg.npv <- weighted.mean(cur.metrics$True_Negatives / (cur.metrics$True_Negatives + cur.metrics$False_Negatives),
      cur.metrics$Sample_Size,
      na.rm = TRUE
    )
    avg.f1score <- weighted.mean(2 * cur.metrics$True_Positives / (2 * cur.metrics$True_Positives + cur.metrics$False_Positives + cur.metrics$False_Negatives),
      cur.metrics$Sample_Size,
      na.rm = TRUE
    )
    avg.accuracy <- weighted.mean((cur.metrics$True_Positives + cur.metrics$True_Negatives) / (cur.metrics$True_Positives + cur.metrics$True_Negatives + cur.metrics$False_Positives + cur.metrics$False_Negatives),
      cur.metrics$Sample_Size,
      na.rm = TRUE
    )

    return(
      data.frame(
        Hash = hash,
        Avg_Sensitivity = avg.sensitivity,
        Avg_Specificity = avg.specificity,
        Avg_PPV = avg.ppv,
        Avg_NPV = avg.npv,
        Avg_F1score = avg.f1score,
        Avg_Accuracy = avg.accuracy
      )
    )
  }

  metric_summary <- do.call("rbind", lapply(phe.data$Hash, calculateMetrics))
  phe.data <- merge(phe.data, metric_summary, by = "Hash")
  
  # Calculate connected components so the phenotype provenance path can be referenced in the viewer app
  
  # Nodes/Edges
  graph_subset <- phe.data[,c("Hash","Title","Provenance_Reasons","Provenance_Hashes")]
  edges <- unnest(graph_subset)
  names(edges) <- c("to", "title",  "reason", "from")
  edges <- edges[,c("from", "to", "title", "reason")]
  vert <- data.frame(hash = graph_subset$Hash, title = graph_subset$Title)
  
  # Make graph
  g <- graph_from_data_frame(d=edges, directed=TRUE, vertices=vert)
  
  # Bind connected component cluster IDs
  phe.data <- cbind(phe.data, Graph_Cluster = as.integer(clusters(g)$membership))
  
  # Return a single list object containing these data frames
  return(
    list(Phenotype = phe.data, Validation = val.data)
  )
}

# Make and export Index.rds
saveRDS(makeIndexFile(), file = file.path(getwd(), "Index.rds"))
print(paste("The index file was saved here:", paste0(file.path(getwd(), "index.rds"))))
print("Please push this index file to the gold standard phenotype library repository.")
