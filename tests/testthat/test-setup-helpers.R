test_that("fish_neuprint_token follows neuprintr token lookup", {
  old_lower <- Sys.getenv("neuprint_token", unset = NA_character_)
  old_upper <- Sys.getenv("NEUPRINT_TOKEN", unset = NA_character_)
  old_opt <- getOption("neuprint_token")
  on.exit({
    if (is.na(old_lower)) Sys.unsetenv("neuprint_token") else Sys.setenv(neuprint_token = old_lower)
    if (is.na(old_upper)) Sys.unsetenv("NEUPRINT_TOKEN") else Sys.setenv(NEUPRINT_TOKEN = old_upper)
    options(neuprint_token = old_opt)
  }, add = TRUE)

  Sys.unsetenv(c("neuprint_token", "NEUPRINT_TOKEN"))
  options(neuprint_token = NULL)
  expect_identical(fishr:::fish_neuprint_token(), "")

  Sys.setenv(NEUPRINT_TOKEN = "upper")
  expect_identical(
    fishr:::fish_neuprint_token(),
    neuprintr:::getenvoroption("token")[["token"]]
  )

  Sys.setenv(neuprint_token = "lower")
  expect_identical(
    fishr:::fish_neuprint_token(),
    neuprintr:::getenvoroption("token")[["token"]]
  )

  Sys.unsetenv(c("neuprint_token", "NEUPRINT_TOKEN"))
  options(neuprint_token = "option-token")
  expect_identical(
    fishr:::fish_neuprint_token(),
    neuprintr:::getenvoroption("token")[["token"]]
  )
})

test_that("fish_set_renviron_var appends and preserves earlier settings", {
  lines <- c("OTHER_VAR=\"x\"", "neuprint_server=\"old\"", "neuprint_server=\"stale\"")
  updated <- fishr:::fish_set_renviron_var(
    lines, "neuprint_server", "https://neuprint-fish2.janelia.org"
  )

  expect_identical(
    updated,
    c(
      "OTHER_VAR=\"x\"",
      "neuprint_server=\"old\"",
      "neuprint_server=\"stale\"",
      "neuprint_server=\"https://neuprint-fish2.janelia.org\""
    )
  )

  appended <- fishr:::fish_set_renviron_var(character(), "neuprint_dataset", "fish2")
  expect_identical(appended, "neuprint_dataset=\"fish2\"")

  unchanged <- fishr:::fish_set_renviron_var(
    updated, "neuprint_server", "https://neuprint-fish2.janelia.org"
  )
  expect_identical(unchanged, updated)
})

test_that("fish_read_renviron_vars reads persisted lowercase and uppercase keys", {
  tf <- tempfile(fileext = ".Renviron")
  writeLines(c(
    "neuprint_token=\"lower-token\"",
    "NEUPRINT_SERVER=\"https://example.org\"",
    "neuprint_dataset=fish1",
    "neuprint_dataset=fish2",
    "# comment"
  ), tf)
  on.exit(unlink(tf), add = TRUE)

  vals <- fishr:::fish_read_renviron_vars(tf)

  expect_identical(vals[["neuprint_token"]], "lower-token")
  expect_identical(vals[["NEUPRINT_SERVER"]], "https://example.org")
  expect_identical(vals[["neuprint_dataset"]], "fish2")
})

test_that("fish_clio_state detects env and cached token sources", {
  old <- Sys.getenv("CLIO_TOKEN", unset = NA_character_)
  on.exit({
    if (is.na(old)) Sys.unsetenv("CLIO_TOKEN") else Sys.setenv(CLIO_TOKEN = old)
  }, add = TRUE)

  tf <- tempfile("flyem_token", fileext = ".json")
  on.exit(unlink(tf), add = TRUE)

  Sys.unsetenv("CLIO_TOKEN")
  expect_false(fishr:::fish_clio_state(tokenfile = tf)$available)

  writeLines("cached-token", tf)
  st <- fishr:::fish_clio_state(tokenfile = tf)
  expect_true(st$available)
  expect_identical(st$source, "cache")

  Sys.setenv(CLIO_TOKEN = "env-token")
  st <- fishr:::fish_clio_state(tokenfile = tf)
  expect_true(st$available)
  expect_identical(st$source, "env")
})
