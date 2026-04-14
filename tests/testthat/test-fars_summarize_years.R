test_that("fars_summarize_years summarizes monthly counts correctly", {
  withr::local_dir(package_root())

  out <- fars_summarize_years(c("2013", "2014"))

  dat2013 <- suppressMessages(readr::read_csv("accident_2013.csv.bz2"))
  dat2014 <- suppressMessages(readr::read_csv("accident_2014.csv.bz2"))

  expected <- dplyr::bind_rows(
    tibble::tibble(MONTH = dat2013$MONTH, year = "2013"),
    tibble::tibble(MONTH = dat2014$MONTH, year = "2014")
  ) |>
    dplyr::count(year, MONTH) |>
    tidyr::spread(year, n)

  out <- dplyr::arrange(out, MONTH)
  expected <- dplyr::arrange(expected, MONTH)

  expect_equal(as.data.frame(out), as.data.frame(expected))
})
