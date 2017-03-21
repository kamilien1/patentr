# test graphics

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
