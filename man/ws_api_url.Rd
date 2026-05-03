\name{ws_api_url}
\alias{ws_api_url}
\title{Build a Webstat Explore API URL}
\usage{ws_api_url(path = "", query = list(), api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{path}{API path.}
\item{query}{Named list of query parameters.}
\item{api_key}{Optional Webstat API key.}
\item{base_url}{Base API URL.}
}
\value{A character URL.}
\description{Build a Webstat Explore API URL with encoded query parameters.}
