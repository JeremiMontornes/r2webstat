\name{ws_records}
\alias{ws_records}
\title{Query records from any Webstat Explore dataset}
\usage{ws_records(dataset_id, where = NULL, select = NULL, refine = NULL, exclude = NULL, group_by = NULL, order_by = NULL, limit = 100, offset = 0, all = FALSE, raw = FALSE, full = FALSE, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{dataset_id}{Dataset identifier.}
\item{where, select, refine, exclude, group_by, order_by}{Optional ODSQL parameters.}
\item{limit}{Number of records to return.}
\item{offset}{Pagination offset.}
\item{all}{Page through all accessible records.}
\item{raw}{Return the parsed API response/list instead of a data frame.}
\item{full}{Return all flattened columns.}
\item{api_key}{Optional Webstat API key. Defaults to an explicit argument,
then `WEBSTAT_API_KEY`, then the package fallback key.}
\item{base_url}{Base API URL.}
}
\value{A flattened data frame by default. Use `raw = TRUE` for the parsed API response.}
\description{Query records from any accessible Huwise/Opendatasoft Explore
dataset. Package requests send the key with an HTTP `Authorization: Apikey ...`
header.}
\examples{
\dontrun{
# Generic records endpoint wrapper
records <- ws_records(
  "series",
  where = 'dataset_id:"FM"',
  limit = 10
)

# Keep all flattened fields
records_full <- ws_records("series", limit = 1, full = TRUE)
}
}
