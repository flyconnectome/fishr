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
#'   \item{\code{"/type:TRP.*"}}{Match the \code{type} field with regex
#'     \code{TRP.*}.}
#'   \item{\code{"TRP.*"}}{Equivalent shorthand — bare strings default to the
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
#' @family fishr-package
#' @examples
#' \dontrun{
#' # fetch all annotations
#' df <- fish_dvid_annotations()
#'
#' # fetch annotations for specific bodies
#' df <- fish_dvid_annotations(c(12345, 67890))
#'
#' # filter by type regex
#' df <- fish_dvid_annotations("/type:TRP.*")
#'
#' # shorthand for type field
#' df <- fish_dvid_annotations("TRP.*")
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
