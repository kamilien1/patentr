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


#' Extract the country code from a vector string of document numbers.
#' 
#' @description Extract the country code from a patent document number, which is the 
#' first two to four letters in a patent document number.
#' 
#' For example, if a patent number is US8880270, the country code is US. In rare
#' cases, we have more than two letters. Typical country codes are US (United States),
#' EP (Europe), JP (Japan), and WO (World, meaning a PCT application). 
#' 
#' @param docNum The character vector of document numbers. 
#' 
#' @return A character vector of the same length inputted, with 2-4 characters
#' representing the country code of the ptaent document.
#' 
#' @importFrom stringr str_extract
#' 
#' @examples 
#' # create a new column called countryCode in the acars data set
#' acars$countryCode <- extractCountryCode(acars$docNum)
#' head(acars[,c("docNum","countryCode")])
#' 
#' @export
#' 
extractCountryCode <- function(docNum) {
  # use the stringr package str_extract    
  stringr::str_extract(docNum, "^[A-Z]{0,4}")
}


#' Extract the numeric portion of the publication number.
#' 
#' @description Extract the numeric portion of the publication number. 
#' This is useful for a number of processing applications, and thus is beneficial
#' to isolate from the entire publication number. 
#' 
#' @param docNum The character vector of document numbers. 
#' 
#' @return A character vector of same length inputted, with varying length. 
#' Typical lengths are 7 to 11 characters. Only numbers are returned. All other
#' characters are stripped. 
#' 
#' @examples 
#' acars$pubNum <- extractPubNumber(acars$docNum)
#' head(acars[,c("docNum","pubNum")]) 
#'   
#'  
#' @export
#' 
extractPubNumber <- function(docNum) {
  # WO applications come with backslash, remove it
  pubNum <- gsub('/','', docNum)
  # get rid of country code
  pubNum <-  gsub("^[A-Z]{0,4}",'',pubNum)
  # get rid of kind code
  pubNum <- gsub("*[A-Z][0-9]$",'', pubNum)
  return(pubNum)
} 