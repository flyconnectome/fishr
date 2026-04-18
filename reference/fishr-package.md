# fishr: Access the Fish2 FlyEM Dataset

A thin wrapper around the malevnc package providing access to the fish2
larval zebrafish EM dataset being proofread at Janelia Research Campus
as part of a collaboration with the Engert / Lichtman labs at Harvard
and Google Research. Currently provides convenience functions for
reading meshes and setting dataset options.

## Package Options

- `fishr.dataset` The name of the active fish2 dataset (default
  `"fish2"`). Set by
  [`choose_fish_dataset`](https://flyconnectome.github.io/fishr/reference/with_fish.md).

The following `malevnc.*` options are set by
[`choose_fish`](https://flyconnectome.github.io/fishr/reference/with_fish.md)
or
[`with_fish`](https://flyconnectome.github.io/fishr/reference/with_fish.md)
to point the `malevnc` package at the fish2 servers:

- `malevnc.server` DVID server URL (set via Clio lookup).

- `malevnc.rootnode` DVID root node UUID (set via Clio lookup).

- `malevnc.neuprint` neuprint server URL (fallback:
  `https://neuprint-fish2.janelia.org`).

- `malevnc.neuprint_dataset` neuprint dataset name (fallback:
  `"fish2"`).

## See also

Useful links:

- <https://flyconnectome.github.io/fishr/>

Other setup-data-access:
[`fish_neuprint()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md),
[`fish_setup()`](https://flyconnectome.github.io/fishr/reference/fish_setup.md),
[`with_fish()`](https://flyconnectome.github.io/fishr/reference/with_fish.md)

## Author

**Maintainer**: Gregory Jefferis <jefferis@gmail.com>
([ORCID](https://orcid.org/0000-0002-0587-9355))

## Examples

``` r
if (FALSE) { # \dontrun{
options()[grepl("^fishr", names(options()))]
options()[grepl("^malevnc", names(options()))]
with_fish(read_fish_meshes(12345))
} # }
```
