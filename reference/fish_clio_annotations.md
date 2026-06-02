# Read Clio body annotations for fish2 body ids

Read live body annotations for the fish2 dataset from Clio.

## Usage

``` r
fish_clio_annotations(
  ids = NULL,
  query = NULL,
  json = FALSE,
  config = NULL,
  cache = FALSE,
  update.bodyids = FALSE,
  test = FALSE,
  show.extra = c("none", "user", "time", "all"),
  ...
)
```

## Arguments

- ids:

  One or more body ids, `NULL` (default) to fetch all annotations, or
  anything accepted by
  [`fish_ids`](https://flyconnectome.github.io/fishr/reference/fish_ids.md).

- query:

  A json query string (see examples or documentation) or an R list with
  field names as elements.

- json:

  Whether to return unparsed JSON rather than an R list (default
  `FALSE`).

- config:

  An optional httr::config (expert use only, must include a bearer
  token)

- cache:

  Whether to cache the result of this call for 5 minutes.

- update.bodyids:

  Whether to update the bodyid associated with annotations based on the
  position field. The default value of this has been switched to `FALSE`
  as of Feb 2022.

- test:

  Whether to unset the clio-store test server (default `FALSE`)

- show.extra:

  Extra columns to show with user/timestamp information.

- ...:

  Additional arguments passed to
  [`pblapply`](https://peter.solymos.org/pbapply/reference/pbapply.html).

## Value

A `data.frame` of body annotations. See
`malevnc::`[`manc_body_annotations`](https://natverse.org/malevnc/reference/manc_body_annotations.html)
for further details.

## Details

This function wraps
`malevnc::`[`manc_body_annotations`](https://natverse.org/malevnc/reference/manc_body_annotations.html)
for the active fish dataset. When `ids` are supplied they are first
resolved with
[`fish_ids`](https://flyconnectome.github.io/fishr/reference/fish_ids.md),
so you can pass fish body ids or simple neuprint-backed queries such as
cell types. Leave `ids=NULL` to use the `query` argument directly, as in
[`malevnc::manc_body_annotations`](https://natverse.org/malevnc/reference/manc_body_annotations.html).
When querying numeric fields such as `group`, use numeric values rather
than quoted strings.

## See also

Other live-annotations:
[`fish_annotate()`](https://flyconnectome.github.io/fishr/reference/fish_annotate.md),
[`fish_dvid_annotations()`](https://flyconnectome.github.io/fishr/reference/fish_dvid_annotations.md)

## Examples

``` r
if (FALSE) { # \dontrun{
fish_clio_annotations(ids = 100003384)
fish_clio_annotations(ids = "RGC")
fish_clio_annotations(query = list(group = 100003384))
} # }
```
