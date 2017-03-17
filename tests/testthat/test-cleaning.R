# test cleaning data


# clean names 
test_that("Imported Sumobrain csv to data frame has names standardized",{
  df <- importPatentData(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skipLines = 1)
  df <- cleanSumobrainNames(sumobrainData = df)
  expect_identical(names(df),names(acars))
  
})


# same length when extracting country code
test_that("Country code extracted from document number, and all country codes are chars of length 2-4",{
  df <- importPatentData(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skipLines = 1)
  df <- cleanSumobrainNames(sumobrainData = df)
  expect_length(extractCountryCode(df$docNum),dim(df)[1])
})

# same length when extracting publication number
test_that("Publication number, numeric portion extracted from document number properly",{
  df <- importPatentData(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skipLines = 1)
  df <- cleanSumobrainNames(sumobrainData = df)
  # should return the same length
  expect_length(extractPubNumber(df$docNum),dim(df)[1])
})


# same length when extracting kind code
test_that("Kind code extracted returns same length as number of rows of data frame",{
  df <- importPatentData(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skipLines = 1)
  df <- cleanSumobrainNames(sumobrainData = df)
  # should return the same length
  expect_length(extractKindCode(df$docNum),dim(df)[1])
})


# same length when extracting kind code
test_that("Office doc length extracted returns same length as number of rows of data frame",{
  df <- importPatentData(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skipLines = 1)
  df <- cleanSumobrainNames(sumobrainData = df)
  df$pubName <- extractPubNumber(df$docNum)
  df$countryCode <- extractCountryCode(df$docNum)
  df$officeDocLength <- extractDocLength(countryCode = df$countryCode, pubNum = df$pubNum)
  # should return the same length
  expect_length(df$officeDocLength ,dim(df)[1])
})


# Dates converted properly
test_that("Dates converted properly from characters",{
  df <- importPatentData(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skipLines = 1)
  df <- cleanSumobrainNames(sumobrainData = df)
  df$pubDate <- extractCleanDate(df$pubDate)
  # should return the same length
  expect_equal(inherits(df$pubDate, "Date") ,TRUE)
})

# same length when extracting kind code
test_that("Google URL vector returns same length as number of rows of data frame",{
  df <- importPatentData(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skipLines = 1)
  df <- cleanSumobrainNames(sumobrainData = df)
  df$pubNum <- extractPubNumber(df$docNum)
  df$countryCode <- extractCountryCode(df$docNum)
  df$kindCode <- extractKindCode(df$docNum)
  # should return the same length
  expect_length(createGoogleURL(countryCode = df$countryCode, 
                                pubNum = df$pubNum, 
                                kindCode =df$kindCode) ,dim(df)[1])
})


# duplicates are removed if exist
test_that("Removing dups is a logical vector",{
  df <- importPatentData(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skipLines = 1)
  df <- cleanSumobrainNames(sumobrainData = df)
  # should be of type logical
  expect_type(removeDups(df$docNum) ,"logical")
})


