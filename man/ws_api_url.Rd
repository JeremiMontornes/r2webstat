\name{ws_api_url}
\alias{ws_api_url}
\title{Build a Webstat Explore API URL}
\usage{ws_api_url(
  path = "",
  query = list(),
  api_key = NULL,
  base_url = webstat_base_url(),
  include_api_key = TRUE
)}
\arguments{
\item{path}{API path.}
\item{query}{Named list of query parameters.}
\item{api_key}{Optional Webstat API key. Defaults to `WEBSTAT_API_KEY`, then
to the package fallback key.}
\item{base_url}{Base API URL.}
\item{include_api_key}{If `TRUE`, include the API key as an `apikey` query
parameter. Internal package requests use an HTTP `Authorization` header
instead.}
}
\value{A character URL.}
\description{Build a Webstat Explore API URL with encoded query parameters.}
