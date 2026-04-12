# Interactive setup helper for fish2 authentication

`fish_setup()` checks whether the current R session is set up for the
fish2 neuprint server and can write the recommended `neuprint_*`
variables to the user's `.Renviron` file.

## Usage

``` r
fish_setup(set_session = interactive())
```

## Arguments

- set_session:

  Whether to apply any saved values to the current R session via
  [`Sys.setenv`](https://rdrr.io/r/base/Sys.setenv.html) (default
  `TRUE`).

## Value

Invisibly returns a list describing the detected configuration and any
values written to `.Renviron`.

## Details

The setup helper uses lowercase `neuprint_*` environment variables by
default because that is still the most common convention across the
natverse. It will also detect uppercase variants and report them to the
user.

If you choose to save settings, `fish_setup()` writes directly to the
user `.Renviron` file and, by default, also sets the same variables in
the current session so that things work immediately.

## See also

Other fishr-package:
[`fish_dvid_annotations()`](https://flyconnectome.github.io/fishr/reference/fish_dvid_annotations.md),
[`fish_ids()`](https://flyconnectome.github.io/fishr/reference/fish_ids.md),
[`read_fish_meshes()`](https://flyconnectome.github.io/fishr/reference/read_fish_meshes.md),
[`with_fish()`](https://flyconnectome.github.io/fishr/reference/with_fish.md)

## Examples

``` r
if (FALSE) { # \dontrun{
fish_setup()
} # }
```
