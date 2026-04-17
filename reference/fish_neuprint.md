# Login to fish2 neuprint server

Login to fish2 neuprint server

## Usage

``` r
fish_neuprint(
  token = fish_neuprint_token(),
  dataset = NULL,
  Force = FALSE,
  use_clio = FALSE,
  ...
)
```

## Arguments

- token:

  neuprint authorisation token obtained e.g. from neuprint.janelia.org
  website.

- dataset:

  Allows you to override the neuprint dataset for `fish_neuprint` (which
  would otherwise be chosen based on the value of
  `options(fishr.dataset)`, normally changed by
  [`choose_fish_dataset`](https://flyconnectome.github.io/fishr/reference/with_fish.md)).

- Force:

  Passed to
  [`neuprintr::neuprint_login`](https://natverse.org/neuprintr/reference/neuprint_login.html).

- use_clio:

  Whether to use a live Clio lookup for fish dataset settings before
  opening the neuprint connection. The default `FALSE` reuses cached
  live lookup results when available and otherwise relies on built-in
  fish2 neuprint settings.

- ...:

  Additional arguments passed to
  [`neuprint_login`](https://natverse.org/neuprintr/reference/neuprint_login.html).

## Value

A `neuprint_connection` object returned by
[`neuprint_login`](https://natverse.org/neuprintr/reference/neuprint_login.html).

## Details

It should be possible to use the same token across public and private
neuprint servers if you are using the same email address. However this
does not seem to work for all users. Before giving up on this, do try
using the *most* recently issued token from a private server rather than
older tokens. If you need to pass a specific token you can use the
`token` argument, also setting `Force=TRUE` to ensure that the specified
token is used if you have already tried to log in during the current
session.

## See also

[`manc_neuprint`](https://natverse.org/malevnc/reference/manc_neuprint.html)

Other neuprint:
[`fish_connection_table()`](https://flyconnectome.github.io/fishr/reference/fish_connection_table.md),
[`fish_neuprint_meta()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint_meta.md),
[`fish_roi_meshes()`](https://flyconnectome.github.io/fishr/reference/fish_roi_meshes.md),
[`fish_rois()`](https://flyconnectome.github.io/fishr/reference/fish_rois.md)

## Examples

``` r
# \donttest{
conn <- fish_neuprint()
conn
#> Connection to neuPrint server:
#>   https://neuprint-fish2.janelia.org
#> with default dataset:
#>    fish2 
#> Login active since: Fri, 17 Apr 2026 14:17:13 GMT
# }
```
