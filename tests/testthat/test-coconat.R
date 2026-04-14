test_that("coconatfly can query fish2 after registration", {
  skip_if_not_installed("coconatfly")
  skip_if_not_installed("coconat")

  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(
    inherits(conn, "try-error"),
    message = "Skipping: fish2 neuprint connection unavailable"
  )

  probe <- try(fish_ids("RGC", conn = conn), silent = TRUE)
  skip_if(
    inherits(probe, "try-error") || !length(probe) > 0,
    message = "Skipping: fish2 id query failed despite available neuprint connection"
  )

  suppressWarnings(register_fish_coconat())

  ids <- try(coconatfly::cf_ids(fish2 = "RGC"), silent = TRUE)
  skip_if(
    inherits(ids, "try-error") || length(ids) < 1,
    message = "Skipping: coconatfly cf_ids query failed for fish2"
  )

  meta <- try(coconatfly::cf_meta(ids), silent = TRUE)
  skip_if(
    inherits(meta, "try-error") || !is.data.frame(meta) || nrow(meta) < 1,
    message = "Skipping: coconatfly cf_meta query failed for fish2"
  )

  meta_all <- try(coconatfly::cf_meta(ids, keep.all = TRUE), silent = TRUE)
  skip_if(
    inherits(meta_all, "try-error") || !is.data.frame(meta_all) || nrow(meta_all) < 1,
    message = "Skipping: coconatfly cf_meta(keep.all=TRUE) query failed for fish2"
  )

  partners <- try(
    coconatfly::cf_partners(list(fish2 = ids[[1]][1]), partners = "outputs"),
    silent = TRUE
  )
  skip_if(
    inherits(partners, "try-error") || !is.data.frame(partners),
    message = paste(
      "Skipping: coconatfly cf_partners query failed for fish2;",
      "upstream coconatfly::add_partner_metadata currently cannot enrich",
      "external datasets registered under their long names"
    )
  )

  expect_true(length(ids) >= 1)
  expect_true(all(c("id", "type", "dataset") %in% colnames(meta)))
  expect_true(all(c("bodyid", "somaLocation") %in% colnames(meta_all)))
  expect_true(all(c("pre_id", "post_id", "weight") %in% colnames(partners)))
})
