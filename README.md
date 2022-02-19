# bill-miller
This repo calculates "The Bill Miller Problem" from Leonard Mlodinow's "The Drunkard's Walk: *How Randomness Rules Our Lives*".

The premise goes that Bill Miller (financier), in hindsight, was an amazing stock picker, and after having performed incredibly well over 15 years, was celebrated by the likes of Forbes and others, claiming the likelihood of his ability to perform well was 1 in 32,768. Dr., Mlodinow ups this likelihood, stating that the probability that any 1 person among 1000 who started "tossing coins" (i.e. picking stocks) was closer to 3%.

Dr. Mlodinow further ups the probability, considering the likelihood of any 1 person over a 40 year period seeing that level of success - defined as beating the market for 15 years or longer (in a row!) in a 40 year period - and calculating *it* at around 3 out of 4, or 75%.

This R script reconsiders Dr. Mlodinow's last calculation, but attempts to consider truly individual/independent coin tossers with hard start and stop periods for each. 

**The resulting likelihood for any one person to beat the market within a definite start and stop time of at least 15 years in a single 40 year period, while larger thn the 3% of his second calculation, is much smaller than the final proposed calc of ~75%, coming in at ~33%.**