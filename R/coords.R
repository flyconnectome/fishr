#' Map xyz points to fish2 body ids via DVID
#'
#' @description Look up the segmentation body id at each 3D point. Thin wrapper
#'   around \code{malevnc::\link[malevnc]{manc_xyz2bodyid}} that targets the
#'   active fish2 DVID node and accepts coordinates in raw voxels (default), nm,
#'   or microns.
#'
#' @details Coordinates are rounded to integer voxel positions before the DVID
#'   call (\code{segmentation/labels}), as in \code{manc_xyz2bodyid}. Points
#'   with \code{NA} coordinates yield \code{NA_character_} in the output.
#'
#' @param xyz Point coordinates: a length-3 numeric vector for a single point,
#'   an Nx3 numeric matrix / data.frame, or anything else accepted by
#'   \code{\link[nat]{xyzmatrix}} (including \code{"x,y,z"} strings).
#' @param units Units of the input coordinates. \code{"raw"} (the default)
#'   leaves them unchanged; \code{"nm"} divides by the fish2 voxel size
#'   \code{(16, 16, 15)}; \code{"microns"} divides by \code{(16, 16, 15) /
#'   1000}. The default is \code{"raw"} because the most common interactive
#'   use is pasting coordinates from neuroglancer.
#' @param node The DVID node (UUID) to query. The default \code{"neutu"} uses
#'   the active neutu node, normally the most up-to-date.
#' @param cache Whether to cache the result of this call for 5 minutes (default
#'   \code{FALSE}).
#'
#' @return A character vector of body ids, one per input point.
#'   \code{NA_character_} where the input row had any \code{NA}.
#' @seealso \code{\link{fish_neuprint_meta}}, \code{\link{fish_somapos}},
#'   \code{malevnc::\link[malevnc]{manc_xyz2bodyid}}
#' @family coords
#' @export
#' @examples
#' \dontrun{
#' # single point from a neuroglancer URL (raw voxel coords)
#' fish_xyz2bodyid(c(36844, 40493, 16389))
#'
#' # batch in nm (e.g. from fish_somapos())
#' meta <- fish_neuprint_meta(109192746)
#' fish_xyz2bodyid(fish_somapos(meta), units = "nm")
#' }
fish_xyz2bodyid <- function(xyz,
                            units = c("raw", "nm", "microns"),
                            node = "neutu",
                            cache = FALSE) {
  units <- match.arg(units)

  xyzmat <- nat::xyzmatrix(xyz)
  if (nrow(xyzmat) == 0L) return(character(0))

  scaledown <- switch(units,
                      raw = 1,
                      nm = c(16, 16, 15),
                      microns = c(16, 16, 15) / 1000)
  if (!identical(scaledown, 1))
    xyzmat <- scale(xyzmat, center = FALSE, scale = scaledown)

  ids <- with_fish(malevnc::manc_xyz2bodyid(xyzmat, node = node, cache = cache))

  # malevnc returns 0 for rows that were all-NA; promote to NA_character_ to
  # match other fishr id-returning helpers.
  ids <- neuprintr:::id2char(ids)
  ids[ids == "0"] <- NA_character_
  ids
}
