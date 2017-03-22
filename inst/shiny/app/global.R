##This should detect and install missing packages before loading them  

list.of.packages <- c("shiny","ggplot2", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages,function(x){library(x,character.only=TRUE)}) 


# TODO 
#' 1) successfully read in csv from
#' 1a) lens.org data
#' 1b) Google patents data
#' 2) successfull read in excel file from sumobrain data
#' 3) successfully visualize patent data frame data by
#' 3a) columns (choose which ones to display)
#' 3b) values within rows: example, choose assignees to display
#' 4) successfully display simple patent summaries
#' 4a) total number of documents by docType
#' 4b) number of documents by assignee
#' 5) be able to export data with the following types
#' 5a) csv export
#' 5b) excel export (xlsx)
#' 