# Mirror points or neurons in fish2 space

`mirror_fish` mirrors objects with 3D vertices calibrated in nanometres
across the fish2 midline using a thin plate spline registration derived
from Philipp Schlegel's navis-fishbrains landmarks.

`fish2_mirror_reg` is the underlying
[`tpsreg`](https://rdrr.io/pkg/nat/man/tpsreg.html) registration object
for mirroring.

## Usage

``` r
mirror_fish(x, ...)

fish2_mirror_reg
```

## Format

`fish2_mirror_reg` is a `tpsreg`/`reglist` object.

An object of class `tpsreg` of length 2.

## Arguments

- x:

  Any object with 3D vertices (calibrated in nm), e.g. a neuron, a
  neuronlist, a mesh, or a 3-column matrix / data frame of points.

- ...:

  Additional arguments passed to
  [`xform_brain`](https://natverse.org/nat.templatebrains/reference/xform_brain.html).

## Value

`mirror_fish` returns the mirrored object.

## Details

`fish2_mirror_reg` is shipped with the package and added to the
`nat.templatebrains` registry on package load by
[`fish_register_xforms`](https://flyconnectome.github.io/fishr/reference/fish_register_xforms.md),
so calling `mirror_fish` normally needs no setup. See
`data-raw/fish2_mirror_reg.R` for the construction recipe from the
upstream
[navis-fishbrains](https://github.com/schlegelp/navis-fishbrains)
landmark CSV.

## Examples

``` r
if (FALSE) { # \dontrun{
library(nat)
# round-trip: mirroring twice should approximately recover the input
pts <- cbind(x = 500000, y = 400000, z = 150000)
mirror_fish(mirror_fish(pts))
} # }
```
