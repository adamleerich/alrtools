# Author: Adam Rich
# Description:
#
#   Test for function
#

# Clear environment before running tests
rm(list = ls(all = TRUE))
require(alrtools)
require(testthat)


context("year")

test_that('year works', {
  expect_equal(year(as.Date('2022-10-14')), 2022)
  expect_equal(year(ISOdate(1923, 12, 2)), 1923)
})

