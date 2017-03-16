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


#' Extract the numeric portion of the document (published) number.
#' 
#' @description Extract the numeric portion of the document number. 
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
#' @seealso \code{\link{createGoogleURL}}
#'  
#' @export
#' 
extractPubNumber <- function(docNum) {
  # may change to extractDocNumber for consistency
  # note that the doc number is the PUBLISHED doc number, hence, pubNum
  # WO applications come with backslash, remove it
  pubNum <- gsub('/','', docNum)
  # get rid of country code
  pubNum <-  gsub("^[A-Z]{0,4}",'',pubNum)
  # get rid of kind code
  pubNum <- gsub("*[A-Z][0-9]$",'', pubNum)
  return(pubNum)
} 


#' Extract the kind code, if available, from the publication number.
#' 
#' @description Extracts the kind code, a one-to-two character code with a letter and 
#' typically a number, if found in the document (published) number. 
#' 
#' @param docNum The character vector of document numbers. 
#' 
#' @return A character vector of kind codes. If none found, a blank character is returned.
#' 
#' @examples 
#' acars$kindCode <- extractKindCode(acars$docNum)
#' head(acars[,c("docNum","kindCode")]) 
#'   
#' @importFrom stringr str_extract
#' 
#' @export
#'
extractKindCode <- function(docNum) {
  
  # get a letter and a number at the end of a string
  kindCode <- stringr::str_extract(docNum, "[A-Z][0-9]{0,1}$")
  # and remove the NA values
  kindCode[is.na(kindCode)] <- ''
  return(kindCode)
}


#' Get a code for length of doc and country code
#' 
#' @description Generate a custom concatenation of country code and length of 
#' the publication number, for document type identification purposes. 
#' 
#' Given limited metadata available on free sites, often times the downloaded
#' data set does not include the type of patent document. There are two easy ways to 
#' discover the type of a patent document. A dictionary stored with the 
#' package can compare the output to match up the type of patent document. 
#' 
#' \enumerate{
#' \item The kind code, if present, is typically the same for each country.
#' \code{B} is usually a patent and \code{A} is usually an application.
#' \item The length of the publication number, along with the country code, is 
#' another great indicator. Applications in USA have 11 numbers, and, for now,
#' 9 numbers for granted patents.
#' }
#' 
#' @param countryCode A string vector of country codes
#' @param pubNum A string vector of the numeric portion of a publication number.
#' 
#' @return A string vector of concatenated country code and publication number 
#' length, such as US11 or EP9. 
#' 
#' @examples 
#' acars$pubNum <- extractPubNumber(acars$docNum)
#' acars$countryCode <- extractCountryCode(acars$docNum)
#' acars$officeDocLength <- extractDocLength(countryCode = acars$countryCode,
#' pubNum = acars$pubNum)
#' head(acars[,c("officeDocLength","docNum")])
#' 
#' @export
#' 
extractDocLength <- function(countryCode, pubNum) {
  # make a concat of length of document and country code to figure out
  # what type of document it is, in general (patent, app, reissue, or design)
  officeLength <- paste(countryCode, nchar(pubNum),sep='')
  officeLength    
  
}


#' Format patent dates.
#' 
#' @description Create a clean year, month, day date.
#' 
#' Reading data in and aout of R may cause date mistakes, using a simple set
#' function will ensure data types are the right format and class type. This 
#' data format is cleaned up to be in the format yyyy-mm-dd with no hours,
#' minutes, seconds, or time zone attached. 
#' 
#' @param dateVector A vector of character dates.
#' @param orders The orders the dates appear in. 
#' 
#' @importFrom lubridate parse_date_time
#' 
#' @return A date vector of year, month, day dates. 
#' 
#' @examples 
#' acars$pubDate <- extractCleanDate(dateVector = acars$pubDate, orders = "ymd")
#' 
#' 
#' @export
#' 
extractCleanDate <- function(dateVector, orders="ymd"){
  
  # use lubridate to ensure all dates are proper
  # get the order and then get rid of the UTC by
  # converting it with as.Date
  as.Date(lubridate::parse_date_time(dateVector, orders=orders))
  
}



#' Create a URL link to Google patents. 
#' 
#' @description Create a URL string to link you to Google Patents. 
#' 
#' By concatenating the country code, publication number, and kind code, you can
#' generate a URL to link you to google patents for further exploration. This 
#' feature is especially useful when browsing the data in a spreadsheet or in 
#' a Shiny app. It is also useful for extracting data from the HTML content. 
#' 
#' As each website (Google, lens.org, sumobrain.com, etc..) has a different 
#' method for generating patent URLs, these functions are website-specific. 
#' 
#' The original Google patents version still works as of March 2017 and the 
#' \code{googleURL} value is  \code{https://www.google.com/patents/}. This older 
#' version may be easier to extract data. 
#' 
#' @param countryCode A character vector of the country code of the document. 
#' Typically a two-letter character. 
#' @param pubNum A character vector of the numeric portion of a publication number.
#' @param kindCode character vector of the kind code of a document. If not available,
#' enter a blank string "".
#' @param googleURL A character string of the URL to Google Patents, with working
#' default value. 
#' 
#' @return A character vector of properly formatted URL strings. 
#' 
#' @examples 
#' acars$kindCode <- extractKindCode(acars$docNum)
#' acars$pubName <- extractPubNumber(acars$docNum)
#' acars$googleURL <- createGoogleURL(countryCode = acars$countryCode, 
#' pubNum = acars$pubNum, kindCode =acars$kindCode)
#' head(acars$googleURL)
#' 
#' @export
createGoogleURL <- function(countryCode, pubNum, kindCode, googleURL = "https://patents.google.com/patent/"){
  # create the URL 
  paste(googleURL, countryCode, pubNum, kindCode,  sep='')  
  # TODO: validate the URL
  # http://stackoverflow.com/questions/28527100/check-if-https-hypertext-transfer-protocol-secure-url-is-valid
}

