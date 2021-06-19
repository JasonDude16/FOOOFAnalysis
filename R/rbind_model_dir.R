#' Combine EEG model data
#'
#' This function is intended to be used after `RtoFOOOF()` and is fairly
#' inflexible The output from `RtoFOOOF()` is a .csv file written to some data
#' directory. If the `RtoFOOOF()` function was implemented a number times,
#' numerous .csv files will have been generated for each EEG condition, for
#' example. This function appends (rbinds) those model data .csv files in a
#' *single* directory. If the files are spread across directories, they will all
#' need to be moved to one directory, and they should be the *only* files in that
#' directory. All data will need to have the same variables (columns) for this
#' function to work.
#' @param file_path Path to directory of .csv files to rbind. Nothing else should
#' be in this directory.
#' @param output_name Name/name and path to output file.
#' @param conds_pattern This function assumes a common naming convention among
#' .csv files. For example, if all .csv files for the Eyes Closed condition at
#' 32Hz contain "EC_32" in the file name, then the conds_pattern argument will
#' take a regex is an input to parse the .csv file name and create a column for
#' the output .csv, called `condition`, which extracts that regex. Defaults to
#' ".._[0-9][0-9]" which parses "XX_##".
#' @keywords EEG
#' @export
#' @examples

rbind_model_dir <- function(file_path, output_name, conds_pattern = ".._[0-9][0-9]") {

    if(!require(stringi))
        stop("First install `stringi` package")

    files <- list.files(file_path)

    if (file.exists(output_name))
        stop("Delete old file first")

    data <- lapply(files, function(x){
        cond <- stringi::stri_extract(x, regex = conds_pattern)
        df <- read.csv(x)
        df$condition <- rep(cond, nrow(df))
        df <- df[-1]
        return(df)
    })

    all <- dplyr::arrange(.data = do.call(rbind, data), ID)
    write.csv(all, output_name, row.names = FALSE)

    if (file.exists(output_name)) {
        message("File saved successfully")
    }
}
