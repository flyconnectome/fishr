#' Read meshes for fish2 body ids
#'
#' @description Fetches pre-computed neuroglancer meshes from the fish2 DVID
#'   server. Meshes are returned in nm coordinates by default (8 nm voxels).
#'
#' @param ids One or more body ids (numeric or character), or a query string
#'   accepted by \code{\link{fish_ids}}.
#' @param units One of \code{"nm"} (default), \code{"raw"} (8 nm voxels), or
#'   \code{"microns"}.
#' @param ... Additional arguments passed to \code{httr::GET}.
#'
#' @return A \code{\link{neuronlist}} containing one or more \code{mesh3d}
#'   objects.
#' @export
#' @inheritParams fish_dvid_annotations
#' @family fishr-package
#' @examples
#' \dontrun{
#' ml <- read_fish_meshes(12345)
#' plot3d(ml)
#' }
read_fish_meshes <- function(ids,
                              node = 'neutu',
                              units = c("nm", "raw", "microns"),
                              ...) {
  units <- match.arg(units)
  ids   <- fish_ids(ids, as_character = TRUE, mustWork = TRUE, unique = TRUE)
  node <- with_fish(malevnc:::manc_nodespec(node, several.ok = F))
  with_fish({
    res <- pbapply::pbsapply(ids, read_fish_mesh, node = node, ...,
                             simplify = FALSE)
    res <- nat::as.neuronlist(res, AddClassToNeurons = FALSE)
    switch(units, raw = res / 8, microns = res / 1000, res)
  })
}

read_fish_mesh <- function(id, node = NULL, ...) {
  u <- with_fish(malevnc:::manc_serverurl(
    "api/node/%s/segmentation_meshes/key/%s.ngmesh?app=natverse",
    node, id
  ))
  with_fish(malevnc:::read_neuroglancer_mesh(u, ...))
}
