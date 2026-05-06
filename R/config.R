webstat_base_url <- function() {
  url <- Sys.getenv("WEBSTAT_BASE_URL", "https://webstat.banque-france.fr/api/explore/v2.1")
  sub("/+$", "", url)
}

webstat_api_key <- function(api_key = NULL) {
  if (!is.null(api_key) && nzchar(api_key)) {
    return(api_key)
  }

  key <- Sys.getenv("WEBSTAT_API_KEY", "")
  if (nzchar(key)) {
    return(key)
  }

  key <- webstat_builtin_api_key()
  if (!is.null(key) && nzchar(key)) {
    return(key)
  }

  NULL
}

webstat_builtin_api_key <- function() {
  key <- getOption("r2webstat.api_key", "")
  if (is.character(key) && length(key) == 1 && nzchar(key)) {
    return(key)
  }

  # Public browser key used by the official Webstat portal for anonymous
  # frontend API calls. Users can still override it with WEBSTAT_API_KEY.
  "a78150367a35332580ae1651b4023f0c333e99b6653821d6ac445af9"
}

#' Set a Webstat API key for the current R session
#'
#' @param api_key API key obtained from the Webstat API portal.
#'
#' @return The previous value of `WEBSTAT_API_KEY`, invisibly.
#' @export
ws_set_api_key <- function(api_key) {
  stopifnot(is.character(api_key), length(api_key) == 1)
  old <- Sys.getenv("WEBSTAT_API_KEY", "")
  Sys.setenv(WEBSTAT_API_KEY = api_key)
  invisible(old)
}

#' Save a Webstat API key for future R sessions
#'
#' This writes `WEBSTAT_API_KEY` to the user-level `.Renviron` file so the
#' package can find it automatically when R starts. The key is not stored in
#' the package source code.
#'
#' @param api_key API key obtained from the Webstat API portal.
#' @param overwrite If `FALSE`, stop when `WEBSTAT_API_KEY` already exists in
#'   `.Renviron`.
#' @param renviron Path to the `.Renviron` file. Defaults to the user-level
#'   file returned by `path.expand("~/.Renviron")`.
#'
#' @return The path to the updated `.Renviron` file, invisibly.
#' @export
ws_save_api_key <- function(api_key, overwrite = FALSE,
                            renviron = path.expand("~/.Renviron")) {
  stopifnot(is.character(api_key), length(api_key) == 1, nzchar(api_key))
  stopifnot(is.logical(overwrite), length(overwrite) == 1)
  stopifnot(is.character(renviron), length(renviron) == 1)

  lines <- if (file.exists(renviron)) {
    readLines(renviron, warn = FALSE)
  } else {
    character()
  }

  has_key <- grepl("^\\s*WEBSTAT_API_KEY\\s*=", lines)
  if (any(has_key) && !isTRUE(overwrite)) {
    stop(
      "`WEBSTAT_API_KEY` already exists in ", renviron,
      ". Use `overwrite = TRUE` to replace it.",
      call. = FALSE
    )
  }

  new_line <- paste0("WEBSTAT_API_KEY=", renviron_quote(api_key))
  if (any(has_key)) {
    lines[has_key] <- new_line
  } else {
    lines <- c(lines, new_line)
  }

  dir.create(dirname(renviron), recursive = TRUE, showWarnings = FALSE)
  writeLines(lines, renviron, useBytes = TRUE)
  Sys.setenv(WEBSTAT_API_KEY = api_key)
  invisible(renviron)
}

#' Check whether a Webstat API key is available
#'
#' @param include_builtin If `TRUE`, also count the package-level fallback key
#'   when one is bundled.
#'
#' @return `TRUE` when a key is available for the current R session.
#' @export
ws_has_api_key <- function(include_builtin = TRUE) {
  has_user_key <- nzchar(Sys.getenv("WEBSTAT_API_KEY", ""))
  if (has_user_key) {
    return(TRUE)
  }

  isTRUE(include_builtin) && !is.null(webstat_builtin_api_key())
}

renviron_quote <- function(x) {
  if (grepl("[[:space:]#'\"]", x)) {
    x <- gsub("\\\\", "\\\\\\\\", x)
    x <- gsub('"', '\\"', x, fixed = TRUE)
    paste0('"', x, '"')
  } else {
    x
  }
}

#' Build a Webstat Explore API URL
#'
#' @param path API path, for example `"catalog/datasets/series/records"`.
#' @param query Named list of query parameters.
#' @param api_key Optional API key. Defaults to `WEBSTAT_API_KEY`, then to the
#'   package fallback key.
#' @param base_url Base API URL. Defaults to Webstat Explore v2.1.
#' @param include_api_key If `TRUE`, include the API key as an `apikey` query
#'   parameter. Internal package requests use an HTTP `Authorization` header
#'   instead.
#'
#' @return A character URL.
#' @export
ws_api_url <- function(path = "", query = list(), api_key = NULL,
                       base_url = webstat_base_url(),
                       include_api_key = TRUE) {
  stopifnot(is.character(path), length(path) == 1)
  path <- sub("^/+", "", path)
  url <- paste0(sub("/+$", "", base_url), if (nzchar(path)) paste0("/", path) else "")
  query <- compact_query(query)

  key <- webstat_api_key(api_key)
  if (isTRUE(include_api_key) && !is.null(key)) {
    query$apikey <- key
  }

  if (!length(query)) {
    return(url)
  }

  paste0(url, "?", encode_query(query))
}
