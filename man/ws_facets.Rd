\name{ws_facets}
\alias{ws_facets}
\title{List facet values for a Webstat Explore dataset}
\usage{ws_facets(dataset_id, facet, where = NULL, refine = NULL, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{dataset_id}{Dataset identifier.}
\item{facet}{One or more facet fields.}
\item{where, refine}{Optional filters.}
\item{api_key}{Optional Webstat API key.}
\item{base_url}{Base API URL.}
}
\value{A parsed facets response.}
\description{List facet values for an Explore dataset.}
