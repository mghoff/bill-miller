# billmillr 0.1.0

* Added a `NEWS.md` file to track changes to the package.
* Created package scaffolding: functions & documentation.

# billmillr 0.2.0

* Added functions & documentation for the simulation solution.

# billmillr 0.2.1

* Converted analytics functions to use lower snake case.
* Updated documentation based on rstudio::conf(2022) pkg development workshop.

# billmiller 0.2.5

* Built and published pkgdown site to GitHub pages: https://mghoff.github.io/billmillr/
* Function Updates:
  * Added argument checks to functions.
  * Stripped defaults from mandatory function arguments.
  * Optimized for performance.
  * Abstracted simulation set of functions to take either numeric or character args.
  * Added sample_probs arg to simulation set of functions:
    * custom vector of sample probabilities to go alongside the provided sample space.
  * Added `prob_of_ge_one` column to `run_simulation()` output data frame.
* README Updates:
  * Re-wrote narrative/motivation for the package.
  * Stripped out bottom section with advent of `prob_of_ge_one`.
