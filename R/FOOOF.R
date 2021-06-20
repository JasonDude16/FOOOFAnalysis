#' Model a physiological power spectrum as a combination of aperiodic and periodic components.
#'
#' WARNING: FOOOF expects frequency and power values in linear space. Passing in logged frequencies and/or power spectra is not detected,
#' and will silently produce incorrect results. Parameters
#' ----------
#' peak_width_limits : list of (float, float), optional, default: (0.5, 12.0) Limits on possible peak width, in Hz, as (lower_bound, upper_bound).
#' max_n_peaks : int, optional, default: inf Maximum number of peaks to fit.
#' min_peak_height : float, optional, default: 0 Absolute threshold for detecting peaks, in units of the input data.
#' peak_threshold : float, optional, default: 2.0 Relative threshold for detecting peaks, in units of standard deviation of the input data.
#' aperiodic_mode : {'fixed', 'knee'} Which approach to take for fitting the aperiodic component.
#' verbose : bool, optional, default: TRUE Verbosity mode. If TRUE, prints out warnings and general status updates. Attributes
#' ----------
#' freqs : 1d array Frequency values for the power spectrum.
#' power_spectrum : 1d array Power values, stored internally in log10 scale.
#' freq_range : list of [float, float] Frequency range of the power spectrum, as [lowest_freq, highest_freq].
#' freq_res : float Frequency resolution of the power spectrum.
#' fooofed_spectrum_ : 1d array The full model fit of the power spectrum, in log10 scale.
#' aperiodic_params_ : 1d array Parameters that define the aperiodic fit. As [Offset, (Knee), Exponent]. The knee parameter is only included if aperiodic component is fit with a knee.
#' peak_params_ : 2d array Fitted parameter values for the peaks. Each row is a peak, as [CF, PW, BW].
#' gaussian_params_ : 2d array Parameters that define the gaussian fit(s). Each row is a gaussian, as [mean, height, standard deviation].
#' r_squared_ : float R-squared of the fit between the input power spectrum and the full model fit.
#' error_ : float Error of the full model fit.
#' n_peaks_ : int The number of peaks fit in the model.
#' has_data : bool Whether data is loaded to the object.
#' has_model : bool Whether model results are available in the object. Notes
#' -----
#' - Commonly used abbreviations used in this module include: CF: center frequency, PW: power, BW: Bandwidth, AP: aperiodic
#' - Input power spectra must be provided in linear scale. Internally they are stored in log10 scale, as this is what the model operates upon.
#' - Input power spectra should be smooth, as overly noisy power spectra may lead to bad fits. For example, raw FFT inputs are not appropriate. Where possible and appropriate, use longer time segments for power spectrum calculation to get smoother power spectra, as this will give better model fits.
#' - The gaussian params are those that define the gaussian of the fit, where as the peak params are a modified version, in which the CF of the peak is the mean of the gaussian, the PW of the peak is the height of the gaussian over and above the aperiodic component, and the BW of the peak, is 2*std of the gaussian (as 'two sided' bandwidth).
#'
#' @param peak_width_limits peak_width_limits
#' @param max_n_peaks max_n_peaks
#' @param min_peak_height min_peak_height
#' @param peak_threshold peak_threshold
#' @param aperiodic_mode aperiodic_mode
#' @param verbose verbose
#'
#' @section peak_width_limits : tuple of (float, float), optional, default: (0.5, 12.0):
#' Limits on possible peak width, in Hz, as (lower_bound, upper_bound). max_n_peaks : int, optional, default: inf Maximum number of peaks to fit. min_peak_height : float, optional, default: 0 Absolute threshold for detecting peaks, in units of the input data. peak_threshold : float, optional, default: 2.0 Relative threshold for detecting peaks, in units of standard deviation of the input data. aperiodic_mode : {'fixed', 'knee'} Which approach to take for fitting the aperiodic component. verbose : bool, optional, default: TRUE Verbosity mode. If TRUE, prints out warnings and general status updates.
#'
#' @section max_n_peaks : int, optional, default: inf:
#' Maximum number of peaks to fit. min_peak_height : float, optional, default: 0 Absolute threshold for detecting peaks, in units of the input data. peak_threshold : float, optional, default: 2.0 Relative threshold for detecting peaks, in units of standard deviation of the input data. aperiodic_mode : {'fixed', 'knee'} Which approach to take for fitting the aperiodic component. verbose : bool, optional, default: TRUE Verbosity mode. If TRUE, prints out warnings and general status updates.
#'
#' @section min_peak_height : float, optional, default: 0:
#' Absolute threshold for detecting peaks, in units of the input data. peak_threshold : float, optional, default: 2.0 Relative threshold for detecting peaks, in units of standard deviation of the input data. aperiodic_mode : {'fixed', 'knee'} Which approach to take for fitting the aperiodic component. verbose : bool, optional, default: TRUE Verbosity mode. If TRUE, prints out warnings and general status updates.
#'
#' @section peak_threshold : float, optional, default: 2.0:
#' Relative threshold for detecting peaks, in units of standard deviation of the input data. aperiodic_mode : {'fixed', 'knee'} Which approach to take for fitting the aperiodic component. verbose : bool, optional, default: TRUE Verbosity mode. If TRUE, prints out warnings and general status updates.
#'
#' @section aperiodic_mode : {'fixed', 'knee'}:
#' Which approach to take for fitting the aperiodic component. verbose : bool, optional, default: TRUE Verbosity mode. If TRUE, prints out warnings and general status updates.
#'
#' @section verbose : bool, optional, default: True:
#' Verbosity mode. If TRUE, prints out warnings and general status updates.
#'
#' @section freqs : 1d array:
#' Frequency values for the power spectrum. power_spectrum : 1d array Power values, stored internally in log10 scale. freq_range : list of [float, float] Frequency range of the power spectrum, as [lowest_freq, highest_freq]. freq_res : float Frequency resolution of the power spectrum. fooofed_spectrum_ : 1d array The full model fit of the power spectrum, in log10 scale. aperiodic_params_ : 1d array Parameters that define the aperiodic fit. As [Offset, (Knee), Exponent]. The knee parameter is only included if aperiodic component is fit with a knee. peak_params_ : 2d array Fitted parameter values for the peaks. Each row is a peak, as [CF, PW, BW]. gaussian_params_ : 2d array Parameters that define the gaussian fit(s). Each row is a gaussian, as [mean, height, standard deviation]. r_squared_ : float R-squared of the fit between the input power spectrum and the full model fit. error_ : float Error of the full model fit. n_peaks_ : int The number of peaks fit in the model. has_data : bool Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section power_spectrum : 1d array:
#' Power values, stored internally in log10 scale. freq_range : list of [float, float] Frequency range of the power spectrum, as [lowest_freq, highest_freq]. freq_res : float Frequency resolution of the power spectrum. fooofed_spectrum_ : 1d array The full model fit of the power spectrum, in log10 scale. aperiodic_params_ : 1d array Parameters that define the aperiodic fit. As [Offset, (Knee), Exponent]. The knee parameter is only included if aperiodic component is fit with a knee. peak_params_ : 2d array Fitted parameter values for the peaks. Each row is a peak, as [CF, PW, BW]. gaussian_params_ : 2d array Parameters that define the gaussian fit(s). Each row is a gaussian, as [mean, height, standard deviation]. r_squared_ : float R-squared of the fit between the input power spectrum and the full model fit. error_ : float Error of the full model fit. n_peaks_ : int The number of peaks fit in the model. has_data : bool Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section freq_range : list of [float, float]:
#' Frequency range of the power spectrum, as [lowest_freq, highest_freq]. freq_res : float Frequency resolution of the power spectrum. fooofed_spectrum_ : 1d array The full model fit of the power spectrum, in log10 scale. aperiodic_params_ : 1d array Parameters that define the aperiodic fit. As [Offset, (Knee), Exponent]. The knee parameter is only included if aperiodic component is fit with a knee. peak_params_ : 2d array Fitted parameter values for the peaks. Each row is a peak, as [CF, PW, BW]. gaussian_params_ : 2d array Parameters that define the gaussian fit(s). Each row is a gaussian, as [mean, height, standard deviation]. r_squared_ : float R-squared of the fit between the input power spectrum and the full model fit. error_ : float Error of the full model fit. n_peaks_ : int The number of peaks fit in the model. has_data : bool Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section freq_res : float:
#' Frequency resolution of the power spectrum. fooofed_spectrum_ : 1d array The full model fit of the power spectrum, in log10 scale. aperiodic_params_ : 1d array Parameters that define the aperiodic fit. As [Offset, (Knee), Exponent]. The knee parameter is only included if aperiodic component is fit with a knee. peak_params_ : 2d array Fitted parameter values for the peaks. Each row is a peak, as [CF, PW, BW]. gaussian_params_ : 2d array Parameters that define the gaussian fit(s). Each row is a gaussian, as [mean, height, standard deviation]. r_squared_ : float R-squared of the fit between the input power spectrum and the full model fit. error_ : float Error of the full model fit. n_peaks_ : int The number of peaks fit in the model. has_data : bool Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section fooofed_spectrum_ : 1d array:
#' The full model fit of the power spectrum, in log10 scale. aperiodic_params_ : 1d array Parameters that define the aperiodic fit. As [Offset, (Knee), Exponent]. The knee parameter is only included if aperiodic component is fit with a knee. peak_params_ : 2d array Fitted parameter values for the peaks. Each row is a peak, as [CF, PW, BW]. gaussian_params_ : 2d array Parameters that define the gaussian fit(s). Each row is a gaussian, as [mean, height, standard deviation]. r_squared_ : float R-squared of the fit between the input power spectrum and the full model fit. error_ : float Error of the full model fit. n_peaks_ : int The number of peaks fit in the model. has_data : bool Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section aperiodic_params_ : 1d array:
#' Parameters that define the aperiodic fit. As [Offset, (Knee), Exponent]. The knee parameter is only included if aperiodic component is fit with a knee. peak_params_ : 2d array Fitted parameter values for the peaks. Each row is a peak, as [CF, PW, BW]. gaussian_params_ : 2d array Parameters that define the gaussian fit(s). Each row is a gaussian, as [mean, height, standard deviation]. r_squared_ : float R-squared of the fit between the input power spectrum and the full model fit. error_ : float Error of the full model fit. n_peaks_ : int The number of peaks fit in the model. has_data : bool Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section peak_params_ : 2d array:
#' Fitted parameter values for the peaks. Each row is a peak, as [CF, PW, BW]. gaussian_params_ : 2d array Parameters that define the gaussian fit(s). Each row is a gaussian, as [mean, height, standard deviation]. r_squared_ : float R-squared of the fit between the input power spectrum and the full model fit. error_ : float Error of the full model fit. n_peaks_ : int The number of peaks fit in the model. has_data : bool Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section gaussian_params_ : 2d array:
#' Parameters that define the gaussian fit(s). Each row is a gaussian, as [mean, height, standard deviation]. r_squared_ : float R-squared of the fit between the input power spectrum and the full model fit. error_ : float Error of the full model fit. n_peaks_ : int The number of peaks fit in the model. has_data : bool Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section r_squared_ : float:
#' R-squared of the fit between the input power spectrum and the full model fit. error_ : float Error of the full model fit. n_peaks_ : int The number of peaks fit in the model. has_data : bool Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section error_ : float:
#' Error of the full model fit. n_peaks_ : int The number of peaks fit in the model. has_data : bool Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section n_peaks_ : int:
#' The number of peaks fit in the model. has_data : bool Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section has_data : bool:
#' Whether data is loaded to the object. has_model : bool Whether model results are available in the object.
#'
#' @section has_model : bool:
#' Whether model results are available in the object.
#'
#' @export

FOOOF <- function(peak_width_limits = list(0.5, 12.0), max_n_peaks = Inf, min_peak_height = 0.0, peak_threshold = 2.0, aperiodic_mode = "fixed", verbose = TRUE) {

    if (!require(reticulate))
      stop("`reticulate` is required to use the FOOOF function")

    import("fooof")
    import("numpy", "np")
    import("matplotlib", "plt")
    import("pandas", "pd")

    fooof_obj <-
    py$fooof$FOOOF(
      peak_width_limits = peak_width_limits,
      max_n_peaks = max_n_peaks,
      min_peak_height = min_peak_height,
      peak_threshold = peak_threshold,
      aperiodic_mode = aperiodic_mode,
      verbose = verbose
    )

    return(py_to_r(fooof_obj))

}
