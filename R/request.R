webstat_get <- function(path, query = list(), api_key = NULL,
                        base_url = webstat_base_url()) {
  url <- ws_api_url(path, query = query, api_key = api_key, base_url = base_url)
  req <- httr2::request(url)
  req <- httr2::req_user_agent(
    req,
    "r2webstat (https://github.com/JeremiMontornes/r2webstat)"
  )
  resp <- httr2::req_perform(req)

  if (httr2::resp_status(resp) >= 400) {
    msg <- httr2::resp_body_string(resp)
    stop("Webstat API request failed: HTTP ", httr2::resp_status(resp), "\n", msg,
         call. = FALSE)
  }

  httr2::resp_body_json(resp, simplifyVector = FALSE)
}

webstat_get_all <- function(path, query = list(), api_key = NULL,
                            base_url = webstat_base_url(), page_size = 100,
                            max_pages = Inf) {
  page_size <- check_limit(page_size, maximum = 100)
  out <- list()
  offset <- 0L
  page <- 0L

  repeat {
    page <- page + 1L
    if (page > max_pages) {
      break
    }

    res <- webstat_get(
      path,
      query = c(query, list(limit = page_size, offset = offset)),
      api_key = api_key,
      base_url = base_url
    )
    records <- as_records(res)
    if (!length(records)) {
      break
    }

    out <- c(out, records)
    offset <- offset + length(records)
    total <- res$total_count %||% length(out)
    if (length(out) >= total || length(records) < page_size) {
      break
    }
  }

  out
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
