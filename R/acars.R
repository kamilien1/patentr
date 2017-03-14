#' Autonomous Vehicle Patent Data
#'
#' An example data set of autonomous vehicle IP from major assignees. 
#' 
#' The data search was performd on Monday, March 13, 2017 from sumobrain.com, and the exact
#' search term was: 
#' 
#' \code{ABST/"autonomous" AN/(Apple* OR Google* OR Waymo* OR Tesla* OR Ford* OR General*)}
#' 
#' For all collections (US patents, applications, EP documents, abstracts of Japan, and WIPO).
#' 
#' Can get raw data with the following commands:
#' 
#' \code{system.file("extdata", "sumobrain_autonomous_search1.xls", package = "patentr")}
#' 
#' \code{system.file("extdata", "sumobrain_autonomous_search2.xls", package = "patentr")}
#' 
#' 
#' @name acars
#' @docType data
#' @keywords data
#' 
#' 
#' @format 
#' A data frame with 499 observations on 10 variables.
#' \describe{
#' \item{docNum}{Document Number}
#' \item{docType}{Document Type}
#' \item{pubDate}{Publication Date}
#' \item{title}{Title}
#' \item{abstract}{Abstract}
#' \item{inventors}{Inventor Name}
#' \item{assignee}{Assignee}
#' \item{appNum}{Application Number}
#' \item{dateFiled}{Filing Date}
#' \item{classPrimary}{Primary Class}
#' }
#' 
#' @seealso \url{http://www.sumobrain.com} You will need to create a free account to export data.
#' 
"acars"