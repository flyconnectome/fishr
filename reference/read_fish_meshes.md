# Read meshes for fish2 body ids

Fetches pre-computed neuroglancer meshes from the fish2 DVID server.
Meshes are returned in nm coordinates by default (8 nm voxels).

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

  One of `"nm"` (default), `"raw"` (8 nm voxels), or `"microns"`.

- ...:

  Additional arguments passed to
  [`httr::GET`](https://httr.r-lib.org/reference/GET.html).

## Value

A [`neuronlist`](https://rdrr.io/pkg/nat/man/neuronlist.html) containing
one or more `mesh3d` objects.

## See also

Other fishr-package:
[`fish_dvid_annotations()`](https://flyconnectome.github.io/fishr/reference/fish_dvid_annotations.md),
[`fish_ids()`](https://flyconnectome.github.io/fishr/reference/fish_ids.md),
[`fish_setup()`](https://flyconnectome.github.io/fishr/reference/fish_setup.md),
[`with_fish()`](https://flyconnectome.github.io/fishr/reference/with_fish.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# pick 10 RGC meshes to read in
rgcs <- read_fish_meshes(fish_ids('RGC')[1:10])
plot3d(rgcs)
} # }
```
