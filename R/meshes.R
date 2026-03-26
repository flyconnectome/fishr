#' Read meshes for fish2 body ids
#'
#' @description Fetches pre-computed neuroglancer meshes from the fish2 DVID
#'   server. Meshes are returned in nm coordinates by default (8 nm voxels).
#'
#' @param ids One or more body ids (numeric or character), or a query string
#'   accepted by \code{\link{fish_ids}}.
#' @param node The DVID node (UUID) to query. Defaults to the root node set by
#'   \code{\link{choose_fish}}.
#' @param units One of \code{"nm"} (default), \code{"raw"} (8 nm voxels), or
#'   \code{"microns"}.
#' @param ... Additional arguments passed to \code{httr::GET}.
#'
#' @return A \code{\link{neuronlist}} containing one or more \code{mesh3d}
#'   objects.
#' @export
#' @family fishr-package
#' @examples
#' \dontrun{
#' ml <- read_fish_meshes(12345)
#' plot3d(ml)
#' }
read_fish_meshes <- function(ids,
                              node  = getOption("malevnc.rootnode"),
                              units = c("nm", "raw", "microns"),
                              ...) {
  units <- match.arg(units)
  ids   <- fish_ids(ids, as_character = TRUE, mustWork = TRUE, unique = TRUE)
  with_fish({
    res <- pbapply::pbsapply(ids, read_fish_mesh, node = node, ...,
                             simplify = FALSE)
    res <- nat::as.neuronlist(res, AddClassToNeurons = FALSE)
    switch(units, raw = res / 8, microns = res / 1000, res)
  })
}

#' @noRd
read_fish_mesh <- function(id, node = getOption("malevnc.rootnode"), ...) {
  server <- getOption("malevnc.server")
  if (is.null(server))
    stop("malevnc.server is not set. Have you called choose_fish() or with_fish()?")
  u <- sprintf(
    "%s/api/node/%s/segmentation_meshes/key/%s.ngmesh?app=natverse",
    server, node, id
  )
  malevnc:::read_neuroglancer_mesh(u, ...)
}
