#' Read in a data file or list of files from excel spreadsheets.
#'
#' @description Import, read, and connect patent data files. Currently: xls files
#' from a filepath. 
#' Future use: can read from a URL, an xlsx file, google doc, and a csv.
#'
#' @param rawDataFilePath A filepath, or list of filespaths, for xls files.
#' @param skipLines Number of lines to skip before reading in your data file.
#' @return A single data frame of all data. NULL if no data. 
#' @examples \dontrun{
#' 
#' # access the files here and put them in a data/ folder of your working directory.
#' file1 <- system.file("extdata/", "sumobrain_autonomous_search1.xls", package="patentr")
#' file2 <- system.file("extdata/", "sumobrain_autonomous_search2.xls", package="patentr")
#' files <- list(file1, file2)
#' ipData <- readPatentData(rawDataFilePath = files, skipLines = 1)
#' 
#' # example 2
#' # assume csv files are in the data folder
#' ipData <- readPatentData(rawDataFilePath = list.files('data/', full.names=T), skipLines = 1)
#' }
#' 
#' 
#' @export
#' 
#' @importFrom readxl read_excel
#' @importFrom plyr ldply
importPatentData <- function(rawDataFilePath = NA, skipLines = 1){
  
  # grep all files that end in "xls". This is a lazy-mans error-check. 
  filePaths <- rawDataFilePath[grep(".*.xls",rawDataFilePath,ignore.case=T)]
  if (length(filePaths) == 0){
    warning("Inputted filepath list: ",rawDataFilePath,"\ndoes not contain any xls files.")
    # exit
    return(NULL)
  }
  else {
    # use read_excel from the readxl package
    # note: on xls files the last column might get dropped
    # a fix was supposed to have worked in Feb 2017
    # https://github.com/tidyverse/readxl/issues/152
    rawData <- lapply(rawDataFilePath, readxl::read_excel, skip = skipLines)
    
    # clean the data with ldply, unlists data and creates single data frame
    cleanData <- plyr::ldply(rawData)
    print(paste("Successfull loaded in a file with",dim(cleanData)[1], "rows and",dim(cleanData)[2],"columns."))
    return(cleanData)
  }
  
}



#' Allow the user to navigate to files manually. 
#' 
#' @description Uses a popup window (Tk file dialog) to allow the user to choose a list of zero or more files interactively.
#' 
#' @return A list of character vectors with absolute pathnames to files.
#' 
#' @examples \dontrun{
#' filePaths <- chooseFiles()
#' allData <- readIpExcel(filePaths)
#' }
#' @export
#' @importFrom tcltk tk_choose.files
chooseFiles <- function() {
  files <- tcltk::tk_choose.files(caption = "Select the file(s) you wish to read")
  files
}