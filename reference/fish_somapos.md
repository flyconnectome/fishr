# Soma positions and logical sides for fish2 neurons

`fish_somapos` returns the soma position of each requested body,
preferring the `somaLocation` field and falling back to `tosomaLocation`
where the former is missing.

`fish_soma_side` returns the logical side of each requested body in the
dataset. The side may be derived from a manual annotation (when one
exists), the instance name suffix, or the soma's position relative to
the fish2 midline.

## Usage

``` r
fish_somapos(ids, units = c("nm", "raw", "microns"), as_character = FALSE)

fish_soma_side(
  ids,
  method = c("auto", "manual", "instance", "position"),
  threshold = 0
)
```

## Arguments

- ids:

  Body ids, a query string (see
  [`fish_ids`](https://flyconnectome.github.io/fishr/reference/fish_ids.md)),
  or a metadata data.frame as returned by
  [`fish_neuprint_meta`](https://flyconnectome.github.io/fishr/reference/fish_neuprint_meta.md).

- units:

  Units for the returned coordinates. `"nm"` (the default) leaves the
  neuprint values unchanged; `"raw"` divides by the fish2 voxel size
  `(16, 16, 15)`; `"microns"` divides by 1000.

- as_character:

  If `TRUE`, return a character vector of `"x,y,z"` strings (the fishr
  convention for location columns). Default `FALSE`.

- method:

  One of `"auto"` (default), `"manual"`, `"instance"`, `"position"`. See
  Details.

- threshold:

  Absolute Y displacement (nm) below which `position` reports a soma as
  midline (`"M"`). Default `0`. Ignored by `instance` and `manual`.

## Value

`fish_somapos` returns an `Nx3` numeric matrix with columns `x`, `y`,
`z`, or a character vector of `"x,y,z"` strings when
`as_character = TRUE`. Bodies that have neither `somaLocation` nor
`tosomaLocation` produce `NA` rows.

`fish_soma_side` returns a character vector of `"L"`, `"R"`, `"M"`,
`"U"` or `NA`, one entry per input body.

## Details

The "side" returned by `fish_soma_side` is the \*\*logical\*\* side of
the neuron in the dataset, not necessarily the side of the physical
soma. For an ascending fibre entering the brain through a nerve from
outside the EM volume, the side reflects the entry point. Such a neuron
may have its soma on one side of the cord and cross to the other side
before entering the imaged volume; the assigned side will follow the
entry nerve, not the soma.

Methods for `fish_soma_side`:

- `auto`:

  Try `manual` first (when implemented), then fill remaining `NA`s with
  `instance`, then with `position`. At present, `manual` is not yet
  implemented, so `auto` chains `instance` -\> `position`.

- `manual`:

  Not yet implemented; errors. Will read a `somaSide` column once
  neuprintr exposes one.

- `instance`:

  Match `_([LRMU])$` against the `name` (or `instance`) column.

- `position`:

  Classify each soma by its signed displacement from the fish2 midline
  via
  [`fish_point_side`](https://flyconnectome.github.io/fishr/reference/fish_point_side.md).
  `threshold` is forwarded as-is; the default `0` means `position` never
  returns `"M"`. `"M"` is reserved for bilaterally symmetric unpaired
  neurons that should be flagged by their instance suffix.

## See also

[`fish_neuprint_meta`](https://flyconnectome.github.io/fishr/reference/fish_neuprint_meta.md),
[`fish_point_side`](https://flyconnectome.github.io/fishr/reference/fish_point_side.md),
[`mirror_fish`](https://flyconnectome.github.io/fishr/reference/mirror_fish.md)

Other data-queries:
[`fish_connection_table()`](https://flyconnectome.github.io/fishr/reference/fish_connection_table.md),
[`fish_ids()`](https://flyconnectome.github.io/fishr/reference/fish_ids.md),
[`fish_neuprint_meta()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint_meta.md),
[`register_fish_coconat()`](https://flyconnectome.github.io/fishr/reference/register_fish_coconat.md)

## Examples

``` r
# \donttest{
meta <- fish_neuprint_meta(109192746)
fish_somapos(meta)
#>           x      y      z
#> [1,] 898128 426816 158175
#> attr(,"scaled:scale")
#> [1] 0.06250000 0.06250000 0.06666667
fish_somapos(meta, units = "microns")
#>            x       y       z
#> [1,] 898.128 426.816 158.175
#> attr(,"scaled:scale")
#> [1] 62.50000 62.50000 66.66667
fish_soma_side(meta)
#> [1] "L"
# }
```
