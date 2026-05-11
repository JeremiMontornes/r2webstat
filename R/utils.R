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

as_flat_df <- function(records) {
  records <- as_records(records)
  if (is.null(records) || length(records) == 0L) {
    return(data.frame())
  }

  flat <- lapply(records, flatten_record)
  cols <- unique(unlist(lapply(flat, names), use.names = FALSE))
  out <- lapply(cols, function(col) {
    vapply(flat, function(x) {
      value <- x[[col]]
      if (is.null(value)) NA_character_ else as.character(value)
    }, character(1))
  })
  names(out) <- cols
  data.frame(out, check.names = FALSE, stringsAsFactors = FALSE)
}

flatten_record <- function(x, prefix = NULL) {
  if (is.null(x)) {
    return(stats::setNames(list(NA_character_), prefix %||% "value"))
  }

  if (is.atomic(x) && length(x) <= 1L) {
    return(stats::setNames(list(x), prefix %||% "value"))
  }

  if (is.atomic(x)) {
    return(stats::setNames(list(paste(x, collapse = "; ")), prefix %||% "value"))
  }

  if (!is.list(x)) {
    return(stats::setNames(list(as.character(x)), prefix %||% "value"))
  }

  nms <- names(x)
  if (is.null(nms)) {
    return(stats::setNames(list(paste(unlist(x), collapse = "; ")), prefix %||% "value"))
  }

  pieces <- list()
  for (nm in nms) {
    child_name <- if (is.null(prefix)) nm else paste(prefix, nm, sep = ".")
    value <- x[[nm]]

    if (is.list(value) && !is.null(names(value))) {
      pieces <- c(pieces, flatten_record(value, child_name))
    } else if (is.atomic(value) && length(value) <= 1L) {
      pieces[[child_name]] <- value
    } else {
      pieces[[child_name]] <- paste(unlist(value), collapse = "; ")
    }
  }
  pieces
}

select_columns <- function(df, columns) {
  keep <- intersect(columns, names(df))
  if (length(keep) == 0L) {
    return(df)
  }
  df[, keep, drop = FALSE]
}

catalog_df <- function(records, full = FALSE) {
  df <- as_flat_df(records)
  if (isTRUE(full)) {
    return(df)
  }

  select_columns(df, c(
    "dataset_id", "dataset_uid", "metas.title", "metas.default.title",
    "metas.description", "metas.default.description", "metas.theme",
    "metas.keyword", "has_records", "records_count", "features",
    "metas.publisher", "metas.license", "modified"
  ))
}

series_df <- function(records, full = FALSE) {
  df <- as_flat_df(records)
  if (isTRUE(full)) {
    return(df)
  }

  select_columns(df, c(
    "dataset_id", "series_key", "title", "title_fr", "title_en",
    "frequency", "freq", "unit", "unit_label", "publication_status",
    "last_update", "last_period", "start_period", "end_period"
  ))
}

observations_df <- function(records, data_only = FALSE, full = FALSE) {
  df <- as_flat_df(records)
  if (!"period" %in% names(df)) {
    period_col <- intersect(
      c("time_period", "time_period_end", "period", "date", "TIME_PERIOD"),
      names(df)
    )
    if (length(period_col) > 0L) {
      df$period <- df[[period_col[1L]]]
    }
  }

  if (!"obs_value" %in% names(df) && "value" %in% names(df)) {
    df$obs_value <- df$value
  }

  if ("period" %in% names(df)) {
    df$period <- parse_webstat_period(df$period)
  }
  if ("obs_value" %in% names(df)) {
    df$obs_value <- suppressWarnings(as.numeric(df$obs_value))
  }

  if (isTRUE(data_only)) {
    out <- select_columns(df, c("serie_key", "series_key", "period", "obs_value"))
    order_cols <- intersect(c("serie_key", "series_key", "period"), names(out))
    if (length(order_cols) > 0L) {
      out <- out[do.call(order, out[order_cols]), , drop = FALSE]
      row.names(out) <- NULL
    }
    return(out)
  }

  if (isTRUE(full)) {
    return(df)
  }

  select_columns(df, c(
    "dataset_id", "serie_key", "series_key", "period",
    "time_period_start", "time_period_end", "obs_value", "obs_status"
  ))
}

parse_webstat_period <- function(x) {
  x <- as.character(x)
  out <- rep(as.Date(NA), length(x))

  year_month <- grepl("^\\d{4}-\\d{2}$", x)
  out[year_month] <- as.Date(paste0(x[year_month], "-01"), format = "%Y-%m-%d")

  year_only <- grepl("^\\d{4}$", x)
  out[year_only] <- as.Date(paste0(x[year_only], "-01-01"), format = "%Y-%m-%d")

  full_date <- !year_month & !year_only
  out[full_date] <- suppressWarnings(as.Date(x[full_date], format = "%Y-%m-%d"))

  out
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
