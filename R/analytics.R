#' Odds of a single streak
#'
#' Calculate the odds of a single streak of at least k heads out of n coin tosses given
#' the probability of heads (tails) is p (q = 1-p).
#'
#' @param num_coins integer, total number of coin flips
#' @param min_heads integer, minimum number of heads to to obtained in a single streak
#' @param prob_heads number, probability of obtaining a heads on a single coin toss
#' @param .saved data frame, contains previously computed probabilities for a given index;
#' used to speed up recursion so not to recalculate every probability should an already seen
#' scenario of num_coins, min_heads, and prob_heads arises.
#'
#' @return numeric, odds of streak
#' @export
#'
#' @examples
#' odds_of_streak(num_coins = 10, min_heads = 3, prob_heads = 0.5)
odds_of_streak <- function(num_coins = 10, min_heads = 5, prob_heads = 0.5, .saved = NULL) {
  # Computes the probability (i.e. S[n, k]) of getting a run of min_heads
  # i.e. the odds of getting K or more heads in a row out of
  # N independent coin tosses where p is the probability of getting a Heads
  # and q = 1-p is the probability of getting a Tails.

  # Using recursion: S[N, K] = p^K + sum_{j=1, K} ( p^(j-1) * (1-p) * S[N-j, K] )
  # As well as base cases: 1.) S[0, K] = 0 and 2.) S[N, K] = 0
  if (is.null(.saved)) {
    .saved <- data.frame(
      ID = character(),
      result = numeric(),
      stringsAsFactors = FALSE
    )
  }

  # Get a unique identifier for computed value
  ID <- paste0(num_coins, min_heads, prob_heads)

  # If it has been computed before, return pre-computed value
  if (ID %in% .saved$ID) {
    return(as.numeric(.saved[which(.saved$ID == ID), 2]))
    # Handle cases where we have no coins, or more heads than coins
  } else {
    if (min_heads > num_coins | num_coins <= 0) {
      result <- 0
    } else {
      # Use our recursive relationship to compute S[n, k] by breaking it into
      # a sum of terms involving S[n-j, k] for 1 <= j <= k
      result <- prob_heads**min_heads # S[n, k] = p^k + ...
      # S[n, k] = ... + sum_{j=1, k} p^(j-1) * (1-p) * S[n-j, k]
      for (first_tail in seq(1, min_heads + 1)) {
        pr <- odds_of_streak(num_coins - first_tail, min_heads, prob_heads, .saved)
        result <- result + (prob_heads**(first_tail - 1)) * (1 - prob_heads) * pr
      }
      # Save computed value for later use, if needed; i.e. if prob has already been calculated
      .saved <- data.frame(rbind(.saved, cbind(ID, result)), stringsAsFactors = FALSE)
    }
  }
  # Return computed value
  return(result)
}


#' Odds of at least K streaks
#'
#' Calculate the probability of the occurrence of at least K-streaks out of N-events
#' given the odds of stated streak.
#'
#' @param N integer, total number of coin tossers
#' @param K integer, number of streaks
#' @param P number, probability of a single streak
#'
#' @return a number
#' @export
#'
#' @examples
#' prob_of_at_least_k(N = 100, K = 1, P = odds_of_streak())
prob_of_at_least_k <- function(N, K, P) {
  n <- N
  k <- K
  p <- P
  l <- L <- 0
  for (k in K:N) {
    l <- choose(n, k) * (p**k) * ((1 - p)**(n - k))
    L <- L + l
  }
  return(L)
}
