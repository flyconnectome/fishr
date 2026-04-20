# Set body annotations for fish2 via Clio

Set one or more Clio body annotations for the fish2 dataset.

## Usage

``` r
fish_annotate(
  x,
  test = TRUE,
  version = NULL,
  write_empty_fields = FALSE,
  allow_new_fields = FALSE,
  designated_user = NULL,
  protect = c("user"),
  chunksize = 50,
  ...
)
```

## Arguments

- x:

  Annotation data usually as a data.frame containing a bodyid column.
  Please see
  `malevnc::`[`manc_annotate_body`](https://natverse.org/malevnc/reference/manc_annotate_body.html)
  for other options.

- test:

  Whether to do a dry run without writing annotations. Because fish2
  does not currently appear to have a separate Clio test server, the
  default `TRUE` returns the supplied annotations and does not send them
  to Clio.

- version:

  Optional clio version to associate with this annotation. The default
  `NULL` uses the current version returned by the API.

- write_empty_fields:

  When `x` is a data.frame, this controls whether empty fields in `x`
  (i.e. `NA` or `""`) overwrite fields in the clio-store database (when
  they are not protected by the `protect` argument). The (conservative)
  default `write_empty_fields=FALSE` does not overwrite. If you do want
  to set fields to an empty value (usually the empty string) then you
  must set `write_empty_fields=TRUE`.

- allow_new_fields:

  Whether to allow creation of new clio fields. Default `FALSE` will
  produce an error encouraging you to check the field names.

- designated_user:

  Optional email address when one person is uploading annotations on
  behalf of another user. See **Users** section for details.

- protect:

  Vector of fields that will not be overwritten if they already have a
  value in clio store. Set to `TRUE` to protect all fields and to
  `FALSE` to overwrite all fields for which you provide data. See
  details for the rationale behind the default value of "user"

- chunksize:

  When you have many bodies to annotate the request will by default be
  sent 50 records at a time to avoid any issue with timeouts. Set to
  `Inf` to insist that all records are sent in a single request. **NB
  only applies when `x` is a data.frame**.

- ...:

  Additional parameters passed to
  [`pbapply::pbsapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)

## Value

When `test=FALSE`, the result returned by
[`manc_annotate_body`](https://natverse.org/malevnc/reference/manc_annotate_body.html).
When `test=TRUE`, returns the checked input `x`.

## Details

This function sets annotations for one or more bodyids. Logically these
annotations move with the bodyid (rather than a point location on the
object). The rules for annotation merges/transfers seem to work well in
practice but in general detailed annotations should be reserved for
large/mature bodies.

The function wraps
`malevnc::`[`manc_annotate_body`](https://natverse.org/malevnc/reference/manc_annotate_body.html)
for the fish2 dataset. The default `test=TRUE` is retained for safety,
but there does not currently appear to be a separate fish2 annotation
test server. Therefore `test=TRUE` currently returns the supplied
annotations without sending them to Clio. Please inspect these carefully
before rerunning with `test=FALSE`.

## See also

Other live-annotations:
[`fish_dvid_annotations()`](https://flyconnectome.github.io/fishr/reference/fish_dvid_annotations.md)

## Examples

``` r
if (FALSE) { # \dontrun{
fish_annotate(data.frame(bodyid = 100003384, group = 100003384), test = TRUE)
} # }
```
