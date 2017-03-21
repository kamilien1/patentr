#' Autonomous Vehicle Patent Data from Sumobrain.com
#'
#' An example data set of autonomous vehicle IP from major assignees. 
#' 
#' The data search was performd on Monday, March 13, 2017 from sumobrain.com, and the exact
#' search term was: 
#' 
#' \code{ABST/"autonomous" AN/(Apple* OR Google* OR Waymo* OR Tesla*} 
#' 
#' \code{OR Ford* OR General*) PD/12/13/1790->3/13/2017}
#' 
#' View the search \href{http://www.sumobrain.com/result.html?p=1&stemming=on&sort=chron&uspat=on&usapp=on&eupat=on&jp=on&pct=on&collections=&srch=xprtsrch&date_range=all&hits=502&from_ss=&srch_id=&srch_name=&search_name=&selected_doc_flag=&selected_newdoc_flag=&selected_portfolio=&portfolio_name=&query_txt=ABST\%2F\%22autonomous\%22+AN\%2F\%28Apple*+OR+Google*+OR+Waymo*+OR+Tesla*+OR+Ford*+OR+General*\%29+PD\%2F12\%2F13\%2F1790-\%3E3\%2F13\%2F2017&search.x=0&search.y=0&search=search_ezy}{here}.
#' 
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
#' \item{docNum}{A published document number including the kind code, publication number,
#' and kind code for the patent document.}
#' \item{docTypeSumobrain}{Very similar to the country code, with minor additions, USAPP being the 
#' most noticable difference. }
#' \item{pubDate}{Publication Date}
#' \item{title}{Title}
#' \item{abstract}{Abstract}
#' \item{inventors}{Inventor Name}
#' \item{assignee}{Assignee}
#' \item{appNum}{Application Number}
#' \item{dateFiled}{Filing Date}
#' \item{classPrimary}{Primary Class}
#' \item{classOthers}{Other Classes}
#' }
#' 
#' @seealso \url{http://www.sumobrain.com} You will need to create a free account to export data.
#' 
#' \code{\link{acarsGoogle}} provides a similar search from Google. 
#' \code{\link{acarsLens}} provides a simialr search from Lens.org. 
#' 
"acars"


#' Autonomous Vehicle Patent Data from Google Patents
#'
#' An example data set of autonomous vehicle IP from major assignees. 
#' 
#' The first row in the raw CSV export contains the search URL and is skipped.
#' 
#' The data search was performd on Saturday, March 18, 2017 from patents.google.com, and the exact
#' search: \href{https://patents.google.com/?q=AB\%3dautonomous&assignee=Apple*,Google*,Waymo*,Tesla*,Ford*,General*&before=filing:20170318}{Google Patents Search}
#' For all countries available on Google.
#' 
#' You process the raw data with the following commands:
#' 
#' \code{temp <- system.file("extdata", "google_autonomous_search.csv", package = "patentr")}
#' 
#' \code{# from the source package you can navigate to }
#' 
#' \code{temp <- read.csv("inst/extdata/google_autonomous_search.csv", skip = 1, stringsAsFactors = FALSE)}
#' 
#' \code{names(temp) <- googleNames}
#' 
#' \code{temp <- data.frame(lapply(temp, function(x){iconv(x,to="ASCII")}),stringsAsFactors = FALSE)} 
#' 
#' \code{dateFields <- c("priorityDate","dateFiled","pubDate","grantDate")}
#' 
#' \code{temp[dateFields] <- as.data.frame(lapply(temp[dateFields], as.Date, format="\%m/\%d/\%y"))}
#' 
#' 
#' @name acarsGoogle
#' @docType data
#' @keywords data
#' 
#' 
#' @format 
#' A data frame with 316 observations on 9 variables.
#' \describe{
#' \item{\code{docNum}}{A published document number including the kind code, publication number,
#' and kind code for the patent document.}
#' \item{\code{title}}{The title of the invention.}
#' \item{\code{assignee}}{The owner of the document.}
#' \item{\code{inventors}}{The name(s) of the inventor(s), separated by commas.}
#' \item{\code{priorityDate}}{The earliest priority date on the application.}
#' \item{\code{dateFiled}}{Date the document was filed. They calll it filing/creation date.}
#' \item{\code{pubDate}}{Date document became publicly available.}
#' \item{\code{grantDate}}{Date the application became a grant. NA if there is no associated grant.}
#' \item{\code{googleURL}}{The link to the Google Patents page for the document.}
#' }
#' 
#' @seealso \url{https://patents.google.com/} 
#' 
#' \code{\link{acars}} provides a similar search from Sumobrain. 
#' \code{\link{acarsLens}} provides a simialr search from Lens.org. 
#' 
"acarsGoogle"

