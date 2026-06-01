# Recreate the Fish2 mirroring registration directly from navis-fishbrains.
#
# navis-fishbrains ships a CSV of landmark pairs and registers them as a navis
# "mirror" transform, where the source side is first axis-flipped within the
# Fish2 bounding box and then a thin plate spline correction is applied. To
# express the whole operation as a single nat::tpsreg (so a plain
# nat.templatebrains::xform_brain() call can perform the mirror), we undo the
# Y-axis flip on the source landmarks before fitting the TPS.
#
# Re-run with:  source("data-raw/fish2_mirror_reg.R")

stopifnot(requireNamespace("nat", quietly = TRUE))

# --- Source CSV --------------------------------------------------------------
# Prefer a local navis-fishbrains checkout (so we can iterate offline); fall
# back to the upstream raw GitHub copy.
local_csv <- "../../Python/navis-fishbrains/fishbrains/data/fish2_mirror_landmarks_nm.csv"
upstream_csv <- paste0(
  "https://raw.githubusercontent.com/schlegelp/navis-fishbrains/",
  "main/fishbrains/data/fish2_mirror_landmarks_nm.csv"
)

src_path <- if (file.exists(local_csv)) local_csv else upstream_csv
message("Reading landmarks from: ", src_path)
lm <- utils::read.csv(src_path)

stopifnot(all(c("x_flip", "y_flip", "z_flip",
                "x_mirr", "y_mirr", "z_mirr") %in% names(lm)))

# --- Fish2 bounding box (nm) -------------------------------------------------
# Mirrors fishbrains/data/template_meta.json.
fish2_bbox_nm <- list(
  x = c(0, 1638400),
  y = c(0, 917504),
  z = c(0, 307620)
)

# --- Undo Y flip on source side ---------------------------------------------
src <- lm[, c("x_flip", "y_flip", "z_flip")]
src[["y_flip"]] <- fish2_bbox_nm$y[2] - src[["y_flip"]]
names(src) <- c("x", "y", "z")
tgt <- setNames(lm[, c("x_mirr", "y_mirr", "z_mirr")], c("x", "y", "z"))

# --- Build registration ------------------------------------------------------
fish2_mirror_reg <- nat::tpsreg(as.matrix(src), as.matrix(tgt))

usethis::use_data(fish2_mirror_reg, overwrite = TRUE, compress = "xz")
