\name{ws_export_url}
\alias{ws_export_url}
\title{Build an export URL for a Webstat Explore dataset}
\usage{ws_export_url(dataset_id, format = c("json", "csv", "xlsx", "parquet"), where = NULL, select = NULL, order_by = NULL, limit = -1, api_key = NULL, base_url = webstat_base_url(), ...)}
\arguments{
\item{dataset_id}{Dataset identifier.}
\item{format}{Export format.}
\item{where, select, order_by}{Optional ODSQL expressions.}
\item{limit}{Number of records to export.}
\item{api_key}{Optional Webstat API key.}
\item{base_url}{Base API URL.}
\item{...}{Additional query parameters.}
}
\value{A character URL.}
\description{Build an export endpoint URL for CSV, JSON, XLSX, or Parquet.}
