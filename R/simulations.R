#' Calculate the Longest Run
#'
#' Finds the single longest run (streak) of a specified value
#' contained within a provided vector
#'
#' @param sample numeric or character vector.
#' @param run_value number or character, the value for which to count sequential occurrences.
#'
#' @return number, the longest run (streak) of values
#' @export
#'
#' @examples
#' s <- sample(c("A", "B"), size = 10, replace = TRUE)
#' print(s)
#'
#' find_longest_run(sample = s, run_value = "A")
find_longest_run <- function(sample, run_value) {
  if (!(run_value %in% sample)) {
    return(0)
  } else {
    run <- max_run <- 1
    for (i in 2:length(sample)) {
      if (sample[i] == run_value && sample[i] == sample[i - 1]) {
        run <- run + 1
        max_run <- max(max_run, run)
      } else {
        run <- 1
        max_run <- max(max_run, run)
      }
    }
    return(max_run)
  }
}


#' Count Runs
#'
#' Out of a given number of trials flipping a fair coin (p = 0.5) n times, count the number of
#' times a run (streak) of length k occurs
#'
#' @param trials number, number of times flipping a coin n times.
#' @param sample_space vector, vector of unique values from which to sample.
#' @param sample_size number, size of sample to generate from \code{sample_space}; e.g. n coin flips.
#' @param run_value number or character, the value on which to count sequential occurrences.
#' @param run_length number, length of streak of interest value.
#'
#' @return number, the total number of applicable runs; i.e. the number of runs where
#' the length of the run is greater than or equal to the specified \code{run_length}.
#' @export
#'
#' @examples
#' run_count <- count_runs()
count_runs <- function(trials = 100,
                       sample_space = c(0, 1),
                       sample_size = 5,
                       run_value = 1,
                       run_length = 3) {
  if (run_length > sample_size) stop("run_length must be less than or equal to sample_size.")
  if (!(run_value %in% sample_space)) stop("run_value must be a member of the sample_space.")

  total_applicable_runs <- 0
  for (t in 1:trials) {
    lr <- find_longest_run(
      sample = sample(sample_space, size = sample_size, replace = TRUE),
      run_value = run_value
    )
    if (lr >= run_length) {
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
#' @return data frame with
#' * 4 columns: \code{iterations}, \code{applicable_trials}, \code{prob_of_zero}, & \code{prob_of_ge_one}; and
#' * the number of rows to be determined by \code{iters}
#' @export
#'
#' @examples
#' tail(run_simulation())
run_simulation <- function(iters = 100,
                           trials = 100,
                           sample_space = c(0, 1),
                           sample_size = 5,
                           run_value = 1,
                           run_length = 3) {
  d <- data.frame(
    iterations = 1:iters,
    applicable_trials = rep(NA_real_, iters),
    prob_of_zero = rep(NA_real_, iters),
    prob_of_ge_one = rep(NA_real_, iters),
    stringsAsFactors = FALSE
  )
  for (i in 1:iters) {
    d[i, 2] <- count_runs(
      trials = trials,
      sample_space = sample_space,
      sample_size = sample_size,
      run_value = run_value,
      run_length = run_length
    )
    d[i, 3] <- nrow(d[which(d[, 2] == 0), ]) / i
    d[i, 4] <- 1 - d[i, 3]
  }
  return(d)
}
