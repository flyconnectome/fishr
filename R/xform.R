#' Thin plate spline registration mirroring points in Fish2 space
#'
#' @description A \code{\link[nat]{tpsreg}} object that maps points in the
#'   Fish2 EM volume (nm) to their mirror image across the midline. Derived
#'   from the landmark pairs shipped with the
#'   \href{https://github.com/schlegelp/navis-fishbrains}{navis-fishbrains}
#'   Python package; see \code{data-raw/fish2_mirror_reg.R} for the
#'   construction recipe.
#'
#' @format A \code{tpsreg}/\code{reglist} object.
#' @docType data
#' @keywords datasets
#' @seealso \code{\link{mirror_fish}}, \code{\link{fish_register_xforms}}
"fish2_mirror_reg"

#' Register Fish2 bridging / mirroring transforms
#'
#' @description \code{fish_register_xforms} adds the package's mirroring
#'   registration (see \code{\link{fish2_mirror_reg}}) to the
#'   \code{nat.templatebrains} registry so that
#'   \code{\link[nat.templatebrains]{xform_brain}} can move points between
#'   \code{"Fish2"} and \code{"fish2_mirror"}. It is called automatically when
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

#' Mirror points or neurons in Fish2 space
#'
#' @description \code{mirror_fish} mirrors objects with 3D vertices calibrated
#'   in nanometres across the Fish2 midline using a thin plate spline
#'   registration derived from Philipp Schlegel's navis-fishbrains landmarks.
#'
#' @param x Any object with 3D vertices (calibrated in nm), e.g. a neuron, a
#'   neuronlist, a mesh, or a 3-column matrix / data frame of points.
#' @param ... Additional arguments passed to
#'   \code{\link[nat.templatebrains]{xform_brain}}.
#'
#' @return The mirrored object.
#' @seealso \code{\link{fish2_mirror_reg}}, \code{\link{fish_register_xforms}}
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
  nat.templatebrains::xform_brain(x, sample = "fish2_mirror",
                                  reference = "Fish2", ...)
}
