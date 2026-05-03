test_that("ws_api_url builds query strings", {
  url <- ws_api_url(
    "catalog/datasets/series/records",
    query = list(limit = 10, where = 'series_key:"ABC"'),
    api_key = "secret",
    base_url = "https://example.test/api"
  )

  expect_match(url, "^https://example[.]test/api/catalog/datasets/series/records[?]")
  expect_match(url, "limit=10", fixed = TRUE)
  expect_match(url, "apikey=secret", fixed = TRUE)
  expect_match(url, "where=series_key%3A%22ABC%22", fixed = TRUE)
})

test_that("ws_export_url uses dataset exports endpoint", {
  url <- ws_export_url(
    "observations",
    format = "csv",
    where = 'series_key:"ABC"',
    api_key = NULL,
    base_url = "https://example.test/api"
  )

  expect_match(url, "catalog/datasets/observations/exports/csv", fixed = TRUE)
  expect_match(url, "where=series_key%3A%22ABC%22", fixed = TRUE)
})
