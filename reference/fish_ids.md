# Resolve fish2 body ids from a variety of inputs

Extracts body ids from vectors, data.frames, or query strings. Query
strings are passed to
`malevnc::`[`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.html)
via the fish2 neuprint server. For filtering DVID annotations by field,
see
[`fish_dvid_annotations`](https://flyconnectome.github.io/fishr/reference/fish_dvid_annotations.md).

## Usage

``` r
fish_ids(
  x,
  mustWork = TRUE,
  as_character = TRUE,
  integer64 = FALSE,
  unique = TRUE,
  conn = NULL
)
```

## Arguments

- x:

  A numeric/character vector of body ids, a `data.frame` with a `bodyid`
  column, or a neuprint query string (e.g. `"DNa02"`,
  `"where:status='Traced'"`).

- mustWork:

  If `TRUE` (default) an error is raised when no ids are found.

- as_character:

  Whether to return ids as character (default `TRUE`). Character is the
  safest default because body ids may exceed the 53-bit integer limit of
  double-precision floating point (`2^53 - 1`).

- integer64:

  Whether to return ids as
  [`bit64::integer64`](https://rdrr.io/pkg/bit64/man/bit64-package.html)
  (default `FALSE`). Takes precedence over `as_character`.

- unique:

  Whether to de-duplicate the result (default `TRUE`).

- conn:

  A `neuprint_connection` object (default `NULL` uses
  [`fish_neuprint`](https://flyconnectome.github.io/fishr/reference/fish_neuprint.md)).

## Value

A character vector of body ids (default), or
[`bit64::integer64`](https://rdrr.io/pkg/bit64/man/bit64-package.html)
when `integer64=TRUE` or `as_character=FALSE`.

## See also

Other fishr-package:
[`fish_dvid_annotations()`](https://flyconnectome.github.io/fishr/reference/fish_dvid_annotations.md),
[`fish_setup()`](https://flyconnectome.github.io/fishr/reference/fish_setup.md),
[`read_fish_meshes()`](https://flyconnectome.github.io/fishr/reference/read_fish_meshes.md),
[`with_fish()`](https://flyconnectome.github.io/fishr/reference/with_fish.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# neuprint query by type
fish_ids("DNa02")
# neuprint where clause
fish_ids("where:status='Traced'")
# numeric ids passed through
fish_ids(c(12345, 67890))
# from a data.frame
df <- fish_dvid_annotations()
fish_ids(df)
} # }
```
