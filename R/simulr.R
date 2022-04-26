

#' Find the Longest Run
#'
#' Finds the single longest run ("streak") of the value "1"
#' provided in a binomial sample of size n.
#'
#' @param binom_sample, numeric vector - a binomial sample; e.g. \code{sample(c(0, 1), size = 5, replace = TRUE)}
#'
#' @return number, representing the longest streak (run of "1") in the provided sample
#' @export
#'
#' @examples
#' find_longest_run(binom_sample = sample(c(0, 1), size = 25, replace = TRUE))
find_longest_run <- function(binom_sample) {
  run <- max_run <- 0
  for (i in 2:length(binom_sample)) {
    if (binom_sample[i] == 1 && binom_sample[i] == binom_sample[i-1]) {
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
#' Out of a given number of trials of flipping a coin n times, count the number of
#' times a run/streak of length k occurs
#'
#' @param trials number, number of attempts to flip a coin n times
#' @param flips number, number of sequential coin flips in which a streak could be counted
#' @param streak_length number, length of streak of interest
#'
#' @return number
#' @export
#'
#' @examples
#' count_runs()
count_runs <- function(trials = 1000, flips = 40, streak_length = 15) {
  x <- NULL
  total_applicable_runs <- 0
  for (t in 1:trials) {
    x[t] <- find_longest_run(binom_sample = sample(c(0, 1), size = flips, replace = TRUE))
    if (x[t] >= streak_length) {
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
#' @param iters number, number of sumulation iterations to consider
#' @param trials number, see \code{count_runs()}
#' @param flips number, see \code{count_runs()}
#' @param streak_length number, see \code{count_runs()}
#'
#' @return data frame
#' @export
#'
#' @examples
#' tail(run_simulation())
run_simulation <- function(iters = 100, trials = 1000, flips = 40, streak_length = 15) {
  d <- data.frame(stringsAsFactors = FALSE)
  for (i in 1:iters) {
    d[i, 1] <- i
    d[i, 2] <- count_runs(trials = trials, flips = flips, streak_length = streak_length)
    d[i, 3] <- round(nrow(d[which(d[, 2] == 0), ]) / nrow(d), 6)

  }
  names(d) <- c("iteration", "applicable_trials", "prob_of_zero")
  return(d)
}
