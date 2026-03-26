test_that("fish neuprint connection works", {
  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  expect_s3_class(conn, "neuprint_connection")
})

test_that("fish_neuprint_meta returns metadata", {
  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  # fetch a small sample — all bodies
  meta <- fish_neuprint_meta(conn = conn)
  expect_s3_class(meta, "data.frame")
  expect_true(nrow(meta) > 0)
  expect_true("bodyid" %in% colnames(meta))
  expect_type(meta$bodyid, "character")
})
