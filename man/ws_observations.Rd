\name{ws_observations}
\alias{ws_observations}
\alias{ws_data}
\title{Query Webstat observations}
\usage{ws_observations(series_key = NULL, start = NULL, end = NULL, where = NULL, select = NULL, order_by = "series_key,time_period_end", limit = 100, offset = 0, all = FALSE, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{series_key}{One or more Webstat series keys.}
\item{start, end}{Optional date bounds applied to `time_period_end`.}
\item{where, select, order_by}{Optional ODSQL expressions.}
\item{limit}{Number of records to return.}
\item{offset}{Pagination offset.}
\item{all}{Page through all accessible records.}
\item{api_key}{Optional Webstat API key. Defaults to an explicit argument,
then `WEBSTAT_API_KEY`, then the package fallback key.}
\item{base_url}{Base API URL.}
}
\value{A parsed API response or list of records.}
\description{Query observations from the Webstat `observations` dataset. The
package includes a public Webstat frontend key fallback, so this usually works
without user-side key configuration.}
\examples{
\dontrun{
obs <- ws_observations(
  series_key = "EXR.M.USD.EUR.SP00.A",
  start = "2020-01-01",
  end = "2024-12-31",
  all = TRUE
)
}
}
