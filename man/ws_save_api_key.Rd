\name{ws_save_api_key}
\alias{ws_save_api_key}
\title{Save a Webstat API key for future R sessions}
\usage{ws_save_api_key(api_key, overwrite = FALSE, renviron = path.expand("~/.Renviron"))}
\arguments{
\item{api_key}{API key obtained from the Webstat API portal.}
\item{overwrite}{Replace an existing `WEBSTAT_API_KEY` entry in `.Renviron`.}
\item{renviron}{Path to the `.Renviron` file.}
}
\value{The path to the updated `.Renviron` file, invisibly.}
\description{Write `WEBSTAT_API_KEY` to the user-level `.Renviron` file so
`r2webstat` can find it automatically when R starts. This is optional because
the package includes a public Webstat frontend key fallback, but a personal key
can be useful when Webstat grants additional permissions to an account.}
