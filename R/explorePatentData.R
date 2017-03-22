# explore patent data, goes hand-in-hand with visualization
## yang yao start

#' Summarize columns of a data frame 
#' 
#' @description Summarize columns of a data frame.
#' 
#' Summarize a data frame \code{df} by a \code{names} character vector of 
#' header names.
#' 
#' @param df A data frame of patent data.
#' @param names a character vector of header names that you want to summarize. 
#' @param naOmit Logical. Optionally, remove NA values at the end of the summary.
#' Useful when comparing fields that have NA values, such as features. 
#' 
#' @return A dataframe of summarize values.
#' 
#' @examples 
#' sumo <- cleanPatentData(patentData = patentr::acars, columnsExpected = sumobrainColumns,
#' cleanNames = sumobrainNames,
#' dateFields = sumobrainDateFields,
#' dateOrders = sumobrainDateOrder,
#' deduplicate = TRUE,
#' cakcDict = patentr::cakcDict,
#' docLengthTypesDict = patentr::docLengthTypesDict,
#' keepType = "grant",
#' firstAssigneeOnly = TRUE, 
#' assigneeSep = ";",
#' stopWords = patentr::assigneeStopWords)
#' 
#' # note that in reality, you need a patent analyst to carefully score
#' # these patents, the score here is for demonstrational purposes
#' score <- round(rnorm(dim(sumo)[1],mean=1.4,sd=0.9))
#' score[score>3] <- 3
#' score[score<0] <- 0
#' sumo$score <- score
#' scoreSum <- summarizeColumns(sumo, "score")
#' scoreSum
#' # load library(ggplot2) for the below part to run
#' # ggplot(scoreSum, aes(x=score, y = total, fill=factor(score) )) + geom_bar(stat="identity")
#' nameAndScore <- summarizeColumns(sumo, c("assigneeClean","score"))
#' # tail(nameAndScore)
#' 
#' @export
#' 
#' @importFrom dplyr group_by_
#' @importFrom dplyr summarize
#' @importFrom dplyr arrange
#' @importFrom dplyr n
#' @importFrom magrittr %>%
#' 
summarizeColumns <- function(df, names, naOmit = FALSE){
  
  # dplyr functions
  # as.symbol or as.name both work, unsure why
  names <- lapply(names, as.name)
  
  # for an error fix 
  # http://stackoverflow.com/questions/9439256/how-can-i-
  # handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
  total <- NULL
  # group by names, sum them, and arrange them top to bottom
  df <- df %>% 
    dplyr::group_by_(.dots = names) %>% 
    dplyr::summarize(total=n())  %>% 
    dplyr::arrange(total)
  
  if(naOmit){
    df <- df %>% 
      stats::na.omit()
  }
  return(df)
}



## yang yao end