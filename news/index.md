# Changelog

## fishr 0.3.0

Several new features including a L/R-side classifier, soma-position
helpers and a unified xyz coordinate converter, plus DVID body lookup at
points.

### What’s Changed

- Add
  [`fish_point_side()`](https://flyconnectome.github.io/fishr/reference/fish_point_side.md)
  to predict the L/R/M side of points in fish2 space by applying
  [`mirror_fish()`](https://flyconnectome.github.io/fishr/reference/mirror_fish.md)
  and measuring the signed y displacement across the midline; supports
  `units = "nm" / "raw" / "emraw" / "microns"`, a configurable midline
  `threshold` and `rval = "side" / "distance"`. By
  [@jefferis](https://github.com/jefferis) in
  <https://github.com/flyconnectome/fishr/pull/4>
- Add
  [`fish_somapos()`](https://flyconnectome.github.io/fishr/reference/fish_somapos.md)
  and
  [`fish_soma_side()`](https://flyconnectome.github.io/fishr/reference/fish_somapos.md)
  for soma queries against fish2 metadata.
  [`fish_somapos()`](https://flyconnectome.github.io/fishr/reference/fish_somapos.md)
  returns an Nx3 matrix of soma positions (preferring `somaLocation`,
  falling back row-wise to `tosomaLocation`) in the requested units;
  [`fish_soma_side()`](https://flyconnectome.github.io/fishr/reference/fish_somapos.md)
  classifies the logical side of each body via `auto` / `instance`
  (`_L`/`_R`/`_M`/`_U` suffix) / `position`
  ([`fish_point_side()`](https://flyconnectome.github.io/fishr/reference/fish_point_side.md)
  on the soma), with `manual` reserved for a future `somaSide` column.
  By [@jefferis](https://github.com/jefferis) in
  <https://github.com/flyconnectome/fishr/pull/4>
- Add
  [`fish_coords()`](https://flyconnectome.github.io/fishr/reference/fish_coords.md)
  as a single public converter between fish2’s voxel scales: nm, raw
  (the (16, 16, 15) nm grid stored in neuprint’s `somaLocation` and
  accepted by the DVID `segmentation/labels` endpoint), emraw (the (8,
  8, 30) nm acquisition grid used in Clio / Neuroglancer URLs) and
  microns. `as_character = TRUE` returns `"x,y,z"` strings via
  [`nat::xyzmatrix2str()`](https://rdrr.io/pkg/nat/man/xyzmatrix.html).
  By [@jefferis](https://github.com/jefferis) in
  <https://github.com/flyconnectome/fishr/pull/7>
- Add
  [`fish_xyz2bodyid()`](https://flyconnectome.github.io/fishr/reference/fish_xyz2bodyid.md)
  to look up the segmentation body id at each 3D point via
  [`malevnc::manc_xyz2bodyid()`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.html),
  returning character ids. Default `units = "emraw"` matches the typical
  interactive case of pasting coordinates from a fish2 neuroglancer URL;
  `raw`, `nm` and `microns` are also accepted. By
  [@jefferis](https://github.com/jefferis) in
  <https://github.com/flyconnectome/fishr/pull/7>
- Fix `fish_neuprint_meta(NULL)` to return the same soma-related columns
  (`somaLocation`, `nsoma`, `somaSide`, …) as `fish_neuprint_meta(ids)`
  by passing the full `possibleFields` list to
  [`neuprintr::neuprint_get_meta()`](https://natverse.org/neuprintr/reference/neuprint_get_meta.html)
  on the all-bodies code path. By
  [@jefferis](https://github.com/jefferis) in
  <https://github.com/flyconnectome/fishr/pull/4>
- Refactor
  [`fish_point_side()`](https://flyconnectome.github.io/fishr/reference/fish_point_side.md)
  and
  [`fish_somapos()`](https://flyconnectome.github.io/fishr/reference/fish_somapos.md)
  to delegate unit conversion to
  [`fish_coords()`](https://flyconnectome.github.io/fishr/reference/fish_coords.md)
  (and both gain `"emraw"` as a `units` value).
  [`fish_somapos()`](https://flyconnectome.github.io/fishr/reference/fish_somapos.md)
  now returns matrices with natverse-standard uppercase `X`/`Y`/`Z`
  column names. By [@jefferis](https://github.com/jefferis) in
  <https://github.com/flyconnectome/fishr/pull/7>

## fishr 0.2.0

First versioned release with a NEWS file.

### What’s Changed

- Add
  [`fish_clio_annotations()`](https://flyconnectome.github.io/fishr/reference/fish_clio_annotations.md)
  to read live Clio body annotations for fish2 (wraps
  [`malevnc::manc_body_annotations()`](https://natverse.org/malevnc/reference/manc_body_annotations.html))
  by [@jefferis](https://github.com/jefferis) in
  <https://github.com/flyconnectome/fishr/pull/2>
- Add
  [`mirror_fish()`](https://flyconnectome.github.io/fishr/reference/mirror_fish.md)
  and the underlying `fish2_mirror_reg` thin plate spline registration
  for mirroring across the fish2 midline. Ported from Philipp Schlegel’s
  [navis-fishbrains](https://github.com/schlegelp/navis-fishbrains)
  landmarks; `data-raw/fish2_mirror_reg.R` recreates the registration
  from the upstream CSV. Verified against
  `navis.mirror_brain(template = "Fish2", mirror_axis = "y")` to
  sub-nanometre precision. By [@jefferis](https://github.com/jefferis)
  in <https://github.com/flyconnectome/fishr/pull/3>
- Stylise the dataset name as lowercase `fish2` throughout docs and
  titles
- Doc polishing and pkgdown reference index cleanup
