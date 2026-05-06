\name{ws_set_api_key}
\alias{ws_set_api_key}
\title{Set a Webstat API key for the current R session}
\usage{ws_set_api_key(api_key)}
\arguments{\item{api_key}{API key obtained from the Webstat API portal.}}
\value{The previous value of `WEBSTAT_API_KEY`, invisibly.}
\description{Set `WEBSTAT_API_KEY` for the current R session. This overrides
the package fallback key until the R session ends.}
