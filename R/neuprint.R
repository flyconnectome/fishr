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
#' @param use_clio Whether to use a live Clio lookup for fish dataset settings
#'   before opening the neuprint connection. The default \code{FALSE} reuses
#'   cached live lookup results when available and otherwise relies on built-in
#'   fish2 neuprint settings.
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
fish_neuprint <- function(token = fish_neuprint_token(),
                          dataset = NULL, Force = FALSE,
                          use_clio = FALSE, ...) {
  if (is.null(dataset)) {
    dataset <- fish_default_dataset()
  }
  dataset <- normalise_fish_dataset(dataset)
  ops <- choose_fish(dataset = dataset, set = FALSE, use_clio = use_clio)

  neuprintr::neuprint_login(
    server = ops$malevnc.neuprint,
    dataset = tolower(ops$malevnc.neuprint_dataset),
    token = token,
    Force = Force,
    ...
  )
}

fish_neuprint_token <- function() {
  token <- neuprintr:::getenvoroption("token")[["token"]]
  if (is.null(token)) "" else token
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
#' \donttest{
#' head(fish_neuprint_meta("RGC"))
#' }
fish_neuprint_meta <- function(ids = NULL, conn = NULL, roiInfo = FALSE,
                                simplify.xyz = TRUE, ...,
                                dataset = fish_default_dataset()) {
  if (is.null(conn)) {
    conn <- fish_neuprint(dataset = dataset)
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

#' Fetch the ROI hierarchy for fish2
#'
#' @param root Character vector specifying a root ROI. The default
#'   (\code{NULL}) returns the whole hierarchy.
#' @param rval Whether to return an edge list \code{data.frame} (default) or an
#'   \code{igraph} object.
#' @param conn Optional, a \code{neuprint_connection} object. Defaults to
#'   \code{\link{fish_neuprint}} to ensure that the query targets fish2.
#' @param ... Additional arguments passed to
#'   \code{\link[neuprintr]{neuprint_ROI_hierarchy}}.
#' @inheritParams neuprintr::neuprint_fetch_custom
#' @inheritParams with_fish
#'
#' @return The ROI hierarchy as either an edge list or \code{igraph} object.
#' @seealso \code{\link[neuprintr]{neuprint_ROI_hierarchy}},
#'   \code{\link{fish_roi_meshes}}
#' @family neuprint
#' @export
#' @examples
#' \donttest{
#' head(fish_rois())
#' }
fish_rois <- function(root = NULL, rval = c("edgelist", "graph"),
                      cache = FALSE, conn = NULL, ...,
                      dataset = fish_default_dataset()) {
  rval <- match.arg(rval)
  if (is.null(conn)) {
    conn <- fish_neuprint(dataset = dataset)
  }

  neuprintr::neuprint_ROI_hierarchy(
    root = root,
    rval = rval,
    cache = cache,
    dataset = dataset,
    conn = conn,
    ...
  )
}

#' Fetch one or more ROI meshes for fish2
#'
#' @param rois Character vector of ROI names.
#' @param units One of \code{"nm"} (default), \code{"raw"} (8 nm voxels), or
#'   \code{"microns"}.
#' @param OmitFailures Whether to omit ROI meshes that could not be read from
#'   the server (default \code{TRUE}).
#' @param conn Optional, a \code{neuprint_connection} object. Defaults to
#'   \code{\link{fish_neuprint}} to ensure that the query targets fish2.
#' @param ... Additional arguments passed to \code{\link[nat]{nlapply}}.
#'   This allows progress reporting and simple parallelisation.
#' @inheritParams with_fish
#'
#' @return A \code{shapelist3d} containing one or more ROI \code{mesh3d}
#'   objects.
#' @seealso \code{\link[neuprintr]{neuprint_ROI_mesh}},
#'   \code{\link[nat]{nlapply}},
#'   \code{\link{fish_rois}}
#' @family neuprint
#' @export
#' @examples
#' \donttest{
#' fish_roi_meshes(c("Midbrain", "Hindbrain"), .progress = "none")
#' }
fish_roi_meshes <- function(rois, units = c("nm", "raw", "microns"),
                            OmitFailures = TRUE, conn = NULL, ...,
                            dataset = fish_default_dataset()) {
  units <- match.arg(units)
  rois <- unique(as.character(rois))
  if (!length(rois) > 0) {
    stop("`rois` must contain at least one ROI name.", call. = FALSE)
  }

  if (is.null(conn)) {
    conn <- fish_neuprint(dataset = dataset)
  }

  roi_hierarchy <- fish_rois(conn = conn, dataset = dataset, cache = TRUE)
  available_rois <- unique(c(roi_hierarchy$parent, roi_hierarchy$roi))
  available_rois <- sort(stats::na.omit(available_rois))
  missing_rois <- setdiff(rois, available_rois)
  if (length(missing_rois)) {
    stop(
      "Unknown ROI name", if (length(missing_rois) > 1) "s" else "", " for `",
      dataset, "`: ", paste(missing_rois, collapse = ", "),
      ". Use `fish_rois(cache = TRUE)` to list available ROIs.",
      call. = FALSE
    )
  }

  idx <- nat::as.neuronlist(stats::setNames(seq_along(rois), rois))
  res <- nat::nlapply(
    idx,
    function(i) neuprintr::neuprint_ROI_mesh(rois[[i]], dataset = dataset, conn = conn),
    OmitFailures = FALSE,
    ...
  )
  failed <- vapply(res, inherits, logical(1), "try-error")
  if (any(failed)) {
    failed_rois <- names(res)[failed]
    warning(
      "Meshes ", paste(failed_rois, collapse = ", "),
      " could not be read from the server.",
      call. = FALSE
    )
    if (isTRUE(OmitFailures)) {
      res <- res[!failed]
    }
  }

  ok <- !vapply(res, inherits, logical(1), "try-error")
  res[ok] <- lapply(res[ok], fish_scale_roi_mesh, units = units)
  if (all(ok)) {
    class(res) <- c("shapelist3d", "list")
  }
  res
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
    conn <- fish_neuprint(dataset = dataset)
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
fish_scale_roi_mesh <- function(mesh, units = c("nm", "raw", "microns")) {
  units <- match.arg(units)
  scale <- switch(units, raw = 1, nm = 8, microns = 8 / 1000)
  if (identical(scale, 1)) {
    return(mesh)
  }

  mesh$vb[1:3, ] <- mesh$vb[1:3, , drop = FALSE] * scale
  mesh
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
