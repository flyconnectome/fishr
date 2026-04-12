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

test_that("fish_connection_table basic query works", {
  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  res <- fish_connection_table("RGC", partners = "outputs", conn = conn)
  expect_s3_class(res, "data.frame")
  expect_true(nrow(res) > 0)
  expect_true(all(c("bodyid", "partner", "weight", "type") %in% colnames(res)))
  # ids should be character
  expect_type(res$bodyid, "character")
  expect_type(res$partner, "character")
})

test_that("fish_connection_table summary works", {
  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  res <- fish_connection_table("RGC", partners = "outputs", summary = TRUE,
                               conn = conn)
  expect_s3_class(res, "data.frame")
  expect_true(nrow(res) > 0)
})

test_that("fish_connection_table moredetails adds columns", {
  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  res <- fish_connection_table("RGC", partners = "outputs",
                               moredetails = "group", conn = conn)
  expect_true("group" %in% colnames(res))
})

test_that("fish_connection_table moredetails=TRUE adds all extra columns", {
  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  res <- fish_connection_table("RGC", partners = "outputs",
                               moredetails = TRUE, conn = conn)
  expect_s3_class(res, "data.frame")
  # should have more columns than without moredetails
  res_basic <- fish_connection_table("RGC", partners = "outputs", conn = conn)
  expect_gt(ncol(res), ncol(res_basic))
})

test_that("fish_rois returns an ROI hierarchy", {
  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  rois <- fish_rois(conn = conn)
  expect_s3_class(rois, "data.frame")
  expect_true(nrow(rois) > 0)
  expect_true(all(c("from", "to") %in% colnames(rois)))
})

test_that("fish_roi_meshes supports one or more ROI meshes and units", {
  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  rois <- fish_rois()
  roi_names <- intersect(c("Neuropil", "Midbrain"), rois)
  skip_if(length(roi_names) < 1, message = "not enough ROI names available")

  meshes_raw <- fish_roi_meshes(roi_names[1:2], units = "raw", conn = conn,
                                .progress = "none")
  meshes_nm <- fish_roi_meshes(roi_names[1], units = "nm", conn = conn,
                               .progress = "none")

  expect_true(inherits(meshes_raw, "shapelist3d"))
  expect_length(meshes_raw, 2)
  expect_true(inherits(meshes_nm, "shapelist3d"))
  expect_length(meshes_nm, 1)
  expect_equal(meshes_nm[[1]]$vb[1:3, ], meshes_raw[[1]]$vb[1:3, ] * 8)
})
