# visualize patent data 


#' Factor one column by another column's popularity
#' 
#' @description Factor (or refactor) a data frame of values to be used 
#' for graphing in the correct order.
#' 
#' Many graphs require a reordering when plotting with a fill value. This 
#' helper function factors the x-value of a plot that will be stacked by 
#' \code{fillVal}.
#' 
#' @param df A data frame containing the x and fill value columns.
#' @param xVal A character value from a header name in \code{df} 
#' that will be used as 
#' the x value in a ggplot2 plot. 
#' @param fillVal A character value from a header name in \code{df} 
#' that will be used as the 
#' fill value in a ggplot2 plot.
#' 
#' 
#' @return A data frame with one factored column. 
#' 
#' @examples 
#' 
#' 
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
#' dim(sumo)
#' sumoFactor <- factorForGraph(sumo, "assigneeClean", "score")
#' # if you want to view, uncomment and load ggplot2
#' # ggplot(sumoFactor, aes(x=assigneeClean, y=score, fill=factor(score))) + 
#' # geom_bar(stat="identity")
#' 
#' 
#' @export
#' 
factorForGraph <- function(df, xVal, fillVal){
  
  # need to unlist the list, then factor it
  df[ , fillVal] <- factor(unlist(df[ , fillVal]))
  
  # factor the xVal in order from most to least
  # group by xVal, get the total
  # and then factor xVal with levels equal to the order of xVal
  temp <- summarizeColumns(df, xVal)
  df[,xVal] <- factor(unlist(df[,xVal]), levels = as.character(unlist(temp[ , xVal])))
  df
}





#' Plot a flipped histogram with a fill value 
#' 
#' @description Plot a flipped histogram with fill values.
#' 
#' Often times, you want to plot a histogram showing patent documents 
#' faceted by one value and filled by another. 
#' 
#' @param df The original data frame of patent data
#' @param xVal A character value of a name in \code{df}
#' @param fillVal A character value of a name in \code{df} to color the chart.
#' @param colors A character vector of colors, the same length as the number of 
#' unique values in the column of \code{xVal[,fillVal]}. Default set to 
#' \code{scoreColors}
#' 
#' @return A plot
#' 
#' @import ggplot2 
#' 
#' @examples 
#' 
#' 
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
#' sumo$assigneeSmall <- strtrim(sumo$assigneeClean,12)
#' flippedHistogram(sumo, "assigneeSmall","score",colors=scoreColors)
#' 
#' 
#' @export
#' 
#' 
flippedHistogram <- function(df, xVal, fillVal, colors= patentr::scoreColors){
  
  # order the graph appropriately  
  df <- factorForGraph(df, xVal, fillVal)

  ggplot(df, aes_string(x=xVal, 
                        fill=fillVal )) + 
    geom_bar() + coord_flip()+
    scale_fill_manual("Score", values= colors, drop = F)+
    theme(legend.position='bottom',
          axis.text = element_text(size=16),
          axis.title = element_text(size=16),
          legend.text = element_text(size=12),
          legend.title = element_text(size=12))+
    xlab('')+ylab("Document Count")
  
}
