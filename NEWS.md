# fishr 0.3.0

Several new features including a L/R-side classifier, soma-position helpers and
a unified xyz coordinate converter, plus DVID body lookup at points.

## What's Changed
* Add `fish_point_side()` to predict the L/R/M side of points in fish2 space
  by applying `mirror_fish()` and measuring the signed y displacement across
  the midline; supports `units = "nm" / "raw" / "emraw" / "microns"`, a
  configurable midline `threshold` and `rval = "side" / "distance"`. By
  @jefferis in https://github.com/flyconnectome/fishr/pull/4
* Add `fish_somapos()` and `fish_soma_side()` for soma queries against fish2
  metadata. `fish_somapos()` returns an Nx3 matrix of soma positions
  (preferring `somaLocation`, falling back row-wise to `tosomaLocation`) in
  the requested units; `fish_soma_side()` classifies the logical side of
  each body via `auto` / `instance` (`_L`/`_R`/`_M`/`_U` suffix) /
  `position` (`fish_point_side()` on the soma), with `manual` reserved for
  a future `somaSide` column. By @jefferis in
  https://github.com/flyconnectome/fishr/pull/4
* Add `fish_coords()` as a single public converter between fish2's voxel
  scales: nm, raw (the (16, 16, 15) nm grid stored in neuprint's
  `somaLocation` and accepted by the DVID `segmentation/labels` endpoint),
  emraw (the (8, 8, 30) nm acquisition grid used in Clio / Neuroglancer
  URLs) and microns. `as_character = TRUE` returns `"x,y,z"` strings via
  `nat::xyzmatrix2str()`. By @jefferis in
  https://github.com/flyconnectome/fishr/pull/7
* Add `fish_xyz2bodyid()` to look up the segmentation body id at each 3D
  point via `malevnc::manc_xyz2bodyid()`, returning character ids. Default
  `units = "emraw"` matches the typical interactive case of pasting
  coordinates from a fish2 neuroglancer URL; `raw`, `nm` and `microns` are
  also accepted. By @jefferis in
  https://github.com/flyconnectome/fishr/pull/7
* Fix `fish_neuprint_meta(NULL)` to return the same soma-related columns
  (`somaLocation`, `nsoma`, `somaSide`, …) as `fish_neuprint_meta(ids)` by
  passing the full `possibleFields` list to `neuprintr::neuprint_get_meta()`
  on the all-bodies code path. By @jefferis in
  https://github.com/flyconnectome/fishr/pull/4
* Refactor `fish_point_side()` and `fish_somapos()` to delegate unit
  conversion to `fish_coords()` (and both gain `"emraw"` as a `units`
  value). `fish_somapos()` now returns matrices with natverse-standard
  uppercase `X`/`Y`/`Z` column names. By @jefferis in
  https://github.com/flyconnectome/fishr/pull/7

# fishr 0.2.0

First versioned release with a NEWS file.

## What's Changed
* Add `fish_clio_annotations()` to read live Clio body annotations for fish2
  (wraps `malevnc::manc_body_annotations()`) by @jefferis in
  https://github.com/flyconnectome/fishr/pull/2
* Add `mirror_fish()` and the underlying `fish2_mirror_reg` thin plate spline
  registration for mirroring across the fish2 midline. Ported from Philipp
  Schlegel's [navis-fishbrains](https://github.com/schlegelp/navis-fishbrains)
  landmarks; `data-raw/fish2_mirror_reg.R` recreates the registration from the
  upstream CSV. Verified against `navis.mirror_brain(template = "Fish2",
  mirror_axis = "y")` to sub-nanometre precision. By @jefferis in
  https://github.com/flyconnectome/fishr/pull/3
* Stylise the dataset name as lowercase `fish2` throughout docs and titles
* Doc polishing and pkgdown reference index cleanup
