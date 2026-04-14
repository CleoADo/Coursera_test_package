test_that("fars_read errors for missing files", {
  expect_error(
    fars_read("this_file_does_not_exist.csv.bz2"),
    "does not exist"
  )
})

test_that("fars_read reads included example file and returns a tibble", {
  path <- package_root("accident_2013.csv.bz2")

  out <- fars_read(path)

  expect_s3_class(out, "tbl_df")
  expect_true(nrow(out) > 0)
  expect_true(all(c("STATE", "MONTH") %in% names(out)))
})
