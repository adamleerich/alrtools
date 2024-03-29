# Author: Adam Rich
# Description:
#
#   Test for function
#

# Clear environment before running tests
rm(list = ls(all = TRUE))
require(alrtools)
require(testthat)


context("month")

test_that('month works', {
  expect_equal(month(as.Date('2022-10-14')), 10)
  expect_equal(month(ISOdate(1923, 12, 2)), 12)
})

