# Connectivity query for fish2 neurons

Connectivity query for fish2 neurons

## Usage

``` r
fish_connection_table(
  ids,
  partners = c("inputs", "outputs"),
  moredetails = FALSE,
  summary = FALSE,
  threshold = 1L,
  roi = NULL,
  by.roi = FALSE,
  conn = NULL,
  ...,
  dataset = fish_default_dataset()
)
```

## Arguments

- ids:

  A set of body ids (see
  [`fish_ids`](https://flyconnectome.github.io/fishr/reference/fish_ids.md)
  for a range of ways to specify these).

- partners:

  Either inputs or outputs. Redundant with `prepost`, but probably
  clearer.

- moredetails:

  `FALSE` (default) to use only the columns returned by
  `neuprint_connection_table`, `TRUE` to join all additional fields from
  [`fish_neuprint_meta`](https://flyconnectome.github.io/fishr/reference/fish_neuprint_meta.md),
  or a character vector naming specific extra fields (e.g.
  `c("group")`).

- summary:

  When `TRUE` and more than one query neuron is given, summarises
  connectivity grouped by partner.

- threshold:

  Only return partners \>= to an integer value. Default of 1 returns all
  partners. This threshold will be applied to the ROI weight when the
  `roi` argument is specified, otherwise to the whole neuron.

- roi:

  a single ROI. Use `neuprint_ROIs` to see what is available.

- by.roi:

  logical, whether or not to break neurons' connectivity down by region
  of interest (ROI)

- conn:

  Optional, a `neuprint_connection` object. Defaults to
  [`fish_neuprint`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md)
  to ensure that the query targets fish2.

- ...:

  Additional arguments passed to
  [`neuprint_connection_table`](https://natverse.org/neuprintr/reference/neuprint_connection_table.html).

- dataset:

  optional, a dataset you want to query. If `NULL`, the default
  specified by your R environ file is used or, failing that the current
  connection, is used. See
  [`neuprint_login`](https://natverse.org/neuprintr/reference/neuprint_login.html)
  for details.

## Value

A data.frame.

## See also

[`manc_connection_table`](https://natverse.org/malevnc/reference/manc_connection_table.html)

Other neuprint:
[`fish_neuprint()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md),
[`fish_neuprint_meta()`](https://flyconnectome.github.io/fishr/reference/fish_neuprint_meta.md)

## Examples

``` r
# \donttest{
fish_connection_table("RGC", partners = "outputs")
#> Warning: Clio dataset lookup failed; falling back to baked-in neuprint settings for `fish2`. Clio-backed functionality may be unavailable in this session.
#> Warning: Clio dataset lookup failed; falling back to baked-in neuprint settings for `fish2`. Clio-backed functionality may be unavailable in this session.
#> Error in (function (path, body = NULL, server = NULL, conf = NULL, parse.json = TRUE,     include_headers = TRUE, simplifyVector = FALSE, app = NULL,     ...) {    if (is.null(app))         app = paste0("neuprintr/", utils::packageVersion("neuprintr"))    req <- if (is.null(body)) {        httr::GET(url = file.path(server, path, fsep = "/"),             config = conf, httr::user_agent(app), ...)    }    else {        httr::POST(url = file.path(server, path, fsep = "/"),             body = body, config = conf, httr::user_agent(app),             ...)    }    neuprint_error_check(req)    if (parse.json) {        parsed = neuprint_parse_json(req, simplifyVector = simplifyVector)        if (length(parsed) == 2 && isTRUE(names(parsed)[2] ==             "error")) {            stop("neuPrint error: ", parsed$error)        }        if (include_headers) {            fields_to_include = c("url", "headers")            attributes(parsed) = c(attributes(parsed), req[fields_to_include])        }        parsed    }    else req})(path = path, body = body, server = server, conf = conf, parse.json = parse.json,     include_headers = include_headers, simplifyVector = simplifyVector,     app = app): Unauthorized (HTTP 401). Failed to process url: https://neuprint-fish2.janelia.org/api/dbmeta/datasets with neuPrint error: Please provide valid credentials.
fish_connection_table("RGC", partners = "outputs", summary = TRUE)
#> Warning: Clio dataset lookup failed; falling back to baked-in neuprint settings for `fish2`. Clio-backed functionality may be unavailable in this session.
#> Warning: Clio dataset lookup failed; falling back to baked-in neuprint settings for `fish2`. Clio-backed functionality may be unavailable in this session.
#> Error in (function (path, body = NULL, server = NULL, conf = NULL, parse.json = TRUE,     include_headers = TRUE, simplifyVector = FALSE, app = NULL,     ...) {    if (is.null(app))         app = paste0("neuprintr/", utils::packageVersion("neuprintr"))    req <- if (is.null(body)) {        httr::GET(url = file.path(server, path, fsep = "/"),             config = conf, httr::user_agent(app), ...)    }    else {        httr::POST(url = file.path(server, path, fsep = "/"),             body = body, config = conf, httr::user_agent(app),             ...)    }    neuprint_error_check(req)    if (parse.json) {        parsed = neuprint_parse_json(req, simplifyVector = simplifyVector)        if (length(parsed) == 2 && isTRUE(names(parsed)[2] ==             "error")) {            stop("neuPrint error: ", parsed$error)        }        if (include_headers) {            fields_to_include = c("url", "headers")            attributes(parsed) = c(attributes(parsed), req[fields_to_include])        }        parsed    }    else req})(path = path, body = body, server = server, conf = conf, parse.json = parse.json,     include_headers = include_headers, simplifyVector = simplifyVector,     app = app): Unauthorized (HTTP 401). Failed to process url: https://neuprint-fish2.janelia.org/api/dbmeta/datasets with neuPrint error: Please provide valid credentials.
# }
```
