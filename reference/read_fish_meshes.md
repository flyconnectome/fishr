# Read meshes for fish2 body ids

Fetches pre-computed neuroglancer meshes from the fish2 DVID server.

## Usage

``` r
read_fish_meshes(ids, node = "neutu", units = c("nm", "raw", "microns"), ...)
```

## Arguments

- ids:

  One or more body ids (numeric or character), or a query string
  accepted by
  [`fish_ids`](https://flyconnectome.github.io/fishr/reference/fish_ids.md).

- node:

  The DVID node (UUID) to query. The default value of 'neutu' uses the
  active neutu node i.e. normally the most up to date.

- units:

  One of `"nm"` (default), `"raw"` (nominal voxel size), or `"microns"`.

- ...:

  Additional arguments passed to
  [`httr::GET`](https://httr.r-lib.org/reference/GET.html).

## Value

A [`neuronlist`](https://rdrr.io/pkg/nat/man/neuronlist.html) containing
one or more `mesh3d` objects.

## Details

It seems that the nominal voxel dimensions of the fish2 dataset are 16 x
16 x 15 nm. Neuron meshes are already returned from DVID in physical nm
scale but this voxel dimension is required to turn raw neuroglancer
coordinates into nm. This means that if you click on a neuron in
neuroglancer, the recorded location will match if you have chosen
\`units="nm"\`. Alternatively you must multiply point locations from
neuroglancer by c(16,16,15) to obtain points in nm space.

## See also

Other 3d-meshes-skeletons:
[`fish_roi_meshes()`](https://flyconnectome.github.io/fishr/reference/fish_roi_meshes.md),
[`fish_rois()`](https://flyconnectome.github.io/fishr/reference/fish_rois.md),
[`read_fish_neurons()`](https://flyconnectome.github.io/fishr/reference/read_fish_neurons.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# pick 10 RGC meshes to read in
rgcs <- read_fish_meshes(fish_ids('RGC')[1:10])
plot3d(rgcs)
} # }
```
