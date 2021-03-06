% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plantuml_knit_engine_register.R
\name{plantuml_knit_engine_register}
\alias{plantuml_knit_engine_register}
\title{Register the function \code{plantuml_knit_engine()} with knitr}
\usage{
plantuml_knit_engine_register()
}
\value{
the result of \code{knitr::knit_engines$set(plantuml = plantuml::plantuml_knit_engine)}
}
\description{
This is a simple helper function, which registers the plantuml knit engine with knitr.
As a result, code chunks of type \code{plantuml} can be evaluated.
}
\examples{
\dontrun{
# in the setup chunk in a RMarkdown document, add
plantuml_knit_engine_register()
}
}
