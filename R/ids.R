#' Resolve fish2 body ids from a variety of inputs
#'
#' @description Extracts body ids from vectors, data.frames, or query strings.
#'   Query strings are passed to \code{malevnc::\link[malevnc]{manc_ids}} via
#'   the fish2 neuprint server.  For filtering DVID annotations by field, see
#'   \code{\link{fish_dvid_annotations}}.
#'
#' @param x A numeric/character vector of body ids, a \code{data.frame} with a
#'   \code{bodyid} column, or a neuprint query string (e.g. \code{"DNa02"},
#'   \code{"where:status='Traced'"}).
#' @param mustWork If \code{TRUE} (default) an error is raised when no ids are
#'   found.
#' @param as_character Whether to return ids as character (default \code{TRUE}).
#'   Character is the safest default because body ids may exceed the 53-bit
#'   integer limit of double-precision floating point (\code{2^53 - 1}).
#' @param integer64 Whether to return ids as \code{bit64::integer64}
#'   (default \code{FALSE}). Takes precedence over \code{as_character}.
#' @param unique Whether to de-duplicate the result (default \code{TRUE}).
#' @param conn A \code{neuprint_connection} object (default \code{NULL} uses
#'   \code{\link{fish_neuprint}}).
#'
#' @return A character vector of body ids (default), or
#'   \code{bit64::integer64} when \code{integer64=TRUE} or
#'   \code{as_character=FALSE}.
#' @export
#' @family fishr-package
#' @examples
#' \donttest{
#' # neuprint query by type
#' fish_ids("RGC")
#' # neuprint where clause
#' fish_ids("where:n.type='RGC'")
#' }
#' \dontrun{
#' # numeric ids passed through
#' fish_ids(c(12345, 67890))
#' # from a data.frame
#' df <- fish_dvid_annotations()
#' fish_ids(df)
#' }
fish_ids <- function(x, mustWork = TRUE, as_character = TRUE,
                     integer64 = FALSE, unique = TRUE, conn = NULL) {
  if (is.data.frame(x)) {
    stopifnot("bodyid" %in% colnames(x))
    ids <- x[["bodyid"]]
  } else if (is.character(x) && length(x) == 1 && .fish_is_query(x)) {
    if (is.null(conn))
      conn <- fish_neuprint()
    ids <- with_fish(
      malevnc::manc_ids(x, mustWork = mustWork, as_character = as_character,
                         integer64 = integer64, unique = unique, conn = conn)
    )
    return(ids)
  } else {
    ids <- x
  }

  ids <- if (isTRUE(integer64)) bit64::as.integer64(ids)
         else if (as_character) as.character(ids)
         else bit64::as.integer64(ids)
  if (unique) ids <- unique(ids)
  if (mustWork && length(ids) == 0)
    stop("No matching fish2 body ids found for: ", x)
  ids
}

# TRUE when a single string should be interpreted as a field query
.fish_is_query <- function(x) {
  substr(x, 1, 1) == "/" || (!grepl("^[0-9]+$", x) && !grepl("^[0-9e+]+$", x))
}

# Filter a data.frame using a /field:regex or bare-type query string
.fish_query_df <- function(query, df, ignore.case = FALSE) {
  if (substr(query, 1, 1) == "/")
    query <- substr(query, 2, nchar(query))

  # bare string with no colon → default to type field
  if (!grepl(":", query, fixed = TRUE))
    query <- paste0("type:", query)

  parts <- unlist(strsplit(query, ":", fixed = TRUE))
  if (length(parts) != 2)
    stop("Cannot parse query `", query,
         "`. Expected format: `/field:regex` or `field:regex`.")

  field <- parts[1]
  regex <- parts[2]

  if (!field %in% colnames(df))
    stop("Unknown field `", field, "`. Available fields: ",
         paste(colnames(df), collapse = ", "))

  if (!startsWith(regex, "^"))
    regex <- paste0("^", regex, "$")

  df[grepl(regex, df[[field]], ignore.case = ignore.case), , drop = FALSE]
}
