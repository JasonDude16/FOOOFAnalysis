#' Wrapper for FOOOF module in Python
#'
#'
#' @param data_list data_list
#' @param append append
#' @param img_path img_path
#' @param data_path data_path
#' @param freq_range freq_range
#' @export
#' @example

FOOOF_R <- function(data_list, append = NULL, img_path = NULL, data_path = NULL, freq_range = c(1L, 50L)) {

    if (!require(reticulate))
        stop("`reticulate` is required to use the FOOOF_R function")

    py$FOOOF_R(
        data_list = data_list,
        append = append,
        img_path = img_path,
        data_path = data_path,
        freq_range = freq_range
    )

}
