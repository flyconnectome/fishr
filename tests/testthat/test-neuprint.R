test_that("fish neuprint connection works", {
  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  expect_s3_class(conn, "neuprint_connection")
})

test_that("fish_neuprint_meta returns metadata", {
  skip_if_no_fish_clio()

  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  # fetch a small sample
  rgc10=fish_ids("RGC")[1:10]
  meta <- fish_neuprint_meta(rgc10, conn = conn)
  expect_s3_class(meta, "data.frame")
  expect_true(nrow(meta) > 0)
  expect_true("bodyid" %in% colnames(meta))
  expect_type(meta$bodyid, "character")
})

test_that("read_fish_neurons returns a neuronlist", {
  skip_if_no_fish_clio()

  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  ids <- fish_ids("RGC", conn = conn)
  skip_if(!length(ids) > 0, message = "no fish2 ids available for RGC")

  neurons <- suppressWarnings(read_fish_neurons(ids[1], conn = conn))
  expect_s3_class(neurons, "neuronlist")
  expect_length(neurons, 1)
})

test_that("fish_connection_table works", {
  skip_if_no_fish_clio()

  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")
  rgc10=fish_ids("RGC")[1:10]
  res_basic <- fish_connection_table(rgc10, partners = "outputs", conn = conn)
  expect_s3_class(res_basic, "data.frame")
  expect_true(nrow(res_basic) > 0)
  expect_true(all(c("bodyid", "partner", "weight", "type") %in% colnames(res_basic)))
  # ids should be character
  expect_type(res_basic$bodyid, "character")
  expect_type(res_basic$partner, "character")

  res <- fish_connection_table(rgc10, partners = "outputs", summary = TRUE,
                               conn = conn)
  expect_s3_class(res, "data.frame")
  expect_true(nrow(res) > 0)

  res <- fish_connection_table(rgc10, partners = "outputs",
                               moredetails = "group", conn = conn)
  expect_true("group" %in% colnames(res))

  res <- fish_connection_table(rgc10, partners = "outputs",
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
  expect_true(all(c("parent", "roi") %in% colnames(rois)))
})

test_that("fish_roi_meshes supports one or more ROI meshes and units", {
  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  rois <- fish_rois(conn = conn)
  roi_names <- intersect(c("Midbrain", "Hindbrain"), rois$roi)
  skip_if(length(roi_names) < 2, message = "not enough ROI names available")

  meshes_raw <- fish_roi_meshes(roi_names[1:2], units = "raw", conn = conn,
                                .progress = "none")
  meshes_nm <- fish_roi_meshes(roi_names[1], units = "nm", conn = conn,
                               .progress = "none")

  expect_true(inherits(meshes_raw, "shapelist3d"))
  expect_length(meshes_raw, 2)
  expect_true(inherits(meshes_nm, "shapelist3d"))
  expect_length(meshes_nm, 1)
  expect_equal(meshes_raw[[1]]$vb[1:3, ], meshes_nm[[1]]$vb[1:3, ] / c(16,16,15))
  # ROI meshes are delivered in nm: Midbrain spans hundreds of microns
  expect_gt(max(meshes_nm[[1]]$vb[1, ]), 1e5)
})

test_that("fish_scale_skeletons converts nm skeletons to other units", {
  n <- nat::Cell07PNs[[1]]
  nm <- fish_scale_skeletons(n, "nm")
  expect_equal(nat::xyzmatrix(nm), nat::xyzmatrix(n))
  expect_equal(nm$d$W, n$d$W)

  raw <- fish_scale_skeletons(n, "raw")
  expect_equal(nat::xyzmatrix(raw),
               sweep(nat::xyzmatrix(n), 2, c(16, 16, 15), "/"))
  expect_equal(raw$d$W, n$d$W / 16)

  um <- fish_scale_skeletons(n, "microns")
  expect_equal(nat::xyzmatrix(um), nat::xyzmatrix(n) / 1000)
  expect_equal(um$d$W, n$d$W / 1000)

  # skeletons delivered in voxels are calibrated to nm first
  vox <- fish_scale_skeletons(n, "nm", skel_nm = c(16, 16, 15))
  expect_equal(nat::xyzmatrix(vox),
               sweep(nat::xyzmatrix(n), 2, c(16, 16, 15), "*"))
  expect_equal(vox$d$W, n$d$W * 16)
})

test_that("read_fish_neurons skeletons agree with DVID meshes in nm", {
  skip_if_no_fish_clio()

  conn <- try(fish_neuprint(), silent = TRUE)
  skip_if(inherits(conn, "try-error"),
          message = "fish2 neuprint connection unavailable")

  ss <- fish_skeleton_size(conn)
  expect_type(ss, "double")
  expect_length(ss, 3)

  id <- fish_ids("RGC", conn = conn)[1]
  sk <- suppressWarnings(read_fish_neurons(id, conn = conn))
  m <- read_fish_meshes(id)
  # skeleton nodes sit inside the mesh so bounding boxes nearly coincide
  expect_equal(apply(nat::xyzmatrix(sk), 2, range),
               apply(nat::xyzmatrix(m), 2, range), tolerance = 0.05)
})
