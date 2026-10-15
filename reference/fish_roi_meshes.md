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

Since September 2026 fish2 ROI meshes are returned from neuprint in nm
(previously they were in raw 16 x 16 x 15 nm voxel space). For
`units="raw"` they are scaled down by these voxel dimensions.

## See also

[`neuprint_ROI_mesh`](https://natverse.org/neuprintr/reference/neuprint_ROI_mesh.html),
[`nlapply`](https://rdrr.io/pkg/nat/man/nlapply.html),
[`fish_rois`](https://flyconnectome.github.io/fishr/reference/fish_rois.md)

Other 3d-meshes-skeletons:
[`fish_rois()`](https://flyconnectome.github.io/fishr/reference/fish_rois.md),
[`read_fish_meshes()`](https://flyconnectome.github.io/fishr/reference/read_fish_meshes.md),
[`read_fish_neurons()`](https://flyconnectome.github.io/fishr/reference/read_fish_neurons.md)

## Examples

``` r
# \donttest{
fish_roi_meshes(c("Midbrain", "Hindbrain"), .progress = "none")
#>  shapelist3d object with 2 items:
#> [[1]] mesh3d object with 288612 vertices, 577186 triangles.
#> [[2]] mesh3d object with 282739 vertices, 565580 triangles.
# }
```
