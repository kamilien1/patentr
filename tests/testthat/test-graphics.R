# test graphics
## kamil bojanczyk start
# svg("tests/testthat/testData/sb0.svg")
# flippedHistogram(subset(sumo, score > 0), "assigneeSmall","score",colors=scoreColors)
# dev.off()
# graphics are the same
test_that("Sumobrain flipped histogram outputs a plot.",{

  file1 <- rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xlsx")
  file2 <- rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search2.xlsx")
  files <- list(file1, file2)
  df <- importPatentData(rawDataFilePath = files, skipLines = skipSumobrain)
  df <- cleanPatentData(patentData = df, columnsExpected = sumobrainColumns,
                        cleanNames = sumobrainNames, dateFields = sumobrainDateFields,
                        dateOrders = sumobrainDateOrder, deduplicate = TRUE,
                        cakcDict = cakcDict, docLengthTypesDict = docLengthTypesDict,
                        keepType = "grant",firstAssigneeOnly = TRUE, assigneeSep = ";",
                        stopWords = assigneeStopWords)
  
  
  # https://github.com/hadley/evaluate/blob/master/tests/testthat/ggplot-loop.r
  df$assigneeSmall <- strtrim(df$assigneeClean,12)
  score <- round(rnorm(dim(df)[1],mean=1.4,sd=0.9))
  score[score>3] <- 3
  score[score<0] <- 0
  df$score <- score
  aPlot <- flippedHistogram(df, "assigneeSmall","score")

  # taken from hadley's ggplot2 tests
  # https://github.com/tidyverse/ggplot2/blob/master/tests/testthat/test-geom-hex.R
  out <- layer_data(aPlot)

  temp <- summarizeColumns(df, c("assigneeSmall","score"))
  expect_equal(nrow(out), nrow(temp))
  expect_equal(sort(out$count), temp$total)
  expect_is(aPlot, c("gg","ggplot"))
  
  # Note: I read a SO post saying it is not wise to test svg outputs against 
  # current plots, thus, the exact plot is not compared to an svg file
})


test_that("facetPlot plots makes a plot object",{
  
  file1 <- rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xlsx")
  file2 <- rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search2.xlsx")
  files <- list(file1, file2)
  df <- importPatentData(rawDataFilePath = files, skipLines = skipSumobrain)
  df <- cleanPatentData(patentData = df, columnsExpected = sumobrainColumns,
                        cleanNames = sumobrainNames, dateFields = sumobrainDateFields,
                        dateOrders = sumobrainDateOrder, deduplicate = TRUE,
                        cakcDict = cakcDict, docLengthTypesDict = docLengthTypesDict,
                        keepType = "grant",firstAssigneeOnly = TRUE, assigneeSep = ";",
                        stopWords = assigneeStopWords)
  
  
  # https://github.com/hadley/evaluate/blob/master/tests/testthat/ggplot-loop.r
  df$assigneeSmall <- strtrim(df$assigneeClean,12)
  score <- round(rnorm(dim(df)[1],mean=1.4,sd=0.9))
  score[score>3] <- 3
  score[score<0] <- 0
  df$score <- score
  category <- c("system","control algorithm","product","control system", "communication")
  c <- round(rnorm(dim(df)[1],mean=2.5,sd=1.5))
  c[c>5] <- 5; c[c<1] <- 1
  df$category <- category[c]
  
  xVal = "category"
  fillVal = "score"
  facetVal = "assigneeSmall"
  
  aPlot <- facetPlot(subset(df, score > 0), xVal, fillVal, facetVal, colors = patentr::scoreColors,
                     recolor = FALSE)
  
  
  # taken from hadley's ggplot2 tests
  # https://github.com/tidyverse/ggplot2/blob/master/tests/testthat/test-geom-hex.R
  out <- layer_data(aPlot)
  expect_is(aPlot, c("gg","ggplot"))

})




test_that("tilePlot plots makes a plot object",{
  
  file1 <- rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xlsx")
  file2 <- rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search2.xlsx")
  files <- list(file1, file2)
  df <- importPatentData(rawDataFilePath = files, skipLines = skipSumobrain)
  df <- cleanPatentData(patentData = df, columnsExpected = sumobrainColumns,
                        cleanNames = sumobrainNames, dateFields = sumobrainDateFields,
                        dateOrders = sumobrainDateOrder, deduplicate = TRUE,
                        cakcDict = cakcDict, docLengthTypesDict = docLengthTypesDict,
                        keepType = "grant",firstAssigneeOnly = TRUE, assigneeSep = ";",
                        stopWords = assigneeStopWords)
  
  
  # https://github.com/hadley/evaluate/blob/master/tests/testthat/ggplot-loop.r
  df$assigneeSmall <- strtrim(df$assigneeClean,12)
  score <- round(rnorm(dim(df)[1],mean=1.4,sd=0.9))
  score[score>3] <- 3
  score[score<0] <- 0
  df$score <- score
  category <- c("system","control algorithm","product","control system", "communication")
  c <- round(rnorm(dim(df)[1],mean=2.5,sd=1.5))
  c[c>5] <- 5; c[c<1] <- 1
  df$category <- category[c]

  category <- c("system","control algorithm","product","control system", "communication")
  c <- round(rnorm(dim(df)[1],mean=2.5,sd=1.5))
  c[c>5] <- 5; c[c<1] <- 1
  df$category <- category[c]
  feature1 <- c("adaptive", "park", "lane", NA,NA,NA,NA,NA, "brake", "steer","accelerate","deactivate")
  f <- round(rnorm(dim(df)[1],mean=5,sd=1))
  l <- length(feature1)
  f[f>l] <- l; f[f<1] <- 1
  df$feature1 <- c(feature1,feature1[f])[1:dim(df)[1]]
  
  aPlot <- tilePlot(df, "category", "feature1")
  
  # taken from hadley's ggplot2 tests
  # https://github.com/tidyverse/ggplot2/blob/master/tests/testthat/test-geom-hex.R
  out <- layer_data(aPlot)
  expect_is(aPlot, c("gg","ggplot"))
  
})



## kamil bojanczyk end