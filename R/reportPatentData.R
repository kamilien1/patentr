# reporting-related functions to generate ppt slides 




#' Add summary text to be used in a pptx slide
#' 
#' @description Add a standard summarized text that will be used in 
#' association with a plot. 
#' 
#' @param df A summarized patent data frame, summarized by one variable. 
#' See \code{\link{summarizeColumns}}.
#' @param singular The name of the variable, singular version. A character string.
#' For example: assignee.
#' @param plural The name of the variable, plural version. A character string.
#' For example: assignees, with an 's'.
#' @param sumVar The vector of the variable to summarize, taken from the original
#' patent data set. For example \code{sumo$score} to summarize the score range. 
#' 
#' @return A length four character vector.
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
#' # Summarize the assignees
#' as <- summarizeColumns(sumo, 'assigneeSmall')
#' summaryText(as, 'assignee','assignees',sumo$score)
#' # summarize the number of features
#' f <- summarizeColumns(sumo, 'feature1', naOmit = TRUE)
#' summaryText(f, 'feature','features',sumo$feature1)
#' 
#' @export
#' 
summaryText <- function(df, singular, plural, sumVar){
  
  m1range <- paste("For entry range ",capWord(min(sumVar, na.rm = TRUE)), " to ",
                       capWord(max(sumVar, na.rm = TRUE)),"...", sep='')
  
  m2size <- paste("There are ", dim(df)[1]," ", plural,".", sep='')
  
  m3top <- paste("Top ",singular," is ", capWord(as.character(utils::tail(unlist(df[,1]),1))),", with ",
                      as.character(utils::tail(unlist(df[,2]),1))," documents.",sep='')
  
  m4total <- paste("Total IP count is ", sum(as.numeric(unlist(df[,2])))," documents.",sep='')
  
  c(m1range, m2size, m3top, m4total)
}




