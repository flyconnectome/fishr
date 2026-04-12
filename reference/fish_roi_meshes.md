# Fetch one or more ROI meshes for fish2

Fetch one or more ROI meshes for fish2

## Usage

``` r
fish_roi_meshes(
  rois,
  units = c("nm", "raw", "microns"),
  conn = NULL,
  ...,
  dataset = fish_default_dataset()
)
```

## Arguments

- rois:

  Character vector of ROI names.

- units:

  One of `"nm"` (default), `"raw"` (voxels), or `"microns"`.

- conn:

  Optional, a `neuprint_connection` object. Defaults to
  [`fish_neuprint`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md)
  to ensure that the query targets fish2.

- ...:

  Additional arguments passed to
  [`nlapply`](https://rdrr.io/pkg/nat/man/nlapply.html). This allows
  progress reporting and simple parallelisation.

- dataset:

  The name of the dataset as reported in Clio (default `"fish2"`).

## Value

A `shapelist3d` containing one or more ROI `mesh3d` objects. Missing
meshes are dropped with a warning.

## Details

It seems that the nominal voxel dimensions of the dataset are 16 x 16 x
15 nm. ROI meshes are returned from neuprint in raw voxel space and are
scaled up by this factor to give the default nm scaling.

## See also

[`neuprint_ROI_mesh`](https://natverse.org/neuprintr/reference/neuprint_ROI_mesh.html),
[`nlapply`](https://rdrr.io/pkg/nat/man/nlapply.html),
[`fish_rois`](https://flyconnectome.github.io/fishr/reference/fish_rois.md)

Other neuprint:
[`fish_connection_table()`](https://flyconnectome.github.io/fishr/reference/fish_connection_table.md),
[`fish_neuprint()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md),
[`fish_neuprint_meta()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint_meta.md),
[`fish_rois()`](https://flyconnectome.github.io/fishr/reference/fish_rois.md)

## Examples

``` r
# \donttest{
fish_roi_meshes(c("Midbrain", "Hindbrain"), .progress = "none")
#>  shapelist3d object with 2 items:
#> [[1]] mesh3d object with 39619 vertices, 78938 triangles.
#> [[2]] mesh3d object with 38987 vertices, 77864 triangles.
# }
```
