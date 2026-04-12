.onLoad <- function(libname, pkgname) {
  op.fishr <- list(
    fishr.dataset = "fish2"
  )
  op <- options()
  toset <- !(names(op.fishr) %in% names(op))
  if (any(toset)) options(op.fishr[toset])

  invisible()
}

.onAttach <- function(libname, pkgname) {
  if (!nzchar(fish_neuprint_token())) {
    packageStartupMessage(
      cli::format_warning("No {.code neuprint_token} was found.")
    )
    if (interactive()) {
      packageStartupMessage(
        cli::format_message(
          "Run {.run [fish_setup()](fishr::fish_setup())} to set up fishr for first use. See {.url https://flyconnectome.github.io/fishr/} for more information."
        )
      )
    } else {
      packageStartupMessage(
        cli::format_message(
          "Run {.code fish_setup()} in an interactive session to set up fishr for first use. See {.url https://flyconnectome.github.io/fishr/} for more information."
        )
      )
    }
  }

  invisible()
}
