\name{ws_series}
\alias{ws_series}
\title{Query Webstat series metadata}
\usage{ws_series(series_key = NULL, dataset_id = NULL, where = NULL, select = NULL, status = NULL, limit = 100, offset = 0, all = FALSE, raw = FALSE, full = FALSE, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{series_key}{Optional exact series key.}
\item{dataset_id}{Optional dataset code filter.}
\item{where, select}{Optional ODSQL expressions.}
\item{status}{Optional publication status values.}
\item{limit}{Number of records to return.}
\item{offset}{Pagination offset.}
\item{all}{Page through all accessible records.}
\item{raw}{Return the parsed API response/list instead of a data frame.}
\item{full}{Return all flattened columns instead of the compact default.}
\item{api_key}{Optional Webstat API key. Defaults to an explicit argument,
then `WEBSTAT_API_KEY`, then the package fallback key.}
\item{base_url}{Base API URL.}
}
\value{A data frame by default.}
\description{Query metadata from the Webstat `series` dataset. The package
includes a public Webstat frontend key fallback, so this usually works without
user-side key configuration.}
