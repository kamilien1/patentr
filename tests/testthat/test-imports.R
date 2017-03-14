# test that import works

# files
file1 <- system.file("extdata/", "sumobrain_autonomous_search1.xls", package="patentr")
file2 <- system.file("extdata/", "sumobrain_autonomous_search2.xls", package="patentr")
files <- list(file1, file2)
# read it in 
patData <- importPatentData(files)

# should be a data frame
expect_true(is.data.frame(patData))


# test_that("importing a data file works",{
#   # files
#   file1 <- system.file("inst/extdata/", "sumobrain_autonomous_search1.xls", package="patentr")
#   file2 <- system.file("inst/extdata/", "sumobrain_autonomous_search2.xls", package="patentr")
#   files <- list(file1, file2)
#   # read it in 
#   patData <- importPatentData(files)
#   
#   # should be a data frame
#   expect_true(is.data.frame(patData))
# })




