#' Interactive setup helper for fish2 authentication
#'
#' @description \code{fish_setup()} checks whether the current R session is set
#'   up for the fish2 neuprint server and can write the recommended
#'   \code{neuprint_*} variables to the user's \code{.Renviron} file.
#'
#' @details The setup helper uses lowercase \code{neuprint_*} environment
#'   variables by default because that is still the most common convention
#'   across the natverse. It will also detect uppercase variants and report
#'   them to the user.
#'
#'   If you choose to save settings, \code{fish_setup()} writes directly to the
#'   user \code{.Renviron} file and, by default, also sets the same variables in
#'   the current session so that things work immediately.
#'
#' @param set_session Whether to apply any saved values to the current R session
#'   via \code{\link{Sys.setenv}} (default \code{TRUE}).
#'
#' @return Invisibly returns a list describing the detected configuration and
#'   any values written to \code{.Renviron}.
#' @family fishr-package
#' @export
#' @examples
#' \dontrun{
#' fish_setup()
#' }
fish_setup <- function(set_session = interactive()) {
  renviron <- fish_user_renviron_path()
  renviron_link <- cli::style_hyperlink(renviron, paste0("file://", renviron))
  account_url <- "https://neuprint-fish2.janelia.org/account"
  account_link <- cli::style_hyperlink(account_url, account_url)
  default_server <- "https://neuprint-fish2.janelia.org"
  default_dataset <- "fish2"
  renviron_vars <- fish_read_renviron_vars(renviron)

  token <- fish_envvar_state("neuprint_token", renviron_vars = renviron_vars)
  server <- fish_envvar_state("neuprint_server", renviron_vars = renviron_vars)
  dataset <- fish_envvar_state("neuprint_dataset", renviron_vars = renviron_vars)
  written <- list()

  cli::cli_h1("fishr setup")
  cli::cli_text("Checking fish2 authentication and neuprint defaults.")
  cli::cli_text("User startup file: {renviron_link}")

  cli::cli_h2("Neuprint token")
  fish_cli_env_status(token, "neuprint_token")

  token_needs_write <- fish_needs_renviron_update(token, token$value)
  if (token_needs_write || !nzchar(token$value)) {
    cli::cli_alert_info("Get a fish2 neuprint token from {account_link}.")

    if (interactive()) {
      existing_token <- token$value
      if (nzchar(existing_token) &&
          fish_prompt_yes_no(
            paste0(
              "Write the detected ", token$value_name,
              " value to neuprint_token in .Renviron?"
            )
          )) {
        written$neuprint_token <- existing_token
      } else {
        new_token <- fish_prompt_token()
        if (nzchar(new_token)) {
          written$neuprint_token <- new_token
        } else {
          cli::cli_alert_warning("Skipping token update for now.")
        }
      }
    } else {
      cli::cli_alert_info(
        "Non-interactive session: not prompting for a token."
      )
    }
  }

  cli::cli_h2("Neuprint defaults")
  fish_cli_env_status(server, "neuprint_server", desired = default_server)
  fish_cli_env_status(dataset, "neuprint_dataset", desired = default_dataset)

  need_defaults <- fish_needs_renviron_update(server, default_server) ||
    fish_needs_renviron_update(dataset, default_dataset) ||
    !identical(server$preferred_value, default_server) ||
    !identical(dataset$preferred_value, default_dataset)
  if (need_defaults && interactive()) {
    if (fish_prompt_yes_no(
      "Update .Renviron to make fish2 the neuprint default in future sessions?",
      default = FALSE
    )) {
      written$neuprint_server <- default_server
      written$neuprint_dataset <- default_dataset
    }
  } else if (need_defaults) {
    cli::cli_alert_info(
      "Non-interactive session: not prompting to write neuprint defaults."
    )
  }

  if (length(written)) {
    fish_write_renviron_vars(renviron, written)
    cli::cli_alert_success("Updated {.file {renviron}}.")

    if (isTRUE(set_session)) {
      do.call(Sys.setenv, written)
      cli::cli_alert_success("Applied the same settings to the current session.")
    } else {
      cli::cli_alert_info(
        "Restart R to pick these settings up automatically in future sessions."
      )
    }
  } else {
    cli::cli_alert_success("No changes were needed.")
  }

  cli::cli_h2("Clio / DVID")
  clio <- fish_clio_state()
  fish_cli_clio_status(clio)
  clio_result <- NULL
  if (clio$available) {
    clio_result <- fish_activate_fish_dataset()
  } else if (interactive()) {
    if (fish_prompt_yes_no(
      "Trigger Clio authentication now so Clio-backed fishr functions also work?"
    )) {
      clio_result <- fish_activate_fish_dataset()
    }
  } else if (!clio$available) {
    cli::cli_alert_info(
      "Non-interactive session: not prompting for Clio authentication."
    )
  }

  if (!is.null(clio_result)) {
    if (isTRUE(clio_result$ok)) {
      clio <- fish_clio_state()
      cli::cli_alert_success(
        "fish2 is now the active malevnc dataset for this session."
      )
    } else {
      cli::cli_alert_warning(
        "Clio authentication or fish2 dataset activation did not complete cleanly."
      )
      if (nzchar(clio_result$message)) {
        cli::cli_alert_info(clio_result$message)
      }
    }
  }

  invisible(list(
    renviron = renviron,
    renviron_vars = renviron_vars,
    token = token,
    server = server,
    dataset = dataset,
    clio = clio,
    written = written
  ))
}

