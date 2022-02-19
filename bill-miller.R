# Clear Environment
rm(list=ls())

# Define recursive function for calculating odds of streak
probOfStreak <- function(numCoins, minHeads, headProb, saved = NULL) {
    # Computes the probability (i.e. S[n,k]) of getting a run of minHeads
    # i.e. K of more heads in a row out of numCoins
    # i.e. N independent coin tosses where the probability of Heads is p
    # and the probability of Tails is q=1-p
    #
    # Using recursion: S[N,K] = p^K + sum_{j=1,K} ( p^(j-1) * (1-p) * S[N-j,K] )
    # As well as base cases: 1. S[0,K] = 0 and S[N,K] = 0
    # saved <- NULL
    if (is.null(saved)) { saved = data.frame(ID = character(), 
                                            result = numeric(), 
                                            stringsAsFactors = F) 
    }
    
    # Get a unique identifier for computed value
    ID <- paste0(numCoins, minHeads, headProb)
    
    # If it has been computed before, return precomputed value
    if (ID %in% saved$ID) { 
        return(as.numeric(saved[which(saved$ID == ID), 2])) 
    # Handle cases where we have no coins, or more heads than coins
    } else if (minHeads > numCoins | numCoins <= 0) { 
        result <- 0
    # Use our recursive relationship to compute S[n,k] by breaking it into
    # a sum of terms involving S[n-j,k] for 1 <= j <= k
        } else {
            result <- headProb**minHeads # S[n,k] = p^k + ...
            # S[n,k] = ... + sum_{j=1,k} p^(j-1)*(1-p)*S[n-j,k]
            for (firstTail in seq(1, minHeads+1)) {
                pr <- probOfStreak(numCoins-firstTail, minHeads, headProb, saved)
                result <- result + (headProb**(firstTail-1))*(1-headProb)*pr
            }
        # Save computed value for later use if needed
        saved <- data.frame(rbind(saved, cbind(ID, result)), stringsAsFactors = F)
        }
        # Return computed value
        return(result)
    }
### Simple Test
probOfStreak(10, 5, 0.5)

### Example from `The Drunkard's Walk: How Randomness Rules Our Lives`
# tictoc::tic()
# probOfStreak(40, 15, 0.5) # p = 0.000411981
# tictoc::toc() # 24713.89 sec elapsed (6.865 hours)

### Liklihood of at least 1 person out of 1000 getting a streak of 15 heads in 40 flips
# (1) pdf: P(X = k) = choose(n, k)*(p^k)*((1-p)^(n-k))
# (2) cdf: P(X <= k) = sum_{i=0,k} (1) for i <= k
# (3) P(X > k) = 1 - P(X <= k); i.e. 1 - (2)

# this p (below) comes from the full enumeration of a streak of at least 15 Heads from 40 trials
p <- 0.000411981 # for the @Risk simulation, we got 0.0002
n <- 1000
k <- 0
# Result (1): P(X = k)
choose(n, k)*(p**k)*((1-p)**(n-k)) # P(X = 0) ~= 0.66 => P(X > 0) ~= 1 - 0.66 = 0.33

# Create function to calculate likelihood of getting k or more occurences.
probOfAtLeastK <- function(N, K, P) {
    n <- N; k <- K; p <- P
    L = 0; l = 0
    for (k in K:N) {
        l <- choose(n, k)*(p**k)*((1-p)**(n-k))
        L <- L + l
    }
    return(L)
}
probOfAtLeastK(n, 1, p)
