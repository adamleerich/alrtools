# Author: Adam Rich
# Date:   2020-05-15
# Description:
#
#   Test for function
#

# Clear environment before running tests
rm(list = ls(all = TRUE))
require(alrtools)
require(testthat)


context("e")

test_that('e works', {
  expect_equal(alrtools::e, exp(1L))
})

