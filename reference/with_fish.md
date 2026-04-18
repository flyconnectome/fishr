# Evaluate an expression after temporarily setting malevnc options

`with_fish` temporarily changes the server/dataset options for the
`malevnc` package so that they target the fish2 dataset while running
your expression.

`choose_fish_dataset` sets the default dataset used by all `fish_*`
functions. It is the recommended way to access fish2 dataset variants.
Unlike `choose_fish` it does *not* permanently change the default
dataset used when callers use functions from the `malevnc` package
directly.

`choose_fish` swaps out the default `malevnc` dataset for the fish2
dataset. This means that all functions from the `malevnc` package should
target fish2 instead. It is recommended that you use `with_fish` to do
this temporarily unless you have no intention of using other FlyEM
datasets. *To switch the default fishr dataset please see
`choose_fish_dataset`*.

When Clio dataset lookup is unavailable, `choose_fish` falls back to a
built-in neuprint-only configuration for the main fish2 dataset.
Clio-backed functionality may be unavailable in that session.

## Usage

``` r
with_fish(expr, dataset = fish_default_dataset())

choose_fish_dataset(dataset = "fish2")

choose_fish(dataset = fish_default_dataset(), set = TRUE, use_clio = NA)
```

## Arguments

- expr:

  An expression involving `malevnc`/`fishr` functions to evaluate with
  the specified dataset.

- dataset:

  The name of the dataset as reported in Clio (default `"fish2"`).

- set:

  Whether to set the relevant package options or just to return a list
  of the required options.

- use_clio:

  Whether to use a live Clio lookup for fish dataset settings. The
  default `NA` first reuses any cached live lookup for the dataset,
  otherwise it tries Clio and falls back to baked-in fish2 neuprint
  settings when available. Use `FALSE` to avoid Clio and rely only on
  cached or built-in settings. Use `TRUE` to require a live Clio lookup.

## Value

`with_fish` returns the result of `expr`. `choose_fish` and
`choose_fish_dataset` return a named list of previous option values,
matching [`options`](https://rdrr.io/r/base/options.html).

## Details

`choose_fish` first tries a live Clio lookup via
[`malevnc::choose_flyem_dataset`](https://natverse.org/malevnc/reference/choose_malevnc_dataset.html).
If that fails (e.g. no network / no Clio token), it falls back to
baked-in neuprint settings. Clio-backed functions will be unavailable in
that fallback session.

## See also

[`choose_flyem_dataset`](https://natverse.org/malevnc/reference/choose_malevnc_dataset.html),
[`choose_malevnc_dataset`](https://natverse.org/malevnc/reference/choose_malevnc_dataset.html)

Other setup-data-access:
[`fish_neuprint()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md),
[`fish_setup()`](https://flyconnectome.github.io/fishr/reference/fish_setup.md),
[`fishr-package`](https://flyconnectome.github.io/fishr/reference/fishr-package.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# temporarily target fish2 for one call
with_fish(read_fish_meshes(12345))

# or set fish2 as the active dataset for the rest of the session
choose_fish()
read_fish_meshes(12345)
} # }
```
