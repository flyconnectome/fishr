test_that("fish_xyz2bodyid handles empty input", {
  expect_identical(fish_xyz2bodyid(matrix(numeric(0), ncol = 3L)), character(0))
})

test_that("fish_xyz2bodyid returns body ids for known reference points", {
  # LHS reference body 101377743 has soma at raw (36844, 40493, 16389).
  pts_raw <- rbind(
    c(36844, 40493, 16389),  # 101377743
    c(NA, NA, NA)            # NA propagates
  )
  res <- try(fish_xyz2bodyid(pts_raw), silent = TRUE)
  skip_if(inherits(res, "try-error"),
          message = "Skipping: fish2 DVID lookup unreachable")
  expect_type(res, "character")
  expect_length(res, nrow(pts_raw))
  expect_identical(res[1], "101377743")
  expect_true(is.na(res[2]))

  # nm input should give the same id at the same physical point.
  pts_nm <- pts_raw * matrix(c(16, 16, 15), nrow = nrow(pts_raw),
                             ncol = 3L, byrow = TRUE)
  res_nm <- try(fish_xyz2bodyid(pts_nm, units = "nm"), silent = TRUE)
  skip_if(inherits(res_nm, "try-error"),
          message = "Skipping: fish2 DVID lookup unreachable")
  expect_identical(res_nm[1], "101377743")
})
