% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/all.R
\name{trim}
\alias{trim}
\title{Remove leading and trailing whitespace from characters}
\usage{
trim(x)
}
\arguments{
\item{x}{a vector of strings}
}
\value{
\code{x} without any leading or trailing whitespace.
}
\description{
Inspired by the Excel function with the same name.
}
\examples{
trim('  leading spaces')
trim('trailing spaces   ')
trim('  leading and trailing spaces   ')
trim('\n\r\t Other kinds of whitespace \t\n\r')
trim("\n Doesn't affect internal whitespace  ")

}
