#' Generate a standard set of header names for Sumobrain import data
#' 
#' @description Create a standard nameset from Sumobrain import data. 
#' See \code{\link{acars}} for the name set.
#' 
#' To download Sumobrain data, go to \url{http://www.sumobrain.com} and create a free
#' account. Then run your search, export the data (250 max at a time), and use the 
#' \code{\link{chooseFiles}} and \code{\link{importPatentData}} functions to load
#' the data into R. 
#' 
#' @param sumobrainData A data frame 11 columns wide, imported from sumobrain.com.
#' @param columnsExpected A sumobrain export has 11 columns. In case their export changes,
#' you can modify the value.
#' @param cleanNames A standard list of clean names. 
#' 
#' @return A data frame 11 columns wide, with standard column names used in other
#' functions. 
#' 
#' @examples
#' cleanData <- cleanSumobrainNames(sumobrainData = acars)
#' 
#' @export
#' 
cleanSumobrainNames <- function(sumobrainData = NA, columnsExpected = 11,
                                    cleanNames = c("docNum", "docType","pubDate",
                                                   "title","abstract","inventors",
                                                   "assignee","appNum","dateFiled",
                                                   "classPrimary","classOthers")){
  
  # sumobrain exports have 11 columns
  if(is.data.frame(sumobrainData) && dim(sumobrainData)[2] == columnsExpected &&
     length(cleanNames)==columnsExpected){
    names(sumobrainData) <- cleanNames
  }
  return(sumobrainData)
}