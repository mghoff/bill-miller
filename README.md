
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

This package provides functions & documentation for solving “The Bill
Miller Problem” presented within the book entitled *The Drunkard’s Walk:
How Randomness Rules Our Lives*, written by Leonard Mlodinow. More
generally, the functions herein can be used to solve for, either
analytically or by simulation, the likelihood of obtaining a winning
streak of given length within a given number of attempts, attempted by a
specified number of individuals.

The premise of this story goes that Bill Miller (financier) was an
amazing stock picker after having performed incredibly well - beating
the market - defined as outperforming the S&P500 - each year over 15
consecutive years. As a result, he was celebrated and acclaimed by the
likes of Forbes and others, who claimed that the likelihood of his
ability to perform this well was 1 in 32,768, or \~0.0032%, which is
roughly true is one considers only the individual, Bill Miller, picking
stocks.

However, what Dr. Mlodinow understands is that there are many hedge
funds all picking stocks and based on this fact, poses the question:
“Out of 1000 stock pickers (coin tossers), what are the odds that 1 of
them beats the market over 15 consecutive years?” The answer to which is
roughly 3%.

Dr. Mlodinow then further refines this calculation by considering the
scenario of beating the market 15 years consecutively or longer over a
40 year period; i.e. over 40 years and with 1000 traders, what is the
probability that at least 1 trader will obtain a winning streak of at
least 15 years with the odds of winning in a given year equal to 0.5.
Based on this refinement, Dr. Mlodinow claims the odds are roughly 3 out
of 4, or 75%; however, he provides no proof or evidence of this claim.

**The resulting likelihood for any one person to beat the market within
a definite start and stop time of at least 15 years in a single 40 year
period, while larger than the 3% of his first calculation, is much
smaller than the final proposed result of \~75%, which this package has
been built to answer and results in a value of \~33%.**

## The Math

#### Part 1:

One must compute the odds of getting a run (Streak) of at least k heads
out of N coin tosses where p (q = 1-p) is the probability of obtaining
heads (tails) from the toss of a coin.

Mathematically,

![](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;S%5BN%2C%20K%5D%20%3D%20p%5Ek%20%2B%20%5Csum_%7Bj%3D1%2C%20K%7D%20%5C%7B%20p%5E%7B%28j-1%29%7D%20%281-p%29%20S%5BN-j%2C%20K%5D%20%5C%7D)

which can be broken down recursively into the sum of terms:

![](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;S%5Bn%2C%20k%5D%20%3D%20p%5Ek%20%2B%20...%20%3D%20%5Csum_%7Bj%3D1%2C%20k%7D%20%5C%7B%20p%5E%7B%28j-1%29%7D%20%281-p%29%20S%5Bn-j%2C%20k%5D%20%5C%7D%20%5Ctext%7B%20for%20%7D%201%20%5Cle%20j%20%5Cle%20k)

which is provided by `odds_of_streak()`.

For more information on the math behind this recursive odds calculation,
see this [Ask A
Mathematician](https://www.askamathematician.com/2010/07/q-whats-the-chance-of-getting-a-run-of-k-successes-in-n-bernoulli-trials-why-use-approximations-when-the-exact-answer-is-known/)
post.

#### Part 2:

To calculate the likelihood that at least k out of M people will obtain
a streak of at least j heads out of N coin tosses, one must perform the
following:

1.  Calculate the PDF:

![](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Cmathrm%7BP%7D%28M%20%3D%20k%29%20%3D%20%7BM%20%5Cchoose%20k%7Dp%5E%7Bk%7D%281-p%29%5E%7B%28M-k%29%7D)

Again, this is provided by `odds_of_streak()`.

2.  Then, calculate the CDF:

![](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Cmathrm%7BP%7D%28X%20%5Cle%20x%29%20%3D%20%5Csum_%7Bi%3D0%2Cx%7D%20%5Cmathrm%7Bpdf%7D%20%5Ctext%7B%20for%20%7D%20%7Bi%20%5Cle%20x%7D)

3.  And, finally, calculate the final result:

![](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;%5Cmathrm%7BP%7D%28X%20%3E%20x%29%20%3D%201%20-%20%5Cmathrm%7BP%7D%28X%20%5Cle%20x%29%20%5Ctext%7B%3B%20i.e.%20%7D%201%20-%20%282%29)

which is provided by `prob_of_at_least_k()`.

### Example 1: Mathematical Proof

Load Package…

``` r
library(billmillr)
```

Calculate the likelihood of obtaining a winning streak of at least 3
heads out of 5 coin tosses given that the probability p (q) of heads
(tails) is fair, i.e. p = q = 0.5.

``` r
pS <- odds_of_streak(num_coins = 5, min_heads = 3, prob_heads = 0.5)
pS
#> [1] 0.25

### NOTE:
# Example from "The Drunkard's Walk: How Randomness Rules Our Lives"
# tictoc::tic()
# odds_of_streak(40, 15, 0.5) = 0.000411981
# tictoc::toc() # 24713.89 sec elapsed (6.865 hours)
```

Now calculate the probability that at least 1 person out of 8 people
will obtain such a winning streak of 3 heads given that the probability
of said streak is 0.25.

``` r
pK <- prob_of_at_least_k(N = 8, K = 1, p = pS)
pK
#> [1] 0.8998871

### NOTE:
# Example from "The Drunkard's Walk: How Randomness Rules Our Lives" continued...
# Result (1): P(X = k) where k = 0 is calculated as choose(n, k)*(p**k)*((1-p)**(n-k))
# P(X = 0) ~= 0.66 => P(X > 0) ~= 1 - 0.66 = 0.33
```

### Example 2: Simulation

Run a simulation on the problem, and return the set of resulting data

``` r
set.seed(1234)
sim_data <- run_simulation(
  iters = 5000,
  trials = 8,
  sample_space = c(0, 1),
  sample_size = 5,
  run_value = 1,
  run_length = 3
  )

tail(sim_data)
#>      iterations applicable_trials prob_of_zero prob_of_ge_one
#> 4995       4995                 0    0.1017017      0.8982983
#> 4996       4996                 2    0.1016813      0.8983187
#> 4997       4997                 0    0.1018611      0.8981389
#> 4998       4998                 1    0.1018407      0.8981593
#> 4999       4999                 1    0.1018204      0.8981796
#> 5000       5000                 0    0.1020000      0.8980000
```

Plot the probability convergence of the simulation results
<p>
<img src="man/figures/README-fig1.png" class="centering" width="80%">
</p>
