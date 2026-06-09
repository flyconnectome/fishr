# Convert xyz points between fish2 coordinate systems

fish2 uses three distinct voxel scales that all turn up in day-to-day
work: nm (the canonical unit for spatial transforms like
[`mirror_fish`](https://flyconnectome.github.io/fishr/reference/mirror_fish.md)),
raw (the (16, 16, 15) nm voxel grid stored in neuprint's `somaLocation`
and friends, and accepted by the DVID `segmentation/labels` endpoint),
and emraw (the (8, 8, 30) nm voxel grid of the EM imagery and the Clio /
Neuroglancer URL conventions). `fish_coords` converts between any of
these, plus microns.

## Usage

``` r
fish_coords(xyz, from = "nm", to = "nm", as_character = FALSE)
```

## Arguments

- xyz:

  Point coordinates. Anything accepted by
  [`xyzmatrix`](https://rdrr.io/pkg/nat/man/xyzmatrix.html) (vector,
  matrix, data.frame, "x,y,z" strings).

- from, to:

  Source and target units. One of `"nm"` (default), `"raw"` (16, 16, 15
  nm voxels, the neuprint grid), `"emraw"` (8, 8, 30 nm voxels, the EM
  acquisition grid), `"microns"`.

- as_character:

  If `TRUE`, return a character vector of `"x,y,z"` strings via
  [`xyzmatrix2str`](https://rdrr.io/pkg/nat/man/xyzmatrix.html).

## Value

An Nx3 numeric matrix in the requested units, or a character vector when
`as_character = TRUE`.

## Details

fish2 has two "raw" voxel grids. `raw` is the (16, 16, 15) nm grid used
by neuprint (it stores `somaLocation` and friends in raw, and the DVID
`segmentation/labels` endpoint accepts raw coordinates). `emraw` is the
(8, 8, 30) nm acquisition grid of the EM imagery and the convention used
in Clio / Neuroglancer URLs. The two grids differ per axis (emraw is
twice the XY resolution of raw and half the Z resolution):
`emraw = raw * c(2, 2, 0.5)`.

## See also

[`fish_xyz2bodyid`](https://flyconnectome.github.io/fishr/reference/fish_xyz2bodyid.md)

Other coords:
[`fish_xyz2bodyid()`](https://flyconnectome.github.io/fishr/reference/fish_xyz2bodyid.md)

## Examples

``` r
# neuprint "raw" -> EM "emraw"
fish_coords(c(57780, 28028, 10984), from = "raw", to = "emraw")
#>           X     Y    Z
#> [1,] 115560 56056 5492

# emraw -> nm
fish_coords(c(115560, 56056, 5492), from = "emraw", to = "nm")
#>           X      Y      Z
#> [1,] 924480 448448 164760

# batch + character output
fish_coords(rbind(c(115560, 56056, 5492), c(0, 0, 0)),
            from = "emraw", to = "raw", as_character = TRUE)
#> [1] "57780,28028,10984" "0,0,0"            
```
