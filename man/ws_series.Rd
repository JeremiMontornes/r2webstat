\name{ws_series}
\alias{ws_series}
\title{Query Webstat series metadata}
\usage{ws_series(series_key = NULL, dataset_id = NULL, where = NULL, select = NULL, status = NULL, limit = 100, offset = 0, all = FALSE, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{series_key}{Optional exact series key.}
\item{dataset_id}{Optional dataset code filter.}
\item{where, select}{Optional ODSQL expressions.}
\item{status}{Optional publication status values.}
\item{limit}{Number of records to return.}
\item{offset}{Pagination offset.}
\item{all}{Page through all accessible records.}
\item{api_key}{Optional Webstat API key.}
\item{base_url}{Base API URL.}
}
\value{A parsed API response or list of records.}
\description{Query metadata from the Webstat `series` dataset.}
