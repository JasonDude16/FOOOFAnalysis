#' Tidy format EEG data
#'
#' This function is intended to be used in conjunction with `read_EEG()`.
#' In `read_EEG()`, the output is not in tidy format.This function formats the
#' data in a way that is in alignment with tidy principles; namely, where each
#' row is an observation and each column is a variable.
#' @param df EEG data sheet from `read_EEG()`.
#' @param to_rownames Assuming the data contain a column of electrode names,
#' this column can be converted to rownames (recommended). Defaults to "channels".
#' @param format Specifies the desired output, which is one of the following
#' options: "avg_elec", "avg_freq", c("avg_elec", "avg_freq"), or "to_FOOOF",
#' which will provide a list output that is conducive for performing FOOOF.
#' @keywords EEG
#' @export
#' @examples

tidy_EEG <- function(df, to_rownames = "channels", format = "to_FOOOF") {

    options = c("to_FOOOF", "avg_elec", "avg_freq")
    avg_elec = any(format == "avg_elec")
    avg_freq = any(format == "avg_freq")
    to_FOOOF = any(format == "to_FOOOF")

    if (!all(format %in% options))
        stop("`format` takes one of the following: ", paste(options, collapse = ", "))
    if(is.matrix(df) | is.numeric(df))
        stop("Input is numeric... Did you already run this function?")
    if(!is.data.frame(df))
        stop("Input must be a data frame")
    if (!is.character(to_rownames))
        stop("`to_rownames`` must be given a column in character format")
    if (length(df) == 0)
        stop("Df is empty and `to_rownames` cannot be completed")
    if (any(colnames(df) %in% to_rownames) == F)
        stop("Column '", to_rownames, "' does not exist")

    df <- column_to_rownames(as.data.frame(df), to_rownames)
    df_t <- t(df)
    names <- gsub(pattern = "\\.\\.\\.(.*)", replacement = "", rownames(df_t))
    row.names(df_t) <- names

    if (avg_freq | to_FOOOF) {
        df_sum <- rowsum(df_t, group = row.names(df_t))
        # grab row name for each frequency group (one row name for each frequency)
        group_names <- names(summary(as.factor(as.numeric(row.names(df_t)))))
        # compute the number of observations for each frequency group
        obs <- summary(as.factor(row.names(df_t)))
        if (length(group_names) != nrow(df_sum))
            stop("Error in avg_freq: Lengths do not match")
        df_avg_freq <- df_sum[NA, ] # empty df with same columns as df_sum
        for (i in 1:nrow(df_avg_freq)) { # divide SUM by # of obs (average)
            df_avg_freq[i, ] <- subset(df_sum, rownames(df_sum) %in% group_names[i]) / obs[i]
        }
        row.names(df_avg_freq) <- group_names

        if (to_FOOOF) {
            freqs <- as.matrix(as.numeric(row.names(df_avg_freq)))
            names(df) <- "freqs"
        }
    }

    if (avg_elec | to_FOOOF) {
        df_avg_elec <- rowMeans(df_t)
    }

    if (avg_freq & avg_elec | to_FOOOF) {
        df_avg_freq_elec <- rowMeans(df_avg_freq)
    }

    if (to_FOOOF) {return(list("spectrum" = df_avg_freq_elec, "freqs" = freqs))}
    if (avg_freq & avg_elec) {return(df_avg_freq_elec)}
    if (avg_freq==TRUE & avg_elec==FALSE) {return(df_avg_freq)}
    if (avg_freq==FALSE & avg_elec==TRUE) {return(df_avg_elec)}

}
