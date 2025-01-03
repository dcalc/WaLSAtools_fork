---
template: main.html
---

# Worked Example - NRMP: Dominant Frequency

This example demonstrates the application of dominant frequency analysis to a synthetic spatio-temporal dataset. The dataset comprises a time series of 2D images, representing the evolution of wave patterns over both space and time. By analyzing the dominant frequencies at each spatial location, we can gain insights into the spatial distribution of oscillatory behavior and identify potential wave modes.

!!! walsa-example "Analysis and Figure"

    The figure below shows the dominant frequency maps calculated using different spectral analysis methods. The maps reveal the spatial distribution of the most prominent oscillation frequencies in the dataset.

    **Methods used:**

    *   Fast Fourier Transform (FFT)
    *   Refined Global Wavelet Spectrum (RGWS) with Morlet wavelet
    *   Refined Global Wavelet Spectrum (RGWS) with Paul wavelet

    **WaLSAtools version:** 1.0

    These particular analyses generate the figure below (Figure 4 in *Nature Reviews Methods Primers*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article. See the source code at the bottom of this page (or <a href="https://github.com/WaLSAteam/WaLSAtools/blob/main/examples/python/Worked_examples__NRMP/FIG4__dominant_frequency__mean_spectra.ipynb" target="_blank">here</a> on Github) for a complete analyses and the plotting routines used to generate this figure.

    ![jpg](/python/converted_notebooks_nrmp/Figures_jpg/Fig4_dominant_frequency_mean_power_spectra.jpg)

    **Figure Caption:** Dominant frequency maps and mean power spectra. Top row: Dominant frequency maps derived using FFT (left), Morlet-based RGWS (middle), and Paul-based RGWS (right). Bottom panel: Normalized mean power spectra for FFT (blue), Morlet-based RGWS (red), and Paul-based RGWS (black).

    ??? source-code "Source code"
        {% include-markdown "python/converted_notebooks_nrmp/FIG4__dominant_frequency__mean_spectra.md" %}

<br>