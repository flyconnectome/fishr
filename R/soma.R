fish_soma_side <- function(ids, method=c("auto", "instance", "position", "manual"), ...) {
  method=match.arg(method)
  meta <- if(is.data.frame(ids)) ids else fish_neuprint_meta(ids)
  if(method=='instance') {
    icol=intersect(c("instance", "name"), names(meta))
    if(length(icol)==0) stop("metadata must contain name or instance column!")
    res=stringr::str_match(meta[[icol]], '_([LRMU])$')[,2]
  } else {
    stop("method: ", method, " not yet implemented!")
  }
  res
}
