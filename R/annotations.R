#' Read DVID body annotations for fish2 body ids
#'
#' @description A thin wrapper around \code{malevnc::\link[malevnc]{manc_dvid_annotations}}
#'   targeting the fish2 dataset. Supports \code{/field:regex} query strings to
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
#' already starts with \code{^}. Queries fetch all annotations (with
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

#' Read Clio body annotations for fish2 body ids
#'
#' @description Read live body annotations for the fish2 dataset from Clio.
#'
#' @param ids One or more body ids, \code{NULL} (default) to fetch all
#'   annotations, or anything accepted by \code{\link{fish_ids}}.
#' @inheritParams malevnc::manc_body_annotations
#'
#' @details This function wraps
#'   \code{malevnc::\link[malevnc]{manc_body_annotations}} for the active fish
#'   dataset. When \code{ids} are supplied they are first resolved with
#'   \code{\link{fish_ids}}, so you can pass fish body ids or simple
#'   neuprint-backed queries such as cell types. Leave \code{ids=NULL} to use
#'   the \code{query} argument directly, as in
#'   \code{malevnc::manc_body_annotations}. When querying numeric fields such
#'   as \code{group}, use numeric values rather than quoted strings.
#'
#' @return A \code{data.frame} of body annotations. See
#'   \code{malevnc::\link[malevnc]{manc_body_annotations}} for further details.
#' @export
#' @family live-annotations
#'
#' @examples
#' \dontrun{
#' fish_clio_annotations(ids = 100003384)
#' fish_clio_annotations(ids = "RGC")
#' fish_clio_annotations(query = list(group = 100003384))
#' }
fish_clio_annotations <- function(ids = NULL, query = NULL, json = FALSE,
                                  config = NULL, cache = FALSE,
                                  update.bodyids = FALSE, test = FALSE,
                                  show.extra = c("none", "user", "time", "all"),
                                  ...) {
  if (!is.null(ids)) {
    ids <- fish_ids(ids, as_character = FALSE, unique = FALSE)
  }
  if (is.list(query) &&
      "group" %in% names(query) &&
      is.character(query$group) &&
      length(query$group) == 1 &&
      grepl("^[0-9]+$", query$group)) {
    warning(
      "`query$group` was supplied as a character string; coercing to numeric ",
      "for Clio query matching.",
      call. = FALSE
    )
    query$group <- as.numeric(query$group)
  }

  with_fish(
    malevnc::manc_body_annotations(
      ids = ids,
      query = query,
      json = json,
      config = config,
      cache = cache,
      update.bodyids = update.bodyids,
      test = test,
      show.extra = show.extra,
      ...
    )
  )
}

#' Set body annotations for fish2 via Clio
#'
#' @description Sets one or more Clio body annotations for the fish2 dataset.
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
#'   \code{dry_run=FALSE} to commit the changes. Note that this preview does
#'   not model server-side protection checks controlled by \code{protect}, so
#'   fields shown in the preview may still be refused when you actually write.
#'   fish2 does not currently have a separate Clio test server, so
#'   \code{test=FALSE} is the default.
#'
#' @param x Annotation data usually as a data.frame containing a bodyid column.
#'   Please see \code{malevnc::\link[malevnc]{manc_annotate_body}} for other
#'   options.
#' @param test Whether to use the Clio test store. Default \code{FALSE}
#'   writes to production (fish2 has no separate test server); see
#'   \code{\link[malevnc]{manc_annotate_body}}.
#' @param dry_run When \code{TRUE} (the default) no data is written; a preview
#'   tibble of the POST body is returned. This preview shows what differs from
#'   the current Clio record, but it does not model server-side protection
#'   checks controlled by \code{protect}. Pass \code{dry_run = FALSE} to
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
#' if (nzchar(Sys.getenv("CLIO_TOKEN"))) {
#'   # preview what would be written for a simple update
#'
#'   fish_annotate(data.frame(bodyid = 100003384, group = 100003384))
#'
#'   # preview multiple fields at once
#'   fish_annotate(data.frame(
#'     bodyid = 100003384,
#'     group = 100003384,
#'     type = "RGC"
#'   ))
#'
#'   # preview the payload that would be sent with protect = TRUE
#'   # note that dry_run does not model server-side protection checks
#'   fish_annotate(
#'     data.frame(bodyid = 100003384, group = 100003384, type = "RGC"),
#'     protect = TRUE
#'   )
#'
#'   # preview an update that would request overwriting existing fields
#'   fish_annotate(
#'     data.frame(bodyid = 100003384, group = 100003384, type = "RGC"),
#'     protect = FALSE
#'   )
#'
#'   # preview clearing a field
#'   fish_annotate(
#'     data.frame(bodyid = 100003384, type = ""),
#'     protect = FALSE,
#'     write_empty_fields = TRUE
#'   )
#' }
#'
#' \dontrun{
#' # actually write an annotation
#' fish_annotate(data.frame(bodyid = 100003384, group = 100003384),
#'               dry_run = FALSE)
#'
#' # actually write while allowing overwrites
#' fish_annotate(
#'   data.frame(bodyid = 100003384, type = "RGC"),
#'   protect = FALSE,
#'   dry_run = FALSE
#' )
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
