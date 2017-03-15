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

# motivation
# test taken from readxl package in tidyverse and modified
# credit goes to tidyverse team
# https://github.com/tidyverse/readxl/blob/83af028bcc577d23b01c4a1f47d2dfc314497253/tests/testthat/helper.R
# NOTE: may need to cancel this test as readxl 0.1.1 still has error, only github version does not have error
# this only works on 0.1.1.9000 (current at time of writing) and above
# test_that("can tolerate xls that underreports number of columns",{
#   # tidyverse test
#   df <- readxl::read_excel(rprojroot::find_testthat_root_file("testData","mtcars.xls"))
#   expect_identical(ncol(df),ncol(mtcars))
#   # test modified
#   df2 <- readxl::read_excel(rprojroot::find_testthat_root_file("testData","sumobrain_autonomous_search1.xls"), skip=1)
#   expect_identical(ncol(df2),ncol(acars))
#   
# })

