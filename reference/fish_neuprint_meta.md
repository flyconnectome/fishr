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
#>      bodyid post pre downstream upstream synweight axonIn dendriteIn axonOut
#> 1 110847565   13 102        105       13       118     10          3     105
#> 2 111011778   14 147        158       14       172     13          1     158
#> 3 100046022   21 194        202       21       223     19          2     202
#> 4 100061403   36 168        177       36       213     34          2     177
#> 5 100063360   55 309        334       55       389     52          3     334
#> 6 100106910   12 142        148       12       160     11          1     148
#>   dendriteOut nsoma somaSide    statusLabel group  name type
#> 1           0     0     <NA> Sensory Anchor     0 RGC_R  RGC
#> 2           0     0     <NA> Sensory Anchor     0 RGC_R  RGC
#> 3           0     0     <NA> Sensory Anchor     0 RGC_R  RGC
#> 4           0     0     <NA> Sensory Anchor     0 RGC_R  RGC
#> 5           0     0     <NA> Sensory Anchor     0 RGC_R  RGC
#> 6           0     0     <NA> Sensory Anchor     0 RGC_R  RGC
#>   connectivityTypeV11 connectivityType perNodeSc proposedType keywords class
#> 1                <NA>             <NA>        NA         <NA>     <NA>  <NA>
#> 2                <NA>             <NA>        NA         <NA>     <NA>  <NA>
#> 3                <NA>             <NA>        NA         <NA>     <NA>  <NA>
#> 4                <NA>             <NA>        NA         <NA>     <NA>  <NA>
#> 5                <NA>             <NA>        NA         <NA>     <NA>  <NA>
#> 6                <NA>             <NA>        NA         <NA>     <NA>  <NA>
#>   comment somaLocation somaId somaVoxels zapbenchId
#> 1    <NA>         <NA>     NA         NA         NA
#> 2    <NA>         <NA>     NA         NA         NA
#> 3    <NA>         <NA>     NA         NA         NA
#> 4    <NA>         <NA>     NA         NA         NA
#> 5    <NA>         <NA>     NA         NA         NA
#> 6    <NA>         <NA>     NA         NA         NA
#>   closestLandmarkDistanceMicrons tosomaLocation status  voxels  soma
#> 1                             NA           <NA> Anchor 4580954 FALSE
#> 2                             NA           <NA> Anchor 4697626 FALSE
#> 3                             NA           <NA> Anchor 5945526 FALSE
#> 4                             NA           <NA> Anchor 7070914 FALSE
#> 5                             NA           <NA> Anchor 8442180 FALSE
#> 6                             NA           <NA> Anchor 6493266 FALSE
# }
```
