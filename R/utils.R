#' Error if a suggested package is unavailable
#'
#' @description Internal helper modelled on the equivalent in
#'   \code{fafbseg}. Used to guard code paths that depend on a package listed
#'   in DESCRIPTION's \code{Suggests} rather than \code{Imports}.
#'
#' @param pkg Package name.
#' @return Invisibly \code{TRUE}; called for the error side effect when the
#'   package is missing.
#' @noRd
check_package_available <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop("Please install suggested package: ", pkg)
  }
  invisible(TRUE)
}
