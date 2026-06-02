# Read DVID body annotations for fish2 body ids

Read body annotations for the fish2 dataset from DVID.

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

This function wraps
`malevnc::`[`manc_dvid_annotations`](https://natverse.org/malevnc/reference/manc_dvid_annotations.html)
for the fish2 dataset. At present this means fetching the full DVID
annotation table for the chosen node and then subsetting in R, even when
`ids` are supplied.

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

Other live-annotations:
[`fish_annotate()`](https://flyconnectome.github.io/fishr/reference/fish_annotate.md),
[`fish_clio_annotations()`](https://flyconnectome.github.io/fishr/reference/fish_clio_annotations.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# fetch annotations for specific bodies
fish_dvid_annotations(c(100003384, 100003412))
} # }
if (FALSE) { # \dontrun{
# fetch all annotations using 5m cache if possible
df <- fish_dvid_annotations(cache=TRUE)

# filter by type regex
df <- fish_dvid_annotations("/type:RGC.*", cache=T)
} # }
if (FALSE) { # \dontrun{
# shorthand for type field
df <- fish_dvid_annotations("RGC", cache=T)
df
} # }
```
