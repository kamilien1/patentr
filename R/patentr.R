#' patentr: A package for analyzing patent data. 
#' 
#' The package is a data processing and reporting tool of patent data sets for patent analysts.
#' 
#' 
#' The package is aimed at patent agents, lawyers, managers, analysts, and 
#' academics who are working on patents. This may be used in a patent landscape 
#' analysis, company IP portfolio analysis, or a freedom to operate search. 
#' 
#' 
#' The patentr package provides four categories of important functions:
#' 
#' \enumerate{
#' \item Data input and cleaning
#' \item Data (re)processing
#' \item Data exploration & visualization
#' \item Visualization & reporting
#' }
#' 
#' 
#' @section patentr main functions:
#' 
#' \code{\link{importPatentData}}: Import xls patent data from filepaths.
#' \code{\link{chooseFiles}}: Uses a popup window (Tk file dialog) to allow the user to choose a list of zero or more files interactively.
#' 
#' @section patentr data:
#' \code{\link{acars}} To pay respect to the \code{\link[datasets]{mtcars}} data, 
#' this is a data set of autonomous driving car patents from major companies. 
#' \code{\link{kindCodes}} A data frame of kind codes by country with associated 
#' descriptions. 
#' \code{\link{docLengthTypes}} A data frame mapping doc length to the type of 
#' patent document.  
#' 
#' @docType package
#' @name patentr
NULL