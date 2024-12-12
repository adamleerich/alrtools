# Author: adaml
# Date:   2024-12-11
# Description:
#
#   Test for function
#

# Clear environment before running tests
rm(list = ls(all = TRUE))


context("quarter_name")

test_that('quarter_name works', {
  expect_equal(quarter_name(as.Date('2024-10-09')), '2024q4')
  expect_equal(quarter_name(as.Date('2020-02-29')), '2020q1')
  expect_equal(quarter_name(as.Date('2022-08-31')), '2022q3')
  expect_equal(quarter_name(as.Date('2021-04-01')), '2021q2')
  expect_equal(quarter_name(as.Date('2021-01-01')), '2021q1')
  expect_equal(quarter_name(as.Date('2021-03-31')), '2021q1')
  expect_equal(quarter_name(as.Date('2021-04-01')), '2021q2')
  expect_equal(quarter_name(as.Date('2021-06-30')), '2021q2')
  expect_equal(quarter_name(as.Date('2021-07-01')), '2021q3')
  expect_equal(quarter_name(as.Date('2021-09-30')), '2021q3')
  expect_equal(quarter_name(as.Date('2021-10-01')), '2021q4')
  expect_equal(quarter_name(as.Date('2021-12-31')), '2021q4')
})


