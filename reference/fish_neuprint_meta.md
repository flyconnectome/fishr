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
#>      bodyid post pre downstream upstream synweight connectivityType perNodeSc
#> 1 111554667    1 213        223        1       224             <NA>        NA
#> 2 111584814    0 259        282        0       282             <NA>        NA
#> 3 111627703    1 258        282        1       283             <NA>        NA
#> 4 111636789    0 124        127        0       127             <NA>        NA
#> 5 111647724    2 257        296        2       298             <NA>        NA
#> 6 111656787    3 167        172        3       175             <NA>        NA
#>      statusLabel group  name type class keywords comment somaLocation somaId
#> 1 Sensory Anchor     0 RGC_R  RGC  <NA>     <NA>    <NA>                  NA
#> 2 Sensory Anchor     0 RGC_R  RGC  <NA>     <NA>    <NA>                  NA
#> 3 Sensory Anchor     0 RGC_R  RGC  <NA>     <NA>    <NA>                  NA
#> 4 Sensory Anchor     0 RGC_R  RGC  <NA>     <NA>    <NA>                  NA
#> 5 Sensory Anchor     0 RGC_R  RGC  <NA>     <NA>    <NA>                  NA
#> 6 Sensory Anchor     0 RGC_R  RGC  <NA>     <NA>    <NA>                  NA
#>   somaVoxels zapbenchId closestLandmarkLocation closestLandmarkDistanceMicrons
#> 1         NA         NA                    <NA>                             NA
#> 2         NA         NA                    <NA>                             NA
#> 3         NA         NA                    <NA>                             NA
#> 4         NA         NA                    <NA>                             NA
#> 5         NA         NA                    <NA>                             NA
#> 6         NA         NA                    <NA>                             NA
#>   tosomaLocation status  voxels  soma
#> 1           <NA> Anchor 7777932 FALSE
#> 2           <NA> Anchor 8305652 FALSE
#> 3           <NA> Anchor 9189373 FALSE
#> 4           <NA> Anchor 5670692 FALSE
#> 5           <NA> Anchor 7134334 FALSE
#> 6           <NA> Anchor 8825884 FALSE
# }
```
