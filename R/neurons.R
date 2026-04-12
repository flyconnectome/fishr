#' Read neuron skeletons via neuprint
#'
#' @param ids Body ids in any form compatible with \code{\link{fish_ids}}.
#' @param connectors Whether to fetch synaptic connections for the neuron
#'   (default \code{FALSE} in contrast to
#'   \code{\link[neuprintr]{neuprint_read_neurons}}).
#' @param ... Additional arguments passed to
#'   \code{\link[neuprintr]{neuprint_read_neurons}}.
#' @param units Units of the returned neurons (default \code{"nm"}).
#' @param heal.threshold The threshold for healing disconnected skeleton
#'   fragments. The default of \code{Inf} ensures that all fragments are joined
#'   together.
#' @param conn Optional, a \code{neuprint_connection} object. Defaults to
#'   \code{\link{fish_neuprint}} to ensure that the query targets fish2.
#' @inheritParams with_fish
#'
#' @return A \code{\link[nat:neuronlist]{neuronlist}} object containing one or
#'   more neurons.
#' @seealso \code{\link[malevnc]{manc_read_neurons}}, and nat functions
#'   including \code{\link[nat]{neuron}}, \code{\link[nat]{neuronlist}}.
#' @family fishr-package
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

  switch(
    units,
    nm = res * c(16, 16, 15, 1),
    microns = res * c(16 / 1000, 16 / 1000, 15 / 1000, 1),
    res
  )
}