#' Autonomous Vehicle Patent Data from Lens Patent Search
#'
#' An example data set of autonomous vehicle IP from major assignees. 
#' 
#' The data search was performd on Saturday, March 18, 2017 from lens.org, and the exact
#' search: 
#' 
#' \href{https://www.lens.org/lens/search?q=abstract\%3Aautonomous+\%26\%26+applicant\%3A\%28Apple*+OR+Google*+OR+Waymo*+OR+Tesla*+OR+Ford*+OR+General*\%29&predicate=\%26\%26&l=en}{Lens Patents Search}
#' 
#' For all countries available on Lens.
#' 
#' Can get raw data with the following commands:
#' 
#' \code{temp <- system.file("extdata", "lens_autonomous_search.csv", package = "patentr")}
#' 
#' \code{temp <- read.csv(temp, stringsAsFactors = FALSE)}
#'
#' \code{temp <- data.frame(lapply(temp, function(x){iconv(x,to="ASCII")}),stringsAsFactors = FALSE)}
#'  
#' \code{names(temp) <- lensNames}
#' 
#' \code{temp$dateFiled <- as.Date(temp$dateFiled, format = '\%m/\%d/\%y')}
#' 
#' \code{temp$pubDate <- as.Date(temp$pubDate, format='\%m/\%d/\%y')} # note that % y is system-specific and may not work everywhere.
#' 
#' \code{colsNum <- c("resultNum","citeCount","familySimpleCount","familyExtendedCount", "seqCount")}
#' 
#' \code{temp[colsNum] <- sapply(temp[colsNum], as.numeric)}
#' 
#' \code{temp$hasFullText <- sapply(temp$hasFullText, function(x) ifelse(x=="yes",TRUE,FALSE))}
#' 
#' @name acarsLens
#' @docType data
#' @keywords data
#' 
#' 
#' @format 
#' A data frame with 863 observations on 26 variables.
#' \describe{
#' \item{resultNum}{The search result number.}
#' \item{countryCode}{The jurisdiction of the patent document.}
#' \item{\code{kindCode}}{The kind code.}
#' \item{docNum}{The published document number with country code and kind code included.}
#' \item{lensID}{The unique identification number of the document on lens.org}
#' \item{pubDate}{Date the document was published.}
#' \item{pubYear}{Year the document published.}
#' \item{appNum}{The filing number of the application (country code, number, and abridged kind code, typically 'A')}
#' \item{dateFiled}{Date the application for the patent document was filed.}
#' \item{priorityApps}{Applications this patent document claims priority. 
#' Format: Country code, application number, A = application or P = provisional, YYYYMMDD of priority. 
#' Multiple application separated by a double semi-colon.}
#' \item{title}{The title of the document.}
#' \item{assignee}{The name of the applicant(s) at the time of filing.}
#' \item{inventors}{The inventor(s).}
#' \item{\lensURL}{The lens.org URL for the document.}
#' \item{docTypeLens}{A lens.org mapping of the doc type. 
#' Granted, application, ambiguous, unknown, search report, and possibly more values.}
#' \item{hasFullText}{A logical value to show if there is a full text available from lens.org}
#' \item{citeCount}{The number of times this document is cited, also known as forward citations.}
#' \item{familySimpleCount}{The number of unique documents in the immediate patent family.}
#' \item{familyExtendedCount}{The number of unique documents sharing a priority applicaiton in the extended family.}
#' \item{seqCount}{Used in biological applications -- the number of sequences in the application.}
#' \item{cpcClasses}{The CPC classification codes, separated by a double semi-colon.}
#' \item{ipcrClasses}{The IPCR classification codes, separated by a double semi-colon.}
#' \item{usClasses}{The US classification codes, separated by a double semi-colon.}
#' \item{pubmedID}{A pubmed ID to any related research.}
#' \item{DOI}{A digital object identifier. 
#' Go to doi.org and paste the value to get the associated research paper.}
#' \item{npl}{Non-patent literature, or citations of non-patent sources.
#' Separated with double semi-colons.}
#' 
#' 
#' }
#' 
#' @seealso \url{www.lens.org} You can export without an account, or can create 
#' an account to save your searches. 
#' 
#' \code{\link{acarsGoogle}} provides a similar search from Google. 
#' \code{\link{acars}} provides a similar search from sumobrain. 
#' 
"acarsLens"