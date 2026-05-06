\name{ws_has_api_key}
\alias{ws_has_api_key}
\title{Check whether a Webstat API key is available}
\usage{ws_has_api_key(include_builtin = TRUE)}
\arguments{
\item{include_builtin}{If `TRUE`, also count the package-level Webstat
frontend key bundled for anonymous browser-style API calls.}
}
\value{`TRUE` when a key is available for the current R session.}
\description{Check whether a Webstat API key is available.}
