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
#>      bodyid post pre downstream upstream synweight nsoma    statusLabel  name
#> 1 112060240    3 278        296        3       299     0 Sensory Anchor RGC_R
#> 2 112158645   10 222        230       10       240     0 Sensory Anchor RGC_R
#> 3 100009896    2  89         90        2        92     0 Sensory Anchor RGC_R
#> 4 100015071    0 128        135        0       135     0 Sensory Anchor RGC_R
#> 5 100015468    2 290        316        2       318     0 Sensory Anchor RGC_R
#> 6 100017513    7 245        252        7       259     0 Sensory Anchor RGC_R
#>   type group connectivityType perNodeSc proposedType keywords class comment
#> 1  RGC     0             <NA>        NA         <NA>     <NA>  <NA>    <NA>
#> 2  RGC     0             <NA>        NA         <NA>     <NA>  <NA>    <NA>
#> 3  RGC     0             <NA>        NA         <NA>     <NA>  <NA>    <NA>
#> 4  RGC     0             <NA>        NA         <NA>     <NA>  <NA>    <NA>
#> 5  RGC     0             <NA>        NA         <NA>     <NA>  <NA>    <NA>
#> 6  RGC     0             <NA>        NA         <NA>     <NA>  <NA>    <NA>
#>   somaLocation somaId somaVoxels zapbenchId closestLandmarkLocation
#> 1                  NA         NA         NA                    <NA>
#> 2                  NA         NA         NA                    <NA>
#> 3                  NA         NA         NA                    <NA>
#> 4                  NA         NA         NA                    <NA>
#> 5                  NA         NA         NA                    <NA>
#> 6                  NA         NA         NA                    <NA>
#>   closestLandmarkDistanceMicrons tosomaLocation status   voxels  soma
#> 1                             NA           <NA> Anchor  9665582 FALSE
#> 2                             NA           <NA> Anchor  8875806 FALSE
#> 3                             NA           <NA> Anchor  6228154 FALSE
#> 4                             NA           <NA> Anchor  5774341 FALSE
#> 5                             NA           <NA> Anchor  9488378 FALSE
#> 6                             NA           <NA> Anchor 10752622 FALSE
# }
```
