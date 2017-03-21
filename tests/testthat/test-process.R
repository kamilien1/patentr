# used with processPatentData.R




# sumobrain data
test_that("Sumobrain data has clean google URLS.",{
  df <- importPatentData(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skipLines = skipSumobrain)
  df <- cleanPatentData(patentData = df, columnsExpected = sumobrainColumns,
                        cleanNames = sumobrainNames, dateFields = sumobrainDateFields,
                        dateOrders = sumobrainDateOrder, deduplicate = TRUE,
                        cakcDict = cakcDict, docLengthTypesDict = docLengthTypesDict,
                        keepType = "grant",firstAssigneeOnly = TRUE, assigneeSep = ";",
                        stopWords = assigneeStopWords)
  kc <- extractKindCode(df$docNum)
  pn <- extractPubNumber(df$docNum)
  cc <- extractCountryCode(df$docNum)
  gurl <- createGoogleURL(countryCode = cc, pubNum = pn, kindCode = kc)
  expect_equal(length(gurl) ,dim(df)[1])
})



test_that("Google data has clean google URLS.",{
  df <- read.csv(rprojroot::find_testthat_root_file("testData","google_autonomous_search.csv"), 
                 skip = skipGoogle, stringsAsFactors = FALSE)
  df <- data.frame(lapply(df,function(x){iconv(x, to = "ASCII")}), stringsAsFactors = FALSE)
  
  df <- cleanPatentData(patentData = df, columnsExpected = googleColumns,
                        cleanNames = googleNames, dateFields = googleDateFields,
                        dateOrders = googleDateOrder, deduplicate = TRUE,
                        cakcDict = cakcDict, docLengthTypesDict = docLengthTypesDict,
                        keepType = "grant",firstAssigneeOnly = TRUE, assigneeSep = ",",
                        stopWords = assigneeStopWords)
  kc <- extractKindCode(df$docNum)
  pn <- extractPubNumber(df$docNum)
  cc <- extractCountryCode(df$docNum)
  gurl <- createGoogleURL(countryCode = cc, pubNum = pn, kindCode = kc)
  expect_equal(length(gurl) ,dim(df)[1])
})


test_that("Lens.org patent data has clean google URLS.",{
  df <- read.csv(rprojroot::find_testthat_root_file("testData","lens_autonomous_search.csv"), 
                 skip = skipLens, stringsAsFactors = FALSE)
  df <- data.frame(lapply(df,function(x){iconv(x, to = "ASCII")}), stringsAsFactors = FALSE)
  
  df <- cleanPatentData(patentData = df, columnsExpected = lensColumns,
                        cleanNames = lensNames, dateFields = lensDateFields,
                        dateOrders = lensDateOrder, deduplicate = TRUE,
                        cakcDict = cakcDict, docLengthTypesDict = docLengthTypesDict,
                        keepType = "grant",firstAssigneeOnly = TRUE, assigneeSep = ";;",
                        stopWords = assigneeStopWords)
  kc <- extractKindCode(df$docNum)
  pn <- extractPubNumber(df$docNum)
  cc <- extractCountryCode(df$docNum)
  gurl <- createGoogleURL(countryCode = cc, pubNum = pn, kindCode = kc)
  expect_equal(length(gurl) ,dim(df)[1])
})


test_that("getClaimFromURL returns character value.",{
  aclaim <- getClaimFromURL("https://patents.google.com/patent/US8818682B1/en")
  expect_is(aclaim ,"character")
})

test_that("getClaimFromURL for an old patent should return blank.",{
  anOldClaim <- getClaimFromURL("https://patents.google.com/patent/US881/en")
  expect_is(anOldClaim ,"character")
})

test_that("getClaimFromURL from a bad (well-formatted, 404 error) URL should return blank.",{
  aBadURLClaim <- getClaimFromURL("https://patents.google.com/patent/USsss881/en")
  expect_is(aBadURLClaim ,"character")
})


test_that("cleanGoogleURL from /mx returns character.",{
  expect_is(cleanGoogleURL("https://patents.google.com/patent/US8818682B1/mx") ,"character")
})

test_that("cleanGoogleURL from / returns character.",{
  expect_is(cleanGoogleURL("https://patents.google.com/patent/US8818682B1/") ,"character")
})


test_that("cleanGoogleURL from no backslash returns character.",{
  expect_is(cleanGoogleURL("https://patents.google.com/patent/US8818682B1") ,"character")
})

test_that("cleanGoogleURL from /en returns character.",{
  expect_is(cleanGoogleURL("https://patents.google.com/patent/US8818682B1/en") ,"character")
})



test_that("getClaimFromURL should return a character of length 1.",{
  krclaim <- getClaimFromURL("https://patents.google.com/patent/KR20150127745A/en")
  expect_equal(length(krclaim), 1)
  expect_is(krclaim, "character")
})


test_that("getClaimsText reads in 3 urls and returns a character vector of length 3.",{
  df <- importPatentData(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skipLines = skipSumobrain)
  df <- cleanPatentData(patentData = df, columnsExpected = sumobrainColumns,
                        cleanNames = sumobrainNames, dateFields = sumobrainDateFields,
                        dateOrders = sumobrainDateOrder, deduplicate = TRUE,
                        cakcDict = cakcDict, docLengthTypesDict = docLengthTypesDict,
                        keepType = "grant",firstAssigneeOnly = TRUE, assigneeSep = ";",
                        stopWords = assigneeStopWords)
  urls <- df$googleURL[1:3]
  clms <- getClaimsText(urls)
  expect_equal(length(clms), 3)
  expect_is(urls, "character")
})