fish_envvar_state <- function(name, renviron_vars = character()) {
  lower <- Sys.getenv(name, unset = "")
  upper_name <- toupper(name)
  upper <- Sys.getenv(upper_name, unset = "")
  renviron_lower <- unname(renviron_vars[name])
  renviron_upper <- unname(renviron_vars[upper_name])

  value_name <- ""
  value <- ""
  if (nzchar(lower)) {
    value <- lower
    value_name <- name
  } else if (nzchar(upper)) {
    value <- upper
    value_name <- upper_name
  }

  list(
    name = name,
    upper_name = upper_name,
    preferred_value = lower,
    lower_value = lower,
    upper_value = upper,
    renviron_preferred_value = if (is.na(renviron_lower)) "" else renviron_lower,
    renviron_upper_value = if (is.na(renviron_upper)) "" else renviron_upper,
    value = value,
    value_name = value_name
  )
}

fish_cli_env_status <- function(state, name, desired = NULL) {
  if (nzchar(state$preferred_value)) {
    if (is.null(desired)) {
      cli::cli_alert_success("{.code {name}} is set in this session.")
    } else if (identical(state$preferred_value, desired)) {
      cli::cli_alert_success(
        "{.code {name}} is already set to the fish2 default."
      )
    } else {
      cli::cli_alert_warning(
        "{.code {name}} is set but differs from the fish2 default."
      )
    }
  } else if (nzchar(state$upper_value)) {
    cli::cli_alert_warning(
      "Found {.code {state$upper_name}} but not {.code {name}}."
    )
  } else {
    cli::cli_alert_warning("{.code {name}} is not set.")
  }

  if (!nzchar(state$preferred_value) && nzchar(state$upper_value)) {
    cli::cli_alert_info(
      "Lowercase {.code {name}} is still the safest default for natverse tools."
    )
  }

  if (!is.null(desired) && nzchar(state$preferred_value) &&
      !identical(state$preferred_value, desired)) {
    cli::cli_text("Current value: {.code {state$preferred_value}}")
    cli::cli_text("Recommended fish2 value: {.code {desired}}")
  }

  if (nzchar(state$preferred_value) && nzchar(state$upper_value) &&
      !identical(state$preferred_value, state$upper_value)) {
    cli::cli_alert_warning(
      "{.code {name}} and {.code {state$upper_name}} are both set and differ."
    )
  }

  if (nzchar(state$renviron_preferred_value)) {
    if (is.null(desired)) {
      cli::cli_text("{.code {name}} is saved in {.file .Renviron}.")
    } else if (!identical(state$renviron_preferred_value, desired)) {
      cli::cli_text(
        "Saved {.file .Renviron} value: {.code {state$renviron_preferred_value}}"
      )
    }
  } else if (nzchar(state$renviron_upper_value)) {
    cli::cli_alert_info(
      "Found {.code {state$upper_name}} in {.file .Renviron}, but not lowercase {.code {name}}."
    )
  } else {
    cli::cli_alert_info("{.code {name}} is not currently saved in {.file .Renviron}.")
  }
}

fish_needs_renviron_update <- function(state, target) {
  nzchar(target) && !identical(state$renviron_preferred_value, target)
}

fish_clio_state <- function(tokenfile = fish_clio_tokenfile()) {
  env_token <- Sys.getenv("CLIO_TOKEN", unset = "")
  file_token <- if (file.exists(tokenfile)) readLines(tokenfile, warn = FALSE, n = 1) else ""

  list(
    env_token = env_token,
    file_token = file_token,
    tokenfile = tokenfile,
    available = nzchar(env_token) || nzchar(file_token),
    source = if (nzchar(env_token)) "env" else if (nzchar(file_token)) "cache" else ""
  )
}

