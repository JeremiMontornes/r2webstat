test_that("ws_has_api_key reflects the environment", {
  old <- Sys.getenv("WEBSTAT_API_KEY", NA_character_)
  on.exit({
    if (is.na(old)) {
      Sys.unsetenv("WEBSTAT_API_KEY")
    } else {
      Sys.setenv(WEBSTAT_API_KEY = old)
    }
  })

  Sys.unsetenv("WEBSTAT_API_KEY")
  expect_false(ws_has_api_key())

  Sys.setenv(WEBSTAT_API_KEY = "abc")
  expect_true(ws_has_api_key())
})

test_that("ws_save_api_key writes .Renviron style entries", {
  path <- tempfile()
  ws_save_api_key("abc123", renviron = path)

  expect_true(file.exists(path))
  expect_equal(readLines(path, warn = FALSE), "WEBSTAT_API_KEY=abc123")
  expect_equal(Sys.getenv("WEBSTAT_API_KEY"), "abc123")
})

test_that("ws_save_api_key protects existing keys", {
  path <- tempfile()
  writeLines("WEBSTAT_API_KEY=old", path)

  expect_error(
    ws_save_api_key("new", renviron = path),
    "already exists",
    fixed = TRUE
  )

  ws_save_api_key("new", overwrite = TRUE, renviron = path)
  expect_equal(readLines(path, warn = FALSE), "WEBSTAT_API_KEY=new")
})
