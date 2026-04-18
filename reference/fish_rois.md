# Fetch the ROI hierarchy for fish2

Fetch the ROI hierarchy for fish2

## Usage

``` r
fish_rois(
  root = NULL,
  rval = c("edgelist", "graph"),
  cache = FALSE,
  conn = NULL,
  ...,
  dataset = fish_default_dataset()
)
```

## Arguments

- root:

  Character vector specifying a root ROI. The default (`NULL`) returns
  the whole hierarchy.

- rval:

  Whether to return an edge list `data.frame` (default) or an `igraph`
  object.

- cache:

  if `TRUE` will use memoisation to cache the result of the call for 24
  hours.

- conn:

  Optional, a `neuprint_connection` object. Defaults to
  [`fish_neuprint`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md)
  to ensure that the query targets fish2.

- ...:

  Additional arguments passed to
  [`neuprint_ROI_hierarchy`](https://natverse.org/neuprintr/reference/neuprint_ROI_hierarchy.html).

- dataset:

  optional, a dataset you want to query. If `NULL`, the default
  specified by your R environ file is used or, failing that the current
  connection, is used. See
  [`neuprint_login`](https://natverse.org/neuprintr/reference/neuprint_login.html)
  for details.

## Value

The ROI hierarchy as either an edge list or `igraph` object.

## See also

[`neuprint_ROI_hierarchy`](https://natverse.org/neuprintr/reference/neuprint_ROI_hierarchy.html),
[`fish_roi_meshes`](https://flyconnectome.github.io/fishr/reference/fish_roi_meshes.md)

Other 3d-meshes-skeletons:
[`fish_roi_meshes()`](https://flyconnectome.github.io/fishr/reference/fish_roi_meshes.md),
[`read_fish_meshes()`](https://flyconnectome.github.io/fishr/reference/read_fish_meshes.md),
[`read_fish_neurons()`](https://flyconnectome.github.io/fishr/reference/read_fish_neurons.md)

## Examples

``` r
# \donttest{
head(fish_rois())
#>      parent            roi
#> 1     fish2          Brain
#> 2     Brain           Mece
#> 3      Mece         Retina
#> 4      Mece      Forebrain
#> 5 Forebrain Olfactory_Bulb
#> 6 Forebrain  Telencephalon
# }
```
