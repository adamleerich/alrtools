# Author: Adam Rich
# Description:
#
#   Test for function
#

# Clear environment before running tests
rm(list = ls(all = TRUE))
require(alrtools)
require(testthat)


context("day")

test_that('day works', {
  expect_equal(day(as.Date('2022-10-14')), 14)
  expect_equal(day(ISOdate(1923, 12, 2)), 2)
})

