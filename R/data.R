#' A kind codes database to show the type of document for each patent document.
#'
#' Patent documents have associated kind codes, which are letter/number code 
#' combinations that signify the type of document, such as application, granted 
#' patent, utility patent, etc. These kind codes vary by country and are a useful 
#' approach to classifying patent document types. Most, however, not all, downloaded 
#' data from free services such as sumobrain.com or lens.org includes the kind code 
#' at the end of the patent document number. 
#' 
#' For example, from the sumobrain.com download from the \code{\link{acars}} data set,
#' here are three documents:
#' \enumerate{
#' \item{US6523912}
#' \item{US20030060197}
#' \item{EP1310400A1}
#' }
#' 
#' The first two items are missing kind codes. The third item has kind code A1 
#' and the country code is EP. 
#' 
#' To clean the data yourself:
#' 
#' \code{temp <- readxl::read_excel(system.file("extdata", "kindCodes.xlsx", package = "patentr"))}
#' 
#' \code{temp <- replace(temp, is.na(temp), "NA")}
#' 
#' \code{temp$dateDeprecated <- as.numeric(temp$dateDeprecated)}
#' 
#' \code{temp$dateDeprecated <- as.Date(temp$dateDeprecated, origin = "1899-12-30")}
#' 
#' \code{temp$dateStarted <- as.numeric(temp$dateStarted)}
#' 
#' \code{temp$dateStarted <- as.Date(temp$dateStarted, origin = "1899-12-30")}
#' 
#' \code{temp$countryAndKindCode <- with(temp,paste0(countryCode, kindCode))}
#' 
#' 
#' See https://www.r-bloggers.com/date-formats-in-r/ for excel mac/windows and confirm this origin works for you by reviewing the source file
#' 
#' View the data sources:
#' \enumerate{
#' \item{\href{https://www.uspto.gov/learning-and-resources/support-centers/electronic-business-center/kind-codes-included-uspto-patent}{USPTO kind codes}}
### Note I had to add a backslash after the % symbol, or else devtools throws a warning. 
#' \item{\href{https://worldwide.espacenet.com/help?locale=en_EP&method=handleHelpTopic&topic=kindcodes\%5C}{EPO file histories}}
#' \item{\href{https://www.cas.org/content/references/patkind}{CAS list of kind codes}}
#' \item{\href{http://ipbookcompanion.org/links/pk_codes.pdf}{IP Book kind codes}}
#' \item{\href{http://www.thomsonfilehistories.com/docs/RESOURCES_Kind\%20Codes\%20by\%20Country.pdf}{Thomson File Histories}}
#' }
#' 
#' 
#' @name kindCodes
#' @docType data
#' @keywords data
#' 
#' 
#' @format A data frame.
#' 
#' \describe{
#' \item{\code{countryCode}}{The country code for the originating office where the application 
#' was filed.}
#' \item{kindCode}{The letter/number code to signify the type of document. Codes may 
#' change after a certain date, so pay attention to \code{dateStarted} and \code{dateDeprecated}}
#' \item{isDeprecated}{Logical TRUE/FALSE if the kind code for the country is no longer in use.}
#' \item{dateDeprecated}{The date the kind code stopped being in use.}
#' \item{isNew}{If the kind code is a replacement for a former kind code, TRUE, else FALSE.}
#' \item{dateStarted}{If isNew == TRUE, the date the new kind code began being used.}
#' \item{comment}{Additional information explaining the details of the kind code.}
#' \item{docTypeLong}{The long version of the document type.}
#' \item{docType}{A shorter, standardized version of \code{docTypeLong}.}
#' \item{expectDuplicate}{A logical TRUE/FALSE to help the analyst understand if the 
#' published document is expected to have a duplicate publication. For example, USB2 is 
#' a granted patent that has an application that was also published, whereas USB1 has no 
#' previous documents published. This helps speed up the deduplication process. }
#' \item{countryAndKindCode}{A concatenation of country code and kind code. Used in 
#' the deduplication process and to determine the type of document.}
#' }
#' 
#' 
#' 
"kindCodes"



#' A document mapper for country codes and document digit length to the type of 
#' document.
#'
#' A simple table that helps map the country code and length of the numeric portion 
#' of the data to the type of document.
#' 
#' 
#' @name docLengthTypes
#' @docType data
#' @keywords data
#' 
#' 
#' @format A data frame with a key and value pair. 
#' 
#' \describe{
#' \item{key}{A concatenated country code and length of the numeric portion of a 
#' document number. For example: US7 is a US document with 7 digits.}
#' \item{value}{The type of patent document based on the country code and document 
#' length value.}
#' 
#' }
#' 
"docLengthTypes"