fish_clio_tokenfile <- function() {
  # TODO: remove this once malevnc exposes a helper to check whether a
  # Clio token is available without triggering token fetch/browser auth.
  # Ideally that helper would also validate token expiry.
  file.path(
    rappdirs::user_data_dir(appname = "rpkg-malevnc"),
    "flyem_token.json"
  )
}

fish_cli_clio_status <- function(state) {
  if (identical(state$source, "env")) {
    cli::cli_alert_success("{.code CLIO_TOKEN} is set in this session.")
  } else if (identical(state$source, "cache")) {
    cli::cli_alert_success(
      "A cached Clio token is available for Clio-backed fishr functions."
    )
  } else {
    cli::cli_alert_info(
      "No Clio token is currently available. Clio-backed functions may need browser authentication."
    )
  }
}

fish_activate_fish_dataset <- function() {
  warning_message <- ""
  result <- withCallingHandlers(
    tryCatch(
      choose_fish(set = TRUE),
      error = function(e) e
    ),
    warning = function(w) {
      warning_message <<- conditionMessage(w)
      invokeRestart("muffleWarning")
    }
  )

  if (inherits(result, "error")) {
    return(list(ok = FALSE, message = conditionMessage(result)))
  }

  ok <- !is.null(result$malevnc.server) && !is.null(result$malevnc.rootnode)
  list(
    ok = ok,
    message = if (ok) "" else warning_message
  )
}

fish_prompt_yes_no <- function(question, default = TRUE) {
  if (!interactive()) {
    return(FALSE)
  }

  suffix <- if (isTRUE(default)) " [Y/n]: " else " [y/N]: "
  answer <- trimws(readline(paste0(question, suffix)))
  if (!nzchar(answer)) {
    return(default)
  }
  tolower(substr(answer, 1, 1)) == "y"
}

fish_prompt_token <- function() {
  if (!interactive()) {
    return("")
  }

  trimws(readline(
    "Paste the token copied from the fish2 account page, or press Enter to skip: "
  ))
}

fish_user_renviron_path <- function() {
  path <- Sys.getenv("R_ENVIRON_USER", unset = "")
  if (!nzchar(path)) {
    path <- "~/.Renviron"
  }
  path.expand(path)
}

fish_read_renviron_vars <- function(path) {
  if (!file.exists(path)) {
    return(character())
  }

  lines <- readLines(path, warn = FALSE)
  fish_renviron_values(lines)
}

fish_renviron_values <- function(lines) {
  parsed <- lapply(lines, fish_parse_renviron_line)
  parsed <- Filter(Negate(is.null), parsed)
  if (!length(parsed) > 0) {
    return(character())
  }

  names_vec <- vapply(parsed, `[[`, character(1), "name")
  keep <- !duplicated(names_vec, fromLast = TRUE)
  parsed <- parsed[keep]

  values <- vapply(parsed, `[[`, character(1), "value")
  names(values) <- vapply(parsed, `[[`, character(1), "name")
  values
}

fish_parse_renviron_line <- function(line) {
  line <- sub("\\s+#.*$", "", line)
  if (!nzchar(trimws(line))) {
    return(NULL)
  }

  m <- regexec("^\\s*([A-Za-z][A-Za-z0-9_]*)\\s*=\\s*(.*?)\\s*$", line)
  parts <- regmatches(line, m)[[1]]
  if (length(parts) != 3) {
    return(NULL)
  }

  list(
    name = parts[2],
    value = fish_unquote_renviron(parts[3])
  )
}

fish_write_renviron_vars <- function(path, vars) {
  lines <- if (file.exists(path)) readLines(path, warn = FALSE) else character()

  for (name in names(vars)) {
    lines <- fish_set_renviron_var(lines, name, vars[[name]])
  }

  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  writeLines(lines, path, useBytes = TRUE)
  invisible(path)
}

fish_set_renviron_var <- function(lines, name, value) {
  entry <- paste0(name, "=", fish_quote_renviron(value))
  current <- unname(fish_renviron_values(lines)[name])
  if (!is.na(current) && identical(current, value)) {
    return(lines)
  }

  c(lines, entry)
}

fish_quote_renviron <- function(value) {
  value <- gsub("\\\\", "\\\\\\\\", value)
  value <- gsub("\"", "\\\\\"", value)
  paste0("\"", value, "\"")
}

fish_unquote_renviron <- function(value) {
  value <- trimws(value)
  if (nchar(value) >= 2) {
    first <- substr(value, 1, 1)
    last <- substr(value, nchar(value), nchar(value))
    if ((identical(first, "\"") && identical(last, "\"")) ||
        (identical(first, "'") && identical(last, "'"))) {
      value <- substr(value, 2, nchar(value) - 1)
    }
  }
  value <- gsub("\\\\\"", "\"", value)
  gsub("\\\\\\\\", "\\\\", value)
}
