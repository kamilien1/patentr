### simple exploratory data anaylsis guide 

# 1 read in data
# access the files here and put them in a data/ folder of your working directory.
file1 <- system.file("extdata/", "sumobrain_autonomous_search1.xls", package="patentr")
file2 <- system.file("extdata/", "sumobrain_autonomous_search2.xls", package="patentr")
files <- list(file1, file2)
ipData <- importPatentData(rawDataFilePath = files, skipLines = 1)


# 2 clean data that was read in 
sumo <- cleanPatentData(patentData = patentr::acars, columnsExpected = sumobrainColumns,
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
View(sumo)


# 3 explore data
# note that in reality, you need a patent analyst to carefully score
# these patents, the score here is for demonstrational purposes
score <- round(rnorm(dim(sumo)[1],mean=1.4,sd=0.9))
score[score>3] <- 3
score[score<0] <- 0
sumo$score <- score
scoreSum <- summarizeColumns(sumo, "score")
scoreSum
# load library(ggplot2) for the below part to run
# ggplot(scoreSum, aes(x=score, y = total, fill=factor(score) )) + geom_bar(stat="identity")
nameAndScore <- summarizeColumns(sumo, c("assigneeClean","score"))
tail(nameAndScore)
names(sumo)
tail(summarizeColumns(sumo, c("docType","score","countryCode")))

# 4 visualize
## 4-1 histogram
sumo$assigneeSmall <- strtrim(sumo$assigneeClean,12)
flippedHistogram(sumo, "assigneeSmall","score",colors=scoreColors)

flippedHistogram(subset(sumo, score > 0), "assigneeSmall","score",colors=scoreColors)

flippedHistogram(subset(sumo, score > 2) ,"assigneeSmall","docType",colors=scoreColors,
recolor = TRUE)

## 4-2 facet plot
category <- c("system","control algorithm","product","control system", "communication")
c <- round(rnorm(dim(sumo)[1],mean=2.5,sd=1.5))
c[c>5] <- 5; c[c<1] <- 1
sumo$category <- category[c]

xVal = "category"
fillVal = "score"
facetVal = "assigneeSmall"

# warning, if xVal has more than 10 unique vals, it is hard to see
facetPlot(subset(sumo, score > 1), xVal, fillVal, facetVal, colors = patentr::scoreColors,
          recolor = FALSE)


## 4-3 tile plots
feature1 <- c("adaptive", "park", "lane", NA,NA,NA,NA,NA,
"brake", "steer","accelerate","deactivate")
f <- round(rnorm(dim(sumo)[1],mean=5,sd=1))
l <- length(feature1)
f[f>l] <- l; f[f<1] <- 1
sumo$feature1 <- c(feature1,feature1[f])[1:dim(sumo)[1]]

tilePlot(sumo, "category", "feature1")

tilePlot(sumo, xVal = "assigneeSmall", tileVal = "feature1", fillVal = "category",
xangle=90, xhjust=0, showLegend = TRUE)

tilePlot(sumo, xVal = "assigneeSmall", tileVal = "feature1", fillVal = "category",
xangle=90, xhjust=0, showLegend = TRUE, facetVal = "docType", fscale = "fixed")

tilePlot(sumo, xVal = "assigneeSmall", tileVal = "feature1", fillVal = "category",
xangle=90, xhjust=0, showLegend = TRUE, facetVal = "docType", fscale = "free")

tilePlot(sumo, xVal = "assigneeSmall", tileVal = "feature1", fillVal = "category",
xangle=90, xhjust=0, showLegend = TRUE, facetVal = "score", fscale = "free")
