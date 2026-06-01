skip_if_no_fish_clio <- function(dataset = "fish2") {
  skip_if_not(
    identical(tolower(Sys.getenv("FISHR_RUN_CLIO_TESTS")), "true"),
    message = "Skipping: set FISHR_RUN_CLIO_TESTS=true to run fish2 Clio live tests"
  )

  ops <- try(
    choose_fish(dataset = dataset, set = FALSE, use_clio = TRUE),
    silent = TRUE
  )

  skip_if(
    inherits(ops, "try-error"),
    message = "Skipping: fish2 Clio dataset lookup unavailable"
  )
  skip_if(
    is.null(ops$malevnc.server) || !nzchar(ops$malevnc.server) ||
      is.null(ops$malevnc.rootnode) || !nzchar(ops$malevnc.rootnode),
    message = "Skipping: fish2 Clio/DVID settings unavailable"
  )

  invisible(ops)
}
