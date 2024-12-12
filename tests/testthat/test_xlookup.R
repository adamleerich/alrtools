# Author: adaml
# Date:   2024-12-11
# Description:
#
#   Test for function
#

# Clear environment before running tests
rm(list = ls(all = TRUE))


context("xlookup")

test_that('xlookup works', {

  ref <- data.frame(
    state = c('UT', 'FL', NA, 'NY', 'CA', 'SD'),
    category = c(1, 2, -1, 10, 3, 0)
  )

  expect_equal(
    xlookup(
      c("CA", "FL", "CA", "NY", "NY", "NY", "UT", "NY", "FL", "SD"),
      ref$state, ref$category),
    c(3, 2, 3, 10, 10, 10, 1, 10, 2, 0) )

  expect_warning(
    xlookup(c('CA', 'FL', 'KY'), ref$state, ref$category),
    regexp = 'Missing values.*KY')

  expect_warning(
    xlookup(c('CA', 'fl'), ref$state, ref$category, ignore_case = FALSE),
    regexp = 'Missing values.*fl')

  expect_equal(
    xlookup(c('CA', 'FL', 'KY'), ref$state, ref$category, warn = FALSE),
    c(3, 2, NA) )

  expect_equal(
    xlookup(c('CA', 'FL', NA), ref$state, ref$category),
    c(3, 2, -1) )

  expect_error(
    xlookup(c('CA', 'FL', NA), ref$state[-1], ref$category),
    'lookup_vector and return_vector must be the same length')

  expect_warning(
    xlookup(c('CA', 'FL', NA), character(0), ref$category),
    'lookup_vector is empty')

  expect_equal(
    xlookup(
      c("CA", "FL", "CA", "NY", "NY", "NY", "UT", "NY", "FL", "SD", NA),
      ref$state),
    c(5, 2, 5, 4, 4, 4, 1, 4, 2, 6, 3) )

  expect_equal(
    xlookup(
      c("CA", "fl", "CA", "NY", "NY", "NY", "UT", "NY", "FL", "SD", NA),
      ref$state,
      ignore_case = FALSE,
      warn = FALSE),
    c(5, NA, 5, 4, 4, 4, 1, 4, 2, 6, 3) )

})


