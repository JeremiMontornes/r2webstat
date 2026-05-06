#' List Webstat datasets
#'
#' The redesigned portal stores Webstat business metadata in an Explore dataset
#' named `webstat-datasets`. Access can require an API key depending on the
#' Webstat subscription attached to your account.
#'
#' @param search Optional text search.
#' @param lang Metadata language, `"fr"` or `"en"`.
#' @param limit Number of records to return.
#' @param all If `TRUE`, page through all accessible records.
#' @param api_key Optional API key. Defaults to an explicit argument, then
#'   `WEBSTAT_API_KEY`, then the package fallback key.
#' @param base_url Base API URL.
#'
#' @return A parsed API response, or a list of records when `all = TRUE`.
#' @export
ws_datasets <- function(search = NULL, lang = c("fr", "en"), limit = 100,
                        all = FALSE, api_key = NULL,
                        base_url = webstat_base_url()) {
  lang <- match.arg(lang)
  where <- if (!is.null(search) && nzchar(search)) {
    paste0('"', search, '"')
  } else {
    NULL
  }

  ws_records(
    "webstat-datasets",
    where = where,
    order_by = paste0("title_", lang),
    limit = limit,
    all = all,
    api_key = api_key,
    base_url = base_url
  )
}

#' Search Webstat resources
#'
#' @param query Search text.
#' @param resource Resource type: `"series"`, `"webstat-datasets"`, or `"themes"`.
#' @param lang Metadata language, `"fr"` or `"en"`.
#' @param limit Number of records to return.
#' @param api_key Optional API key. Defaults to an explicit argument, then
#'   `WEBSTAT_API_KEY`, then the package fallback key.
#' @param base_url Base API URL.
#'
#' @return A parsed API response.
#' @export
ws_search <- function(query, resource = c("series", "webstat-datasets", "themes"),
                      lang = c("fr", "en"), limit = 20, api_key = NULL,
                      base_url = webstat_base_url()) {
  stopifnot(is.character(query), length(query) == 1, nzchar(query))
  resource <- match.arg(resource)
  lang <- match.arg(lang)
  order_by <- if (identical(resource, "themes")) paste0("path_", lang) else NULL

  ws_records(
    resource,
    where = paste0('"', query, '"'),
    order_by = order_by,
    limit = limit,
    api_key = api_key,
    base_url = base_url
  )
}

#' Query Webstat series metadata
#'
#' @param series_key Optional exact series key.
#' @param dataset_id Optional dataset code filter.
#' @param where Optional ODSQL where clause. Combined with filters.
#' @param select Optional ODSQL select expression.
#' @param status Optional publication status values.
#' @param limit Number of records to return.
#' @param offset Pagination offset.
#' @param all If `TRUE`, page through all accessible records.
#' @param api_key Optional API key. Defaults to an explicit argument, then
#'   `WEBSTAT_API_KEY`, then the package fallback key.
#' @param base_url Base API URL.
#'
#' @return A parsed API response, or a list of records when `all = TRUE`.
#' @export
ws_series <- function(series_key = NULL, dataset_id = NULL, where = NULL,
                      select = NULL, status = NULL, limit = 100, offset = 0,
                      all = FALSE, api_key = NULL,
                      base_url = webstat_base_url()) {
  clauses <- c(where, exact_clause("series_key", series_key),
               in_clause("dataset_id", dataset_id),
               in_clause("publication_status", status))
  clauses <- clauses[nzchar(clauses)]

  ws_records(
    "series",
    where = if (length(clauses)) paste(clauses, collapse = " AND ") else NULL,
    select = select,
    order_by = "dataset_id,series_key",
    limit = limit,
    offset = offset,
    all = all,
    api_key = api_key,
    base_url = base_url
  )
}

#' Query Webstat observations
#'
#' @param series_key One or more Webstat series keys.
#' @param start,end Optional date bounds applied to `time_period_end`.
#' @param where Optional ODSQL where clause. Combined with filters.
#' @param select Optional ODSQL select expression.
#' @param order_by Ordering expression.
#' @param limit Number of records to return.
#' @param offset Pagination offset.
#' @param all If `TRUE`, page through all accessible records.
#' @param api_key Optional API key. Defaults to an explicit argument, then
#'   `WEBSTAT_API_KEY`, then the package fallback key.
#' @param base_url Base API URL.
#'
#' @return A parsed API response, or a list of records when `all = TRUE`.
#' @export
ws_observations <- function(series_key = NULL, start = NULL, end = NULL,
                            where = NULL, select = NULL,
                            order_by = "series_key,time_period_end",
                            limit = 100, offset = 0, all = FALSE,
                            api_key = NULL, base_url = webstat_base_url()) {
  clauses <- c(where, in_clause("series_key", series_key),
               date_clause("time_period_end", start, ">="),
               date_clause("time_period_end", end, "<="))
  clauses <- clauses[nzchar(clauses)]

  ws_records(
    "observations",
    where = if (length(clauses)) paste(clauses, collapse = " AND ") else NULL,
    select = select,
    order_by = order_by,
    limit = limit,
    offset = offset,
    all = all,
    api_key = api_key,
    base_url = base_url
  )
}

#' Alias for `ws_observations()`
#'
#' @inheritParams ws_observations
#'
#' @return A parsed API response, or a list of records when `all = TRUE`.
#' @export
ws_data <- ws_observations

exact_clause <- function(field, value) {
  if (is.null(value) || !length(value)) {
    return("")
  }
  value <- as.character(value[[1]])
  if (!nzchar(value)) {
    return("")
  }
  paste0(field, ':"', value, '"')
}

in_clause <- function(field, values) {
  if (is.null(values) || !length(values)) {
    return("")
  }
  values <- as.character(values)
  values <- values[nzchar(values)]
  if (!length(values)) {
    return("")
  }
  if (length(values) == 1) {
    return(paste0(field, ':"', values, '"'))
  }
  paste0(field, ' IN ("', paste(values, collapse = '","'), '")')
}

date_clause <- function(field, value, op) {
  if (is.null(value) || !length(value) || is.na(value[[1]])) {
    return("")
  }
  paste(field, op, paste0('"', as.character(value[[1]]), '"'))
}
