#' Register fish2 dataset for coconatfly
#'
#' @description Register fish2 dataset adapters for use with
#'   \href{https://natverse.org/coconatfly}{coconatfly}.
#'
#' @param showerror Logical; when \code{FALSE}, return invisibly if
#'   dependencies are missing.
#' @return Invisible \code{NULL}.
#' @family data-queries
#' @export
#'
#' @examples
#' \dontrun{
#' register_fish_coconat()
#' coconatfly::cf_meta(coconatfly::cf_ids(fish2 = "RGC"))
#' }
register_fish_coconat <- function(showerror = TRUE) {
  if (!requireNamespace("coconat", quietly = !showerror)) {
    if (!showerror) {
      return(invisible(NULL))
    }
    coconat_link <- cli::style_hyperlink("coconat", "https://natverse.org/coconat/")
    coconatfly_link <- cli::style_hyperlink("coconatfly", "https://natverse.org/coconatfly/")
    stop(
      paste(
        paste(
          "Package", coconat_link, "is required to register fish2 for",
          coconatfly_link, "."
        ),
        cli::format_message(
          "Install it with {.run [natmanager::install(pkgs = \"coconat\")](natmanager::install(pkgs = \"coconat\"))}."
        ),
        sep = "\n"
      ),
      call. = FALSE
    )
  }

  coconat::register_dataset(
    name = "fish2",
    shortname = "zf",
    species = "Danio rerio",
    sex = "U",
    age = "6 dpf",
    namespace = "coconatfly",
    description = paste(
      "The fish2 larval zebrafish whole-brain EM dataset imaged at Harvard and",
      "currently being proofread at Janelia."
    ),
    metafun = fish_cfmeta,
    idfun = fish_cfids,
    partnerfun = fish_cfpartners
  )

  if (!nzchar(system.file(package = "coconatfly"))) {
    coconat_link <- cli::style_hyperlink("coconat", "https://natverse.org/coconat/")
    coconatfly_link <- cli::style_hyperlink("coconatfly", "https://natverse.org/coconatfly/")
    cli::cli_warn(
      c(
        "!" = paste(
          "Package", coconatfly_link,
          "is not installed, so the registered fish2 dataset is not usable yet."
        ),
        "i" = "Install it with {.run [natmanager::install(pkgs = \"coconatfly\")](natmanager::install(pkgs = \"coconatfly\"))} to use {.code coconatfly::cf_*()} functions."
      ),
      call = NULL
    )
  }

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
#' @importFrom dplyr all_of case_when select rename
fish_cfmeta <- function(ids = NULL, ignore.case = FALSE, fixed = FALSE,
                        unique = TRUE, ...,
                        dataset = fish_default_dataset()) {
  df <- fish_neuprint_meta(ids, dataset = dataset, ...)
  missing_cols <- setdiff(
    c("side", "name", "group", "class", "notes", "soma"),
    colnames(df)
  )
  for (col in missing_cols) {
    df[[col]] <- NA_character_
  }

  selcols <- c(
    "id",
    "side",
    "type",
    "instance",
    "class",
    "subclass",
    "subsubclass",
    "lineage",
    "notes",
    "soma",
    "group"
  )
  df <- df %>%
    mutate(
      side = dplyr::case_when(
        !is.na(.data$side) ~ substr(toupper(.data$side), 1, 1),
        !is.na(.data$name) & nzchar(.data$name) ~ stringr::str_match(.data$name, "_([LR])(?:_|$)")[, 2],
        TRUE ~ NA_character_
      ),
      id = id2char(.data$bodyid),
      instance = .data$name,
      subclass = NA_character_,
      subsubclass = NA_character_,
      lineage = NA_character_,
      group = id2char(.data$group)
    )

  df %>%
    select(all_of(selcols), dplyr::everything()) %>%
    select(-all_of(c("bodyid", "name")))
}

#' @noRd
#' @importFrom dplyr mutate select
fish_cfpartners <- function(ids, partners = c("outputs", "inputs"),
                            threshold = 1L, ...,
                            dataset = fish_default_dataset()) {
  res <- fish_connection_table(
    ids,
    partners = partners,
    threshold = threshold,
    summary = FALSE,
    details = FALSE,
    moredetails = FALSE,
    dataset = dataset,
    ...
  )
  res
}
