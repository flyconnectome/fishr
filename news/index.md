# Changelog

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
