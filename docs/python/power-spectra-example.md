---
template: main.html
---

# Worked Example - NRMP: Power Spectra

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

    ![figure3](python/converted_notebooks_nrmp/Figures_jpg/Fig3_power_spectra_1D_signal.jpg)

    **Figure Caption:** Performance of diverse analysis methods on a synthetic 1D time series. The signal comprises dominant oscillations at 5, 12, 15, 18, and 25 Hz, a transient oscillation at 2 Hz, a weak signal at 33 Hz, a quasi-periodic signature at 10 Hz, noise, and other complexities. **a**, The detrended and apodized signal. **b**, The unevenly sampled signal. **c**, The FFT power spectrum. **d**, The Lomb-Scargle periodogram. **e**, The global wavelet spectrum (GWS) for the Morlet, Mexican Hat, and Paul wavelets. **f**, The refined global wavelet spectrum (RGWS) for the Morlet, Mexican Hat, and Paul wavelets. **g**, The HHT spectrum using EMD. **h**, The FFT power spectra of the individual IMFs extracted by EMD. **i**, The HHT spectrum using EEMD. **j**, The FFT power spectra of the individual IMFs extracted by EEMD. **k**, The Welch power spectrum. **l-n**, The wavelet power spectra for the Morlet, Mexican Hat, and Paul wavelets, respectively. All powers are normalized to their maximum value and shown in percentages, with panels **c**, **d**, **h**, and **j** zoomed in on a smaller power range for better visibility of smaller peaks. The 95% confidence levels are indicated by dot-dashed curves for 1D power spectra and solid black contours for wavelet spectra. Vertical lines above each 1D spectrum mark the frequency resolution. Green vertical (or horizontal) lines on the frequency axes indicate the predefined frequencies used to construct the synthetic signal.

    See the source code below for a complete analyses andthe plotting routines used to generate this figure.

    ??? source-code "Source code"
        ``` python
        --8<-- "python/converted_notebooks_nrmp/FIG3__walsatools_power_spectra.md"
        ```

<br>