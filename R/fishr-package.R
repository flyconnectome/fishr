#' @keywords internal
#' @importFrom coconat id2char
#' @section Package Options:
#'
#' \itemize{
#'
#'   \item \code{fishr.dataset} The name of the active fish2 dataset (default
#'   \code{"fish2"}). Set by \code{\link{choose_fish_dataset}}.
#'
#'   }
#'
#'   The following \code{malevnc.*} options are set by \code{\link{choose_fish}}
#'   or \code{\link{with_fish}} to point the \code{malevnc} package at the fish2
#'   servers:
#'
#'   \itemize{
#'
#'   \item \code{malevnc.server} DVID server URL (set via Clio lookup).
#'
#'   \item \code{malevnc.rootnode} DVID root node UUID (set via Clio lookup).
#'
#'   \item \code{malevnc.neuprint} neuprint server URL (fallback:
#'   \code{https://neuprint-fish2.janelia.org}).
#'
#'   \item \code{malevnc.neuprint_dataset} neuprint dataset name (fallback:
#'   \code{"fish2"}).
#'
#'   }
#'
#' @examples
#' \donttest{
#' options()[grepl("^fishr", names(options()))]
#' }
#' \dontrun{
#' with_fish(read_fish_meshes(12345))
#' }
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
