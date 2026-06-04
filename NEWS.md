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
