# Read neuron skeletons via neuprint

Read neuron skeletons via neuprint

## Usage

``` r
read_fish_neurons(
  ids,
  connectors = FALSE,
  units = c("nm", "raw", "microns"),
  heal.threshold = Inf,
  conn = NULL,
  ...,
  dataset = fish_default_dataset()
)
```

## Arguments

- ids:

  Body ids in any form compatible with
  [`fish_ids`](https://flyconnectome.github.io/fishr/reference/fish_ids.md).

- connectors:

  Whether to fetch synaptic connections for the neuron (default `FALSE`
  in contrast to
  [`neuprint_read_neurons`](https://natverse.org/neuprintr/reference/neuprint_read_neurons.html)).

- units:

  Units of the returned neurons (default `"nm"`).

- heal.threshold:

  The threshold for healing disconnected skeleton fragments. The default
  of `Inf` ensures that all fragments are joined together.

- conn:

  Optional, a `neuprint_connection` object. Defaults to
  [`fish_neuprint`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md)
  to ensure that the query targets fish2.

- ...:

  Additional arguments passed to
  [`neuprint_read_neurons`](https://natverse.org/neuprintr/reference/neuprint_read_neurons.html).

- dataset:

  The name of the dataset as reported in Clio (default `"fish2"`).

## Value

A [`neuronlist`](https://rdrr.io/pkg/nat/man/neuronlist.html) object
containing one or more neurons.

## See also

[`manc_read_neurons`](https://natverse.org/malevnc/reference/manc_read_neurons.html),
and nat functions including
[`neuron`](https://rdrr.io/pkg/nat/man/neuron.html),
[`neuronlist`](https://rdrr.io/pkg/nat/man/neuronlist.html).

Other fishr-package:
[`fish_dvid_annotations()`](https://flyconnectome.github.io/fishr/reference/fish_dvid_annotations.md),
[`fish_ids()`](https://flyconnectome.github.io/fishr/reference/fish_ids.md),
[`fish_setup()`](https://flyconnectome.github.io/fishr/reference/fish_setup.md),
[`read_fish_meshes()`](https://flyconnectome.github.io/fishr/reference/read_fish_meshes.md),
[`with_fish()`](https://flyconnectome.github.io/fishr/reference/with_fish.md)

## Examples

``` r
# \donttest{
rgcsk3 <- read_fish_neurons(fish_ids("RGC")[1:3])
plot(rgcsk3, WithNodes=FALSE)

# }
```
