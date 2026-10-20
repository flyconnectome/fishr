#' Read neuron skeletons via neuprint
#'
#' @param ids Body ids in any form compatible with \code{\link{fish_ids}}.
#' @param connectors Whether to fetch synaptic connections for the neuron
#'   (default \code{FALSE} in contrast to
#'   \code{\link[neuprintr]{neuprint_read_neurons}}).
#' @param ... Additional arguments passed to
#'   \code{\link[neuprintr]{neuprint_read_neurons}}.
#' @param units Units of the returned neurons: \code{"nm"} (default),
#'   \code{"raw"} (16 x 16 x 15 nm voxels) or \code{"microns"}. Node radii are
#'   scaled by the x voxel size (16 nm) for \code{"raw"}.
#' @param heal.threshold The threshold for healing disconnected skeleton
#'   fragments. The default of \code{Inf} ensures that all fragments are joined
#'   together.
#' @param conn Optional, a \code{neuprint_connection} object. Defaults to
#'   \code{\link{fish_neuprint}} to ensure that the query targets fish2.
#' @inheritParams with_fish
#'
#' @details Since September 2026 the fish2 neuprint server returns skeletons
#'   with coordinates and radii in nm (previously they were in 16 x 16 x 15 nm
#'   voxels). The skeleton units are read from the
#'   \code{skeletonCoordinateResolutionNm} field of the neuprint \code{Meta}
#'   node; when this is absent (older releases) skeletons are assumed to be in
#'   16 x 16 x 15 nm voxels.
#'
#' @return A \code{\link[nat:neuronlist]{neuronlist}} object containing one or
#'   more neurons.
#' @seealso \code{\link[malevnc]{manc_read_neurons}}, and nat functions
#'   including \code{\link[nat]{neuron}}, \code{\link[nat]{neuronlist}}.
#' @family 3d-meshes-skeletons
#' @export
#' @examples
#' \donttest{
#' rgcsk3 <- read_fish_neurons(fish_ids("RGC")[1:3])
#' plot(rgcsk3, WithNodes=FALSE)
#' }
read_fish_neurons <- function(ids, connectors = FALSE,
                              units = c("nm", "raw", "microns"),
                              heal.threshold = Inf, conn = NULL, ...,
                              dataset = fish_default_dataset()) {
  units <- match.arg(units)
  if (is.null(conn))
    conn <- fish_neuprint(dataset = dataset)

  ids <- fish_ids(ids)
  res <- with_fish(
    malevnc::manc_read_neurons(
      ids,
      conn = conn,
      connectors = connectors,
      heal.threshold = heal.threshold,
      ...
    ),
    dataset = dataset
  )

  fish_scale_skeletons(res, units = units,
                       skel_nm = fish_skeleton_size(conn, dataset = dataset))
}

#' Calibrate neuprint skeletons to nm then convert to the requested units
#'
#' @param x A neuron or neuronlist as returned by neuprint.
#' @param skel_nm nm per skeleton unit (length 3); radii use the x value.
#' @noRd
fish_scale_skeletons <- function(x, units = c("nm", "raw", "microns"),
                                 skel_nm = c(1, 1, 1)) {
  units <- match.arg(units)
  fac <- c(skel_nm, skel_nm[1]) /
    switch(units, nm = 1, raw = c(16, 16, 15, 16), microns = 1000)
  if (isTRUE(all(fac == 1))) x else x * fac
}

#' nm per unit of skeletons returned by neuprint
#'
#' @description Reads \code{skeletonCoordinateResolutionNm} from the neuprint
#'   \code{Meta} node. Older datasets lack this field, in which case skeletons
#'   are in voxel units (16 x 16 x 15 nm for fish2).
#' @return Numeric vector of length 3.
#' @noRd
fish_skeleton_size <- function(conn, dataset = fish_default_dataset()) {
  res <- neuprintr::neuprint_fetch_custom(
    cypher = "MATCH (m:Meta) RETURN m.skeletonCoordinateResolutionNm",
    dataset = dataset, conn = conn)
  ss <- as.numeric(unlist(res$data))
  if (length(ss) == 3) ss else c(16, 16, 15)
}
