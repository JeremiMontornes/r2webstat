\name{ws_search}
\alias{ws_search}
\title{Search Webstat resources}
\usage{ws_search(query, resource = c("series", "webstat-datasets", "themes"), lang = c("fr", "en"), limit = 20, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{query}{Search text.}
\item{resource}{Resource type.}
\item{lang}{Metadata language.}
\item{limit}{Number of records to return.}
\item{api_key}{Optional Webstat API key.}
\item{base_url}{Base API URL.}
}
\value{A parsed API response.}
\description{Search series, datasets, or themes using the new Webstat Explore API.}
