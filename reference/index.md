# Package index

## Overview and setup

- [`fishr`](https://flyconnectome.github.io/fishr/reference/fishr-package.md)
  [`fishr-package`](https://flyconnectome.github.io/fishr/reference/fishr-package.md)
  : fishr: Access the fish2 FlyEM Dataset
- [`fish_setup()`](https://flyconnectome.github.io/fishr/reference/fish_setup.md)
  : Interactive setup helper for fish2 authentication

## Data access

- [`with_fish()`](https://flyconnectome.github.io/fishr/reference/with_fish.md)
  [`choose_fish_dataset()`](https://flyconnectome.github.io/fishr/reference/with_fish.md)
  [`choose_fish()`](https://flyconnectome.github.io/fishr/reference/with_fish.md)
  : Evaluate an expression after temporarily setting malevnc options
- [`fish_neuprint()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md)
  : Login to fish2 neuprint server

## Query ids, metadata and connectivity

- [`fish_ids()`](https://flyconnectome.github.io/fishr/reference/fish_ids.md)
  : Resolve fish2 body ids from a variety of inputs
- [`fish_neuprint_meta()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint_meta.md)
  : Fetch neuprint metadata for fish2 neurons
- [`fish_connection_table()`](https://flyconnectome.github.io/fishr/reference/fish_connection_table.md)
  : Connectivity query for fish2 neurons
- [`fish_xyz2bodyid()`](https://flyconnectome.github.io/fishr/reference/fish_xyz2bodyid.md)
  : Map xyz points to fish2 body ids via DVID
- [`register_fish_coconat()`](https://flyconnectome.github.io/fishr/reference/register_fish_coconat.md)
  : Register fish2 dataset for coconatfly

## 3D Meshes and Skeletons

- [`fish_rois()`](https://flyconnectome.github.io/fishr/reference/fish_rois.md)
  : Fetch the ROI hierarchy for fish2
- [`fish_roi_meshes()`](https://flyconnectome.github.io/fishr/reference/fish_roi_meshes.md)
  : Fetch one or more ROI meshes for fish2
- [`read_fish_meshes()`](https://flyconnectome.github.io/fishr/reference/read_fish_meshes.md)
  : Read meshes for fish2 body ids
- [`read_fish_neurons()`](https://flyconnectome.github.io/fishr/reference/read_fish_neurons.md)
  : Read neuron skeletons via neuprint

## Read and set live annotations

- [`fish_dvid_annotations()`](https://flyconnectome.github.io/fishr/reference/fish_dvid_annotations.md)
  : Read DVID body annotations for fish2 body ids
- [`fish_clio_annotations()`](https://flyconnectome.github.io/fishr/reference/fish_clio_annotations.md)
  : Read Clio body annotations for fish2 body ids
- [`fish_annotate()`](https://flyconnectome.github.io/fishr/reference/fish_annotate.md)
  : Set body annotations for fish2 via Clio

## Coordinates, spatial transforms and point locations

- [`fish_coords()`](https://flyconnectome.github.io/fishr/reference/fish_coords.md)
  : Convert xyz points between fish2 coordinate systems
- [`mirror_fish()`](https://flyconnectome.github.io/fishr/reference/mirror_fish.md)
  [`fish2_mirror_reg`](https://flyconnectome.github.io/fishr/reference/mirror_fish.md)
  : Mirror points or neurons in fish2 space
- [`fish_point_side()`](https://flyconnectome.github.io/fishr/reference/fish_point_side.md)
  : Predict the L/R side of points in fish2 space
- [`fish_somapos()`](https://flyconnectome.github.io/fishr/reference/fish_somapos.md)
  [`fish_soma_side()`](https://flyconnectome.github.io/fishr/reference/fish_somapos.md)
  : Soma positions and logical sides for fish2 neurons

## Utility: URL helpers

- [`reexports`](https://flyconnectome.github.io/fishr/reference/reexports.md)
  [`flyem_shorten_url`](https://flyconnectome.github.io/fishr/reference/reexports.md)
  [`flyem_expand_url`](https://flyconnectome.github.io/fishr/reference/reexports.md)
  : Objects exported from other packages
