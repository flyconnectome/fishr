#' Soma positions and logical sides for fish2 neurons
#'
#' @description \code{fish_somapos} returns the soma position of each requested
#'   body, preferring the \code{somaLocation} field and falling back to
#'   \code{tosomaLocation} where the former is missing.
#'
#' @description \code{fish_soma_side} returns the logical side of each
#'   requested body in the dataset. The side may be derived from a manual
#'   annotation (when one exists), the instance name suffix, or the soma's
#'   position relative to the fish2 midline.
#'
#' @details The "side" returned by \code{fish_soma_side} is the **logical**
#'   side of the neuron in the dataset, not necessarily the side of the
#'   physical soma. For an ascending fibre entering the brain through a nerve
#'   from outside the EM volume, the side reflects the entry point. Such a
#'   neuron may have its soma on one side of the cord and cross to the other
#'   side before entering the imaged volume; the assigned side will follow
#'   the entry nerve, not the soma.
#'
#' @details Methods for \code{fish_soma_side}:
#'   \describe{
#'     \item{\code{auto}}{Try \code{manual} first (when implemented), then
#'       fill remaining \code{NA}s with \code{instance}, then with
#'       \code{position}. At present, \code{manual} is not yet implemented,
#'       so \code{auto} chains \code{instance} -> \code{position}.}
#'     \item{\code{manual}}{Not yet implemented; errors. Will read a
#'       \code{somaSide} column once neuprintr exposes one.}
#'     \item{\code{instance}}{Match \code{_([LRMU])$} against the
#'       \code{name} (or \code{instance}) column.}
#'     \item{\code{position}}{Classify each soma by its signed displacement
#'       from the fish2 midline via \code{\link{fish_point_side}}.
#'       \code{threshold} is forwarded as-is; the default \code{0} means
#'       \code{position} never returns \code{"M"}. \code{"M"} is reserved
#'       for bilaterally symmetric unpaired neurons that should be flagged
#'       by their instance suffix.}
#'   }
#'
#' @param ids Body ids, a query string (see \code{\link{fish_ids}}), or a
#'   metadata data.frame as returned by \code{\link{fish_neuprint_meta}}.
#' @param units Units for the returned coordinates. The neuprint
#'   \code{somaLocation} / \code{tosomaLocation} values are stored in raw
#'   voxel coordinates. \code{"nm"} (the default) scales them up by the
#'   fish2 voxel size \code{(16, 16, 15)}; \code{"raw"} leaves them
#'   unchanged; \code{"microns"} returns \code{"nm" / 1000}.
#' @param as_character If \code{TRUE}, return a character vector of
#'   \code{"x,y,z"} strings (the fishr convention for location columns).
#'   Default \code{FALSE}.
#' @param method One of \code{"auto"} (default), \code{"manual"},
#'   \code{"instance"}, \code{"position"}. See Details.
#' @param threshold Absolute Y displacement (nm) below which \code{position}
#'   reports a soma as midline (\code{"M"}). Default \code{0}. Ignored by
#'   \code{instance} and \code{manual}.
#'
#' @return \code{fish_somapos} returns an \code{Nx3} numeric matrix with
#'   columns \code{x}, \code{y}, \code{z}, or a character vector of
#'   \code{"x,y,z"} strings when \code{as_character = TRUE}. Bodies that
#'   have neither \code{somaLocation} nor \code{tosomaLocation} produce
#'   \code{NA} rows.
#'
#'   \code{fish_soma_side} returns a character vector of \code{"L"},
#'   \code{"R"}, \code{"M"}, \code{"U"} or \code{NA}, one entry per input
#'   body.
#'
#' @seealso \code{\link{fish_neuprint_meta}}, \code{\link{fish_point_side}},
#'   \code{\link{mirror_fish}}
#' @family data-queries
#' @export
#' @examples
#' \donttest{
#' meta <- fish_neuprint_meta(109192746)
#' fish_somapos(meta)
#' fish_somapos(meta, units = "microns")
#' fish_soma_side(meta)
#' }
fish_somapos <- function(ids, units = c("nm", "raw", "microns"),
                         as_character = FALSE) {
  units <- match.arg(units)

  meta <- if (is.data.frame(ids)) ids else fish_neuprint_meta(ids)
  if (!any(c("somaLocation", "tosomaLocation") %in% colnames(meta))) {
    stop("metadata must contain a somaLocation or tosomaLocation column.")
  }

  loc <- meta$somaLocation
  if ("tosomaLocation" %in% colnames(meta)) {
    missing <- is.na(nat::xyzmatrix(loc))[,1]
    if (any(missing)) loc[missing] <- meta$tosomaLocation[missing]
  }

  xyz <- nat::xyzmatrix(loc)
  # nat::xyzmatrix may drop rows that fail to parse; guard against that and
  # rebuild a full Nx3 with NAs where the location string was NA / unparsable.
  if (nrow(xyz) != length(loc)) {
    out <- matrix(NA_real_, nrow = length(loc), ncol = 3L,
                  dimnames = list(NULL, c("x", "y", "z")))
    parsed <- !is.na(loc) & nzchar(loc)
    out[parsed, ] <- xyz
    xyz <- out
  } else {
    colnames(xyz) <- c("x", "y", "z")
  }

  scaleup <- switch(units,
                  nm = c(16, 16, 15),
                  raw = 1,
                  microns = c(16, 16, 15)/1000)
  if (!identical(scaleup, 1))
    xyz <- scale(xyz, center=F, scale=1/scaleup)

  if (isTRUE(as_character)) nat::xyzmatrix2str(xyz) else xyz
}

#' @rdname fish_somapos
#' @export
fish_soma_side <- function(ids,
                           method = c("auto", "manual", "instance", "position"),
                           threshold = 0) {
  method <- match.arg(method)

  if (method == "manual") {
    stop("method=\"manual\" is not yet implemented; ",
         "no somaSide column is exposed for fish2 yet.")
  }

  meta <- if (is.data.frame(ids)) ids else fish_neuprint_meta(ids)
  if (nrow(meta) == 0L) return(character(0))
  name_col <- intersect(c("name", "instance"), colnames(meta))[1]
  has_loc <- any(c("somaLocation", "tosomaLocation") %in% colnames(meta))

  if (method == "instance") {
    if (is.na(name_col))
      stop("metadata must contain a name or instance column.")
    return(stringr::str_match(meta[[name_col]], "_([LRMU])$")[, 2])
  }

  if (method == "position") {
    if (!has_loc)
      stop("metadata must contain a somaLocation or tosomaLocation column.")
    # NA rows from fish_somapos are expected (neuron has no soma); skip them
    # before fish_point_side so it doesn't warn about untransformable points.
    xyz <- fish_somapos(meta, units = "nm")
    ok <- is.finite(rowSums(xyz))
    res <- rep(NA_character_, nrow(xyz))
    if (any(ok))
      res[ok] <- fish_point_side(xyz[ok, , drop = FALSE],
                                 units = "nm", threshold = threshold)
    return(res)
  }

  # method == "auto": instance -> position (manual to be added later).
  if (is.na(name_col) && !has_loc) {
    stop("metadata must contain at least one of somaLocation and tosomaLocation",
         " and at least one of name or instance.")
  }
  res <- fish_soma_side(meta, method='instance')
  missing <- is.na(res)
  if (any(missing)) {
    res[missing] <- fish_soma_side(meta[missing, , drop = FALSE],
                                   method = "position",
                                   threshold = threshold)
  }
  res
}
