context("Test downloading functions")
test_that("get_shape() expects character", {
  expect_error(get_shape(x))
})
