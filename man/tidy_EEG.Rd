% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tidy_EEG.R
\name{tidy_EEG}
\alias{tidy_EEG}
\title{Tidy format EEG data}
\usage{
tidy_EEG(df, to_rownames = "channels", format = "to_FOOOF")
}
\arguments{
\item{df}{EEG data sheet from \code{read_EEG()}.}

\item{to_rownames}{Assuming the data contain a column of electrode names,
this column can be converted to rownames (recommended). Defaults to "channels".}

\item{format}{Specifies the desired output, which is one of the following
options: "avg_elec", "avg_freq", c("avg_elec", "avg_freq"), or "to_FOOOF",
which will provide a list output that is conducive for performing FOOOF.}
}
\description{
This function is intended to be used in conjunction with \code{read_EEG()}.
In \code{read_EEG()}, the output is not in tidy format.This function formats the
data in a way that is in alignment with tidy principles; namely, where each
row is an observation and each column is a variable.
}
\keyword{EEG}
