test_that("webstat_get_all replaces pagination parameters", {
  calls <- list()
  fake_get <- function(path, query = list(), api_key = NULL, base_url = NULL) {
    calls[[length(calls) + 1L]] <<- query
    list(total_count = 1L, results = list(list(x = 1L)))
  }

  local_mocked_bindings(webstat_get = fake_get)

  out <- webstat_get_all(
    "catalog/datasets/test/records",
    query = list(limit = 10, offset = 50, where = "x > 0"),
    page_size = 100
  )

  expect_length(out, 1)
  expect_equal(calls[[1]]$limit, 100)
  expect_equal(calls[[1]]$offset, 0)
  expect_equal(calls[[1]]$where, "x > 0")
})
