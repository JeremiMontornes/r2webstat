\name{ws_catalog}
\alias{ws_catalog}
\title{Query the Webstat Explore catalog}
\usage{ws_catalog(where = NULL, select = NULL, order_by = NULL, limit = 20, offset = 0, all = FALSE, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{where, select, order_by}{Optional ODSQL expressions.}
\item{limit}{Number of datasets to return.}
\item{offset}{Pagination offset.}
\item{all}{Page through all accessible results.}
\item{api_key}{Optional Webstat API key. Defaults to an explicit argument,
then `WEBSTAT_API_KEY`, then the package fallback key.}
\item{base_url}{Base API URL.}
}
\value{A parsed API response or list of results.}
\description{Query datasets available from the Webstat Explore catalog. Package
requests send the key with an HTTP `Authorization: Apikey ...` header.}
