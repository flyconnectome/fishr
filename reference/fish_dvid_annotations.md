# Read DVID body annotations for fish2 body ids

A thin wrapper around
`malevnc::`[`manc_dvid_annotations`](https://natverse.org/malevnc/reference/manc_dvid_annotations.html)
targeting the fish2 dataset. Supports `/field:regex` query strings to
filter annotations locally (see Details).

## Usage

``` r
fish_dvid_annotations(
  ids = NULL,
  node = "neutu",
  rval = c("data.frame", "list"),
  columns_show = NULL,
  cache = FALSE
)
```

## Arguments

- ids:

  One or more body ids, `NULL` (default) to fetch all annotations, or a
  query string (see Details).

- node:

  The DVID node (UUID) to query. The default value of 'neutu' uses the
  active neutu node i.e. normally the most up to date.

- rval:

  Whether to return a fully parsed `"data.frame"` (default) or an R
  `"list"`.

- columns_show:

  Whether to show all columns or only those with a `'_user'` or
  `'_time'` suffix. Accepted values: `'user'`, `'time'`, `'all'`.

- cache:

  Whether to cache the result for 5 minutes (default `FALSE`).

## Value

A `tibble` of body annotations. See
`malevnc::`[`manc_dvid_annotations`](https://natverse.org/malevnc/reference/manc_dvid_annotations.html)
for column details.

## Details

Query string formats for filtering DVID annotations:

- `"/type:RGC..*"`:

  Match the `type` field with regex `RGC..*`.

- `"RGC.*"`:

  Equivalent shorthand — bare strings default to the `type` field.

- `"/status:Traced"`:

  Match a different field.

Regex queries are automatically anchored (`^...$`) unless the pattern
already starts with `^`. Queries fetch all annotations (with
`cache=TRUE`) and then filter locally.

For neuprint-based id lookups, use
[`fish_ids`](https://flyconnectome.github.io/fishr/reference/fish_ids.md)
instead.

## See also

Other fishr-package:
[`fish_ids()`](https://flyconnectome.github.io/fishr/reference/fish_ids.md),
[`fish_setup()`](https://flyconnectome.github.io/fishr/reference/fish_setup.md),
[`read_fish_meshes()`](https://flyconnectome.github.io/fishr/reference/read_fish_meshes.md),
[`with_fish()`](https://flyconnectome.github.io/fishr/reference/with_fish.md)

## Examples

``` r
# \donttest{
# fetch annotations for specific bodies
fish_dvid_annotations(c(100003384, 100003412))
#> Warning: Clio dataset lookup failed; falling back to baked-in neuprint settings for `fish2`. Clio-backed functionality may be unavailable in this session.
#> Error in (function (server = getOption("malevnc.server")) {    if (is.null(server))         stop("Please use options(malevnc.server) to set the URL of the emdata server!")    pu = tryCatch(httr::parse_url(server), error = function(e) stop("Unable to parse malevnc.server URL:",         server))    server_down <- is.null(curl::nslookup(pu$hostname, error = FALSE))    if (server_down) {        internet_ok <- !is.null(curl::nslookup("google.com",             error = FALSE))        if (internet_ok)             stop("Cannot reach malevnc server. Please check `options('malevnc.server')")        else stop("Cannot reach malevnc server or google. Please check your internet connection!")    }    server})(): Please use options(malevnc.server) to set the URL of the emdata server!
# }
if (FALSE) { # \dontrun{
# fetch all annotations using 5m cache if possible
df <- fish_dvid_annotations(cache=TRUE)

# filter by type regex
df <- fish_dvid_annotations("/type:RGC.*", cache=T)
} # }
# \donttest{
# shorthand for type field
df <- fish_dvid_annotations("RGC", cache=T)
#> Warning: Clio dataset lookup failed; falling back to baked-in neuprint settings for `fish2`. Clio-backed functionality may be unavailable in this session.
#> Error in (function (server = getOption("malevnc.server")) {    if (is.null(server))         stop("Please use options(malevnc.server) to set the URL of the emdata server!")    pu = tryCatch(httr::parse_url(server), error = function(e) stop("Unable to parse malevnc.server URL:",         server))    server_down <- is.null(curl::nslookup(pu$hostname, error = FALSE))    if (server_down) {        internet_ok <- !is.null(curl::nslookup("google.com",             error = FALSE))        if (internet_ok)             stop("Cannot reach malevnc server. Please check `options('malevnc.server')")        else stop("Cannot reach malevnc server or google. Please check your internet connection!")    }    server})(): Please use options(malevnc.server) to set the URL of the emdata server!
df
#> function (x, df1, df2, ncp, log = FALSE) 
#> {
#>     if (missing(ncp)) 
#>         .Call(C_df, x, df1, df2, log)
#>     else .Call(C_dnf, x, df1, df2, ncp, log)
#> }
#> <bytecode: 0x55a4a212a078>
#> <environment: namespace:stats>
# }
```
