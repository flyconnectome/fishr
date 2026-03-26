test_that(".fish_is_query detects queries correctly", {
  expect_true(fishr:::.fish_is_query("/type:TRP.*"))
  expect_true(fishr:::.fish_is_query("TRP.*"))
  expect_true(fishr:::.fish_is_query("status:Traced"))
  expect_false(fishr:::.fish_is_query("12345"))
  expect_false(fishr:::.fish_is_query("9876543210"))
})

test_that(".fish_query_df filters correctly", {
  df <- data.frame(
    bodyid = c(1, 2, 3, 4),
    type = c("TRP01", "TRP02", "MBON01", "DN01"),
    status = c("Traced", "Traced", "Orphan", "Traced"),
    stringsAsFactors = FALSE
  )

  # /field:regex form

  res <- fishr:::.fish_query_df("/type:TRP.*", df)
  expect_equal(nrow(res), 2)
  expect_equal(res$bodyid, c(1, 2))

  # bare string defaults to type
  res2 <- fishr:::.fish_query_df("TRP.*", df)
  expect_equal(res2$bodyid, c(1, 2))

  # different field
  res3 <- fishr:::.fish_query_df("/status:Traced", df)
  expect_equal(nrow(res3), 3)

  # exact match (anchored)
  res4 <- fishr:::.fish_query_df("TRP01", df)
  expect_equal(nrow(res4), 1)
  expect_equal(res4$bodyid, 1)
})

test_that(".fish_query_df errors on bad field", {
  df <- data.frame(bodyid = 1, type = "X", stringsAsFactors = FALSE)
  expect_error(fishr:::.fish_query_df("/nosuchfield:foo", df), "Unknown field")
})

test_that(".fish_query_df errors on malformed query", {
  df <- data.frame(bodyid = 1, type = "X", stringsAsFactors = FALSE)
  expect_error(fishr:::.fish_query_df("/a:b:c", df), "Cannot parse")
})

test_that("fish_ids passes through numeric ids", {
  ids <- fish_ids(c(111, 222), mustWork = FALSE)
  expect_equal(ids, c("111", "222"))
})

test_that("fish_ids extracts bodyid from data.frame", {
  df <- data.frame(bodyid = c(10, 20, 30))
  ids <- fish_ids(df, mustWork = FALSE)
  expect_equal(ids, c("10", "20", "30"))
})

test_that("fish_ids deduplicates when unique=TRUE", {
  ids <- fish_ids(c(1, 1, 2), unique = TRUE, mustWork = FALSE)
  expect_equal(ids, c("1", "2"))
})

test_that("fish_ids returns integer64 when as_character=FALSE", {
  ids <- fish_ids(c(10, 20), as_character = FALSE, mustWork = FALSE)
  expect_s3_class(ids, "integer64")
})

test_that("fish_ids returns integer64 when integer64=TRUE", {
  ids <- fish_ids(c("10", "20"), integer64 = TRUE, mustWork = FALSE)
  expect_s3_class(ids, "integer64")
})

test_that("fish_ids preserves >53-bit ids as character", {
  # 2^53 + 1 — cannot be exactly represented as double
  big <- "9007199254740993"
  ids <- fish_ids(big, mustWork = FALSE)
  expect_equal(ids, big)
})

test_that("fish_ids preserves >53-bit ids as integer64", {
  big <- "9007199254740993"
  ids <- fish_ids(big, integer64 = TRUE, mustWork = FALSE)
  expect_s3_class(ids, "integer64")
  expect_equal(as.character(ids), big)
})

test_that("fish_ids round-trips >53-bit ids from data.frame", {
  big <- "9007199254740993"
  df <- data.frame(bodyid = big, stringsAsFactors = FALSE)
  ids <- fish_ids(df, mustWork = FALSE)
  expect_equal(ids, big)
})
