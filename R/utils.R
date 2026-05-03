compact_query <- function(query) {
  if (is.null(query)) {
    return(list())
  }
  if (!is.list(query)) {
    stop("`query` must be a named list.", call. = FALSE)
  }
  keep <- vapply(query, function(x) {
    !(is.null(x) || length(x) == 0 || (length(x) == 1 && is.na(x)) ||
        (is.character(x) && length(x) == 1 && !nzchar(x)))
  }, logical(1))
  query[keep]
}

encode_query <- function(query) {
  pieces <- unlist(Map(function(name, value) {
    if (length(value) == 0) {
      return(character())
    }
    paste0(
      utils::URLencode(name, reserved = TRUE),
      "=",
      utils::URLencode(as.character(value), reserved = TRUE)
    )
  }, names(query), query), use.names = FALSE)

  paste(pieces, collapse = "&")
}

normalize_path <- function(path) {
  path <- sub("^/+", "", path)
  sub("/+$", "", path)
}

as_records <- function(x) {
  if (!is.null(x$results)) {
    return(x$results)
  }
  if (!is.null(x$records)) {
    return(x$records)
  }
  x
}

check_limit <- function(limit, maximum = NULL) {
  if (is.null(limit)) {
    return(NULL)
  }
  if (!is.numeric(limit) || length(limit) != 1 || is.na(limit)) {
    stop("`limit` must be a single number.", call. = FALSE)
  }
  limit <- as.integer(limit)
  if (!is.null(maximum) && limit > maximum) {
    stop("`limit` cannot exceed ", maximum, " for this endpoint.", call. = FALSE)
  }
  limit
}
