# r2webstat

`r2webstat` is an R client for the redesigned Banque de France Webstat portal.
The new portal is backed by the Huwise/Opendatasoft Explore API v2.1, so this
package does not reuse the old `rwebstat` endpoints.

The package currently exposes:

- `ws_catalog()` for the public Explore catalog.
- `ws_records()` and `ws_structure()` for any accessible Explore dataset.
- `ws_datasets()`, `ws_series()`, and `ws_observations()` for Webstat datasets.
- `ws_facets()` for facet exploration.

Some Webstat datasets, including `series`, `observations`, and
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
library(ggplot2)

# Optional: use your own key instead of the package fallback
# ws_save_api_key("your-api-key")

# Get observations up to the latest available date
obs <- ws_observations(
  series_key = "FM.D.U2.EUR.4F.KR.MRR_FR.LEV",
  start = "2010-01-01",
  all = TRUE
)

ggplot(obs, aes(period, obs_value)) +
  geom_line(linewidth = 0.8) +
  labs(
    title = "ECB main refinancing operations rate",
    x = NULL,
    y = "Percent"
  ) +
  theme_minimal()
```

![Example Webstat series](man/figures/ecb_mrr.png)

## Notes on the new Webstat API

The redesigned Webstat site uses the Explore v2.1 REST API under
`https://webstat.banque-france.fr/api/explore/v2.1`. Query parameters use
ODSQL (`where`, `select`, `group_by`, `order_by`, `refine`, `exclude`).
The `records` endpoint is paginated and capped. Normal package requests send
the API key in the HTTP `Authorization` header, matching the official Webstat
frontend.

Official migration guide:
<https://webstat.banque-france.fr/fr/pages/guide-migration-api/>
