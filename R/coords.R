#' Convert xyz points between fish2 coordinate systems
#'
#' @description fish2 uses three distinct voxel scales that all turn up in
#'   day-to-day work: nm (the canonical unit for spatial transforms like
#'   \code{\link{mirror_fish}}), raw (the (16, 16, 15) nm voxel grid stored in
#'   neuprint's \code{somaLocation} and friends), and emraw (the (8, 8, 30) nm
#'   voxel grid of the EM imagery and the Clio / DVID URL conventions).
#'   \code{fish_coords} converts between any of these, plus microns.
#'
#' @details fish2 has two "raw" voxel grids because neuprint indexes the
#'   segmentation at a coarser (16, 16, 15) nm grid (the natural unit for
#'   computations against the segmentation volume), while the underlying EM
#'   image stack and the Clio annotation server use the finer (8, 8, 30) nm
#'   acquisition grid. Coordinates copied from neuroglancer URLs that point at
#'   the EM imagery (or pasted from Clio) are in emraw; coordinates pulled
#'   from \code{somaLocation} / \code{tosomaLocation} or sent to the DVID
#'   \code{segmentation/labels} endpoint are in raw. raw and emraw are related
#'   by \code{emraw = raw * c(2, 2, 0.5)}.
#'
#' @param xyz Point coordinates. Anything accepted by
#'   \code{\link[nat]{xyzmatrix}} (vector, matrix, data.frame, "x,y,z" strings).
#' @param from,to Source and target units. One of \code{"nm"} (default),
#'   \code{"raw"} (16, 16, 15 nm voxels, the neuprint grid), \code{"emraw"}
#'   (8, 8, 30 nm voxels, the EM acquisition grid), \code{"microns"}.
#' @param as_character If \code{TRUE}, return a character vector of
#'   \code{"x,y,z"} strings via \code{\link[nat]{xyzmatrix2str}}.
#'
#' @return An Nx3 numeric matrix in the requested units, or a character vector
#'   when \code{as_character = TRUE}.
#' @family coords
#' @seealso \code{\link{fish_xyz2bodyid}}
#' @export
#' @examples
#' # neuprint "raw" -> EM "emraw"
#' fish_coords(c(57780, 28028, 10984), from = "raw", to = "emraw")
#'
#' # emraw -> nm
#' fish_coords(c(115560, 56056, 5492), from = "emraw", to = "nm")
#'
#' # batch + character output
#' fish_coords(rbind(c(115560, 56056, 5492), c(0, 0, 0)),
#'             from = "emraw", to = "raw", as_character = TRUE)
fish_coords <- function(xyz, from = "nm", to = "nm", as_character = FALSE) {
  unit_choices <- c("nm", "raw", "emraw", "microns")
  from <- match.arg(from, unit_choices)
  to <- match.arg(to, unit_choices)

  xyzmat <- nat::xyzmatrix(xyz)
  if (nrow(xyzmat) == 0L)
    return(if (isTRUE(as_character)) character(0) else xyzmat)

  # Input units -> nm (multiply each column by the voxel size).
  to_nm <- switch(from,
                  nm = 1,
                  raw = c(16, 16, 15),
                  emraw = c(8, 8, 30),
                  microns = 1000)
  if (!identical(to_nm, 1))
    xyzmat <- sweep(xyzmat, 2, to_nm, `*`)

  # nm -> output units (divide each column by the target voxel size).
  from_nm <- switch(to,
                    nm = 1,
                    raw = c(16, 16, 15),
                    emraw = c(8, 8, 30),
                    microns = 1000)
  if (!identical(from_nm, 1))
    xyzmat <- sweep(xyzmat, 2, from_nm, `/`)

  if (isTRUE(as_character)) nat::xyzmatrix2str(xyzmat) else xyzmat
}

#' Map xyz points to fish2 body ids via DVID
#'
#' @description Look up the segmentation body id at each 3D point. Thin wrapper
#'   around \code{malevnc::\link[malevnc]{manc_xyz2bodyid}} that targets the
#'   active fish2 DVID node. Input may be in emraw (default), raw, nm or
#'   microns; see \code{\link{fish_coords}} for what each means.
#'
#' @details The DVID \code{segmentation/labels} endpoint indexes the
#'   segmentation at the neuprint (16, 16, 15) "raw" grid, so input
#'   coordinates are first converted to raw via \code{\link{fish_coords}} and
#'   then rounded to integer voxel positions before the call (as in
#'   \code{manc_xyz2bodyid}). Points with \code{NA} coordinates yield
#'   \code{NA_character_} in the output.
#'
#' @param xyz Point coordinates: a length-3 numeric vector for a single point,
#'   an Nx3 numeric matrix / data.frame, or anything else accepted by
#'   \code{\link[nat]{xyzmatrix}} (including \code{"x,y,z"} strings).
#' @param units Units of the input coordinates. \code{"emraw"} (the default)
#'   matches coordinates copied from neuroglancer URLs against the fish2 EM
#'   imagery; \code{"raw"} matches the neuprint segmentation grid;
#'   \code{"nm"} and \code{"microns"} are self-explanatory. See
#'   \code{\link{fish_coords}} for the underlying voxel sizes.
#' @param node The DVID node (UUID) to query. The default \code{"neutu"} uses
#'   the active neutu node, normally the most up-to-date.
#' @param cache Whether to cache the result of this call for 5 minutes (default
#'   \code{FALSE}).
#'
#' @return A character vector of body ids, one per input point.
#'   \code{NA_character_} where the input row had any \code{NA}.
#' @seealso \code{\link{fish_neuprint_meta}}, \code{\link{fish_coords}},
#'   \code{malevnc::\link[malevnc]{manc_xyz2bodyid}}
#' @family coords
#' @export
#' @examples
#' \dontrun{
#' # default emraw matches a point copied from a fish2 EM neuroglancer URL
#' fish_xyz2bodyid(c(115560, 56056, 5492))                # -> 100001043
#'
#' # same body looked up via neuprint-raw coordinates
#' fish_xyz2bodyid(c(57780, 28028, 10984), units = "raw") # -> 100001043
#' }
fish_xyz2bodyid <- function(xyz,
                            units = c("emraw", "raw", "nm", "microns"),
                            node = "neutu",
                            cache = FALSE) {
  units <- match.arg(units)

  xyzmat <- fish_coords(xyz, from = units, to = "raw")
  if (nrow(xyzmat) == 0L) return(character(0))

  ids <- with_fish(malevnc::manc_xyz2bodyid(xyzmat, node = node, cache = cache))

  # malevnc returns 0 for rows that were all-NA; promote to NA_character_ to
  # match other fishr id-returning helpers.
  ids <- neuprintr:::id2char(ids)
  ids[ids == "0"] <- NA_character_
  ids
}
