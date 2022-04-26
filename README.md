
<!-- README.md is generated from README.Rmd. Please edit that file -->

# billmillr

**Author:** [Matthew Hoff](https://github.com/mghoff) <br/> **License:**
[MIT](https://opensource.org/licenses/MIT)<br/>

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/ropensci/epubr?branch=master&svg=true)](https://ci.appveyor.com/project/leonawicz/epubr)

## The Premise

This package calculates “The Bill Miller Problem” from Leonard
Mlodinow’s “The Drunkard’s Walk: *How Randomness Rules Our Lives*”.

The premise of this story goes that Bill Miller (financier) was an
amazing stock picker after having performed incredibly well - beating
the market over 15 consecutive years. As a result, he was celebrated and
acclaimed by the likes of Forbes and others, who claimed that the
likelihood of his ability to perform this well was 1 in 32,768. Dr.,
Mlodinow ups this likelihood, stating that the probability that any 1
person among 1000 who started “tossing coins” (i.e. picking stocks) was
closer to 3%.

Dr. Mlodinow then further ups the probability, considering the
likelihood that any 1 person over a 40 year period seeing that level of
success, defined as beating the market for 15 years in a row or longer,
is roughly 3 out of 4, or 75%.

**The resulting likelihood for any one person to beat the market within
a definite start and stop time of at least 15 years in a single 40 year
period, while larger the the 3% of his second calculation, is much
smaller than the final proposed result of \~75%, which this calculates
at \~33%.**

## The Math

#### Part 1:

One must compute the odds of getting a run (Streak) of at least k heads
out of N coin tosses where p (q = 1-p) is the probability of obtaining
heads (tails) from the toss of a coin.

Mathematically,

![S\[N, K\] = p^k + \\sum\_{j=1, K} \\{ p^{(j-1)} (1-p) S\[N-j, K\] \\}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;S%5BN%2C%20K%5D%20%3D%20p%5Ek%20%2B%20%5Csum_%7Bj%3D1%2C%20K%7D%20%5C%7B%20p%5E%7B%28j-1%29%7D%20%281-p%29%20S%5BN-j%2C%20K%5D%20%5C%7D "S[N, K] = p^k + \sum_{j=1, K} \{ p^{(j-1)} (1-p) S[N-j, K] \}")

which can be broken down recursively into the sum of terms:

![S\[n, k\] = p^k + ... = \\sum\_{j=1, k} \\{ p^{(j-1)} (1-p) S\[n-j, k\] \\} \\text{ for } 1 \\le j \\le k](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;S%5Bn%2C%20k%5D%20%3D%20p%5Ek%20%2B%20...%20%3D%20%5Csum_%7Bj%3D1%2C%20k%7D%20%5C%7B%20p%5E%7B%28j-1%29%7D%20%281-p%29%20S%5Bn-j%2C%20k%5D%20%5C%7D%20%5Ctext%7B%20for%20%7D%201%20%5Cle%20j%20%5Cle%20k "S[n, k] = p^k + ... = \sum_{j=1, k} \{ p^{(j-1)} (1-p) S[n-j, k] \} \text{ for } 1 \le j \le k")

which is provided by `oddsOfStreak`.

For more information on the math behind this recursive odds calculation,
see this [Ask A
Mathematician](https://www.askamathematician.com/2010/07/q-whats-the-chance-of-getting-a-run-of-k-successes-in-n-bernoulli-trials-why-use-approximations-when-the-exact-answer-is-known/)
post.

#### Part 2:

To calculate the likelihood that at least x out of M people will obtain
a streak of at least k Heads out of N coin tosses, one must perform the
following:

1.  Calculate the pdf:

![\\mathrm{P}(X=x)={M \\choose x}p^{x}(1-p)^{(M-x)}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Cmathrm%7BP%7D%28X%3Dx%29%3D%7BM%20%5Cchoose%20x%7Dp%5E%7Bx%7D%281-p%29%5E%7B%28M-x%29%7D "\mathrm{P}(X=x)={M \choose x}p^{x}(1-p)^{(M-x)}")

2.  Calculate the cdf:

![\\mathrm{P}(X \\le x) = \\sum\_{i=0,x} \\mathrm{pdf} \\text{ for } {i \\le x}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Cmathrm%7BP%7D%28X%20%5Cle%20x%29%20%3D%20%5Csum_%7Bi%3D0%2Cx%7D%20%5Cmathrm%7Bpdf%7D%20%5Ctext%7B%20for%20%7D%20%7Bi%20%5Cle%20x%7D "\mathrm{P}(X \le x) = \sum_{i=0,x} \mathrm{pdf} \text{ for } {i \le x}")

3.  Finally, calculate:

![\\mathrm{P}(X > x) = 1 - \\mathrm{P}(X \\le x) \\text{; i.e. } (1) - (2)](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Cmathrm%7BP%7D%28X%20%3E%20x%29%20%3D%201%20-%20%5Cmathrm%7BP%7D%28X%20%5Cle%20x%29%20%5Ctext%7B%3B%20i.e.%20%7D%20%281%29%20-%20%282%29 "\mathrm{P}(X > x) = 1 - \mathrm{P}(X \le x) \text{; i.e. } (1) - (2)")

which is provided by `probOfAtLeastK`.

## Example 1: Mathematical Proof

Load Package…

``` r
library(billmillr)
```

Calculate the likelihood of a streak of at least 5 heads out of 10 coin
tosses given that the probability p (q) of heads (tails) is fair, i.e. p
= q = 0.5.

``` r
pS <- oddsOfStreak(numCoins = 10, minHeads = 5, probHeads = 0.5)
pS
#> [1] 0.109375

# # Example from "The Drunkard's Walk: How Randomness Rules Our Lives"
# tictoc::tic()
# oddsOfStreak(40, 15, 0.5) # p = 0.000411981; NOTE: for the @Risk simulation, we got 0.0002 - i.e. this is within bounds.
# tictoc::toc() # 24713.89 sec elapsed (6.865 hours)
```

Now calculate the probability that at least 1 out of 5 people will
obtain such a streak given that the probability of said streak is
0.109375.

``` r
pK <- probOfAtLeastK(N = 5, K = 1, P = pS)
pK
#> [1] 0.4396306

# # Example from "The Drunkard's Walk: How Randomness Rules Our Lives" continued...
# # Result (1): P(X = k) where k = 0
# choose(n, k)*(p**k)*((1-p)**(n-k))
# # P(X = 0) ~= 0.66 => P(X > 0) ~= 1 - 0.66 = 0.33
```

## Example 2: Simulation

Run a simulation on the problem, and return the set of resulting data

``` r
sim_data <- run_simulation(iters = 5000)
tail(sim_data)
#>      iteration applicable_trials prob_of_zero
#> 4995      4995                 0     0.667067
#> 4996      4996                 0     0.667134
#> 4997      4997                 2     0.667000
#> 4998      4998                 0     0.667067
#> 4999      4999                 0     0.667133
#> 5000      5000                 0     0.667200
```

Plot the probability convergence of the simulation results

``` r
plot(x = sim_data$iteration, y = sim_data$prob_of_zero, type = "l", col = "red",
     main = "Probability Convergence", xlab = "iterations", ylab = "probability")
```

![](README_files/figure-gfm/plot-results-1.png)<!-- -->

Calculate the probability of obtaining zero streaks…

``` r
tail(sim_data, n = 1)
#>      iteration applicable_trials prob_of_zero
#> 5000      5000                 0       0.6672
nrow(sim_data[which(sim_data$applicable_trials == 0), ]) / nrow(sim_data)
#> [1] 0.6672
```

…followed by the probability of at least 1 streak.

``` r
# Probability of at least 1 streak; i.e. 1 - P(0)
1 - (nrow(sim_data[which(sim_data$applicable_trials == 0), ]) / nrow(sim_data))
#> [1] 0.3328
```
