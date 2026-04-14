#' Read local csv file
#'
#' Reads a CSV file from a file path and returns it as a tibble
#'
#' @param filename Path to the target file.
#'
#' @returns A tibble.
#'
#' @importFrom readr read_csv
#' @importFrom dplyr as_tibble
#'
#' @examples
#' \dontrun{
#' data <- fars_read("accident_2013.csv.bz2")
#' }
#'
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::as_tibble(data)
}

#' Create file name from year
#'
#' Creates the file name of a compressed CSV file containing accident data
#' for a given year.
#'
#' @param year Year as integer or character.
#'
#' @returns A character string with the file name.
#'
#' @examples
#' \dontrun{
#' file_name <- make_filename(2015)
#' }
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}

#' Read accident data files for given years
#'
#' Reads accident data files for the specified years and returns the
#' `MONTH` and `year` columns for each successfully read file.
#'
#' `NULL` is returned for non-existent elements.
#'
#' @param years A vector of years of interest.
#'
#' @returns A list of tibbles.
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#'
#' @examples
#' \dontrun{
#' file_list <- fars_read_years(c("2013", "2014", "2016"))
#' }
#'
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#' Read in and summarize accident data files for given years
#'
#' Reads accident data files for the specified years and summarizes them per `year` and `MONTH`.
#'
#' @param years A vector of years of interest.
#'
#' @returns A tibble with monthly accident counts per year.
#'
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom tidyr spread
#'
#' @examples
#' \dontrun{
#' summary_tbl <- fars_summarize_years(c("2013", "2014", "2016"))
#' }
#'
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = dplyr::n()) %>%
    tidyr::spread(year, n)
}

#' Plot accidents in a given year and state
#'
#' Plots the geographical locations of reported accidents in a given year and U.S. state.
#'
#' @param state.num Numeric state code as integer or character.
#' @param year Year as integer or character.
#'
#' @returns `NULL`, but still plots the map.
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @examples
#' \dontrun{
#'   fars_map_state(state.num = 1, year = 2013)
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
