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
    key
  } else {
    NULL
  }
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

#' Build a Webstat Explore API URL
#'
#' @param path API path, for example `"catalog/datasets/series/records"`.
#' @param query Named list of query parameters.
#' @param api_key Optional API key. Defaults to `WEBSTAT_API_KEY`.
#' @param base_url Base API URL. Defaults to Webstat Explore v2.1.
#'
#' @return A character URL.
#' @export
ws_api_url <- function(path = "", query = list(), api_key = NULL,
                       base_url = webstat_base_url()) {
  stopifnot(is.character(path), length(path) == 1)
  path <- sub("^/+", "", path)
  url <- paste0(sub("/+$", "", base_url), if (nzchar(path)) paste0("/", path) else "")
  query <- compact_query(query)

  key <- webstat_api_key(api_key)
  if (!is.null(key)) {
    query$apikey <- key
  }

  if (!length(query)) {
    return(url)
  }

  paste0(url, "?", encode_query(query))
}
