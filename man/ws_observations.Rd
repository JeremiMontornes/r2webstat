\name{ws_observations}
\alias{ws_observations}
\alias{ws_data}
\title{Query Webstat observations}
\usage{ws_observations(series_key = NULL, start = NULL, end = Sys.Date(), where = NULL, select = NULL, order_by = "series_key,time_period_end", limit = 100, offset = 0, all = FALSE, data_only = FALSE, raw = FALSE, full = FALSE, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{series_key}{One or more Webstat series keys.}
\item{start, end}{Optional date bounds applied to `time_period_end`. `end`
defaults to `Sys.Date()`.}
\item{where, select, order_by}{Optional ODSQL expressions.}
\item{limit}{Number of records to return.}
\item{offset}{Pagination offset.}
\item{all}{Page through all accessible records.}
\item{data_only}{Return only `series_key`, `period`, and `obs_value` when
available. `period` is parsed as a Date and `obs_value` as numeric.}
\item{raw}{Return the parsed API response/list instead of a data frame.}
\item{full}{Return all flattened columns. Ignored when `data_only = TRUE`.}
\item{api_key}{Optional Webstat API key. Defaults to an explicit argument,
then `WEBSTAT_API_KEY`, then the package fallback key.}
\item{base_url}{Base API URL.}
}
\value{A data frame by default.}
\description{Query observations from the Webstat `observations` dataset. The
package includes a public Webstat frontend key fallback, so this usually works
without user-side key configuration.}
\examples{
\dontrun{
# Daily ECB main refinancing operations rate
obs <- ws_observations(
  series_key = "FM.D.U2.EUR.4F.KR.MRR_FR.LEV",
  start = "2010-01-01",
  all = TRUE
)

# Alias with the same arguments
obs2 <- ws_data(
  series_key = "MIR1.M.FR.B.L23FRLA.D.R.A.2230U6.EUR.O",
  start = "2010-01-01",
  all = TRUE
)
}
}
