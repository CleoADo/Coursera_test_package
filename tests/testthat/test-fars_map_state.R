test_that("fars_map_state errors for an invalid state number", {
  withr::local_dir(package_root())

  expect_error(
    fars_map_state(100, 2013),
    "invalid STATE number"
  )
})

test_that("fars_map_state runs without error for a valid state", {
  dat <- fars_read(package_root("accident_2013.csv.bz2"))
  valid_state <- dat$STATE[!is.na(dat$STATE)][1]

  withr::local_dir(package_root())

  grDevices::pdf(file = tempfile(fileext = ".pdf"))
  on.exit(grDevices::dev.off(), add = TRUE)

  expect_no_error(
    fars_map_state(valid_state, 2013)
  )
})
