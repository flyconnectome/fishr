# Predict the L/R side of points in fish2 space

Applies the fish2 mirror transform to each input point and measures the
signed displacement along the mirror (Y) axis before and after
transform. The sign indicates which side of the midline the point lies
on.

## Usage

``` r
fish_point_side(
  xyz,
  units = c("nm", "raw", "emraw", "microns"),
  threshold = 5000,
  rval = c("side", "distance")
)
```

## Arguments

- xyz:

  Point coordinates. Anything accepted by
  [`xyzmatrix`](https://rdrr.io/pkg/nat/man/xyzmatrix.html) (matrix,
  data.frame, neuron, neuronlist), a length-3 numeric vector for a
  single point, or a character vector of comma-separated `"x,y,z"`
  strings (the fishr convention for location columns).

- units:

  Units of the input coordinates. `"nm"` (the default) matches
  [`mirror_fish`](https://flyconnectome.github.io/fishr/reference/mirror_fish.md);
  `"raw"`, `"emraw"` and `"microns"` are scaled to nm via
  [`fish_coords`](https://flyconnectome.github.io/fishr/reference/fish_coords.md)
  first.

- threshold:

  Distance from midline below which points are reported as M rather than
  L or R. Default 5000 nm (~5 \\\mu\\m, ~1% of the y (medio-lateral)
  extent of the fish2 brain). Set to 0 for all values to be L or R

- rval:

  What to return. `"side"` (the default) gives a character vector of
  side labels (`"L"`, `"R"` or `"M"`). `"distance"` gives a signed
  distance from the midline in nm (always nm, regardless of `units`),
  positive on the right, negative on the left.

## Value

When `rval = "side"`, a character vector of `"L"`, `"R"` or `"M"`, one
per input point, or `NA` for bad points. When `rval = "distance"`, a
numeric vector of signed distances from the midline in nm.

## Details

right-side points have `dist = (mirror_y - y)/2 < 0`. Points with
`|dist| <= threshold` are reported as midline. If `dist==0` and
`threshold==0` then points will be reported as "R".

## See also

[`mirror_fish`](https://flyconnectome.github.io/fishr/reference/mirror_fish.md)

## Examples

``` r
# known right-side point (raw voxel)
fish_point_side(c(30159, 33753, 6352), units = "raw")
#> [1] "L"

# a small batch in nm
xyz_nm <- rbind(c(482544, 540048,  95280),   # right
                c(482544, 380000,  95280),   # left
                c(735728, 430864,  94620))   # near midline
fish_point_side(xyz_nm)
#> [1] "L" "R" "M"

# signed distance from the midline (always in nm)
fish_point_side(xyz_nm, rval = "distance")
#> [1] -109997.34   47184.62   -1481.66
```
