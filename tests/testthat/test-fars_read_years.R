test_that("fars_read_years reads included example files", {
  withr::local_dir(package_root())

  out <- fars_read_years(c("2013", "2014"))

  expect_length(out, 2)

  expect_s3_class(out[[1]], "tbl_df")
  expect_named(out[[1]], c("MONTH", "year"))
  expect_true(all(out[[1]]$year == "2013"))

  expect_s3_class(out[[2]], "tbl_df")
  expect_named(out[[2]], c("MONTH", "year"))
  expect_true(all(out[[2]]$year == "2014"))
})

test_that("fars_read_years warns and returns NULL for missing years", {
  withr::local_dir(package_root())

  expect_warning(
    out <- fars_read_years(c("2013", "2012")),
    "invalid year: 2012"
  )

  expect_length(out, 2)
  expect_s3_class(out[[1]], "tbl_df")
  expect_null(out[[2]])
})
