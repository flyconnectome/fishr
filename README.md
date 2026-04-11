# fishr

`fishr` is a thin wrapper around [malevnc](https://github.com/natverse/malevnc)
for working with the **fish2** larval zebrafish whole-brain EM dataset in the
same style as [malecns](https://github.com/natverse/malecns) and
[yakuba](https://github.com/natverse/yakuba).

The fish2 dataset is currently being proofread at Janelia Research Campus.

The initial package focuses on:

- dataset selection helpers (`choose_fish`, `with_fish`)
- neuprint metadata and connectivity queries (`fish_neuprint_meta`, `fish_connection_table`)
- body id lookup (`fish_ids`)
- DVID body annotations (`fish_dvid_annotations`)
- neuroglancer meshes (`read_fish_meshes`)

## Installation

```r
# install natmanager if needed
if (!requireNamespace("natmanager")) install.packages("natmanager")
natmanager::install(pkgs = "fishr")
```

You also need to make sure that you are authenticated to both clio and neuprint.

### Authentication - Neuprint
Access to neuprint requires authentication. See https://github.com/natverse/neuprintr#authentication for details.
The recommendation is to set the neuprint_token environment variable, which is available after logging in to the neuprint website. Follow the instructions at that link to get your token and edit your .Renviron file. Make sure you have a blank line at the end of the file.

```
# nb this token is a dummy
neuprint_token="asBatEsiOIJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImIsImxldmVsIjoicmVhZHdyaXRlIiwiaW1hZ2UtdXJsIjoiaHR0cHM7Ly9saDQuZ29vZ2xldXNlcmNvbnRlbnQuY29tLy1QeFVrTFZtbHdmcy9BQUFBQUFBQUFBDD9BQUFBQUFBQUFBQS9BQ0hpM3JleFZMeEI4Nl9FT1asb0dyMnV0QjJBcFJSZlI6MTczMjc1MjU2HH0.jhh1nMDBPl5A1HYKcszXM518NZeAhZG9jKy3hzVOWEU"
```

Note that you can optionally specify a default server dataset in this .Renviron 
file to ensure that all R functions from neuprintr (see below) also target the
fish dataset by default:

```
neuprint_server="https://neuprint-fish2.janelia.org"
neuprint_dataset = "fish2"
```

### Authentication - Clio
You need to authenticate with Clio API to interact with the Clio/DVID annotation
system. You do this via a Google OAuth "dance" in your web browser which is
automatically triggered by `choose_fish()`. Note that the Clio and neuprint tokens look similar, but are not the same. Note also that the neuprint token appears to be indefinite while the Clio token currently lasts 3 weeks.

## Example

This example shows some basic activities including finding ids by type,
fetching metadata and connectivity information and reading and plotting 
some retinal ganglion cell meshes.

```r
library(fishr)
library(nat)
choose_fish()

# find some RGCs
rgc10=fish_ids("RGC")[1:10]
# get metadata
fish_neuprint_meta(rgc10)

# connectivity query
fish_neuprint_meta(rgc10)

# fetch some RGC meshes
rgcm <- read_fish_meshes(rgc10)
plot3d(rgcm)
```


### using malevnc and neuprintr functions

fishr has a set of core functions but there is a lot of useful functionality in 
other R packages for interacting with the flyem connectome data ecosystem 
especially [malevnc](https://natverse.org/malevnc/) and [neuprintr](https://natverse.org/neuprintr/).

malevnc is especially useful for interacting with the annotation and segmentation 
infrastructure (clio/DVID). You can use any [function in the malevnc package](https://natverse.org/malevnc/reference/) after wrapping it in 
`with_fish()`. 

```r
with_fish(malevnc::clio_fields())
```

If you only ever use the fish dataset then doing

```
choose_fish()
malevnc::clio_fields()
```
once per session means that all subsequent malevbcqueries will be targeted at the fish2 dataset.

Similarly you can use [function in the base neuprintr package](https://natverse.org/neuprintr/reference/) package.

If the fish dataset is the only (or last) neuprint connection made in a session
then [all neuprintr functions](https://natverse.org/neuprintr/reference/index.html) will target that dataset.

```r
fc=fish_neuprint()
fc
neuprintr::neuprint_ROIs(conn = fc)
```
