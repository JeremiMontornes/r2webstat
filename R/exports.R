#' Build an export URL for a Webstat Explore dataset
#'
#' @param dataset_id Dataset identifier.
#' @param format Export format. Common values include `"json"`, `"csv"`,
#'   `"xlsx"`, and `"parquet"`.
#' @param where Optional ODSQL where clause.
#' @param select Optional ODSQL select expression.
#' @param order_by Optional ODSQL ordering expression.
#' @param limit Number of records to export. Use `-1` for all records.
#' @param api_key Optional API key. Defaults to an explicit argument, then
#'   `WEBSTAT_API_KEY`, then the package fallback key.
#' @param base_url Base API URL.
#' @param ... Additional query parameters passed to the export endpoint.
#'
#' @return A character URL.
#' @export
ws_export_url <- function(dataset_id, format = c("json", "csv", "xlsx", "parquet"),
                          where = NULL, select = NULL, order_by = NULL,
                          limit = -1, api_key = NULL,
                          base_url = webstat_base_url(), ...) {
  stopifnot(is.character(dataset_id), length(dataset_id) == 1, nzchar(dataset_id))
  format <- match.arg(format)
  query <- c(
    list(where = where, select = select, order_by = order_by, limit = limit),
    list(...)
  )

  ws_api_url(
    paste0("catalog/datasets/", dataset_id, "/exports/", format),
    query = query,
    api_key = api_key,
    base_url = base_url
  )
}
