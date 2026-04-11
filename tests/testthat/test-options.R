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

test_that("with_fish restores options", {
  old_ds <- getOption("malevnc.dataset")
  on.exit(options(malevnc.dataset = old_ds))

  result <- with_fish(getOption("malevnc.dataset"))
  expect_equal(result, "fish2")
  # should be restored
  expect_equal(getOption("malevnc.dataset"), old_ds)
})
