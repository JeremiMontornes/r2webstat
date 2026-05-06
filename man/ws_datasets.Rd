\name{ws_datasets}
\alias{ws_datasets}
\title{List Webstat datasets}
\usage{ws_datasets(search = NULL, lang = c("fr", "en"), limit = 100, all = FALSE, api_key = NULL, base_url = webstat_base_url())}
\arguments{
\item{search}{Optional text search.}
\item{lang}{Metadata language.}
\item{limit}{Number of records to return.}
\item{all}{Page through all accessible records.}
\item{api_key}{Optional Webstat API key. Defaults to an explicit argument,
then `WEBSTAT_API_KEY`, then the package fallback key.}
\item{base_url}{Base API URL.}
}
\value{A parsed API response or list of records.}
\description{List records from the Webstat business dataset catalog. The
package includes a public Webstat frontend key fallback, so this usually works
without user-side key configuration.}
