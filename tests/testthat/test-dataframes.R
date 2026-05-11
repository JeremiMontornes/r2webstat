test_that("catalog queries return compact data frames by default", {
  local_mocked_bindings(
    webstat_get = function(path, query = list(), api_key = NULL, base_url = NULL) {
      list(
        total_count = 1L,
        results = list(list(
          dataset_id = "EXR",
          metas = list(title = "Exchange rates", description = "Daily rates"),
          fields = list(list(name = "too much detail"))
        ))
      )
    }
  )

  out <- ws_catalog(limit = 1)

  expect_s3_class(out, "data.frame")
  expect_equal(out$dataset_id, "EXR")
  expect_true("metas.title" %in% names(out))
  expect_false("fields" %in% names(out))
})

test_that("series queries return compact data frames by default", {
  local_mocked_bindings(
    webstat_get = function(path, query = list(), api_key = NULL, base_url = NULL) {
      list(
        total_count = 1L,
        results = list(list(
          dataset_id = "EXR",
          series_key = "EXR.M.USD.EUR.SP00.A",
          title = "Euro-dollar exchange rate",
          nested = list(verbose = "detail")
        ))
      )
    }
  )

  out <- ws_series(dataset_id = "EXR", limit = 1)
  raw <- ws_series(dataset_id = "EXR", limit = 1, raw = TRUE)

  expect_s3_class(out, "data.frame")
  expect_equal(out$series_key, "EXR.M.USD.EUR.SP00.A")
  expect_false("nested.verbose" %in% names(out))
  expect_type(raw, "list")
  expect_equal(raw$total_count, 1L)
})

test_that("observations support data_only output", {
  local_mocked_bindings(
    webstat_get = function(path, query = list(), api_key = NULL, base_url = NULL) {
      list(
        total_count = 1L,
        results = list(list(
          series_key = "EXR.M.USD.EUR.SP00.A",
          time_period_end = "2024-12-31",
          obs_value = "1.08",
          obs_status = "A"
        ))
      )
    }
  )

  out <- ws_observations(
    series_key = "EXR.M.USD.EUR.SP00.A",
    limit = 1,
    data_only = TRUE
  )

  expect_s3_class(out, "data.frame")
  expect_named(out, c("series_key", "period", "obs_value"))
  expect_equal(out$period, "2024-12-31")
})
