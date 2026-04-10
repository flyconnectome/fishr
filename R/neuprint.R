#' Login to fish2 neuprint server
#'
#' @details It should be possible to use the same token across public and
#'   private neuprint servers if you are using the same email address. However
#'   this does not seem to work for all users. Before giving up on this, do try
#'   using the \emph{most} recently issued token from a private server rather
#'   than older tokens. If you need to pass a specific token you can use the
#'   \code{token} argument, also setting \code{Force=TRUE} to ensure that the
#'   specified token is used if you have already tried to log in during the
#'   current session.
#'
#' @inheritParams malevnc::manc_neuprint
#' @param dataset Allows you to override the neuprint dataset for
#'   \code{fish_neuprint} (which would otherwise be chosen based on the value
#'   of \code{options(fishr.dataset)}, normally changed by
#'   \code{\link{choose_fish_dataset}}).
#' @param Force Passed to \code{neuprintr::neuprint_login}.
#' @param ... Additional arguments passed to
#'   \code{\link[neuprintr]{neuprint_login}}.
#'
#' @return A \code{neuprint_connection} object returned by
#'   \code{\link[neuprintr]{neuprint_login}}.
#' @seealso \code{\link[malevnc]{manc_neuprint}}
#' @family neuprint
#' @export
#' @examples
#' \donttest{
#' conn <- fish_neuprint()
#' conn
#' }
fish_neuprint <- function(token = Sys.getenv("neuprint_token"),
                           dataset = NULL, Force = FALSE, ...) {
  ops <- choose_fish(set = FALSE)
  if (is.null(dataset)) {
    dataset <- ops$malevnc.neuprint_dataset
  }

  neuprintr::neuprint_login(
    server = ops$malevnc.neuprint,
    dataset = tolower(dataset),
    token = token,
    Force = Force,
    ...
  )
}

#' Fetch neuprint metadata for fish2 neurons
#'
#' @param ids Body ids, a query string (see \code{\link{fish_ids}}), or
#'   \code{NULL} to return all bodies known to neuprint.
#' @param conn Optional, a \code{neuprint_connection} object. Defaults to
#'   \code{\link{fish_neuprint}} to ensure that the query targets fish2.
#' @param roiInfo Whether to include ROI information (default \code{FALSE}).
#' @param simplify.xyz Whether to simplify columns containing XYZ locations to a
#'   simple \code{"x,y,z"} format (default \code{TRUE}).
#' @param ... Additional arguments passed to
#'   \code{\link[neuprintr]{neuprint_get_meta}}.
#' @inheritParams with_fish
#'
#' @return A data.frame with one row for each unique input id and \code{NA}s for
#'   all columns except \code{bodyid} when neuprint holds no metadata.
#' @seealso \code{\link[malevnc]{manc_neuprint_meta}}
#' @family neuprint
#' @export
#' @examples
#' \dontrun{
#' fish_neuprint_meta()
#' }
fish_neuprint_meta <- function(ids = NULL, conn = NULL, roiInfo = FALSE,
                                simplify.xyz = TRUE, ...,
                                dataset = fish_default_dataset()) {
  if (is.null(conn)) {
    conn <- with_fish(fish_neuprint(), dataset = dataset)
  }

  if (is.null(ids)) {
    # bypass manc_neuprint_meta(NULL) which tries to resolve DVID annotations;
    # query neuprint directly for all bodies
    res <- neuprintr::neuprint_get_meta(
      "where:exists(n.bodyId)", conn = conn, ...
    )
  } else {
    res <- with_fish(
      malevnc::manc_neuprint_meta(
        ids,
        conn = conn,
        roiInfo = roiInfo,
        ...
      ),
      dataset = dataset
    )
  }
  res$bodyid <- as.character(res$bodyid)

  if (isTRUE(simplify.xyz)) {
    loc_cols <- grep("Location$", colnames(res))
    for (col in loc_cols) {
      res[[col]] <- neuprint_simplify_xyz(res[[col]])
    }
  }

  if (is.null(ids)) res[order(bit64::as.integer64(res$bodyid)), ] else res
}

#' Connectivity query for fish2 neurons
#'
#' @param ids A set of body ids (see \code{\link{fish_ids}} for a range of ways
#'   to specify these).
#' @param moredetails \code{FALSE} (default) to use only the columns returned by
#'   \code{neuprint_connection_table}, \code{TRUE} to join all additional fields
#'   from \code{\link{fish_neuprint_meta}}, or a character vector naming
#'   specific extra fields (e.g. \code{c("group")}).
#' @param conn Optional, a \code{neuprint_connection} object. Defaults to
#'   \code{\link{fish_neuprint}} to ensure that the query targets fish2.
#' @inheritParams malevnc::manc_connection_table
#' @inheritParams neuprintr::neuprint_connection_table
#' @param ... Additional arguments passed to
#'   \code{\link[neuprintr]{neuprint_connection_table}}.
#' @inheritParams with_fish
#'
#' @return A data.frame.
#' @seealso \code{\link[malevnc]{manc_connection_table}}
#' @family neuprint
#' @export
#' @examples
#' \donttest{
#' fish_connection_table("RGC", partners = "outputs")
#' fish_connection_table("RGC", partners = "outputs", summary = TRUE)
#' }
fish_connection_table <- function(ids, partners = c("inputs", "outputs"),
                                  moredetails = FALSE,
                                  summary = FALSE, threshold = 1L,
                                  roi = NULL, by.roi = FALSE, conn = NULL, ...,
                                  dataset = fish_default_dataset()) {
  if (is.null(conn)) {
    conn <- with_fish(fish_neuprint(), dataset = dataset)
  }

  ids <- fish_ids(ids, conn = conn)
  res <- neuprintr::neuprint_connection_table(
    ids,
    partners = partners,
    details = TRUE,
    threshold = threshold,
    conn = conn,
    summary = summary,
    roi = roi,
    by.roi = by.roi,
    ...
  )

  if ("bodyid" %in% colnames(res))
    res$bodyid <- neuprintr:::id2char(res$bodyid)
  if ("partner" %in% colnames(res))
    res$partner <- neuprintr:::id2char(res$partner)

  if (!isFALSE(moredetails) && nrow(res) > 0) {
    if (is.character(moredetails)) {
      extrafields <- moredetails
    } else {
      extrafields <- NULL
    }
    dets <- fish_neuprint_meta(unique(res$partner), conn = conn, dataset = dataset)
    if (is.null(extrafields)) {
      extrafields <- setdiff(colnames(dets), colnames(res))
    }
    dets <- dets[union("bodyid", extrafields)]
    res <- dplyr::left_join(res, dets, by = c("partner" = "bodyid"))
  }

  res
}

#' @noRd
neuprint_simplify_xyz <- function(x) {
  longform <- grepl("^list", x)
  if (any(longform)) {
    x[longform] <- sub("list\\(([0-9 ,]+)\\).*", "\\1", x[longform])
    stillbad <- grepl("^list", x[longform])
    if (any(stillbad)) {
      warning("failed to parse ", sum(stillbad), " locations. Setting to NA.")
      x[longform][stillbad] <- NA
    }
  }
  x
}
