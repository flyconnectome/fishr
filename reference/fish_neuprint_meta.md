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
[`fish_somapos()`](https://flyconnectome.github.io/fishr/reference/fish_somapos.md),
[`register_fish_coconat()`](https://flyconnectome.github.io/fishr/reference/register_fish_coconat.md)

## Examples

``` r
# \donttest{
head(fish_neuprint_meta("RGC"))
#>      bodyid post pre downstream upstream synweight nsoma    statusLabel
#> 1 110656660    8 219        229        8       237     0 Sensory Anchor
#> 2 100009896    2  89         90        2        92     0 Sensory Anchor
#> 3 100015071    0 128        135        0       135     0 Sensory Anchor
#> 4 100015468    2 290        316        2       318     0 Sensory Anchor
#> 5 100017513    7 245        252        7       259     0 Sensory Anchor
#> 6 100023948    1 167        173        1       174     0 Sensory Anchor
#>   somaSide connectivityType perNodeSc  name type group proposedType keywords
#> 1     <NA>             <NA>        NA RGC_R  RGC     0         <NA>     <NA>
#> 2     <NA>             <NA>        NA RGC_R  RGC     0         <NA>     <NA>
#> 3     <NA>             <NA>        NA RGC_R  RGC     0         <NA>     <NA>
#> 4     <NA>             <NA>        NA RGC_R  RGC     0         <NA>     <NA>
#> 5     <NA>             <NA>        NA RGC_R  RGC     0         <NA>     <NA>
#> 6     <NA>             <NA>        NA RGC_R  RGC     0         <NA>     <NA>
#>   class comment somaLocation somaId somaVoxels zapbenchId
#> 1  <NA>    <NA>                  NA         NA         NA
#> 2  <NA>    <NA>                  NA         NA         NA
#> 3  <NA>    <NA>                  NA         NA         NA
#> 4  <NA>    <NA>                  NA         NA         NA
#> 5  <NA>    <NA>                  NA         NA         NA
#> 6  <NA>    <NA>                  NA         NA         NA
#>   closestLandmarkLocation closestLandmarkDistanceMicrons tosomaLocation status
#> 1                    <NA>                             NA           <NA> Anchor
#> 2                    <NA>                             NA           <NA> Anchor
#> 3                    <NA>                             NA           <NA> Anchor
#> 4                    <NA>                             NA           <NA> Anchor
#> 5                    <NA>                             NA           <NA> Anchor
#> 6                    <NA>                             NA           <NA> Anchor
#>     voxels  soma
#> 1  9735937 FALSE
#> 2  6228154 FALSE
#> 3  5774341 FALSE
#> 4  9488378 FALSE
#> 5 10752622 FALSE
#> 6  6913578 FALSE
# }
```
