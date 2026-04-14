## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(testpackagedevtools)

## -----------------------------------------------------------------------------
make_filename(2013)
make_filename("2015")

## ----eval = FALSE-------------------------------------------------------------
# dat <- fars_read("accident_2013.csv.bz2")
# dat

## ----eval = FALSE-------------------------------------------------------------
# fars_read("does_not_exist.csv.bz2")

## ----eval = FALSE-------------------------------------------------------------
# year_list <- fars_read_years(c("2013", "2014", "2015"))
# year_list

## ----eval = FALSE-------------------------------------------------------------
# year_list <- fars_read_years(c("2013", "2014", "2012"))
# year_list

## ----eval = FALSE-------------------------------------------------------------
# summary_tbl <- fars_summarize_years(c("2013", "2014", "2015"))
# summary_tbl

## ----eval = FALSE-------------------------------------------------------------
# fars_map_state(state.num = 1, year = 2013)

## ----eval = FALSE-------------------------------------------------------------
# fars_map_state(state.num = 100, year = 2013)

## ----eval = FALSE-------------------------------------------------------------
# file_2013 <- make_filename(2013)
# 
# dat_2013 <- fars_read(file_2013)
# 
# year_data <- fars_read_years(c(2013, 2014, 2015))
# 
# year_summary <- fars_summarize_years(c(2013, 2014, 2015))
# 
# fars_map_state(state.num = 1, year = 2013)

