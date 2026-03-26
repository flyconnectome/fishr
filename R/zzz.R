.onLoad <- function(libname, pkgname) {
  op.fishr <- list(
    fishr.dataset = "fish2"
  )
  op <- options()
  toset <- !(names(op.fishr) %in% names(op))
  if (any(toset)) options(op.fishr[toset])

  invisible()
}
