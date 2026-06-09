test_that("fish_coords round-trips between all units", {
  pts <- rbind(c(1000, 2000, 3000), c(0, 0, 0))
  for (u in c("nm", "raw", "emraw", "microns")) {
    expect_equal(
      fish_coords(fish_coords(pts, from = "nm", to = u), from = u, to = "nm"),
      fish_coords(pts),
      tolerance = 1e-9,
      info = u
    )
  }
})

test_that("fish_coords raw <-> emraw uses the documented ratio", {
  # raw (16,16,15) -> emraw (8,8,30) is (x*2, y*2, z/2).
  raw <- c(57780, 28028, 10984)
  expect_equal(
    as.numeric(fish_coords(raw, from = "raw", to = "emraw")),
    c(115560, 56056, 5492)
  )
  expect_equal(
    as.numeric(fish_coords(c(115560, 56056, 5492), from = "emraw", to = "raw")),
    raw
  )
})

test_that("fish_coords scales nm <-> microns and nm <-> raw / emraw", {
  expect_equal(
    as.numeric(fish_coords(c(16000, 16000, 15000), from = "nm", to = "raw")),
    c(1000, 1000, 1000)
  )
  expect_equal(
    as.numeric(fish_coords(c(8000, 8000, 30000), from = "nm", to = "emraw")),
    c(1000, 1000, 1000)
  )
  expect_equal(
    as.numeric(fish_coords(c(1000, 1000, 1000), from = "nm", to = "microns")),
    c(1, 1, 1)
  )
})

test_that("fish_coords as_character returns x,y,z strings", {
  res <- fish_coords(
    rbind(c(1, 2, 3), c(4, 5, 6)),
    from = "raw", to = "raw", as_character = TRUE
  )
  expect_identical(res, c("1,2,3", "4,5,6"))
})

test_that("fish_coords handles empty input", {
  empty <- matrix(numeric(0), ncol = 3L)
  expect_equal(dim(fish_coords(empty)), c(0L, 3L))
  expect_identical(fish_coords(empty, as_character = TRUE), character(0))
})

test_that("fish_xyz2bodyid handles empty input", {
  expect_identical(fish_xyz2bodyid(matrix(numeric(0), ncol = 3L)), character(0))
})

test_that("fish_xyz2bodyid resolves Mauthner_R at every supported unit", {
  # Mauthner_R body 100001043 sits at raw (57780, 28028, 10984) =
  # emraw (115560, 56056, 5492).
  pts_emraw <- rbind(
    c(115560, 56056,  5492),  # default emraw
    c(NA,     NA,     NA)     # NA propagates
  )
  res <- try(fish_xyz2bodyid(pts_emraw), silent = TRUE)
  skip_if(
    inherits(res, "try-error"),
    message = "Skipping: fish2 DVID lookup unreachable"
  )
  expect_type(res, "character")
  expect_length(res, nrow(pts_emraw))
  expect_identical(res[1], "100001043")
  expect_true(is.na(res[2]))

  # Same body via raw, nm, microns.
  expect_identical(
    fish_xyz2bodyid(c(57780, 28028, 10984), units = "raw"),
    "100001043"
  )
  expect_identical(
    fish_xyz2bodyid(c(57780 * 16, 28028 * 16, 10984 * 15), units = "nm"),
    "100001043"
  )
  expect_identical(
    fish_xyz2bodyid(
      c(57780 * 16 / 1000, 28028 * 16 / 1000, 10984 * 15 / 1000),
      units = "microns"
    ),
    "100001043"
  )
})
