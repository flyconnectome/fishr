# fishr

<!-- badges: start -->
[![natverse](https://img.shields.io/badge/natverse-Part%20of%20the%20natverse-a241b6)](https://natverse.org)
[![Docs](https://img.shields.io/badge/docs-100%25-brightgreen.svg)](https://flyconnectome.github.io/fishr/)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/flyconnectome/fishr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/flyconnectome/fishr/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

The goal of **fishr** is to provide
[natverse](https://natverse.org) access to the **fish2** larval zebrafish
whole-brain EM dataset. It follows the same general pattern as
[malecns](https://github.com/natverse/malecns) and
[malevnc](https://github.com/natverse/malevnc), providing dataset-specific
helpers on top of the [neuprintr](https://github.com/natverse/neuprintr) package 
and a bridge to the broader natverse connectomics tooling for computational
neuroanatomy.

The fish2 dataset is currently being proofread at Janelia Research Campus as part of a multi-institution collaboration.

The initial package focuses on:

- dataset selection helpers (`choose_fish()`, `with_fish()`)
- body id lookup (`fish_ids()`)
- neuprint metadata and connectivity queries (`fish_neuprint_meta`, `fish_connection_table`)
- DVID body annotations (`fish_dvid_annotations`)
- neuroglancer meshes and skeletons (`read_fish_meshes`, `read_fish_neurons`)

## Installation

If you are new to R, we recommend installing the RStudio IDE and base R as
detailed at https://posit.co/download/rstudio-desktop/#download.

To install the fishr package and its dependencies, in your R terminal do:

```r
# install natmanager if needed
if (!requireNamespace("natmanager")) install.packages("natmanager")
natmanager::install(pkgs = "fishr")
```

You also need to make sure that you are authenticated to both clio and neuprint.

### Authentication
Access to neuprint requires authentication. We recommend running:

```r
library(fishr)
fish_setup()
```

in an interactive R session and following the prompts. This will help you record
your token and offer to set the fish2 dataset/server as the default for all 
neuprint commands. 
See https://github.com/natverse/neuprintr#authentication to learn more about 
the relevant environment variables.

You need to authenticate with Clio API to interact with the Clio/DVID annotation
system. You do this via a Google OAuth "dance" in your web browser which is
automatically triggered by `choose_fish()` or functions that require Clio access. 
Note that the Clio and neuprint tokens look similar, but are not the same. Note also that the neuprint token appears to be indefinite while the Clio token currently lasts 3 weeks.

## Example

This example shows some basic activities including finding ids by type,
fetching metadata and connectivity information, and reading and plotting
some retinal ganglion cell meshes.

```r
library(fishr)
library(nat)
# you only have to run this once, but you can 
fish_setup()

# find some RGCs
rgc10=fish_ids("RGC")[1:10]
# get metadata
fish_neuprint_meta(rgc10)

# connectivity query
fish_connection_table(rgc10, partners = "outputs")

# fetch some RGC meshes
rgcm <- read_fish_meshes(rgc10)
plot3d(rgcm)

# read and plot one fish skeleton
rgcn <- read_fish_neurons(rgc10[1])
plot3d(rgcn, col = "cyan")

# Get meshes for some ROIs. NB not all ROIs have meshes.
roi.meshes <- fish_roi_meshes(c("Midbrain", "Hindbrain"), .progress = "none")
wire3d(roi.meshes, col='grey')
```

### other useful packages
fishr has a set of core functions but there is a lot of useful functionality in
other R packages for interacting with the FlyEM connectome data ecosystem,
especially [malevnc](https://natverse.org/malevnc/) and [neuprintr](https://natverse.org/neuprintr/).

#### malevnc 

malevnc is especially useful for interacting with the annotation and segmentation 
infrastructure (clio/DVID). You can use any [function in the malevnc package](https://natverse.org/malevnc/reference/) after wrapping it in 
`with_fish()`. 

```r
with_fish(malevnc::clio_fields())
```

If you only ever use the fish dataset then doing `choose_fish()` once per 
session means that all subsequent malevnc functions will target the fish2 dataset.

```
choose_fish()
malevnc::clio_fields()
```

This already happens if you follow default prompts when you run `fish_setup()`.

The key end user application for the malevnc package right now is probably 
setting clio annotations via malevnc::manc_annotate_body()

#### neuprintr

Similarly you can use [all functions in the base neuprintr package](https://natverse.org/neuprintr/reference/).
If you have followed the default prompts in `fish_setup()` and are not using
other FlyEM datasets, then fish2 should be the default there too.

If you use other neuprint datasets then neuprintr uses the last (or only)
neuprint connection made in a session and will target that dataset.

```r
fc=fish_neuprint()
fc
neuprintr::neuprint_ROIs(conn = fc)
```
