\name{ws_search}
\alias{ws_search}
\title{Search Webstat resources}
\usage{ws_search(query, resource = c("series", "webstat-datasets", "themes"), lang = c("fr", "en"), limit = 20, raw = FALSE, full = FALSE, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{query}{Search text.}
\item{resource}{Resource type.}
\item{lang}{Metadata language.}
\item{limit}{Number of records to return.}
\item{raw}{Return the parsed API response/list instead of a data frame.}
\item{full}{Return all flattened columns.}
\item{api_key}{Optional Webstat API key.}
\item{base_url}{Base API URL.}
}
\value{A data frame by default.}
\description{Search series, datasets, or themes using the new Webstat Explore API.}
