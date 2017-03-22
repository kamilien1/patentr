## kamil bojanczyk start
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
#' @param decFill Sort fill value in decreasing order. 
#' 
#' 
#' @return A data frame with two of the columns factored.
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
factorForGraph <- function(df, xVal, fillVal, decFill = TRUE){
  
 
  
  # need to unlist the list, then factor it
  df[ , fillVal] <- factor(unlist(df[ , fillVal]))
  df[ , fillVal] <- factor(df[, fillVal], 
                           levels = sort(levels(df[,fillVal]), decreasing = decFill))
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
#' \code{scoreColors}.
#' @param recolor A logical allowing you to choose to recolor the plot if the 
#' colors vector is not applicable to you. Default set to \code{FALSE}. Uses 
#' the helper function \code{\link{makeColors}} to generate colors. Note that your 
#' plot may fail if \code{colors} is not the same length as the number of unique 
#' values in fillVal and \code{recolor} is set to \code{FALSE}.
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
#' flippedHistogram(subset(sumo, score > 0), "assigneeSmall","score",colors=scoreColors)
#' flippedHistogram(subset(sumo, score > 2) ,"score","assigneeSmall",colors=scoreColors,
#' recolor = TRUE)
#' flippedHistogram(subset(sumo, score > 2) ,"assigneeSmall","docType",colors=scoreColors,
#' recolor = TRUE)
#' 
#' @export
#' 
#' 
#' @seealso \code{\link{makeColors}}, \code{\link{capWord}}
#' 
flippedHistogram <- function(df, xVal, fillVal, colors = patentr::scoreColors,
                             recolor = FALSE){
  
  # order the graph appropriately  
  df <- factorForGraph(df, xVal, fillVal)

  # sanity check for colors
  # score has a 
  if (length(colors) != length(unique(df[,fillVal])) && recolor){
    colors <- makeColors(length(unique(df[,fillVal])))
  }
  
  plot <- ggplot(df, aes_string(x = xVal, fill = fillVal )) + 
    geom_bar() + 
    coord_flip() +
    theme(legend.position='bottom',
          axis.text = element_text(size=16),
          axis.title = element_text(size=16),
          legend.text = element_text(size=12),
          legend.title = element_text(size=12))+
    xlab('') +
    ylab("Document Count") +  
    scale_fill_manual(capWord(fillVal), values = colors, drop = F)
  
  return(plot)
  
}


#' Make color hues
#' 
#' @description Generate an evenly-spaced number of color hues.
#'  
#' Credit for this function goes to \href{http://stackoverflow.com/questions/8197559/emulate-ggplot2-default-color-palette}{John Colby's}
#' Stack Overflow post.
#' 
#' @param numColors Number of colors, a numeric input.
#'  
#' @return A character vector of colors. 
#' 
#' @examples 
#' makeColors(5)
#' 
#' @export
#' 
#' @seealso \code{\link{flippedHistogram}}
#' 
makeColors <- function(numColors){
  hues = seq(15, 375, length = numColors + 1)
  grDevices::hcl(h = hues, l = 65, c = 100)[1:numColors]
}

#' Make a tiled plot
#' 
#' @description Tile plot an x and y variable by facet z. 
#' 
#' Tile plots are a a great way to show a dense amount of information in one 
#' plot sequence. Plotting document count by category, and plotting by assignee, 
#' is one example. 
#' 
#' @param df A data frame of the cleaned data you want to plot. 
#' @param xVal A character string of the x value you want for your plot, must be a 
#' name of the header in \code{df}.
#' @param fillVal A character string of the fill value you want for your plot, must be a 
#' name of the header in \code{df}.
#' @param facetVal A character string of the facet you want for your plot, must be a 
#' name of the header in \code{df}.
#' @param colors A character vector of colors, the same length as the number of 
#' unique values in the column of \code{xVal[,fillVal]}. Default set to 
#' \code{scoreColors}.
#' @param recolor A logical allowing you to choose to recolor the plot if the 
#' colors vector is not applicable to you. Default set to \code{FALSE}. Uses 
#' the helper function \code{\link{makeColors}} to generate colors. Note that your 
#' plot may fail if \code{colors} is not the same length as the number of unique 
#' values in fillVal and \code{recolor} is set to \code{FALSE}.
#' 
#' @return A ggplot2 plot object.
#' 
#' @examples 
#' 
#' \dontrun{
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
#' score[score>3] <- 3; score[score<0] <- 0
#' sumo$score <- score
#' sumo$assigneeSmall <- strtrim(sumo$assigneeClean,12)
#' category <- c("system","control algorithm","product","control system", "communication")
#' c <- round(rnorm(dim(sumo)[1],mean=2.5,sd=1.5))
#' c[c>5] <- 5; c[c<1] <- 1
#' sumo$category <- category[c]
#' 
#' xVal = "category"
#' fillVal = "score"
#' facetVal = "assigneeSmall"
#' 
#' facetPlot(subset(sumo, score > 0), xVal, fillVal, facetVal, colors = patentr::scoreColors,
#'           recolor = FALSE)
#' }
#' 
#' @export
#' 
#' @import ggplot2
#' 
facetPlot <- function(df, xVal, fillVal, facetVal, colors = patentr::scoreColors,
                      recolor = FALSE){
  
  df <- factorForGraph(df, xVal, fillVal)
  
  # sanity check for colors
  if (length(colors) != length(unique(df[,fillVal])) && recolor){
    colors <- makeColors(length(unique(df[,fillVal])))
  }
  
  plot <- ggplot(df, aes_string(x = xVal, fill = fillVal)) +
    geom_bar(stat = 'count') +
    facet_wrap(stats::as.formula(paste("~ ",facetVal)), scales='free') +
    scale_fill_manual(capWord(fillVal), values=colors, drop=F)+
    xlab(capWord(xVal)) +
    ylab("Document Count") +
    theme(axis.text.x=element_text(angle = 20, hjust = 0.5, vjust = 0.5)) 
  
  return(plot)
  
}







#' Capitalize the first letter of a character
#' 
#' @description A quick shortcut function to capitalize the first letter 
#' of a character. Useful for making data frame column names quickly look like 
#' plain english.
#' 
#' @param s Character string to input. Default set to \code{"word"}.
#' 
#' @return A character string with the first letter capitalized. 
#' 
#' @examples 
#' 
#' capWord("hello")
#' capWord("")
#' capWord("Hi")
#' 
#' @export
#' 
#' @seealso \code{\link{flippedHistogram}}
#'  
#'
#'  
capWord <- function(s){
  gsub("^([[:alpha:]])", "\\U\\1", s, perl=TRUE)   
}




#' Make a facet tile plot to view two features.
#' 
#' @description Scan for patent market gaps. 
#' Visualize the features of a set of patents by a category. Can view up to 
#' four dimensions of data with this plot (x, y, and optionals fill and facet).
#' 
#' Quickly scan this chart to look for gaps in the feature sets. 
#' 
#' @param df The patent data frame you want to graph.
#' @param xVal The x value you will be plotting, a character value that is a 
#' name of \code{df}.
#' @param tileVal The tile value you will be plotting, a character value that is a 
#' name of \code{df}.
#' @param fillVal An optional value for filling the color of the tiles on a third 
#' variable. Default set to \code{NA} and evaluates to \code{xVal}.
#' @param xangle A numeric 0 to 360 value for the angle of the x axis text 
#' @param xhjust Double value between 0 and 1. 0 Means left justified, 1 means right justified,
#' default set to 0.5 (middle), for the x axis text.
#' @param showLegend A logical to allow you to show or hide the legend, which is 
#' mapped to the fillVal 
#' @param facetVal Optional faceting. 
#' A character string of the facet you want for your plot, must be a 
#' name of the header in \code{df}. Default set to \code{NA}. 
#' @param fscale Facet scale, a character value chosen from \code{c("free","fixed")}.
#' Default set to \code{fixed}. It changes the y axis to adjust to each facet 
#' and drop unused y (tile) values or keeps them all constant. 
#' 
#' 
#' @return A ggplot2 facet plot object. 
#' 
#' @examples 
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
#' score[score>3] <- 3; score[score<0] <- 0
#' sumo$score <- score
#' sumo$assigneeSmall <- strtrim(sumo$assigneeClean,12)
#' category <- c("system","control algorithm","product","control system", "communication")
#' c <- round(rnorm(dim(sumo)[1],mean=2.5,sd=1.5))
#' c[c>5] <- 5; c[c<1] <- 1
#' sumo$category <- category[c]
#' feature1 <- c("adaptive", "park", "lane", NA,NA,NA,NA,NA, 
#' "brake", "steer","accelerate","deactivate")
#' f <- round(rnorm(dim(sumo)[1],mean=5,sd=1))
#' l <- length(feature1)
#' f[f>l] <- l; f[f<1] <- 1
#' sumo$feature1 <- c(feature1,feature1[f])[1:dim(sumo)[1]]
#' 
#' tilePlot(sumo, "category", "feature1")
#' 
#' tilePlot(sumo, xVal = "assigneeSmall", tileVal = "feature1", fillVal = "category",
#' xangle=90, xhjust=0, showLegend = TRUE)
#' 
#' tilePlot(sumo, xVal = "assigneeSmall", tileVal = "feature1", fillVal = "category",
#' xangle=90, xhjust=0, showLegend = TRUE, facetVal = "docType", fscale = "fixed")
#' 
#' tilePlot(sumo, xVal = "assigneeSmall", tileVal = "feature1", fillVal = "category",
#' xangle=90, xhjust=0, showLegend = TRUE, facetVal = "docType", fscale = "free")
#' 
#' tilePlot(sumo, xVal = "assigneeSmall", tileVal = "feature1", fillVal = "category",
#' xangle=90, xhjust=0, showLegend = TRUE, facetVal = "score", fscale = "free")

#' 
#' @import ggplot2
#' @importFrom dplyr select_
#' 
#' @export
#' 
tilePlot <- function(df, xVal, tileVal, fillVal = NA, xangle = 0, xhjust = 0.5,
                     showLegend = FALSE, facetVal = NA, fscale = c("free","fixed")){
  
  # fillVal becomes tileVal in the event of it being blank
  fillVal <- ifelse(is.na(fillVal), yes = xVal, fillVal)
  
  temp <- df[stats::complete.cases(select_(df, .dots=c(xVal, tileVal, fillVal))),]
  
  
  # may need to hardcode value
  plotTile <- ggplot(temp,aes_string(x = xVal,y = tileVal, height=1)) +
    # fill was xVal
    geom_tile(aes_string(fill = fillVal)) +
    ggtitle('') + 
    guides(fill = ifelse(showLegend, guide_legend(), FALSE)) + 
    xlab(capWord(xVal)) +
    ylab(capWord(tileVal)) +
    theme(axis.text.x = element_text(angle = xangle,hjust = xhjust))
  
  # note this includes the unwanted NA values, you may want to pre-filter
  if(!is.na(facetVal) && facetVal %in% names(df)){
    plotTile <- plotTile + 
      facet_wrap(stats::as.formula(paste("~ ",facetVal)), scales=fscale[1]) 
  }
  
  return(plotTile)
  
  
}



#' Generate a word cloud with a given subset of patent data fields. 
#' 
#' @description Create a word cloud from a patent data set. 
#' 
#' @param file The data frame you want word cloud, typically the abstract, title, 
#' and claims subset.
#' @param rmwords A character vector of words you exclude from your analysis. Default 
#' is \code{\link{excludeWords}}. 
#' @param minfreq From \code{\link[wordcloud]{wordcloud}}, the min frequency 
#' to include a word. Default is 10.
#' @param maxwords From \code{\link[wordcloud]{wordcloud}}, the max number of 
#' words to show. Default is 150. 
#' @param ... \code{\link[wordcloud]{wordcloud}} options
#' 
#' @examples 
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
#' # df <- dplyr::select(sumo, title, abstract)
#' df <- sumo[,c("title","abstract")]
#' wordCloudIt(df, excludeWords, minfreq = 20, 
#' random.order = FALSE, rot.per = 0.25)
#' 
#' @return NULL, prints out a wordcloud
#' 
#' 
#' @importFrom tm Corpus
#' @importFrom tm VectorSource
#' @importFrom tm tm_map
#' @importFrom tm content_transformer
#' @importFrom tm removePunctuation
#' @importFrom tm removeWords
#' @importFrom tm stopwords
#' @importFrom RColorBrewer brewer.pal
#' @importFrom wordcloud wordcloud
#' 
#' 
#' 
#' @export
#' 
# may need to use mc.cores
wordCloudIt <- function(file, rmwords,minfreq = 20,maxwords=150, ...) {
  
  # take in the entire file
  # so you better subset the columns to claim1 and whatever else
  c <- tm::Corpus(tm::VectorSource(file))
  # convert to ASCII to 'make it work'
  c <- tm::tm_map(c,function(x) iconv(x, to='ASCII', sub='byte'))
  # lower case results
  c <- tm::tm_map(c,tolower)
  # no punctuations !?.,
  c <- tm::tm_map(c, tm::removePunctuation)
  # no stop words! If the but as...
  c <- tm::tm_map(c,function(x) tm::removeWords(x,tm::stopwords()))
  # No claim words! See list above function
  c <- tm::tm_map(c,function(x) tm::removeWords(x, rmwords))
  # Make it pretty with 4 colors in the Dark2 palette
  pal2 <- RColorBrewer::brewer.pal(4,"Dark2")
  # take in additional functions if we want
  wordcloud::wordcloud(c,min.freq = minfreq, max.words = maxwords, colors = pal2,...)
  
}



## kamil bojanczyk end