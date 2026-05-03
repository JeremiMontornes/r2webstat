\name{ws_records}
\alias{ws_records}
\title{Query records from any Webstat Explore dataset}
\usage{ws_records(dataset_id, where = NULL, select = NULL, refine = NULL, exclude = NULL, group_by = NULL, order_by = NULL, limit = 100, offset = 0, all = FALSE, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{dataset_id}{Dataset identifier.}
\item{where, select, refine, exclude, group_by, order_by}{Optional ODSQL parameters.}
\item{limit}{Number of records to return.}
\item{offset}{Pagination offset.}
\item{all}{Page through all accessible records.}
\item{api_key}{Optional Webstat API key.}
\item{base_url}{Base API URL.}
}
\value{A parsed API response or list of records.}
\description{Query records from any accessible Huwise/Opendatasoft Explore dataset.}
