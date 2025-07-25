% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_app.R
\name{run_flux_qaqc}
\alias{run_flux_qaqc}
\title{Launch the interactive 'shiny' QA/QC app for flux data}
\usage{
run_flux_qaqc(offset)
}
\arguments{
\item{offset}{Integer. The site's UTC offset in hours (e.g. -5 for 'UTC-5', +2 for 'UTC+2').
Must be a single integer between -12 and +14;
supplying a value outside this range throws an error.}
}
\value{
No return value, called for side effects (it launches the Shiny app).
}
\description{
Launch the interactive 'shiny' QA/QC app for flux data
}
\examples{
# — Quick automated checks —
# These run during R CMD check, but users don’t see them:
try(run_flux_qaqc(-13))  # should print error message
try(run_flux_qaqc(15))   # should print error message

# — Interactive demo (only in an interactive R session) —
if (interactive()) {
  run_flux_qaqc(-5)     # US Eastern Standard Time ('UTC-5')
}


}
