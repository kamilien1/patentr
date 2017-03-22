## yang yao 
## motivation: R Shiny gallery and look at urls in ui.R
library(shiny)


## kamil bojanczyk start
function(input, output) {
  #read in file as rawdata
  rawData <- reactive({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    if("csv" %in%  unlist(strsplit(inFile$type,"[/]"))){
      # print("reading file")
      read.csv(inFile$datapath, header=input$header, sep=input$sep, 
               quote=input$quote)  
    } else{
      ext <- tools::file_ext(inFile$name)
      # print(paste("extention is",ext))
      file.rename(inFile$datapath,
                  paste(inFile$datapath, ext, sep="."))
      readxl::read_excel(paste(inFile$datapath, ext, sep="."), 1)
    }
  })
  ## kamil bojanczyk end 
  #show raw data in a table
  output$contents <- renderTable({rawData()})
  
 # clean the raw data
  cleanData <- eventReactive(input$cleanDataButton, {
    df <- rawData()
    if(is.null(df)) return(NULL)
    cleanPatentData(df, columnsExpected = sumobrainColumns,
                            cleanNames = sumobrainNames,
                            dateFields = sumobrainDateFields,
                            dateOrders = sumobrainDateOrder,
                            deduplicate = TRUE,
                            cakcDict = patentr::cakcDict,
                            docLengthTypesDict = patentr::docLengthTypesDict,
                            keepType = "grant",
                            firstAssigneeOnly = TRUE,
                            assigneeSep = ";",
                            stopWords = patentr::assigneeStopWords)
  })
  
  #show the clean data in the tab 
  output$cleanContents <- renderTable({
     cleanData()
  })
  
  #show the first plot
  output$outplot1 <- renderPlot({
    df2<-cleanData()
    df2$assigneeSmall <- strtrim(df2$assigneeClean,12)
    score <- round(rnorm(dim(df2)[1],mean=1.4,sd=0.9))
    score[score>3] <- 3
    score[score<0] <- 0
    df2$score <- score
    scoreSum <- summarizeColumns(df2, "score")
    ggplot(scoreSum, aes(x=score, y = total, fill=factor(score) )) + geom_bar(stat="identity")
    # score[score>3] <- 3
    # score[score<0] <- 0
    # df2$score <- score
    # df2 <- df2[score >2,]
    # flippedHistogram(df2, "assigneeSmall","score",colors=scoreColors)
    
   })
  
  #download the clean data
  output$downloadData <- downloadHandler(
    filename = ('clean.csv'),
    content = function(file) {
      write.csv(cleanData(), file)
    }
  )
}



## yang yao 
## motivation: R Shiny gallery and look at urls in ui.R