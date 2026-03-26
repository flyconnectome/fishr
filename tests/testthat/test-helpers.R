test_that("fish dataset normalisation works", {
  expect_equal(fishr:::normalise_fish_dataset("fish2"), "fish2")
  expect_equal(fishr:::normalise_fish_dataset(NULL), "fish2")
  expect_equal(fishr:::normalise_fish_dataset(""), "fish2")
  # unknown datasets are passed through as-is
  expect_equal(fishr:::normalise_fish_dataset("fish2-special"), "fish2-special")
})

test_that("fish_known_dataset_options returns neuprint fallback for fish2", {
  ops <- fishr:::fish_known_dataset_options("fish2")
  expect_true(is.list(ops))
  expect_equal(ops$malevnc.dataset, "fish2")
  expect_equal(ops$malevnc.neuprint, "https://neuprint-fish2.janelia.org")
  expect_equal(ops$malevnc.neuprint_dataset, "fish2")
  # DVID not hardcoded

  expect_null(ops$malevnc.server)
  expect_null(ops$malevnc.rootnode)
})

test_that("fish_known_dataset_options returns NULL for unknown datasets", {
  expect_null(fishr:::fish_known_dataset_options("fish99"))
})

test_that("neuprint_simplify_xyz strips list wrappers", {
  expect_equal(
    fishr:::neuprint_simplify_xyz("list(1, 2, 3)"),
    "1, 2, 3"
  )
  # plain strings passed through
  expect_equal(
    fishr:::neuprint_simplify_xyz("100, 200, 300"),
    "100, 200, 300"
  )
})
