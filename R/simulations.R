#' Calculate the Longest Run
#'
#' Finds the single longest run (streak) of a specified value
#' contained within a provided vector
#'
#' @param sample numeric or character vector.
#' @param run_value number or character, the value on which to count sequential occurrences.
#'
#' @return number, the longest run (streak) of values
#' @export
#'
#' @examples
#' s <- sample(c(0, 1), size = 10, replace = TRUE)
#' print(s)
#'
#' find_longest_run(sample = s, run_value = 1)
find_longest_run <- function(sample, run_value = 1) {
  # Arg Check
  sample_vals <- unique(sample)
  if (!(run_value %in% sample_vals)) stop("run_value not found in sample")

  # Count
  run <- max_run <- 0
  for (i in 2:length(sample)) {
    if (sample[i] == run_value && sample[i] == sample[i - 1]) {
      run <- run + 1
      max_run <- max(max_run, run)
    } else {
      run <- 0
      max_run <- max(max_run, run)
    }
  }
  return(max_run + 1)
}


#' Count Runs
#'
#' Out of a given number of trials flipping a fair coin (p = 0.5) n times, count the number of
#' times a run (streak) of length k occurs
#'
#' @param trials number, number of attempts to flip a coin n times.
#' @param sample_space vector, vector of unique values from which to sample.
#' @param sample_size number, size of sample to generate from \code{sample_space}.
#' @param run_value number or character, the value on which to count sequential occurrences.
#' @param run_length number, length of streak of interest.
#'
#' @return number
#' @export
#'
#' @examples
#' count_runs()
count_runs <- function(trials = 1000,
                       sample_space = c(0, 1),
                       sample_size = 40,
                       run_value = 1,
                       run_length = 15) {
  x <- NULL
  total_applicable_runs <- 0
  for (t in 1:trials) {
    x[t] <- find_longest_run(sample = sample(sample_space, size = sample_size, replace = TRUE),
                             run_value = run_value)
    if (x[t] >= run_length) {
      total_applicable_runs <- total_applicable_runs + 1
    }
  }
  return(total_applicable_runs)
}


#' Run Simulation
#'
#' Iterate over \code{count_runs()}, counting the number of applicable trials where
#' such a trial is defined as having the occurrence of a streak of at least the
#' designated length. Additionally, keep a running tally of the cumulative likelihood
#' of obtaining exactly zero streaks.
#'
#' This function outputs a data frame with three columns:
#' 1.) the iteration number,
#' 2.) the count of applicable trials in that iteration, and
#' 3.) the cumulative probability of obtaining zero streaks.
#'
#' @param iters number, number of simulation iterations
#' @param trials number, see \code{count_runs()}
#' @param sample_space vector, see \code{count_runs()}
#' @param sample_size number, see \code{count_runs()}
#' @param run_value number, see \code{count_runs()}
#' @param run_length number, see \code{count_runs()}
#'
#' @return data frame with 3 columns; the number of rows determined by \code{iters}
#' @export
#'
#' @examples
#' tail(run_simulation())
run_simulation <- function(iters = 100,
                           trials = 1000,
                           sample_space = c(0, 1),
                           sample_size = 40,
                           run_value = 1,
                           run_length = 15) {
  d <- data.frame(stringsAsFactors = FALSE)
  for (i in 1:iters) {
    d[i, 1] <- i
    d[i, 2] <- count_runs(trials, sample_space, sample_size, run_value, run_length)
    d[i, 3] <- round(nrow(d[which(d[, 2] == 0), ]) / nrow(d), 6)
  }
  names(d) <- c("iteration", "applicable_trials", "prob_of_zero")
  return(d)
}
