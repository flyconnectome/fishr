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

Other neuprint:
[`fish_connection_table()`](https://flyconnectome.github.io/fishr/reference/fish_connection_table.md),
[`fish_neuprint()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md),
[`fish_roi_meshes()`](https://flyconnectome.github.io/fishr/reference/fish_roi_meshes.md),
[`fish_rois()`](https://flyconnectome.github.io/fishr/reference/fish_rois.md)

## Examples

``` r
# \donttest{
head(fish_neuprint_meta("RGC"))
#>      bodyid post pre downstream upstream synweight    statusLabel
#> 1 110888244    2 287        318        2       320 Sensory Anchor
#> 2 110916137    2 141        149        2       151 Sensory Anchor
#> 3 110958352    1  62         70        1        71 Sensory Anchor
#> 4 100009896    2  89         90        2        92 Sensory Anchor
#> 5 100015071    0 128        135        0       135 Sensory Anchor
#> 6 100015468    2 290        316        2       318 Sensory Anchor
#>   connectivityType  name type perNodeSc group class keywords comment
#> 1             <NA> RGC_R  RGC        NA     0  <NA>     <NA>    <NA>
#> 2             <NA> RGC_R  RGC        NA     0  <NA>     <NA>    <NA>
#> 3             <NA> RGC_R  RGC        NA     0  <NA>     <NA>    <NA>
#> 4             <NA> RGC_R  RGC        NA     0  <NA>     <NA>    <NA>
#> 5             <NA> RGC_R  RGC        NA     0  <NA>     <NA>    <NA>
#> 6             <NA> RGC_R  RGC        NA     0  <NA>     <NA>    <NA>
#>   somaLocation somaId somaVoxels zapbenchId closestLandmarkLocation
#> 1                  NA         NA         NA                    <NA>
#> 2                  NA         NA         NA                    <NA>
#> 3                  NA         NA         NA                    <NA>
#> 4                  NA         NA         NA                    <NA>
#> 5                  NA         NA         NA                    <NA>
#> 6                  NA         NA         NA                    <NA>
#>   closestLandmarkDistanceMicrons tosomaLocation status  voxels  soma
#> 1                             NA           <NA> Anchor 8805954 FALSE
#> 2                             NA           <NA> Anchor 5075924 FALSE
#> 3                             NA           <NA> Anchor 3678756 FALSE
#> 4                             NA           <NA> Anchor 6228154 FALSE
#> 5                             NA           <NA> Anchor 5774341 FALSE
#> 6                             NA           <NA> Anchor 9488378 FALSE
# }
```
