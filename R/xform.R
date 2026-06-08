#' Mirror points or neurons in fish2 space
#'
#' @description \code{mirror_fish} mirrors objects with 3D vertices calibrated
#'   in nanometres across the fish2 midline using a thin plate spline
#'   registration derived from Philipp Schlegel's navis-fishbrains landmarks.
#'
#' @param x Any object with 3D vertices (calibrated in nm), e.g. a neuron, a
#'   neuronlist, a mesh, or a 3-column matrix / data frame of points.
#' @param ... Additional arguments passed to
#'   \code{\link[nat.templatebrains]{xform_brain}}.
#'
#' @return \code{mirror_fish} returns the mirrored object.
#' @format \code{fish2_mirror_reg} is a \code{tpsreg}/\code{reglist} object.
#' @export
#' @examples
#' \dontrun{
#' library(nat)
#' # round-trip: mirroring twice should approximately recover the input
#' pts <- cbind(x = 500000, y = 400000, z = 150000)
#' mirror_fish(mirror_fish(pts))
#' }
mirror_fish <- function(x, ...) {
  if (!requireNamespace("nat.templatebrains", quietly = TRUE)) {
    stop("Package 'nat.templatebrains' is required for mirror_fish().")
  }
  # Morpho is a Suggest of nat (used by nat::xform.tpsreg for the actual TPS
  # transform). Without it xform_brain silently returns NAs.
  check_package_available("Morpho")
  nat.templatebrains::xform_brain(x, sample = "fish2_mirror",
                                  reference = "fish2", ...)
}

#' @rdname mirror_fish
#' @docType data
#' @keywords datasets
#' @description \code{fish2_mirror_reg} is the underlying
#'   \code{\link[nat]{tpsreg}} registration object for mirroring.
#'
#' @details \code{fish2_mirror_reg} is shipped with the package and added to the
#'   \code{nat.templatebrains} registry on package load by
#'   \code{\link{fish_register_xforms}}, so calling \code{mirror_fish} normally
#'   needs no setup. See \code{data-raw/fish2_mirror_reg.R} for the construction
#'   recipe from the upstream
#'   \href{https://github.com/schlegelp/navis-fishbrains}{navis-fishbrains}
#'   landmark CSV.

"fish2_mirror_reg"

#' Predict the L/R side of points in fish2 space
#'
#' @description Applies the fish2 mirror transform to each input point and
#'   measures the signed displacement along the mirror (Y) axis before and after
#'   transform. The sign indicates which side of the midline the point lies on.
#'
#' @details right-side points have \code{dist = (mirror_y - y)/2 < 0}. Points
#'   with \code{|dist| <= threshold} are reported as midline. If \code{dist==0}
#'   and \code{threshold==0} then points will be reported as "R".
#'
#' @param xyz Point coordinates. Anything accepted by
#'   \code{\link[nat]{xyzmatrix}} (matrix, data.frame, neuron, neuronlist), a
#'   length-3 numeric vector for a single point, or a character vector of
#'   comma-separated \code{"x,y,z"} strings (the fishr convention for location
#'   columns).
#' @param units Units of the input coordinates. \code{"nm"} (the default)
#'   matches \code{\link{mirror_fish}}; \code{"raw"} (16, 16, 15 nm voxel
#'   spacing) and \code{"microns"} are scaled to nm first.
#' @param threshold Distance from midline below which points are reported as M
#'   rather than L or R. Default 5000 nm (~5 \eqn{\mu}m, ~1\% of the y
#'   (medio-lateral) extent of the fish2 brain). Set to 0 for all values to be L
#'   or R
#' @param rval What to return. \code{"side"} (the default) gives a character
#'   vector of side labels (\code{"L"}, \code{"R"} or \code{"M"}).
#'   \code{"distance"} gives a signed distance from the midline in nm (always
#'   nm, regardless of \code{units}), positive on the right, negative on the
#'   left.
#'
#' @return When \code{rval = "side"}, a character vector of \code{"L"},
#'   \code{"R"} or \code{"M"}, one per input point, or \code{NA} for bad points.
#'   When \code{rval = "distance"}, a numeric vector of signed distances from
#'   the midline in nm.
#' @seealso \code{\link{mirror_fish}}
#' @family spatial-transforms
#' @export
#' @examples
#' # known right-side point (raw voxel)
#' fish_point_side(c(30159, 33753, 6352), units = "raw")
#'
#' # a small batch in nm
#' xyz_nm <- rbind(c(482544, 540048,  95280),   # right
#'                 c(482544, 380000,  95280),   # left
#'                 c(735728, 430864,  94620))   # near midline
#' fish_point_side(xyz_nm)
#'
#' # signed distance from the midline (always in nm)
#' fish_point_side(xyz_nm, rval = "distance")
fish_point_side <- function(xyz,
                            units = c("nm", "raw", "microns"),
                            threshold = 5000,
                            rval = c("side", "distance")) {
  units <- match.arg(units)
  rval <- match.arg(rval)
  checkmate::assert_number(threshold, lower=0, upper = Inf)

  xyz <- nat::xyzmatrix(xyz)
  if (nrow(xyz) == 0L)
    return(if (rval == "side") character(0) else numeric(0))

  scaleup <- switch(units,
                  nm = 1,
                  raw = c(16, 16, 15),
                  microns = c(1000, 1000, 1000))
  if (!identical(scaleup, 1))
    xyz <- scale(xyz, scale = 1/scaleup, center = F)

  mxyz <- mirror_fish(xyz)
  # |dy| is twice distance from midline (point and mirror sit at +d and -d)
  dist <- unname((mxyz[, 2] - xyz[, 2]) / 2)
  dist[!is.finite(dist)] <- NA_real_

  if (rval == "distance")
    return(dist)

  # dist == 0 deliberately maps to "R" (caller can use threshold > 0 to get "M").
  side <- ifelse(dist < 0, "L", "R")
  if (threshold > 0)
    side[abs(dist) < threshold] <- "M"

  side
}

#' Register fish2 bridging / mirroring transforms
#'
#' @description \code{fish_register_xforms} adds the package's mirroring
#'   registration (see \code{\link{fish2_mirror_reg}}) to the
#'   \code{nat.templatebrains} registry so that
#'   \code{\link[nat.templatebrains]{xform_brain}} can move points between
#'   \code{"fish2"} and \code{"fish2_mirror"}. It is called automatically when
#'   the package is loaded.
#'
#' @return Invisibly returns \code{TRUE} when the registration is added,
#'   \code{FALSE} otherwise (e.g. if \code{nat.templatebrains} is unavailable).
#' @keywords internal
#' @export
#' @examples
#' \dontrun{
#' fish_register_xforms()
#' }
fish_register_xforms <- function() {
  if (!requireNamespace("nat.templatebrains", quietly = TRUE)) {
    return(invisible(FALSE))
  }
  nat.templatebrains::add_reglist(
    fishr::fish2_mirror_reg,
    sample = "fish2_mirror",
    reference = "fish2"
  )
  invisible(TRUE)
}
