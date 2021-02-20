
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {skyphone}

<!-- badges: start -->

[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
<!-- badges: end -->

The goal of {skyphone} is to create an audio version of [GitHub
Skyline](https://skyline.github.com/) in R.

Skyline is a novelty vanity webservice from GitHub. You input a username
and can ‘view a 3D model of your GitHub contribution graph.’ {skyphone}
fetches this data and puts it in a nice, tidy table that you can sonify
or plot.

Very much in development.

## Installation

You can install the development version of {skyphone} using {remotes}.

``` r
# install.packages("remotes")
remotes::install_github("skyphone")
```

## Examples

I’ll read in my own 2020 GitHub contributions from the Skyline API.

``` r
library(skyphone)
md <- sky_get("matt-dray", 2020)
md
#> # A tibble: 366 x 6
#>    user       year  week   day date       count
#>    <chr>     <int> <int> <int> <date>     <int>
#>  1 matt-dray  2020     1     1 2020-01-01     5
#>  2 matt-dray  2020     1     2 2020-01-02     5
#>  3 matt-dray  2020     1     3 2020-01-03     8
#>  4 matt-dray  2020     1     4 2020-01-04     3
#>  5 matt-dray  2020     2     5 2020-01-05     0
#>  6 matt-dray  2020     2     6 2020-01-06     7
#>  7 matt-dray  2020     2     7 2020-01-07    10
#>  8 matt-dray  2020     2     8 2020-01-08     2
#>  9 matt-dray  2020     2     9 2020-01-09     6
#> 10 matt-dray  2020     2    10 2020-01-10     0
#> # … with 356 more rows
```

You can make an audio version via the {sonify} package.

``` r
sky_sonify(md, play = FALSE, out_dir = NULL)
#> 
#> WaveMC Object
#>  Number of Samples:      220500
#>  Duration (seconds):     5
#>  Samplingrate (Hertz):   44100
#>  Number of channels:     2
#>  PCM (integer format):   TRUE
#>  Bit (8/16/24/32/64):    16
```

You can hear the output if you set `play = TRUE` and/or save the audio
file as a .wav to the folder provided by `out_dir`.

There’s also a simple, opinionated built-in plotting function.

``` r
sky_plot(md)
```

<img src="man/figures/README-example-plot-1.png" width="100%" />

## Thanks

To GitHub, obviously. To [Matt
Kerlogue](https://www.github.com/mattkerlogue) for the nerdsnipe. To Den
Delimarsky for [writing about the Skyline
API](https://den.dev/blog/get-github-contributions-api/).

## GitHub terms

You can read GitHub’s
[terms](https://docs.github.com/en/github/site-policy/github-terms-of-service),
[privacy](https://docs.github.com/en/github/site-policy/github-privacy-statement)
for their service.

## Code of Conduct

Please note that the skyphone project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
