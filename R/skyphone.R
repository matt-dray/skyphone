
#' Fetch GitHub Skyline Data
#'
#' Construct a GitHub Skyline API path for a given user and year, fetch and
#' augment the data, and convert to a tidy tabular format.
#'
#' @param user Character string. A GitHub user whose contributions you want to
#'     fetch.
#' @param year Single numeric value. The year for which you want to collect the
#'     contribution count.
#'
#' @return A data.frame/tibble with columns user, year, week, day, date and
#'     count. Row count will be 365 or 366 if a leap year.
#' @export
#'
#' @importFrom rlang .data
#'
#' @examples \dontrun{ sky_get(user = "matt-dray", year = 2020) }
sky_get <- function(user, year = 2020) {

  if (class(user) != "character") {
    stop("Argument 'user' must be a character string.")
  }

  if (class(year) != "numeric") {
    stop("Argument 'year' must be numeric.")
  }

  path <- paste0(
    "https://skyline.github.com/api/contributions?",
    "username=", user, "&year=", year
  )

  df <- jsonlite::fromJSON(path)$contributions %>%
    tidyr::unnest(.data$days) %>%
    dplyr::transmute(
      user = user, year = as.integer(year),
      week = .data$week + 1L, day = dplyr::row_number(),
      date = as.Date(.data$day, origin = paste0(year - 1, "-12-31")),
      .data$count
    )

  return(df)

}

#' Sonify A GitHub Skyline Dataset
#'
#' Present GitHub Skyline contributions data in audio format using the {sonify}
#' package.
#'
#' @param data A data.frame/tibble. An object output from \code{\link{sky_get}}
#'     containing the GitHub contributions data for a given user in a given
#'     year.
#' @param play Logical. Should the audio be played? Defaults to TRUE
#' @param out_dir Character. The folder to which the audio file will be saved.
#'     Defaults to NULL (no file is saved).
#'
#' @return A WaveMC-class object, plus optional audio output and a .wav file.
#'
#' @export
#'
#' @examples \dontrun{
#'     d <- sky_get(user = "matt-dray", year = 2020)
#'     sky_sonify (d, play = FALSE, out_dir = "~/Desktop")
#'     }
sky_sonify <- function(data, play = TRUE, out_dir = NULL) {

  if (class(any(data != "data.frame"))) {
    stop("Argument 'data' should be a data.frame output from sky_get().")
  }

  if (class(play != "logical")) {
    stop("Argument 'play' should be TRUE or FALSE.")
  }

  if (class(out_dir != "character")) {
    stop("Argument 'out_dir' must be a character string.")
  }

  audio <- sonify::sonify(
    data[["day"]], data[["count"]],
    play = play
  )

  if (!is.null(out_dir)) {
    out_file <- paste0(
      "skyphone_", unique(data[["user"]]), "_", unique(data[["year"]]), ".wav"
    )
    tuneR::writeWave(audio, file.path(out_dir, out_file))

  }

  return(audio)

}

#' Plot A GitHub Skyline Dataset
#'
#' Produce a simple, opinionated plot of GitHub Skyline data showing
#' contribution count over time for a given year.
#'
#' @param data A data.frame/tibble. An object output from \code{\link{sky_get}}
#'     containing the GitHub contributions data for a given user in a given
#'     year.
#'
#' @return A gg/ggplot-class object.
#'
#' @export
#'
#' @importFrom rlang .data
#'
#' @examples \dontrun{
#'     d <- sky_get(user = "matt-dray", year = 2020)
#'     sky_plot(d)
#'     }
sky_plot <- function(data) {

  if (class(any(data != "data.frame"))) {
    stop("Argument 'data' should be a data.frame output from sky_get().")
  }

  ggplot2::ggplot() +
    ggplot2::geom_col(
      ggplot2::aes(data[["date"]], data[["count"]])
    ) +
    ggplot2::labs(
      title = paste0(
        unique(data[["user"]]), "'s ",
        unique(data[["year"]]),
        " Github Skyline"
      ),
      subtitle = "Data via skyline.github.com/",
      x = "Date", y = "Count"
    ) +
    ggplot2::theme_minimal()

}
