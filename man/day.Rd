% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all.R
\name{day}
\alias{day}
\title{Day of a date vector}
\usage{
day(d)
}
\arguments{
\item{d}{a vector of dates}
}
\value{
The day part of each value in \code{d}
as an integer.
}
\description{
Day of a date vector
}
\examples{
day(as.Date('2022-10-14'))
day(ISOdate(1923, 12, 2))

}
