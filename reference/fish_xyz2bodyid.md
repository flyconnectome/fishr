# Map xyz points to fish2 body ids via DVID

Look up the segmentation body id at each 3D point. Thin wrapper around
`malevnc::`[`manc_xyz2bodyid`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.html)
that targets the active fish2 DVID node. Input may be in emraw
(default), raw, nm or microns; see
[`fish_coords`](https://flyconnectome.github.io/fishr/reference/fish_coords.md)
for what each means.

## Usage

``` r
fish_xyz2bodyid(
  xyz,
  units = c("emraw", "raw", "nm", "microns"),
  node = "neutu",
  cache = FALSE
)
```

## Arguments

- xyz:

  Point coordinates: a length-3 numeric vector for a single point, an
  Nx3 numeric matrix / data.frame, or anything else accepted by
  [`xyzmatrix`](https://rdrr.io/pkg/nat/man/xyzmatrix.html) (including
  `"x,y,z"` strings).

- units:

  Units of the input coordinates. `"emraw"` (the default) matches
  coordinates copied from neuroglancer URLs against the fish2 EM
  imagery; `"raw"` matches the neuprint segmentation grid; `"nm"` and
  `"microns"` are self-explanatory. See
  [`fish_coords`](https://flyconnectome.github.io/fishr/reference/fish_coords.md)
  for the underlying voxel sizes.

- node:

  The DVID node (UUID) to query. The default `"neutu"` uses the active
  neutu node, normally the most up-to-date.

- cache:

  Whether to cache the result of this call for 5 minutes (default
  `FALSE`).

## Value

A character vector of body ids, one per input point. `NA_character_`
where the input row had any `NA`.

## Details

The DVID `segmentation/labels` endpoint accepts coordinates on the
neuprint (16, 16, 15) "raw" grid, so input coordinates are first
converted to raw via
[`fish_coords`](https://flyconnectome.github.io/fishr/reference/fish_coords.md)
and then rounded to integer voxel positions before the call (as in
`manc_xyz2bodyid`). Points with `NA` coordinates yield `NA_character_`
in the output.

## See also

[`fish_neuprint_meta`](https://flyconnectome.github.io/fishr/reference/fish_neuprint_meta.md),
[`fish_coords`](https://flyconnectome.github.io/fishr/reference/fish_coords.md),
`malevnc::`[`manc_xyz2bodyid`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.html)

Other coords:
[`fish_coords()`](https://flyconnectome.github.io/fishr/reference/fish_coords.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# default emraw matches a point copied from a fish2 EM neuroglancer URL
fish_xyz2bodyid(c(115560, 56056, 5492))                # -> 100001043

# same body looked up via neuprint-raw coordinates
fish_xyz2bodyid(c(57780, 28028, 10984), units = "raw") # -> 100001043
} # }
```
