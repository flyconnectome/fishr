#' Read meshes for fish2 body ids
#'
#' @description Fetches pre-computed neuroglancer meshes from the fish2 DVID
#'   server.
#'
#' @details It seems that the nominal voxel dimensions of the fish2 dataset are
#'   16 x 16 x 15 nm. Neuron meshes are already returned from DVID in physical
#'   nm scale but this voxel dimension is required to turn raw neuroglancer
#'   coordinates into nm. This means that if you click on a neuron in
#'   neuroglancer, the recorded location will match if you have chosen
#'   `units="nm"`. Alternatively you must multiply point locations from
#'   neuroglancer by c(16,16,15) to obtain points in nm space.
#'
#' @param ids One or more body ids (numeric or character), or a query string
#'   accepted by \code{\link{fish_ids}}.
#' @param units One of \code{"nm"} (default), \code{"raw"} (nominal voxel size),
#'   or \code{"microns"}.
#' @param ... Additional arguments passed to \code{httr::GET}.
#'
#' @return A \code{\link[nat:neuronlist]{neuronlist}} containing one or more
#'   \code{mesh3d} objects.
#' @importFrom nat as.neuronlist
#' @export
#' @inheritParams fish_dvid_annotations
#' @family 3d-meshes-skeletons
#' @examples
#' \dontrun{
#' # pick 10 RGC meshes to read in
#' rgcs <- read_fish_meshes(fish_ids('RGC')[1:10])
#' plot3d(rgcs)
#' }
read_fish_meshes <- function(ids,
                              node = 'neutu',
                              units = c("nm", "raw", "microns"),
                              ...) {
  units <- match.arg(units)
  ids   <- fish_ids(ids, as_character = TRUE, mustWork = TRUE, unique = TRUE)
  node <- with_fish(malevnc:::manc_nodespec(node, several.ok = F))
  res <- pbapply::pbsapply(ids, read_fish_mesh, node = node, ...,
                           simplify = FALSE)
  res <- as.neuronlist(res, AddClassToNeurons = FALSE)
  switch(units, raw = res / c(16,16,15), microns = res / 1000, res)
}

read_fish_mesh <- function(id, node = NULL, ...) {
  with_fish({
    u <- malevnc:::manc_serverurl(
      "api/node/%s/segmentation_meshes/key/%s.ngmesh?app=natverse",
      node, id)
    malevnc:::read_neuroglancer_mesh(u, ...)
  })
}