#' Header names for a data upload sourced from sumobrain.com
#'
#' A character vector to standardize the headers of the imported excel from a 
#' sumobrain.com patent data export.
#'
#' Used with \code{\link{acars}} data.
#'
#' @name sumobrainNames
#' @docType data
#' @keywords data
#'
#'
#' @format A character vector
#'
#' \describe{
#' \item{sumobrainNames}{An 11-element character vector of clean sumobrain names.}
#'
#' }
#'
#' @seealso Go to \href{www.sumobrain.com}{Sumobrain}, create a free account, and 
#' download the data.
#' 
#' \code{\link{skipGoogle}}, \code{\link{skipLens}}, \code{\link{skipSumobrain}},
#' \code{\link{googleColumns}},\code{\link{lensColumns}}, \code{\link{sumobrainColumns}}, 
#' \code{\link{lensNames}}, \code{\link{googleNames}}
#'   
"sumobrainNames"


#' The number of columns in a sumobrain.com data export.
#'
#' A convenient hard-coded value that can be used when reading in sumobrain.com 
#' exported patent data files.
#'
#' Used with \code{\link{acars}} data.
#'
#' @name sumobrainColumns
#' @docType data
#' @keywords data
#'
#'
#' @format A numeric value.
#'
#' \describe{
#' \item{sumobrainColumns}{A hard-coded numeric value for the number of columns in a 
#' sumobrain.com data export.}
#'
#' }
#'
#' @seealso
#' \code{\link{skipGoogle}}, \code{\link{skipLens}}, \code{\link{skipSumobrain}},
#' \code{\link{googleColumns}},\code{\link{lensColumns}},
#' \code{\link{sumobrainNames}}, \code{\link{lensNames}}, \code{\link{googleNames}}
#' 
"sumobrainColumns"

#' The number of lines to skip in a data read for a sumobrain.com export file.
#'
#' The number of lines to skip in a data read for a sumobrain.com export file.
#' Used with \code{\link{acars}} data.
#'
#'
#' @name skipSumobrain
#' @docType data
#' @keywords data
#'
#'
#' @format A numeric value.
#'
#' \describe{
#' \item{skipSumobrain}{A hard-coded numeric value for how many lines to skip 
#' in a sumobrain.com data export.}
#'
#' }
#' @seealso
#' \code{\link{skipGoogle}}, \code{\link{skipLens}}, 
#' \code{\link{googleColumns}},\code{\link{lensColumns}}, \code{\link{sumobrainColumns}}, 
#' \code{\link{sumobrainNames}}, \code{\link{lensNames}}, \code{\link{googleNames}}
#'
#' 
"skipSumobrain"



#' Header names for a data upload sourced from Google Patents data exports.
#'
#' A character vector to standardize the headers of the imported csv from a 
#' Google Patents patent data export. Used with \code{\link{acarsGoogle}} data.
#'
#'
#' @name googleNames
#' @docType data
#' @keywords data
#'
#'
#' @format A character vector.
#'
#' \describe{
#' \item{googleNames}{A 9-element character vector of clean Google patent names.}
#'
#' }
#'
#' @seealso Go to \href{patents.google.com}{Google Patents} to download the data.
#' 
#' \code{\link{skipGoogle}}, \code{\link{skipLens}}, \code{\link{skipSumobrain}},
#' \code{\link{googleColumns}},\code{\link{lensColumns}}, \code{\link{sumobrainColumns}}, 
#' \code{\link{sumobrainNames}}, \code{\link{lensNames}}
#'
"googleNames"


#' Number of columns in Google Patents export data.
#'
#' The number of columns in a Google Patents CSV export.
#' 
#' Used with \code{\link{acarsGoogle}} data.
#'
#'
#' @name googleColumns
#' @docType data
#' @keywords data
#'
#'
#' @format A numeric value.
#'
#' \describe{
#' \item{googleColumns}{A numeric value of number of columns in a csv export from 
#' Google Patents.}
#'
#' }
#'
#' @seealso
#' 
#' \code{\link{skipGoogle}}, \code{\link{skipLens}}, \code{\link{skipSumobrain}},
#' \code{\link{lensColumns}}, \code{\link{sumobrainColumns}}, 
#' \code{\link{sumobrainNames}}, \code{\link{lensNames}}, \code{\link{googleNames}}
#' 
"googleColumns"

#' How many lines to skip in a Google Patents CSV export file.
#'
#' A hard-coded value for the number of lines to skip in a Google Patents csv 
#' export.
#'
#' Used with \code{\link{acarsGoogle}} data.
#'
#' @name skipGoogle
#' @docType data
#' @keywords data
#'
#'
#' @format A numeric value.
#'
#' \describe{
#' \item{skipGoogle}{A numeric value for number of lines to skip in a Google 
#' Patents csv export.}
#'
#' }
#'
#' @seealso
#' 
#' \code{\link{skipLens}}, \code{\link{skipSumobrain}},
#' \code{\link{googleColumns}},\code{\link{lensColumns}}, \code{\link{sumobrainColumns}}, 
#' \code{\link{sumobrainNames}}, \code{\link{lensNames}}, \code{\link{googleNames}}
#' 
"skipGoogle"


