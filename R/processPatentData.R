#' Create a URL link to Google patents
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
#' @param lang The language you want to read the patent, default set to "en" english.
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
createGoogleURL <- function(countryCode, pubNum, kindCode, 
                            googleURL = "https://patents.google.com/patent/",
                            lang ="en"){
  # create the URL 
  paste(googleURL, countryCode, pubNum, kindCode, "/",lang, sep='')  
  # TODO: validate the URL
  # http://stackoverflow.com/questions/28527100/check-if-https-hypertext-transfer-protocol-secure-url-is-valid
}



#' Get a claim from a Google Patents URL
#' 
#' @description Input a valid Google Patents URL of the form given below and 
#' then get back a claim from the index of your choosing. If no claim exists or 
#' if your index is out of bounds, an  empty character string returns. 
#' 
#' The function works on strings that begin with the following sequence: 
#' \code{https://patents.google.com/patent/}. If the string sequence afterwards 
#' is invalid, a 404 status returns from the GET command and eventually an empty 
#' string returns. 
#' 
#' 
#' 
#' 
#' @return A character vector of the claim from each Google URL. If no claim exists, 
#' or if the country code is not on the inclusion list, an empty character value is returned 
#' for that index.
#' 
#' @param googleURL The well-formatted google URL built from \code{\link{createGoogleURL}}.
#' It is a character value.
#' @param langCode The language code, used check for non-english text.
#' @param whichClaim Default set to 1, a numeric determining which claim to get. Note
#' if claim is out of bounds, the return claim will be a blank character. 
#' 
#' 
#' @seealso \code{\link{createGoogleURL}}, \code{\link{extractCountryCode}},
#' \code{\link{cleanGoogleURL}}
#' 
#' @examples 
#' 
#' # works for USA
#' aclaim <- getClaimFromURL("https://patents.google.com/patent/US8818682B1/en")
#' print(aclaim)
#' # test WO, EP
#' woclaim <- getClaimFromURL("https://patents.google.com/patent/WO2015134152A1/en")
#' print(woclaim)
#' epclaim <- getClaimFromURL("https://patents.google.com/patent/EP2991875A1/en")
#' print(epclaim)
#' # test KR, JP, CN
#' krclaim <- getClaimFromURL("https://patents.google.com/patent/KR20150127745A/en")
#' cnclaim <- getClaimFromURL("https://patents.google.com/patent/CN104786953A/en")
#' jpclaim <- getClaimFromURL("https://patents.google.com/patent/JP2016173842A/en")
#' declaim <- getClaimFromURL("https://patents.google.com/patent/DE102014219223A1/en")
#' 
#' @export
#' 
#' @importFrom XML xpathSApply 
#' @importFrom XML xmlValue 
#' @importFrom XML getNodeSet 
#' @importFrom XML htmlParse
#' @importFrom httr GET
#' 
getClaimFromURL <- function(googleURL, langCode="en", whichClaim = 1){
  
  # make sure language code is set in URL
  googleURL <- cleanGoogleURL(googleURL = googleURL, langCode = langCode)

  # pd = patent data
  pd1 <- httr::GET(url = googleURL)
  pd2 <- XML::htmlParse(pd1)
  # future mode will have an input vector of options to choose from
  pd3 <- XML::getNodeSet(pd2, "//div[@class='claim']")

  # pc = patent claim
  # if exists
  if(length(pd3)>=whichClaim){
    
    # if US
    # works for USA
    pc <- XML::xmlValue(pd3[[whichClaim]])

  } 
    else{
      # works for WO, EP
      pd3 <- XML::getNodeSet(pd2, "//claim")
      if(length(pd3)>=whichClaim){
        pc <- XML::xmlValue(pd3[[whichClaim]]) 

        
      } else{
        # catch all
        pc <- ""
      }

  }

  # if english, get rid of non-english words and try replacing 
  # any alphanumerics that are non-english vocabulary
  if(langCode == "en" && (length(pd3) >= whichClaim) ){
    
    pd3 <- XML::getNodeSet(pd2, "//div[@class='claim']")
    pd3 <- XML::getNodeSet(pd2, "//div[contains(@class,'claim')]")
    pd4 <- XML::getNodeSet(pd3[[whichClaim]],
                           paste0("//div[@num=",whichClaim,"]//span[@class='notranslate']/text()"))
    pd5 <- paste((sapply(pd4, XML::xmlValue)), collapse = "")
    # if returns a value and less than the original printout
    # replace pc with the new "cleaner" version
    # note this may have issues and "too much" may be returned
    # requires further testing, (nchar(pd5) < nchar(pc)) may need to
    if( nchar(pd5) > 1 ){
      pc <- pd5
    }
    pc <- gsub("[^[:alnum:] ]","",pc)
  }
  

  # trim  to remove new lines and numbering with a period
  pc <- trimws(gsub("\\n|[0-9].", "", pc))
  # remove excessive spacing
  pc <- gsub("\\s+"," ", pc)
  # return a trimmed version of the claim
  return(pc)
  
}
# later want to get the # of claims 
# http://stackoverflow.com/questions/8702039/how-to-find-the-max-attribute-from-an-xml-document-using-xpath-1-0
# do something like this /library/book[@id = max(/library/book/@id)]
# may need to sleep to not call too many
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/Sys.sleep.html




