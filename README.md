# r2webstat

`r2webstat` is an R client for the redesigned Banque de France Webstat portal.
The new portal is backed by the Huwise/Opendatasoft Explore API v2.1, so this
package does not reuse the old `rwebstat` endpoints.

The package currently exposes:

- `ws_catalog()` for the public Explore catalog.
- `ws_records()` and `ws_structure()` for any accessible Explore dataset.
- `ws_datasets()`, `ws_series()`, and `ws_observations()` for Webstat business datasets.
- `ws_facets()` for facet exploration.
- `ws_export_url()` for CSV, JSON, XLSX, and Parquet export URLs.

Some Webstat business datasets, including `series`, `observations`, and
`webstat-datasets`, require a Webstat API key. The official Webstat portal
uses an `Authorization: Apikey ...` header for browser API calls; `r2webstat`
bundles that public frontend key as a fallback so most users do not need to
configure anything. If you want to use your own key, save it once on your
machine:

```r
library(r2webstat)

ws_save_api_key("your-api-key")
ws_has_api_key()
```

Restart R after saving the key. For temporary use in the current session only,
use `ws_set_api_key("your-api-key")`.

## Examples

```r
library(r2webstat)

# Optional: use your own key instead of the package fallback
# ws_save_api_key("your-api-key")

# Explore catalog visible to your key/session
ws_catalog(limit = 5)

# Search series metadata
series <- ws_series(dataset_id = "EXR", limit = 20)

# Download observations for one or more series
obs <- ws_observations(
  series_key = "EXR.M.USD.EUR.SP00.A",
  start = "2020-01-01",
  end = "2024-12-31",
  all = TRUE
)

# Create an export URL
url <- ws_export_url(
  "observations",
  format = "csv",
  where = 'series_key:"EXR.M.USD.EUR.SP00.A"',
  limit = -1
)
```

## Notes on the new Webstat API

The redesigned Webstat site uses the Explore v2.1 REST API under
`https://webstat.banque-france.fr/api/explore/v2.1`. Query parameters use
ODSQL (`where`, `select`, `group_by`, `order_by`, `refine`, `exclude`).
The `records` endpoint is paginated and capped, while `exports` is the right
path for large downloads. Normal package requests send the API key in the
HTTP `Authorization` header, matching the official Webstat frontend; exported
URLs can still include the key as an `apikey` query parameter because a URL
cannot carry custom headers by itself.

Official migration guide:
<https://webstat.banque-france.fr/fr/pages/guide-migration-api/>
