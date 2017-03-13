#' Read in a data file or list of files from excel spreadsheets.
#'
#' @description This read in file can turn into an S3 class where you read from 
#' a URL, an excel file, google doc, and a csv.
#'
#' @param rawDataFilePath A file, or list of files, in xls format. URL in future.
#' @param skipLines Number of lines to skip before reading in your data file.
#' @return A single data frame of all data. 
#' @examples
#' add(1, 1)
#' add(10, 1)
#' 
#' @export
#' 
#' @importFrom readxl read_excel
#' @importFrom plyr ldply
readPatentData <- function(rawDataFilePath = NA, skipLines = 1){
  
  # grep all files that end in "xls". This is a lazy-mans error-check. 
  filePaths <- rawDataFilePath[grep(".*.xls",rawDataFilePath,ignore.case=T)]
  if (length(filePaths) == 0){
    warning("Inputted filepath list: ",rawDataFilePath,"\ndoes not contain any xls files.")
    # exit
    return(NULL)
  }
  else {
    # use read_excel from the readxl package
    rawData <- lapply(rawDataFilePath, readxl::read_excel, skip = skipLines)
    
    # clean the data with ldply, unlists data and creates single data frame
    cleanData <- plyr::ldply(rawData)
    print(paste("Successfull loaded in a file with dim:",dim(cleanData)))
    return(cleanData)
  }
  
}