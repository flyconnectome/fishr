fish_default_dataset <- function() {
  getOption("fishr.dataset", default = "fish2")
}

normalise_fish_dataset <- function(dataset) {
  if (is.null(dataset) || !nzchar(dataset)) {
    return("fish2")
  }
  dataset
}

# Hardcoded neuprint-only fallback for the main fish2 dataset.
# DVID server/rootnode are intentionally NULL — they are only available
# via a live Clio lookup (malevnc::choose_flyem_dataset).
fish_known_dataset_options <- function(dataset) {
  dataset <- normalise_fish_dataset(dataset)
  if (!identical(dataset, "fish2")) {
    return(NULL)
  }

  list(
    malevnc.dataset          = dataset,
    malevnc.neuprint         = "https://neuprint-fish2.janelia.org",
    malevnc.neuprint_dataset = "fish2",
    malevnc.server           = NULL,
    malevnc.rootnode         = NULL
  )
}

fish_dataset_options_cache <- function() {
  getOption("fishr.dataset_options", default = list())
}

fish_cached_dataset_options <- function(dataset = fish_default_dataset()) {
  dataset <- normalise_fish_dataset(dataset)
  fish_dataset_options_cache()[[dataset]]
}

fish_cache_dataset_options <- function(ops, dataset = NULL) {
  if (is.null(dataset)) {
    dataset <- ops$malevnc.dataset
  }
  dataset <- normalise_fish_dataset(dataset)
  cache <- fish_dataset_options_cache()
  cache[[dataset]] <- ops
  options(fishr.dataset_options = cache)
  invisible(ops)
}

#' Evaluate an expression after temporarily setting malevnc options
#'
#' @description \code{with_fish} temporarily changes the server/dataset options
#'   for the \code{malevnc} package so that they target the fish2 dataset while
#'   running your expression.
#'
#' @details \code{choose_fish} first tries a live Clio lookup via
#'   \code{malevnc::choose_flyem_dataset}. If that fails (e.g. no network / no
#'   Clio token), it falls back to baked-in neuprint settings. Clio-backed
#'   functions will be unavailable in that fallback session.
#'
#' @param expr An expression involving \code{malevnc}/\code{fishr} functions to
#'   evaluate with the specified dataset.
#' @param dataset The name of the dataset as reported in Clio (default
#'   \code{"fish2"}).
#' @param use_clio Whether to use a live Clio lookup for fish dataset settings.
#'   The default \code{NA} first reuses any cached live lookup for the dataset,
#'   otherwise it tries Clio and falls back to baked-in fish2 neuprint settings
#'   when available. Use \code{FALSE} to avoid Clio and rely only on cached or
#'   built-in settings. Use \code{TRUE} to require a live Clio lookup.
#' @inheritParams malevnc::choose_malevnc_dataset
#'
#' @return \code{with_fish} returns the result of \code{expr}.
#'   \code{choose_fish} and \code{choose_fish_dataset} return a named list of
#'   previous option values, matching \code{\link{options}}.
#' @seealso \code{\link[malevnc]{choose_flyem_dataset}},
#'   \code{\link[malevnc]{choose_malevnc_dataset}}
#' @family setup-data-access
#' @export
#' @examples
#' \dontrun{
#' # temporarily target fish2 for one call
#' with_fish(read_fish_meshes(12345))
#'
#' # or set fish2 as the active dataset for the rest of the session
#' choose_fish()
#' read_fish_meshes(12345)
#' }
with_fish <- function(expr, dataset = fish_default_dataset()) {
  oldop <- choose_fish(dataset = dataset)
  on.exit(options(oldop), add = TRUE)
  oldop2 <- choose_fish_dataset(dataset = dataset)
  on.exit(options(oldop2), add = TRUE)
  force(expr)
}

#' @rdname with_fish
#' @description \code{choose_fish_dataset} sets the default dataset used by all
#'   \code{fish_*} functions. It is the recommended way to access fish2 dataset
#'   variants. Unlike \code{choose_fish} it does \emph{not} permanently change
#'   the default dataset used when callers use functions from the \code{malevnc}
#'   package directly.
#' @export
choose_fish_dataset <- function(dataset = "fish2") {
  dataset <- normalise_fish_dataset(dataset)

  old_dataset <- fish_default_dataset()
  if (!identical(old_dataset, dataset))
    message("switching fish dataset from `", old_dataset, "` to `", dataset, "`")

  options(fishr.dataset = dataset)
}

#' @rdname with_fish
#' @description \code{choose_fish} swaps out the default \code{malevnc}
#'   dataset for the fish2 dataset. This means that all functions from the
#'   \code{malevnc} package should target fish2 instead. It is recommended that
#'   you use \code{with_fish} to do this temporarily unless you have no
#'   intention of using other FlyEM datasets. \emph{To switch the default fishr
#'   dataset please see \code{choose_fish_dataset}}.
#'
#'   When Clio dataset lookup is unavailable, \code{choose_fish} falls back to a
#'   built-in neuprint-only configuration for the main fish2 dataset.
#'   Clio-backed functionality may be unavailable in
#'   that session.
#' @export
choose_fish <- function(dataset = fish_default_dataset(), set = TRUE,
                        use_clio = NA) {
  dataset <- normalise_fish_dataset(dataset)
  ops <- if (isTRUE(use_clio)) NULL else fish_cached_dataset_options(dataset)

  if (is.null(ops) && !isFALSE(use_clio)) {
    live_ops <- tryCatch(
      malevnc::choose_flyem_dataset(dataset = dataset, set = FALSE),
      error = identity
    )

    if (!inherits(live_ops, "error")) {
      ops <- fish_cache_dataset_options(live_ops, dataset = dataset)
    } else if (isTRUE(use_clio)) {
      stop(live_ops)
    } else {
      ops <- fish_known_dataset_options(dataset)
      if (is.null(ops)) {
        stop(live_ops)
      }

      warning(
        "Clio dataset lookup failed; falling back to baked-in neuprint settings ",
        "for `", dataset, "`. Clio-backed functionality may be unavailable ",
        "in this session.",
        call. = FALSE
      )
    }
  }

  if (is.null(ops)) {
    ops <- fish_known_dataset_options(dataset)
    if (is.null(ops)) {
      stop(
        "No cached or built-in configuration is available for fish dataset `",
        dataset, "`.",
        call. = FALSE
      )
    }
  }

  if (isTRUE(set)) options(ops) else ops
}
