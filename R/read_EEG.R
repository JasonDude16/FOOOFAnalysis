#' Read EEG excel files
#'
#' This function reads in EEG excel files where each sheet is a participant,
#' each electrode is a row and each is the power expressed in Hz.
#' @param file Path to file to be read in.
#' @param skip Numeric or character vector defining sheets to be skipped when reading.
#' Defaults to 2:length(sheets).
#' @param verbose Provides a summary of what was read in. Defaults to True.
#' @keywords EEG
#' @export
#' @examples

read_EEG <- function(file, skip = 2:length(sheets), verbose = TRUE) {

    if (!require(readxl))
        stop("'readxl' needs to be installed")
    if (!require(textshape))
        stop("'textshape' needs to be installed")

    sheets <- excel_sheets(file) # read number of sheets
    data_list <- vector(mode = "list", length = length(sheets)) # empty list

    if (is.character(skip)){ # if char is given find its position in sheets
        skip <- suppressWarnings(which(sheets == skip))
    }

    for (sheet in 1:length(sheets)) {
        if (sheet %in% skip == TRUE) {next} # skip specified values
        data_list[[sheet]] <- suppressMessages(read_excel(path = file, sheet = sheet))
        names(data_list)[sheet] <- sheets[sheet] # sheet name = list name
    }

    if (sum(skip) > 0) {data_list <- data_list[-skip]} # remove skip from list

    if (verbose) { # quality check
        items <- sum(lapply(data_list, length)  == 0)
        print(paste("Number of sheets in file: ", length(sheets)))
        print(paste("Number of sheets skipped: ", length(skip)))
        print(paste("Number of sheets in list: ", length(data_list)))
        print(paste("Number of sheets with length zero: ", items))
        print(paste("Sheets read in: ", paste(names(data_list), collapse = ", ")))
        print(paste("Sheet numbers read in: ", paste(which(1:length(sheets) %in% skip == F), collapse = ", ")))
    }

    return(data_list)

}
