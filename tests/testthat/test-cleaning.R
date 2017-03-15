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