#' Add a PPTX slide with chart on the right and text on the left
#' 
#' @description Generate a commonly-used PPTX slide format where the patent 
#' chart is on the right and some text is on the left. 
#' 
#' This function automates a number of steps used in formatting a pptx slide. 
#' It returns the ppt object with the new slide included. 
#' 
#' @param ppt A ppt object.
#' @param plot A plot object from ggplot2. 
#' @param text A character vector of text, typically less than one paragraph 
#' in size.
#' @param title A character title for a page. Default is NULL
#' @param slide_layout The name of a slide layout, the same name as the names in a .potx 
#' powerpoint template file. Default is a Title and Content blank layout.
#' @param Poffx Plot image x position from left top, inches. 
#' See \code{\link[ReporteRs]{addPlot}}. Default is 5.3. 
#' @param Poffy Plot image y position from left top, inches.
#' See \code{\link[ReporteRs]{addPlot}}. Default is 0.
#' @param Pwidth Plot image width, inches. 
#' See \code{\link[ReporteRs]{addPlot}}. Default is 8.
#' @param Pheight Plot image height, inches. 
#' See \code{\link[ReporteRs]{addPlot}}. Default is 7.5
#' @param Toffx Text image x position from left top, inches. 
#' See \code{\link[ReporteRs]{addPlot}}. Default is 1.
#' @param Toffy Text image y position from left top, inches. 
#' See \code{\link[ReporteRs]{addPlot}}. Default is 2.
#' @param Twidth Text image width, inches. 
#' See \code{\link[ReporteRs]{addPlot}}. Default is 5.
#' @param Theight Text image height, inches. 
#' See \code{\link[ReporteRs]{addPlot}}. Default is 5.5.
#' 
#' 
#' @examples 
#' 
#' sumo <- cleanPatentData(patentData = patentr::acars, columnsExpected = sumobrainColumns,
#'                         cleanNames = sumobrainNames,
#'                         dateFields = sumobrainDateFields,
#'                         dateOrders = sumobrainDateOrder,
#'                         deduplicate = TRUE,
#'                         cakcDict = patentr::cakcDict,
#'                         docLengthTypesDict = patentr::docLengthTypesDict,
#'                         keepType = "grant",
#'                         firstAssigneeOnly = TRUE,
#'                         assigneeSep = ";",
#'                         stopWords = patentr::assigneeStopWords)
#' 
#' # note that in reality, you need a patent analyst to carefully score
#' # these patents, the score here is for demonstrational purposes
#' score <- round(rnorm(dim(sumo)[1],mean=1.4,sd=0.9))
#' score[score>3] <- 3
#' score[score<0] <- 0
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
#' flippedHistogram(sumo, "assigneeSmall","score",colors=scoreColors)
#' flippedHistogram(subset(sumo, score > 0), "assigneeSmall","score",colors=scoreColors)
#' 
#' flippedHistogram(subset(sumo, score > 2) ,"assigneeSmall","docType",colors=scoreColors,
#'                  recolor = TRUE)
#' 
#' 
#' 
#' 
#' # create a ppt
#' ppt <- ReporteRs::pptx(title="IP Update")
#' # view the types of layouts available by default
#' # slide.layouts(ppt)
#' layoutTitleContent = "Title and Content"
#' 
#' # first plot of top score (3) 
#' asdt <- summarizeColumns(subset(sumo,score > 2),'docType')
#' ppt <- 
#'   addChartRightTextLeftPptx(ppt = ppt,
#'                             plot = flippedHistogram(subset(sumo, score > 2) ,
#'                                                     "assigneeSmall","docType",
#'                                                     colors=scoreColors, 
#'                                                     recolor = TRUE), 
#'                             text = summaryText(asdt, "doc type", "doc types", 
#'                                                subset(sumo,score>2)$docType), 
#'                             title = "Doc Types for Top Score Docs", 
#'                             slide_layout = layoutTitleContent)
#' 
#' # top scores by assignee
#' ascore <- summarizeColumns(subset(sumo,score > 2),'assigneeSmall')
#' ppt <- 
#'   addChartRightTextLeftPptx(ppt = ppt,
#'                             plot = flippedHistogram(subset(sumo, score > 2) ,
#'                                                     "assigneeSmall","score",
#'                                                     colors=scoreColors, 
#'                                                     recolor = FALSE), 
#'                             text = summaryText(ascore, "assignee", "assignees", 
#'                                                subset(sumo,score>2)$assigneeSmall), 
#'                             title = "Assignees with Top Scores", 
#'                             slide_layout = layoutTitleContent)
#' 
#' 
#' # last plot is category
#' sc <- summarizeColumns(sumo,'category')
#' ppt <- 
#'   addChartRightTextLeftPptx(ppt = ppt,
#'                             plot = flippedHistogram(sumo ,"category",
#'                                                     "score", colors = scoreColors,
#'                                                     recolor = TRUE),
#'                             text = summaryText(sc, "category", "categories", sumo$category),
#'                             title = "Categories and Scores",
#'                             slide_layout = layoutTitleContent)
#' 
#' find a data folder and write it out to your folder
#' # out <- paste("data/",Sys.Date(),"_exampleChartRightTextLeft.pptx",sep='')
#' # ReporteRs::writeDoc(ppt, out)
#' 


#' 
#' 
#' @export
#' 
#' @import ReporteRs
#' 
addChartRightTextLeftPptx <- function(ppt, plot, text, title, slide_layout = "Title and Content",
                                      Poffx = 5.3,Poffy = 0,Pwidth = 8, Pheight = 7.5,
                                      Toffx = 1, Toffy = 2, Twidth = 5, Theight = 5.5){
  # add a new slide
  ppt <- ReporteRs::addSlide(ppt, slide.layout = slide_layout)
  # add the plot, it takes up slightly more than half (13.3in by 7.5in per slide)
  ppt <- ReporteRs::addPlot(ppt, print, x = plot, 
                            offx = Poffx, offy = Poffy, 
                            width = Pwidth, height = Pheight)
  # add in bullet point text
  ppt <- ReporteRs::addParagraph(ppt, text, 
                                 par.properties = ReporteRs::parProperties(list.style='unordered', level=1),
                                 offx = Toffx, offy = Toffy, 
                                 width = Twidth, height=Theight)
  # add in title overlaid last
  ppt <- ReporteRs::addTitle(ppt, title)
  ppt
}
