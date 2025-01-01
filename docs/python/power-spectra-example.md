---
template: main.html
title: Power Spectra
---

## Worked Example - NRMP: Power Spectra

This example demonstrates the application of various spectral analysis techniques to a synthetic 1D signal constructed with predefined frequencies and amplitudes. The signal includes a range of oscillatory components with different characteristics, including:

*   **Dominant oscillations:** Five dominant frequencies (5, 12, 15, 18, and 25 Hz) with varying amplitudes.
*   **Transient oscillation:** A short-lived oscillation with a frequency of 2 Hz.
*   **Weak oscillation:** A low-amplitude oscillation with a frequency of 33 Hz.
*   **Quasi-periodic oscillation:** An oscillation with a frequency of 10 Hz and a time-varying amplitude.
*   **Noise:** Random noise added to the signal.

By analyzing this synthetic signal with different methods, we can evaluate their ability to accurately identify and characterize these diverse oscillatory components. This provides valuable insights into the strengths and limitations of each technique, guiding the selection of appropriate methods for analyzing real-world data. For a comprehensive discussion of the analysis and results, please refer to the associated article in *Nature Reviews Methods Primers*.

!!! walsa-example "Analysis and Figure"

    The figure below presents a comparative analysis of various wave analysis methods applied to the synthetic 1D signal. The signal was pre-processed by detrending (to remove any linear trends) and apodized (to reduce edge effects) using a Tukey window.

    **Methods used:**

    *   Fast Fourier Transform (FFT)
    *   Lomb-Scargle Periodogram
    *   Welch's Method
    *   Wavelet Transform (with Morlet, Paul, and Mexican Hat wavelets)
    *   Global Wavelet Spectrum (GWS)
    *   Refined Global Wavelet Spectrum (RGWS)
    *   Hilbert-Huang Transform (HHT) with Empirical Mode Decomposition (EMD) and Ensemble EMD (EEMD)

    **WaLSAtools version:** 1.0

    **To reproduce this figure in WaLSAtools:**

    1.  Launch the interactive interface: `WaLSAtools()`
    2.  Select "Single Time Series Analysis".
    3.  Choose "1D Signal".
    4.  Select the desired analysis method.
    5.  Follow the instructions to input the data and parameters.
    6.  Generate and save the figure.

    These particular analyses generate the figure below (Figure 3 in *Nature Reviews Methods Primers*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article.

    [![Figure 3](examples/python/Worked_examples__NRMP/Figures/Fig3_power_spectra_1D_signal.pdf)](examples/python/Worked_examples__NRMP/Figures/Fig3_power_spectra_1D_signal.pdf)

    **Figure Caption:** Performance of diverse analysis methods on a synthetic 1D time series. The signal comprises dominant oscillations at 5, 12, 15, 18, and 25 Hz, a transient oscillation at 2 Hz, a weak signal at 33 Hz, a quasi-periodic signature at 10 Hz, noise, and other complexities. **a**, The detrended and apodized signal. **b**, The unevenly sampled signal. **c**, The FFT power spectrum. **d**, The Lomb-Scargle periodogram. **e**, The global wavelet spectrum (GWS) for the Morlet, Mexican Hat, and Paul wavelets. **f**, The refined global wavelet spectrum (RGWS) for the Morlet, Mexican Hat, and Paul wavelets. **g**, The HHT spectrum using EMD. **h**, The FFT power spectra of the individual IMFs extracted by EMD. **i**, The HHT spectrum using EEMD. **j**, The FFT power spectra of the individual IMFs extracted by EEMD. **k**, The Welch power spectrum. **l-n**, The wavelet power spectra for the Morlet, Mexican Hat, and Paul wavelets, respectively. All powers are normalized to their maximum value and shown in percentages, with panels **c**, **d**, **h**, and **j** zoomed in on a smaller power range for better visibility of smaller peaks. The 95% confidence levels are indicated by dot-dashed curves for 1D power spectra and solid black contours for wavelet spectra. Vertical lines above each 1D spectrum mark the frequency resolution. Green vertical (or horizontal) lines on the frequency axes indicate the predefined frequencies used to construct the synthetic signal.

    The analyses are performed as (see the source code at the bottom of the page for the complete code including plotting routines):

    ```python
    # Import necessary libraries
    import numpy as np
    from astropy.io import fits
    from WaLSAtools import WaLSAtools, walsa_detrend_apod
    import warnings

    warnings.filterwarnings('ignore', category=RuntimeWarning)

    # Load the synthetic signal from the FITS file
    data_dir= 'Synthetic_Data/'
    file_path = data_dir + 'NRMP_signal_1D.fits'
    hdul = fits.open(file_path)
    signal = hdul[0].data  # 1D synthetic signal data
    time = hdul[1].data  # Time array saved in the second HDU (Extension HDU 1)
    hdul.close()

    # Sampling rate and duration of the data
    sampling_rate = 100  # Hz
    duration = 10        # seconds

    #--------------------------------------------------------------------------
    # Create unevenly sampled data by removing gaps from the signal
    # Define gaps' sizes and start indices
    gap_sizes = [17, 42, 95, 46]  # Sizes of gaps
    gap_starts = [150, 200, 500, 800]  # Start indices for gaps
    # Create initial set of indices
    n_points = len(signal)
    indices = np.arange(n_points)
    # Remove gaps
    for gap_start, gap_size in zip(gap_starts, gap_sizes):
        indices = indices[(indices < gap_start) | (indices >= gap_start + gap_size)]
    # Reduce both time and signal arrays according to final indices
    t_uneven = time[indices]
    signal_uneven = signal[indices]
    # Sort time and signal to maintain ascending order (although should already be in order)
    sorted_indices = np.argsort(t_uneven)
    t_uneven = t_uneven[sorted_indices]
    signal_uneven = signal_uneven[sorted_indices]
    #--------------------------------------------------------------------------
    # FFT Analysis using WaLSAtools
    fft_power, fft_freqs, fft_significance = WaLSAtools(signal=signal, time=time, method='fft', siglevel=0.95, apod=0.1)
    # Normalize FFT power to its maximum value
    fft_power_normalized = 100 * fft_power / np.max(fft_power)
    fft_significance_normalized = 100 * fft_significance / np.max(fft_power)
    #--------------------------------------------------------------------------
    # Lomb-Scargle Analysis using WaLSAtools
    ls_power, ls_freqs, ls_significance = WaLSAtools(signal=signal, time=time, method='lombscargle', siglevel=0.95, apod=0.1)
    # Normalize Lomb-Scargle power to its maximum value
    ls_power_normalized = 100 * ls_power / np.max(ls_power)
    ls_significance_normalized = 100 * ls_significance / np.max(ls_power)
    #--------------------------------------------------------------------------
    # Wavelet Analysis using WaLSAtools - Morlet
    wavelet_power_morlet, wavelet_periods_morlet, wavelet_significance_morlet, coi_morlet, (global_power_morlet, global_conf_morlet), (rgws_morlet_periods, rgws_morlet_power) = WaLSAtools(
        signal=signal, time=time, method='wavelet', siglevel=0.95, apod=0.1, mother='morlet', GWS=True, RGWS=True
    )
    #--------------------------------------------------------------------------
    # Wavelet Analysis using WaLSAtools - DOG (Mexican Hat)
    wavelet_power_dog, wavelet_periods_dog, wavelet_significance_dog, coi_dog, (global_power_dog, global_conf_dog), (rgws_dog_periods, rgws_dog_power) = WaLSAtools(
        signal=signal, time=time, method='wavelet', siglevel=0.95, apod=0.1, mother='dog', GWS=True, RGWS=True
    )
    #--------------------------------------------------------------------------
    # Wavelet Analysis using WaLSAtools - Paul
    wavelet_power_paul, wavelet_periods_paul, wavelet_significance_paul, coi_paul, (global_power_paul, global_conf_paul), (rgws_paul_periods, rgws_paul_power) = WaLSAtools(
        signal=signal, time=time, method='wavelet', siglevel=0.95, apod=0.1, mother='paul', GWS=True, RGWS=True
    )
    #--------------------------------------------------------------------------
    # Welch Power Spectral Density Analysis using WaLSAtools
    welch_psd, welch_freqs, welch_significance = WaLSAtools(signal=signal, time=time, method='welch', siglevel=0.95, nperseg=200, noverlap=20)
    # Normalize Welch PSD to its maximum value
    welch_psd_normalized = 100 * welch_psd / np.max(welch_psd)
    welch_significance_normalized = 100 * welch_significance / np.max(welch_psd)
    #--------------------------------------------------------------------------
    # EMD & HHT Calculations using WaLSAtools
    HHT_power_spectrum_EMD, HHT_significance_level_EMD, HHT_freq_bins_EMD, psd_spectra_fft_EMD, confidence_levels_fft_EMD, _, _, _ = WaLSAtools(
        signal=signal, time=time, method='emd', siglevel=0.95)
    # Normalize power spectra to their maximum values
    HHT_power_spectrum_EMD_normalized = 100 * HHT_power_spectrum_EMD / np.max(HHT_power_spectrum_EMD)
    HHT_significance_level_EMD_normalized = 100 * HHT_significance_level_EMD / np.max(HHT_power_spectrum_EMD)
    #--------------------------------------------------------------------------
    # EEMD & HHT Calculations using WaLSAtools
    HHT_power_spectrum_EEMD, HHT_significance_level_EEMD, HHT_freq_bins_EEMD, psd_spectra_fft_EEMD, confidence_levels_fft_EEMD, _, _, _ = WaLSAtools(
        signal=signal, time=time, method='emd', siglevel=0.95, EEMD=True)
    # Normalize power spectra to their maximum values
    HHT_power_spectrum_EEMD_normalized = 100 * HHT_power_spectrum_EEMD / np.max(HHT_power_spectrum_EEMD)
    HHT_significance_level_EEMD_normalized = 100 * HHT_significance_level_EEMD / np.max(HHT_power_spectrum_EEMD)

    # ... (rest of the code for plotting)
    ```

    ??? source-code "Source code"
        ``` python
        --8<-- "examples/python/Worked_examples__NRMP/FIG3__walsatools_power_spectra.ipynb"
        ```