#' Query the Webstat Explore catalog
#'
#' @param where Optional ODSQL where clause.
#' @param select Optional ODSQL select expression.
#' @param order_by Optional ODSQL ordering expression.
#' @param limit Number of datasets to return.
#' @param offset Pagination offset.
#' @param all If `TRUE`, page through all accessible results.
#' @param raw If `TRUE`, return the parsed API response/list.
#' @param full If `TRUE`, return all flattened columns. The default keeps the
#'   most useful catalog fields.
#' @param api_key Optional API key. Defaults to an explicit argument, then
#'   `WEBSTAT_API_KEY`, then the package fallback key.
#' @param base_url Base API URL.
#'
#' @return A data frame by default. Use `raw = TRUE` for the parsed API response.
#' @export
ws_catalog <- function(where = NULL, select = NULL, order_by = NULL,
                       limit = 20, offset = 0, all = FALSE, raw = FALSE,
                       full = FALSE, api_key = NULL,
                       base_url = webstat_base_url()) {
  query <- list(
    where = where,
    select = select,
    order_by = order_by,
    limit = check_limit(limit, maximum = 100),
    offset = offset
  )

  if (isTRUE(all)) {
    records <- webstat_get_all("catalog/datasets", query = query, api_key = api_key,
                               base_url = base_url)
    if (isTRUE(raw)) {
      return(records)
    }
    return(catalog_df(records, full = full))
  }

  response <- webstat_get("catalog/datasets", query = query, api_key = api_key,
                          base_url = base_url)
  if (isTRUE(raw)) {
    return(response)
  }
  catalog_df(response, full = full)
}

#' Query records from any Webstat Explore dataset
#'
#' @param dataset_id Dataset identifier.
#' @param where Optional ODSQL where clause.
#' @param select Optional ODSQL select expression.
#' @param refine Optional facet refinement, e.g. `series_key:"EXR.M.USD.EUR.SP00.A"`.
#' @param exclude Optional facet exclusion.
#' @param group_by Optional ODSQL grouping expression.
#' @param order_by Optional ODSQL ordering expression.
#' @param limit Number of records to return. Explore records endpoints are
#'   limited to 100 records per page.
#' @param offset Pagination offset.
#' @param all If `TRUE`, page through all accessible records.
#' @param raw If `TRUE`, return the parsed API response/list.
#' @param full If `TRUE`, return all flattened columns.
#' @param api_key Optional API key. Defaults to an explicit argument, then
#'   `WEBSTAT_API_KEY`, then the package fallback key.
#' @param base_url Base API URL.
#'
#' @return A flattened data frame by default. Use `raw = TRUE` for the parsed
#'   API response.
#' @export
ws_records <- function(dataset_id, where = NULL, select = NULL, refine = NULL,
                       exclude = NULL, group_by = NULL, order_by = NULL,
                       limit = 100, offset = 0, all = FALSE, raw = FALSE,
                       full = FALSE, api_key = NULL, base_url = webstat_base_url()) {
  stopifnot(is.character(dataset_id), length(dataset_id) == 1, nzchar(dataset_id))
  path <- paste0("catalog/datasets/", dataset_id, "/records")
  query <- list(
    where = where,
    select = select,
    refine = refine,
    exclude = exclude,
    group_by = group_by,
    order_by = order_by,
    limit = check_limit(limit, maximum = 100),
    offset = offset
  )

  if (isTRUE(all)) {
    records <- webstat_get_all(path, query = query, api_key = api_key,
                               base_url = base_url)
    if (isTRUE(raw)) {
      return(records)
    }
    return(as_flat_df(records))
  }

  response <- webstat_get(path, query = query, api_key = api_key, base_url = base_url)
  if (isTRUE(raw)) {
    return(response)
  }
  as_flat_df(response)
}

#' Get metadata for a Webstat Explore dataset
#'
#' @param dataset_id Dataset identifier.
#' @param select Optional ODSQL select expression.
#' @param api_key Optional API key. Defaults to an explicit argument, then
#'   `WEBSTAT_API_KEY`, then the package fallback key.
#' @param base_url Base API URL.
#'
#' @return A parsed dataset metadata list.
#' @export
ws_structure <- function(dataset_id, select = NULL, api_key = NULL,
                         base_url = webstat_base_url()) {
  stopifnot(is.character(dataset_id), length(dataset_id) == 1, nzchar(dataset_id))
  webstat_get(
    paste0("catalog/datasets/", dataset_id),
    query = list(select = select),
    api_key = api_key,
    base_url = base_url
  )
}

#' List facet values for a Webstat Explore dataset
#'
#' @param dataset_id Dataset identifier.
#' @param facet One or more facet fields.
#' @param where Optional ODSQL where clause.
#' @param refine Optional facet refinement.
#' @param api_key Optional API key. Defaults to an explicit argument, then
#'   `WEBSTAT_API_KEY`, then the package fallback key.
#' @param base_url Base API URL.
#'
#' @return A parsed facets response.
#' @export
ws_facets <- function(dataset_id, facet, where = NULL, refine = NULL,
                      api_key = NULL, base_url = webstat_base_url()) {
  stopifnot(is.character(dataset_id), length(dataset_id) == 1, nzchar(dataset_id))
  stopifnot(is.character(facet), length(facet) >= 1)
  webstat_get(
    paste0("catalog/datasets/", dataset_id, "/facets"),
    query = list(facet = facet, where = where, refine = refine),
    api_key = api_key,
    base_url = base_url
  )
}
