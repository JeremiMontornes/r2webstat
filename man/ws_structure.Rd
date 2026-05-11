\name{ws_structure}
\alias{ws_structure}
\title{Get metadata for a Webstat Explore dataset}
\usage{ws_structure(dataset_id, select = NULL, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{dataset_id}{Dataset identifier.}
\item{select}{Optional ODSQL select expression.}
\item{api_key}{Optional Webstat API key.}
\item{base_url}{Base API URL.}
}
\value{A parsed dataset metadata list.}
\description{Retrieve metadata and field structure for one dataset.}
\examples{
\dontrun{
structure <- ws_structure("observations")
names(structure)
}
}
