#' Run model fit, and display a report, which includes a plot, and printed results.
#'
#' Parameters
#' ----------
#' freqs : 1d array, optional Frequency values for the power spectrum.
#' power_spectrum : 1d array, optional Power values, which must be input in linear space.
#' freq_range : list of [float, float], optional Desired frequency range to fit the model to. If not provided, fits across the entire given range.
#' plt_log : bool, optional, default: FALSE Whether or not to plot the frequency axis in log space. Notes
#' -----
#' Data is optional, if data has already been added to the object.
#'
#' @param freqs freqs
#' @param power_spectrum power_spectrum
#' @param freq_range freq_range
#' @param plt_log plt_log
#'
#' @section freqs : 1d array, optional:
#' Frequency values for the power spectrum. power_spectrum : 1d array, optional Power values, which must be input in linear space. freq_range : list of [float, float], optional Desired frequency range to fit the model to. If not provided, fits across the entire given range. plt_log : bool, optional, default: FALSE Whether or not to plot the frequency axis in log space.
#'
#' @section power_spectrum : 1d array, optional:
#' Power values, which must be input in linear space. freq_range : list of [float, float], optional Desired frequency range to fit the model to. If not provided, fits across the entire given range. plt_log : bool, optional, default: FALSE Whether or not to plot the frequency axis in log space.
#'
#' @section freq_range : list of [float, float], optional:
#' Desired frequency range to fit the model to. If not provided, fits across the entire given range. plt_log : bool, optional, default: FALSE Whether or not to plot the frequency axis in log space.
#'
#' @section plt_log : bool, optional, default: False:
#' Whether or not to plot the frequency axis in log space.
#'
#' @export

FOOOF_report <- function(fooof_obj, freqs = NULL, power_spectrum = NULL, freq_range = NULL, plt_log = FALSE) {

    if (!require(reticulate))
        stop("`reticulate` is required to use the FOOOF_summaries function")

    import("fooof")
    import("numpy", "np")
    import("matplotlib", "plt")
    import("pandas", "pd")

    self <- reticulate::r_to_py(fooof_obj)

    power_spectrum <- reticulate::r_to_py(power_spectrum, convert = TRUE)
    freq_range <- reticulate::r_to_py(freq_range, convert = TRUE)

    power_spectrum <- reticulate::py_eval("np.ravel(power_spectrum)", convert = FALSE)
    freq_range <- reticulate::py_eval("np.ravel(freq_range)", convert = FALSE)

    py$fooof$FOOOF$report(
        self = self,
        freqs = freqs,
        power_spectrum = py$power_spectrum,
        freq_range = py$freq_range,
        plt_log = plt_log
    )

}