#' Sanitize a Google URL before attempting to extract data
#' 
#' @description Clean up the google URL to make sure it will be read properly.
#' 
#' If you use the \code{\link{createGoogleURL}} function, you won't have to use this function. 
#' However, if you use your own generator or want to change the language, use this 
#' function to do so.
#' 
#' @param googleURL A character value of a google URL.
#' @param langCode A language code, default set to "en" English.
#' 
#' @return A clean character vector of a Google Patents URL.
#' 
#' @export
#' 
#' @examples 
#' 
#' cleanGoogleURL("https://patents.google.com/patent/US8818682B1/mx")
#' cleanGoogleURL("https://patents.google.com/patent/US8818682B1/")
#' cleanGoogleURL("https://patents.google.com/patent/US8818682B1")
#' cleanGoogleURL("https://patents.google.com/patent/US8818682B1/en")
#' 
#' @seealso \code{\link{createGoogleURL}}
#' 
cleanGoogleURL <- function(googleURL, langCode="en"){
  
  expr <- paste0("\\/",langCode)
  # if the last two digist are not the language code, attempt to fix it
  if(regexpr(expr,googleURL)==-1L){
    
    # 3 types of errors
    # 1 /en <--> /mx replace lang code
    # 2 /en <--> / add lang code
    # 3 /en <--> '' doesn't exist, add lang code and backslash
    
    if(regexpr("\\/[A-Za-z]{2}$",googleURL)>-1L){
      googleURL <- gsub("\\/[A-Za-z]{2}$",paste0("/",langCode),googleURL)
    } else if(regexpr("\\/$",googleURL)>-1L){
      googleURL <- gsub("\\/$",paste0("/",langCode),googleURL)
    } else{
      # warning, attempting to generate URL, this may fail
      googleURL <- gsub("$",paste0("/",langCode),googleURL)
    }
    
  }
  return(googleURL)
}

#' Get claims data for all rows in a data frame
#' 
#' @description Generate claims data for all rows in a data frame. 
#' 
#' This is a wrapper function for the \code{\link{getClaimFromURL}} function.
#' 
#' @param googleURLs A character vector of Google URLs
#' @param langCode A language code, default set to "en"
#' @param whichClaim Which claim (if available) to return. Default set to 1st.
#' 
#' @export
#' 
#' @examples 
#' 
#' cc <- extractCountryCode(acars$docNum)
#' pn <- extractPubNumber(acars$docNum)
#' kc <- extractKindCode(acars$docNum)
#' urls <- createGoogleURL(countryCode = cc, pubNum = pn ,kindCode = kc)
#' urls <- urls[1:4]
#' clms <- getClaimsText(urls)
#' clms[1]
#' 
#' @seealso \code{\link{createGoogleURL}}, \code{\link{cleanGoogleURL}},
#' \code{\link{getClaimFromURL}}
#' 
getClaimsText <- function(googleURLs, langCode="en",whichClaim=1){
  sapply(googleURLs, function(x){
    getClaimFromURL(googleURL = x, langCode = langCode, whichClaim = whichClaim)
  })
}



