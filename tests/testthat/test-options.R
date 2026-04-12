test_that("fish_default_dataset reads option", {
  old <- getOption("fishr.dataset")
  on.exit(options(fishr.dataset = old))
  options(fishr.dataset = "fish2")
  expect_equal(fishr:::fish_default_dataset(), "fish2")
})

test_that("choose_fish_dataset sets and restores options", {
  old <- getOption("fishr.dataset")
  on.exit(options(fishr.dataset = old))

  choose_fish_dataset("fish2")
  expect_equal(getOption("fishr.dataset"), "fish2")
})

test_that("choose_fish with set=FALSE returns options list", {
  ops <- choose_fish(set = FALSE)
  expect_true(is.list(ops))
  expect_true("malevnc.neuprint" %in% names(ops))
  expect_true("malevnc.neuprint_dataset" %in% names(ops))
})

test_that("choose_fish with use_clio=FALSE falls back to built-in fish2 settings", {
  old_cache <- getOption("fishr.dataset_options")
  on.exit(options(fishr.dataset_options = old_cache), add = TRUE)
  options(fishr.dataset_options = NULL)

  ops <- choose_fish(set = FALSE, use_clio = FALSE)
  expect_identical(ops$malevnc.neuprint, "https://neuprint-fish2.janelia.org")
  expect_identical(ops$malevnc.neuprint_dataset, "fish2")
})

test_that("choose_fish with use_clio=FALSE prefers cached live settings", {
  old_cache <- getOption("fishr.dataset_options")
  on.exit(options(fishr.dataset_options = old_cache), add = TRUE)
  options(
    fishr.dataset_options = list(
      fish2 = list(
        malevnc.dataset = "fish2",
        malevnc.neuprint = "https://example.org",
        malevnc.neuprint_dataset = "fish2-alt",
        malevnc.server = "https://clio.example.org",
        malevnc.rootnode = "abc"
      )
    )
  )

  ops <- choose_fish(dataset = "fish2", set = FALSE, use_clio = FALSE)
  expect_identical(ops$malevnc.neuprint, "https://example.org")
  expect_identical(ops$malevnc.neuprint_dataset, "fish2-alt")
})

test_that("choose_fish with use_clio=FALSE errors for unknown datasets", {
  old_cache <- getOption("fishr.dataset_options")
  on.exit(options(fishr.dataset_options = old_cache), add = TRUE)
  options(fishr.dataset_options = NULL)

  expect_error(
    choose_fish(dataset = "unknown-fish", set = FALSE, use_clio = FALSE),
    "No cached or built-in configuration"
  )
})

test_that("with_fish restores options", {
  old_ds <- getOption("malevnc.dataset")
  on.exit(options(malevnc.dataset = old_ds))

  result <- with_fish(getOption("malevnc.dataset"))
  expect_equal(result, "fish2")
  # should be restored
  expect_equal(getOption("malevnc.dataset"), old_ds)
})
