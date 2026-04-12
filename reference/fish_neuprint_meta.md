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
#>      bodyid post pre downstream upstream synweight    statusLabel  name type
#> 1 109786996    5 297        316        5       321 Sensory Anchor RGC_R  RGC
#> 2 100009896    2  89         90        2        92 Sensory Anchor RGC_R  RGC
#> 3 100015071    0 128        135        0       135 Sensory Anchor RGC_R  RGC
#> 4 100015468    2 290        316        2       318 Sensory Anchor RGC_R  RGC
#> 5 100017513    7 245        252        7       259 Sensory Anchor RGC_R  RGC
#> 6 100023948    1 167        173        1       174 Sensory Anchor RGC_R  RGC
#>   connectivityType group class keywords comment somaLocation somaId somaVoxels
#> 1             <NA>     0  <NA>     <NA>    <NA>                  NA         NA
#> 2             <NA>     0  <NA>     <NA>    <NA>                  NA         NA
#> 3             <NA>     0  <NA>     <NA>    <NA>                  NA         NA
#> 4             <NA>     0  <NA>     <NA>    <NA>                  NA         NA
#> 5             <NA>     0  <NA>     <NA>    <NA>                  NA         NA
#> 6             <NA>     0  <NA>     <NA>    <NA>                  NA         NA
#>   zapbenchId closestLandmarkLocation closestLandmarkDistanceMicrons
#> 1         NA                    <NA>                             NA
#> 2         NA                    <NA>                             NA
#> 3         NA                    <NA>                             NA
#> 4         NA                    <NA>                             NA
#> 5         NA                    <NA>                             NA
#> 6         NA                    <NA>                             NA
#>   tosomaLocation status   voxels  soma
#> 1           <NA> Anchor  9793912 FALSE
#> 2           <NA> Anchor  6228154 FALSE
#> 3           <NA> Anchor  5774341 FALSE
#> 4           <NA> Anchor  9488378 FALSE
#> 5           <NA> Anchor 10752622 FALSE
#> 6           <NA> Anchor  6913578 FALSE
# }
```
