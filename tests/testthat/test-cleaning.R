# test cleaning data


test_that("Imported Sumobrain csv to data frame has names standardized",{
  df <- importPatentData(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skipLines = 1)
  df <- cleanSumobrainNames(sumobrainData = df)
  expect_identical(names(df),names(acars))
  
})