#' Header names for a data upload sourced from lens.org.
#'
#' A character vector to standardize the headers of the imported csv from a 
#' lens.org patent data export.
#'
#'
#' Used with \code{\link{acarsLens}} data.
#'
#' @name lensNames
#' @docType data
#' @keywords data
#'
#'
#' @format A character vector.
#'
#' \describe{
#' \item{sumobrainNames}{A 26-element character vector of clean lens.org header names.}
#'
#' }
#'
#' @seealso Go to \href{lens.org}{Lens}, optionally create a free account, and 
#' download the data. 
#' 
#' \code{\link{skipGoogle}}, \code{\link{skipLens}}, \code{\link{skipSumobrain}},
#' \code{\link{googleColumns}},\code{\link{lensColumns}}, \code{\link{sumobrainColumns}}, 
#' \code{\link{sumobrainNames}},  \code{\link{googleNames}}
#' 
"lensNames"


#' The number of columns in a lens.org csv data export.
#'
#' The number of columns in a lens.org csv data export.
#'
#' Used with \code{\link{acarsLens}} data.
#'
#' @name lensColumns
#' @docType data
#' @keywords data
#'
#'
#' @format A numeric value.
#'
#' \describe{
#' \item{lensColumns}{A numeric value of the number of columns in a lens.org 
#' patent data export. }
#'
#' }
#'
#' @seealso
#' \code{\link{skipGoogle}}, \code{\link{skipLens}}, \code{\link{skipSumobrain}},
#' \code{\link{googleColumns}}, \code{\link{sumobrainColumns}}, 
#' \code{\link{sumobrainNames}}, \code{\link{lensNames}}, \code{\link{googleNames}}
#' 
"lensColumns"

#' How many lines to skip in a lens.org patent data export.
#'
#' How many lines to skip in a lens.org patent data export.
#'
#'
#' Used with \code{\link{acarsLens}} data.
#'
#' @name skipLens
#' @docType data
#' @keywords data
#'
#'
#' @format A numeric value.
#'
#' \describe{
#' \item{skipLens}{A numeric value representing the number of rows to skip in a 
#' lens.org csv data export.}
#'
#' }
#'
#' @seealso
#' \code{\link{skipGoogle}}, \code{\link{skipSumobrain}},
#' \code{\link{googleColumns}},\code{\link{lensColumns}}, \code{\link{sumobrainColumns}}, 
#' \code{\link{sumobrainNames}}, \code{\link{lensNames}}, \code{\link{googleNames}}
"skipLens"




#' A named vector of key/value pairs for country codes and publication number 
#' document lengths used to determine the type of document.
#'
#'
#' A named vector of key/value pairs for country codes and publication number 
#' document lengths used to determine the type of document.
#'
#'
#' @name docLengthTypesDict
#' @docType data
#' @keywords data
#'
#'
#' @format A named character vector
#'
#' \describe{
#' \item{docLengthTypesDict}{A named character vector representing key/value pairs
#' of doc lengths, country codes, and type of patent document.}
#'
#' }
#'
#' Built with the following code: 
#' 
#' \code{docLengthTypesDict <- docLengthTypes$value}
#' 
#' \code{names(docLengthTypesDict) <- docLengthTypes$key}
#'
#' @seealso
#' \code{\link{generateDocType}}, \code{\link{docLengthTypes}}
#' 
"docLengthTypesDict"


#' A country and kind code dictionary.
#'
#'
#' A named vector of key/value pairs for country codes and kind codes used to 
#' determine the type of document. 
#'
#'
#' @name cakcDict
#' @docType data
#' @keywords data
#'
#'
#' @format A named character vector
#'
#' \describe{
#' \item{cakcDict}{A named character vector representing key/value pairs
#' of country codes, kind codes, and type of patent document.}
#'
#' }
#'
#' Built with the following code: 
#' 
#' \code{cakcDict <- kindCodes$docType}
#' 
#' \code{names(cakcDict) <- kindCodes$countryAndKindCode}
#'
#' @seealso
#' \code{\link{generateDocType}}, \code{\link{kindCodes}}
#' 
"cakcDict"





#' A simple stop word list for assignee names.
#'
#'
#' A character vector of common stop words to remove from assignee names for 
#' name standardization, such as "inc".
#'
#'
#' @name assigneeStopWords
#' @docType data
#' @keywords data
#'
#'
#' @format A character vector
#'
#' \describe{
#' \item{assigneeStopWords}{A character vector of stop words.}
#' }
#'
#' @seealso
#' \code{\link{cleanNames}}
#' 
"assigneeStopWords"
