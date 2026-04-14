package_root <- function(...) {
  normalizePath(
    testthat::test_path("..", "..", ...),
    mustWork = FALSE
  )
}
