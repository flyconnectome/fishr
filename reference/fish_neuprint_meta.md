# Fetch neuprint metadata for fish2 neurons

Fetch neuprint metadata for fish2 neurons

## Usage

``` r
fish_neuprint_meta(
  ids = NULL,
  conn = NULL,
  roiInfo = FALSE,
  simplify.xyz = TRUE,
  ...,
  dataset = fish_default_dataset()
)
```

## Arguments

- ids:

  Body ids, a query string (see
  [`fish_ids`](https://flyconnectome.github.io/fishr/reference/fish_ids.md)),
  or `NULL` to return all bodies known to neuprint.

- conn:

  Optional, a `neuprint_connection` object. Defaults to
  [`fish_neuprint`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md)
  to ensure that the query targets fish2.

- roiInfo:

  Whether to include ROI information (default `FALSE`).

- simplify.xyz:

  Whether to simplify columns containing XYZ locations to a simple
  `"x,y,z"` format (default `TRUE`).

- ...:

  Additional arguments passed to
  [`neuprint_get_meta`](https://natverse.org/neuprintr/reference/neuprint_get_meta.html).

- dataset:

  The name of the dataset as reported in Clio (default `"fish2"`).

## Value

A data.frame with one row for each unique input id and `NA`s for all
columns except `bodyid` when neuprint holds no metadata.

## See also

[`manc_neuprint_meta`](https://natverse.org/malevnc/reference/manc_neuprint_meta.html)

Other data-queries:
[`fish_connection_table()`](https://flyconnectome.github.io/fishr/reference/fish_connection_table.md),
[`fish_ids()`](https://flyconnectome.github.io/fishr/reference/fish_ids.md),
[`register_fish_coconat()`](https://flyconnectome.github.io/fishr/reference/register_fish_coconat.md)

## Examples

``` r
# \donttest{
head(fish_neuprint_meta("RGC"))
#>      bodyid post pre downstream upstream synweight connectivityType perNodeSc
#> 1 110888244    2 287        318        2       320             <NA>        NA
#> 2 110916137    2 141        149        2       151             <NA>        NA
#> 3 110958352    1  62         70        1        71             <NA>        NA
#> 4 100009896    2  89         90        2        92             <NA>        NA
#> 5 100015071    0 128        135        0       135             <NA>        NA
#> 6 100015468    2 290        316        2       318             <NA>        NA
#>      statusLabel  name type group class keywords comment somaLocation somaId
#> 1 Sensory Anchor RGC_R  RGC     0  <NA>     <NA>    <NA>                  NA
#> 2 Sensory Anchor RGC_R  RGC     0  <NA>     <NA>    <NA>                  NA
#> 3 Sensory Anchor RGC_R  RGC     0  <NA>     <NA>    <NA>                  NA
#> 4 Sensory Anchor RGC_R  RGC     0  <NA>     <NA>    <NA>                  NA
#> 5 Sensory Anchor RGC_R  RGC     0  <NA>     <NA>    <NA>                  NA
#> 6 Sensory Anchor RGC_R  RGC     0  <NA>     <NA>    <NA>                  NA
#>   somaVoxels zapbenchId closestLandmarkLocation closestLandmarkDistanceMicrons
#> 1         NA         NA                    <NA>                             NA
#> 2         NA         NA                    <NA>                             NA
#> 3         NA         NA                    <NA>                             NA
#> 4         NA         NA                    <NA>                             NA
#> 5         NA         NA                    <NA>                             NA
#> 6         NA         NA                    <NA>                             NA
#>   tosomaLocation status  voxels  soma
#> 1           <NA> Anchor 8805954 FALSE
#> 2           <NA> Anchor 5075924 FALSE
#> 3           <NA> Anchor 3678756 FALSE
#> 4           <NA> Anchor 6228154 FALSE
#> 5           <NA> Anchor 5774341 FALSE
#> 6           <NA> Anchor 9488378 FALSE
# }
```
