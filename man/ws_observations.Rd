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
\item{api_key}{Optional Webstat API key.}
\item{base_url}{Base API URL.}
}
\value{A parsed API response or list of records.}
\description{Query observations from the Webstat `observations` dataset.}
