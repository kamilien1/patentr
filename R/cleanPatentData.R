#' Generate a standard set of header names for import data
#' 
#' @description Create a standard nameset from Sumobrain import data. 
#' See \code{\link{acars}} for the name set.
#' 
#' There are three main sources of free and exportable patent data from the internet: 
#' \enumerate{
#' \item{\href{www.sumobrain.com}{Sumobrain}}
#' \item{\href{www.lens.org}{The Lens}}
#' \item{\href{www.patents.google.com}{Google}}
#' }
#' 
#' These three popular sites have varying levels of exportable data available. 
#' Sumobrain tends to be the most comprehensive, followed by Lens, and finally 
#' by Google. Thus, all three have hardcoded data available in the \code{patentr} 
#' package. 
#' 
#' To download Sumobrain data, go to \url{http://www.sumobrain.com} and create a free
#' account. Then run your search, export the data (250 max at a time), and use the 
#' \code{\link{chooseFiles}} and \code{\link{importPatentData}} functions to load
#' the data into R. 
#' 
#' To download Lens data, go to \url{www.lens.org}. You do not need to create an 
#' account. Run your search, and in the header section, look for the cloud icon 
#' with a downward arrow. Choose the CSV option. 
#' 
#' To download Google patent data, visit \url{www.patents.google.com}, run 
#' your search, and click "Download (CSV)" in the upper left-hand corner. 
#' 
#' @param patentData A data frame. Default is NA.
#' @param columnsExpected An expected number of columns. 
#' Default is Sumobrain \code{\link{sumobrainColumns}} data.
#' @param cleanNames A standard list of clean names. Default is Sumobrain 
#' \code{\link{sumobrainNames}} data.
#' 
#' @return A data frame 11 columns wide, with standard column names used in other
#' functions. 
#' 
#' @examples
#' cleanData <- cleanHeaderNames(patentData = acars)
#' 
#' @export
#' 
#' @seealso \enumerate{
#' \item{\code{\link{sumobrainColumns}}}
#' \item{\code{\link{sumobrainNames}}}
#' \item{\code{\link{skipSumobrain}}}
#' \item{\code{\link{googleColumns}}}
#' \item{\code{\link{googleNames}}}
#' \item{\code{\link{skipGoogle}}}
#' \item{\code{\link{lensColumns}}}
#' \item{\code{\link{lensNames}}}
#' \item{\code{\link{skipLens}}}
#' }
#' 
#' 
cleanHeaderNames <- function(patentData = NA, columnsExpected = patentr::sumobrainColumns,
                                    cleanNames = patentr::sumobrainNames){
  
  # check to make sure dataframe is the appropriate width and the names 
  # fit the width
  if(is.data.frame(patentData) && dim(patentData)[2] == columnsExpected &&
     length(cleanNames)==columnsExpected){
    names(patentData) <- cleanNames
  }
  return(patentData)
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




#' View all your duplicate entries to decide which to remove.
#' 
#' @description Return a logical vector of all duplicate entries. 
#' 
#' Often times, you want to review your duplicate results to determine which 
#' rows you want to keep and which you want to erase. 
#' 
#' For example, if you have 
#' an application number that is an application, and another that is a search report, 
#' then you will want to keep the application data and remove the search report 
#' entry. 
#' 
#' Or, if you have an application number that has both a grant and an 
#' application entry, you may want to remove the application from your analysis 
#' and focus on the grant data, as the claim scope is most important for the 
#' granted patent. 
#' 
#' @param input A vector or a data frame which you wish to view duplicated values. 
#' 
#' @return A logical vector of TRUE / FALSE with all entries that contain two 
#' or more duplicate values. 
#' 
#' @examples 
#' 
#' acarsDups <- acars[showDups(acars$appNum),]
#' head(acarsDups[order(acarsDups$appNum),c("docNum","docTypeSumobrain","appNum")])
#' 
#' @export
#' 
#' @seealso \code{\link[base]{duplicated}}, \code{\link{removeDups}}
#'
showDups <- function(input){
  
  # return all dups
  duplicated(input) | duplicated(input, fromLast=T)  
}


#' Remove duplicate entries in a patent data set. 
#' 
#' @description Remove duplicate values in the patent data. Typically you will 
#' want to check if you have repeat document numbers. A document number should be 
#' a unique number in your dataset, thus, having a duplicate document number in your 
#' data set should be avoided. You can optionally specify which document type to keep.
#' 
#' Often times, your data sets contain duplicate patent entries. This function is 
#' a wrapper function of the \code{\link[base]{duplicated}} function, 
#' applied to a dataframe or vector. 
#' 
#' For example, if you have the vector [US123, US123, US456], you will get the value 
#' TRUE FALSE TRUE and the duplicate value is removed. 
#' 
#' You can go deeper with the optional variables. For many analyses, we want to exclude the 
#' second document, typically the application. This function allows you to choose 
#' which document type to keep and the rest get thrown out.
#' 
#' 
#' @param input A vector or a data frame which you wish to remove duplicate values. 
#' When choosing a data frame, you are more selective. For example, you may want to 
#' remove a patent document only if it has the same docNum and country code. 
#' @param hasDup A logical vector noting if a duplicate exists. If NA, ignore. The 
#' \code{\link{showDups}} funciton helps with this input.
#' @param docType A character vector of the type of patent document (app, grant, etc.). 
#' If NA, ignore.
#' @param keepType A character variable denoting which document type to keep. Default is "grant". 
#' If NA, ignore.
#' 
#' @return A logical vector used to remove duplicate documents not fitting the one 
#' chosen. TRUE is for the document to keep.
#' 
#' @examples 
#' 
#' # simple removal: see how many rows were removed
#' dim(acars) - dim(acars[removeDups(acars$appNum),])
#' 
#' # specific removal: keep the grant docs
#' acars$hasDup <- showDups(acars$appNum)
#' 
#' @export
#' 
#' @seealso \code{\link[base]{duplicated}}, \code{\link{showDups}}
#'
removeDups <- function(input, hasDup = NA, docType = NA, keepType = NA){
  
  # return all the unique doc numbers
  # or if there are any with 2 or greater, cut those out
  dupsVector <- duplicated(input)
  if (sum(dupsVector) >0){
    print(paste("Removing",sum(dupsVector), "duplicates."))
  } else{
    print("No duplicates found.")
  }
  
  # simple return
  if(is.na(hasDup) && is.na(docType) && is.na(keepType)){
    # Note: this is unordered and you may have remove the rows 
    # where other column values have data missing, such as the abstract. 
    return(!duplicated(input))
  } else if(!is.na(hasDup) && !is.na(docType) && !is.na(keepType)){
    # keep it or throw it out  
    # Note for the hasDup == FALSE cases, we want to keep them as well
    # may need to add an | 
    return(ifelse(hasDup==TRUE & docType == keepType, TRUE, FALSE))
  } else{
      # return back all TRUES
      warning("Arguments error. Either choose a simple input, or fill out all other argument fields.
              Returning All TRUEs back to you.")
    # note if user put in something bad, this throws an error
      return(ifelse(is.vector(input),rep(TRUE,length(input)),rep(TRUE,dim(input)[1])))
  }
  

} ## TODO: test 

#' Calculate the type of document
#' 
#' @description Determine the type of document from the patent publication data. 
#' 
#' Often times, data exports from publicly available sources do not provide the 
#' type of patent document, or, if provided, still requires standardization. By 
#' using the kind code, country code, 
#' 
#' @param officeDocLength The concat value of country code and number of numerical digits. 
#' Extracted using the \code{\link{extractDocLength}} function.
#' @param countryAndKindCode The concat value of the country code and kind code. 
#' Extracted using the \code{\link{extractCountryCode}} and \code{\link{extractKindCode}} 
#' functions. 
#' @param cakcDict A county and kind code dictionary. Default is \code{\link{cakcDict}}.
#' @param docLengthTypesDict A document length and type dictionary. Default is \code{\link{docLengthTypesDict}}.
#' 
#' @examples 
#' 
#' acars <- acars
#' acars$pubNum <- extractPubNumber(acars$docNum) # pubnum, ex ####
#' acars$countryCode <- extractCountryCode(acars$docNum) # country code, ex USAPP, USD
#' acars$officeDocLength <- extractDocLength(countryCode = acars$countryCode, 
#'                                          pubNum = acars$pubNum) # cc + pub num length concat
#' acars$kindCode <- extractKindCode(acars$docNum)
#' acars$countryAndKindCode <- with(acars, paste0(countryCode, kindCode))
#'                                          
#' acars$docType <- generateDocType(officeDocLength = acars$officeDocLength,
#'                             countryAndKindCode = acars$countryAndKindCode,
#'                             cakcDict = cakcDict,
#'                             docLengthTypesDict = docLengthTypesDict)
#' table(acars$docType)
#' 
#' 
#' @return A vector of characters labeling the document type, with NA for when 
#' no match was found.
#' 
#' @export
#' 
#' @seealso \code{\link{cakcDict}}, \code{\link{docLengthTypesDict}}
#' 
generateDocType <- function(officeDocLength, countryAndKindCode, 
                            cakcDict = patentr::cakcDict, 
                            docLengthTypesDict = patentr::docLengthTypesDict){

  
  docTypeDLT <- docLengthTypesDict[officeDocLength]
  docTypeCAKC <- cakcDict[countryAndKindCode]
  # replace NA values
  docTypeCAKC <- ifelse(is.na(docTypeCAKC),"NA",docTypeCAKC)
  docTypeDLT <- ifelse(is.na(docTypeDLT), "NA",docTypeDLT)
  # prioritize docTypeCAKC as it is a more comprehensive list
  # else, default on docTypeDLT
  docType <- ifelse(docTypeCAKC!="NA", docTypeCAKC, docTypeDLT)
  
  foundValue <- sum(officeDocLength %in% names(docLengthTypesDict) | 
                      countryAndKindCode %in% names(cakcDict))
  
  # warn user if not everything is fine
  if (foundValue < length(officeDocLength)) { 
    warning("In generateDocType, not all values were found. ",
            length(officeDocLength)-foundValue," Values will be NA.")}
  
  return(docType)
  
  # view what is not equal to inspect what they are, probably WO reports
  # notequal <- acars[!(docTypeCAKC == docTypeDLT) & 
  # docTypeCAKC != "NA" & docTypeDLT != "NA", c(1,2,14, 16)]
  # head(notequal)

}

