#' Read DVID body annotations for fish2 body ids
#'
#' @description A thin wrapper around \code{malevnc::\link[malevnc]{manc_dvid_annotations}}
#'   targeting the fish2 dataset.  Supports \code{/field:regex} query strings to
#'   filter annotations locally (see Details).
#'
#' @param ids One or more body ids, \code{NULL} (default) to fetch all
#'   annotations, or a query string (see Details).
#' @param node The DVID node (UUID) to query. The default value of 'neutu' uses
#'   the active neutu node i.e. normally the most up to date.
#' @param rval Whether to return a fully parsed \code{"data.frame"} (default)
#'   or an R \code{"list"}.
#' @param columns_show Whether to show all columns or only those with a
#'   \code{'_user'} or \code{'_time'} suffix. Accepted values: \code{'user'},
#'   \code{'time'}, \code{'all'}.
#' @param cache Whether to cache the result for 5 minutes (default
#'   \code{FALSE}).
#'
#' @details Query string formats for filtering DVID annotations:
#' \describe{
#'   \item{\code{"/type:RGC..*"}}{Match the \code{type} field with regex
#'     \code{RGC..*}.}
#'   \item{\code{"RGC.*"}}{Equivalent shorthand — bare strings default to the
#'     \code{type} field.}
#'   \item{\code{"/status:Traced"}}{Match a different field.}
#' }
#' Regex queries are automatically anchored (\code{^...$}) unless the pattern
#' already starts with \code{^}.  Queries fetch all annotations (with
#' \code{cache=TRUE}) and then filter locally.
#'
#' For neuprint-based id lookups, use \code{\link{fish_ids}} instead.
#'
#' @return A \code{tibble} of body annotations. See
#'   \code{malevnc::\link[malevnc]{manc_dvid_annotations}} for column details.
#' @export
#' @family live-annotations
#' @examples
#' \donttest{
#' # fetch annotations for specific bodies
#' fish_dvid_annotations(c(100003384, 100003412))
#' }
#' \dontrun{
#' # fetch all annotations using 5m cache if possible
#' df <- fish_dvid_annotations(cache=TRUE)
#'
#' # filter by type regex
#' df <- fish_dvid_annotations("/type:RGC.*", cache=T)
#' }
#' \donttest{
#' # shorthand for type field
#' df <- fish_dvid_annotations("RGC", cache=T)
#' df
#' }
fish_dvid_annotations <- function(ids = NULL,
                                   node = 'neutu',
                                   rval = c("data.frame", "list"),
                                   columns_show = NULL,
                                   cache = FALSE) {
  query <- NULL
  if (is.character(ids) && length(ids) == 1 && .fish_is_query(ids)) {
    query <- ids
    ids <- NULL
    cache <- TRUE
  }
  df <- with_fish(malevnc::manc_dvid_annotations(ids = ids, node = node,
                                                   rval = rval,
                                                   columns_show = columns_show,
                                                   cache = cache))
  if (!is.null(query))
    df <- .fish_query_df(query, df)
  df
}

#' Set body annotations for fish2 via Clio
#'
#' @description Set one or more Clio body annotations for the fish2 dataset.
#'
#' @details This function sets annotations for one or more bodyids. Logically
#'   these annotations move with the bodyid (rather than a point location on the
#'   object). The rules for annotation merges/transfers seem to work well in
#'   practice but in general detailed annotations should be reserved for
#'   large/mature bodies.
#'
#'   The function wraps \code{malevnc::\link[malevnc]{manc_annotate_body}} for
#'   the fish2 dataset. Safe-by-default: the default \code{dry_run=TRUE}
#'   returns a preview of the POST body that would be sent to Clio without
#'   writing anything. Inspect the preview and then rerun with
#'   \code{dry_run=FALSE} to commit the changes. Fish2 does not currently
#'   have a separate Clio test server, so \code{test=FALSE} is the default.
#'
#' @param x Annotation data usually as a data.frame containing a bodyid column.
#'   Please see \code{malevnc::\link[malevnc]{manc_annotate_body}} for other
#'   options.
#' @param test Whether to use the Clio test store. Default \code{FALSE}
#'   writes to production (fish2 has no separate test server); see
#'   \code{\link[malevnc]{manc_annotate_body}}.
#' @param dry_run When \code{TRUE} (the default) no data is written; a preview
#'   tibble of the POST body is returned. Pass \code{dry_run = FALSE} to
#'   actually write. See \code{\link[malevnc]{manc_annotate_body}} for full
#'   details.
#' @param chunksize When you have many bodies to annotate the request will by
#'   default be sent 50 records at a time to avoid any issue with timeouts. Set
#'   to \code{Inf} to insist that all records are sent in a single request.
#'   \bold{NB only applies when \code{x} is a data.frame}.
#' @inheritParams malevnc::manc_annotate_body
#'
#' @return The result returned by \code{\link[malevnc]{manc_annotate_body}}:
#'   \code{NULL} invisibly when writing, or a preview \code{tibble} when
#'   \code{dry_run=TRUE}.
#' @export
#' @family live-annotations
#'
#' @examples
#' \dontrun{
#' # preview what would be written
#' fish_annotate(data.frame(bodyid = 100003384, group = 100003384))
#' # actually write
#' fish_annotate(data.frame(bodyid = 100003384, group = 100003384),
#'               dry_run = FALSE)
#' }
fish_annotate <- function(x, test = FALSE, version = NULL,
                          write_empty_fields = FALSE,
                          allow_new_fields = FALSE,
                          designated_user = NULL,
                          protect = c("user"), chunksize = 50,
                          dry_run = TRUE, ...) {
  if (is.data.frame(x) && "bodyid" %in% colnames(x)) {
    x$bodyid <- fish_ids(x$bodyid, as_character = FALSE, unique = FALSE)
  }

  if(is.data.frame(x) && !'bodyid' %in% colnames(x))
    stop("`x` does not contain a bodyid column")

  res <- with_fish(
    malevnc::manc_annotate_body(
      x,
      test = test,
      version = version,
      write_empty_fields = write_empty_fields,
      allow_new_fields = allow_new_fields,
      designated_user = designated_user,
      protect = protect,
      chunksize = chunksize,
      query = FALSE,
      dry_run = dry_run,
      ...
    )
  )

  if (isTRUE(dry_run)) res else invisible(res)
}
