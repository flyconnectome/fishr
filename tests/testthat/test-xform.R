test_that("fish_point_side classifies the calibration point as left", {
  # Calibration: body 101377743 sits clearly on the LHS at raw voxel
  # (36844, 40493, 16389).
  expect_identical(
    fish_point_side(c(36844, 40493, 16389), units = "raw"),
    "L"
  )
  # Also accepts a space-separated string (nat::xyzmatrix is flexible).
  expect_identical(
    fish_point_side("36844 40493 16389", units = "raw"),
    "L"
  )

  # Its mirror image must therefore be on the right.
  cal_nm <- c(36844, 40493, 16389) * c(16, 16, 15)
  cal_mir <- as.numeric(mirror_fish(matrix(cal_nm, nrow = 1L)))
  expect_identical(fish_point_side(cal_mir), "R")
})

test_that("fish_point_side classifies a known near-midline point as M", {
  # Calibration: raw voxel (45983, 26929, 6299) is "on the midline give or
  # take a few microns". Mirror displacement should be small (~3 um).
  expect_identical(
    fish_point_side(c(45983, 26929, 6299), units = "raw"),
    "M"
  )
})

test_that("fish_point_side handles batches, strings, units and NAs", {
  # Batch of left / right / near-midline points (nm).
  batch <- rbind(
    c(482544, 540048,  95280), # left  (raw 30159, 33753, 6352)
    c(482544, 380000,  95280), # right (raw 30159, 23750, 6352)
    c(500000, 438500, 150000)  # within the empirical midline band
  )
  expect_identical(fish_point_side(batch), c("L", "R", "M"))

  # "x,y,z" string input.
  expect_identical(
    fish_point_side(c("482544,540048,95280", "482544,380000,95280")),
    c("L", "R")
  )

  # microns input should agree with nm input.
  expect_identical(
    fish_point_side(batch / 1000, units = "microns"),
    fish_point_side(batch)
  )

  # NA propagation: direct NA input from the user is allowed but warns.
  expect_warning(
    expect_identical(
      fish_point_side(rbind(c(482544, 540048, 95280), c(NA, NA, NA))),
      c("L", NA_character_)
    ),
    regexp = "transformed"
  )
})

test_that("fish_point_side respects threshold", {
  pts <- rbind(c(482544, 540048, 95280), c(482544, 380000, 95280))
  # With an absurdly large threshold every point becomes midline.
  expect_true(all(fish_point_side(pts, threshold = 1e9) == "M"))
})

test_that("fish_point_side returns signed midline distance in nm", {
  batch <- rbind(
    c(482544, 540048,  95280), # left
    c(482544, 380000,  95280), # right
    c(500000, 438500, 150000)  # near midline
  )

  d_nm <- fish_point_side(batch, rval = "distance")
  expect_type(d_nm, "double")
  expect_length(d_nm, nrow(batch))

  # Sign convention: positive = R, negative = L, matches the side labels.
  sides <- fish_point_side(batch)
  expect_identical(sign(d_nm)[sides == "L"], -1)
  expect_identical(sign(d_nm)[sides == "R"], 1)

  # First point is several tens of microns off the midline.
  expect_gt(abs(d_nm[1]), 10000)

  # Distance is always in nm regardless of input units.
  expect_equal(
    fish_point_side(batch / 1000, units = "microns", rval = "distance"),
    d_nm
  )

  # NA propagation: direct NA input from the user is allowed but warns.
  expect_warning(
    expect_identical(
      fish_point_side(rbind(c(482544, 540048, 95280), c(NA, NA, NA)),
                      rval = "distance")[2],
      NA_real_
    ),
    regexp = "transformed"
  )
})
