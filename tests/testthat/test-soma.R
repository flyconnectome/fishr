test_that("fish_somapos returns nm matrix from somaLocation", {
  # sample LHS neuron bodyid 101377743
  df <- data.frame(
    bodyid = "x",
    somaLocation = "36844 40493 16389",
    stringsAsFactors = FALSE
  )
  xyz <- fish_somapos(df)
  expect_equal(dim(xyz), c(1L, 3L))
  expect_identical(colnames(xyz), c("x", "y", "z"))
  # nm = raw * (16, 16, 15)
  expect_equal(as.numeric(xyz), c(36844 * 16, 40493 * 16, 16389 * 15))
  # raw passes through unchanged.
  expect_equal(as.numeric(fish_somapos(df, units = "raw")),
               c(36844, 40493, 16389))
})

test_that("fish_somapos converts units", {
  df <- data.frame(somaLocation = "1000,1000,1000", stringsAsFactors = FALSE)
  expect_equal(as.numeric(fish_somapos(df, units = "raw")), c(1000, 1000, 1000))
  expect_equal(as.numeric(fish_somapos(df, units = "nm")), c(16000, 16000, 15000))
  expect_equal(as.numeric(fish_somapos(df, units = "microns")), c(16, 16, 15))
})

test_that("fish_somapos returns x,y,z strings with as_character=TRUE", {
  # "1,2,3" raw -> nm = "16,32,45"; raw passthrough leaves it.
  df <- data.frame(somaLocation = "1,2,3", stringsAsFactors = FALSE)
  expect_identical(fish_somapos(df, units = "raw", as_character = TRUE), "1,2,3")
  expect_identical(fish_somapos(df, as_character = TRUE), "16,32,45")
})

test_that("fish_somapos falls back to tosomaLocation row-wise", {
  df <- data.frame(
    somaLocation = c(NA, "1,2,3"),
    tosomaLocation = c("4,5,6", "99,99,99"),
    stringsAsFactors = FALSE
  )
  # raw output keeps the comparisons simple.
  xyz <- fish_somapos(df, units = "raw")
  expect_equal(xyz[1, ], c(x = 4, y = 5, z = 6))
  # Row 2 must NOT fall back, because somaLocation is non-NA.
  expect_equal(xyz[2, ], c(x = 1, y = 2, z = 3))
})

test_that("fish_somapos returns NA row when both locations missing", {
  df <- data.frame(
    somaLocation = c(NA, "1,2,3"),
    tosomaLocation = c(NA, NA),
    stringsAsFactors = FALSE
  )
  xyz <- fish_somapos(df, units = "raw")
  expect_true(all(is.na(xyz[1, ])))
  expect_equal(xyz[2, ], c(x = 1, y = 2, z = 3))
})

test_that("fish_somapos errors when neither column is present", {
  expect_error(fish_somapos(data.frame(bodyid = "x")),
               regexp = "somaLocation or tosomaLocation")
})

test_that("fish_soma_side(method='manual') errors for now", {
  df <- data.frame(name = "x_L")
  expect_error(fish_soma_side(df, method = "manual"),
               regexp = "manual.*not yet implemented")
})

test_that("fish_soma_side(method='instance') extracts L/R/M/U or NA", {
  df <- data.frame(
    name = c("Mauthner_L", "foo_R", "bar_M", "baz_U", "no_suffix"),
    stringsAsFactors = FALSE
  )
  expect_identical(
    fish_soma_side(df, method = "instance"),
    c("L", "R", "M", "U", NA_character_)
  )
})

test_that("fish_soma_side(method='instance') errors without name/instance", {
  df <- data.frame(somaLocation = "1,2,3", stringsAsFactors = FALSE)
  expect_error(fish_soma_side(df, method = "instance"),
               regexp = "name or instance")
})

test_that("fish_soma_side(method='position') never returns M at threshold=0", {
  # Raw voxel points: (36844, 40493, 16389) is on the LHS (ref body 101377743);
  # the mirror across the y midline (~26929 raw) gives an RHS point.
  df <- data.frame(
    somaLocation = c("36844,40493,16389", "36844,13365,16389"),
    stringsAsFactors = FALSE
  )
  res <- fish_soma_side(df, method = "position")
  expect_identical(res, c("L", "R"))
  expect_false(any(res == "M", na.rm = TRUE))
})

test_that("fish_soma_side(method='auto') prefers instance over position", {
  # Row 1: instance says M; position would say L. Auto must say M.
  # Row 2: no instance suffix; position resolves to R.
  df <- data.frame(
    name = c("foo_M", "bar_no_suffix"),
    somaLocation = c("36844,40493,16389", "36844,13365,16389"),
    stringsAsFactors = FALSE
  )
  expect_identical(fish_soma_side(df), c("M", "R"))
})
