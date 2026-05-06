webstat_get <- function(path, query = list(), api_key = NULL,
                        base_url = webstat_base_url()) {
  key <- webstat_api_key(api_key)
  url <- ws_api_url(
    path,
    query = query,
    api_key = NULL,
    base_url = base_url,
    include_api_key = FALSE
  )
  req <- httr2::request(url)
  req <- httr2::req_user_agent(
    req,
    "r2webstat (https://github.com/JeremiMontornes/r2webstat)"
  )
  if (!is.null(key)) {
    req <- httr2::req_headers(req, Authorization = paste("Apikey", key))
  }
  req <- httr2::req_error(req, is_error = function(resp) FALSE)
  resp <- httr2::req_perform(req)

  if (httr2::resp_status(resp) >= 400) {
    stop(webstat_error_message(resp, path), call. = FALSE)
  }

  httr2::resp_body_json(resp, simplifyVector = FALSE)
}

webstat_error_message <- function(resp, path) {
  status <- httr2::resp_status(resp)
  body <- httr2::resp_body_string(resp)
  parsed <- tryCatch(
    httr2::resp_body_json(resp, simplifyVector = TRUE),
    error = function(e) NULL
  )

  message <- if (is.list(parsed) && !is.null(parsed$message)) {
    parsed$message
  } else if (nzchar(body)) {
    body
  } else {
    httr2::resp_status_desc(resp)
  }

  code <- if (is.list(parsed) && !is.null(parsed$error_code)) {
    paste0(" (", parsed$error_code, ")")
  } else {
    ""
  }

  hint <- ""
  if (status %in% c(401, 403, 404) &&
      grepl("catalog/datasets/(series|observations|webstat-datasets)", path)) {
    hint <- paste0(
      "\n\nThe Webstat business datasets `series`, `observations`, and ",
      "`webstat-datasets` may require a Webstat API key with the right ",
      "authorization. Set it with `ws_set_api_key()` or the `WEBSTAT_API_KEY` ",
      "environment variable. You can still test the package without a key with ",
      "`ws_catalog()` and `ws_records(\"tableaux_rapports_preetablis\")`."
    )
  }

  paste0("Webstat API request failed: HTTP ", status, code, "\n", message, hint)
}

webstat_get_all <- function(path, query = list(), api_key = NULL,
                            base_url = webstat_base_url(), page_size = 100,
                            max_pages = Inf) {
  page_size <- check_limit(page_size, maximum = 100)
  query$limit <- NULL
  query$offset <- NULL
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
