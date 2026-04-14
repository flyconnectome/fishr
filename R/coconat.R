#' Register fish2 dataset for coconatfly
#'
#' @description Register fish2 dataset adapters for use with
#'   \href{https://natverse.org/coconatfly}{coconatfly}.
#'
#' @param showerror Logical; when \code{FALSE}, return invisibly if
#'   dependencies are missing.
#' @return Invisible \code{NULL}.
#' @export
#'
#' @examples
#' \dontrun{
#' register_fish_coconat()
#' coconatfly::cf_meta(coconatfly::cf_ids(fish2 = "RGC"))
#' }
register_fish_coconat <- function(showerror = TRUE) {
  if (!requireNamespace("coconatfly", quietly = !showerror)) {
    if (!showerror) {
      return(invisible(NULL))
    }
    stop(
      "Package 'coconatfly' is required. Install with: ",
      "devtools::install_github('natverse/coconatfly')"
    )
  }
  if (!requireNamespace("coconat", quietly = !showerror)) {
    if (!showerror) {
      return(invisible(NULL))
    }
    stop(
      "Package 'coconat' is required. Install with: ",
      "devtools::install_github('natverse/coconat')"
    )
  }

  coconat::register_dataset(
    name = "fish2",
    shortname = "zf",
    species = "Danio rerio",
    sex = "U",
    age = "larval",
    namespace = "coconatfly",
    description = paste(
      "The fish2 larval zebrafish whole-brain EM dataset imaged at Harvard and",
      "currently being proofread at Janelia."
    ),
    metafun = fish_cfmeta,
    idfun = fish_cfids,
    partnerfun = fish_cfpartners
  )

  invisible(NULL)
}

#' @noRd
fish_cfids <- function(ids = NULL, integer64 = FALSE, unique = FALSE, ...,
                       dataset = fish_default_dataset()) {
  fish_ids(
    ids,
    integer64 = integer64,
    as_character = !isTRUE(integer64),
    unique = unique,
    ...
  )
}

#' @noRd
fish_cfmeta <- function(ids = NULL, ignore.case = FALSE, fixed = FALSE,
                        unique = TRUE, ...,
                        dataset = fish_default_dataset()) {
  df <- fish_neuprint_meta(ids, dataset = dataset, ...)

  instance <- df$name
  needs_instance <- is.na(instance) | !nzchar(instance)
  instance[needs_instance] <- df$type[needs_instance]
  needs_instance <- is.na(instance) | !nzchar(instance)
  instance[needs_instance] <- df$bodyid[needs_instance]

  out <- data.frame(
    id = as.character(df$bodyid),
    side = NA_character_,
    class = if ("class" %in% colnames(df)) df$class else NA_character_,
    subclass = NA_character_,
    subsubclass = NA_character_,
    type = if ("type" %in% colnames(df)) df$type else NA_character_,
    lineage = NA_character_,
    instance = instance,
    group = if ("group" %in% colnames(df)) df$group else NA,
    status = if ("status" %in% colnames(df)) df$status else NA_character_,
    name = if ("name" %in% colnames(df)) df$name else NA_character_,
    stringsAsFactors = FALSE
  )

  extras <- df
  extras <- extras[setdiff(colnames(extras), c("class", "type", "group", "status", "name"))]

  cbind(out, extras, stringsAsFactors = FALSE)
}

#' @noRd
fish_cfpartners <- function(ids, partners = c("outputs", "inputs"),
                            threshold = 1L, ...,
                            dataset = fish_default_dataset()) {
  partners <- match.arg(partners)
  ids <- fish_ids(ids, as_character = TRUE, unique = TRUE)
  conn <- fish_neuprint(dataset = dataset)
  res <- fish_connection_table(
    ids,
    partners = partners,
    threshold = threshold,
    summary = FALSE,
    details = FALSE,
    moredetails = FALSE,
    conn = conn,
    dataset = dataset,
    ...
  )

  if (!nrow(res) > 0) {
    out <- data.frame(
      pre_id = character(),
      post_id = character(),
      weight = integer(),
      stringsAsFactors = FALSE
    )
    return(out)
  }

  if (partners == "outputs") {
    data.frame(
      pre_id = as.character(res$bodyid),
      post_id = as.character(res$partner),
      weight = res$weight,
      stringsAsFactors = FALSE
    )
  } else {
    data.frame(
      pre_id = as.character(res$partner),
      post_id = as.character(res$bodyid),
      weight = res$weight,
      stringsAsFactors = FALSE
    )
  }
}
