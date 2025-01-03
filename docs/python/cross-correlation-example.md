---
template: main.html
---

# Worked Example - NRMP: Cross-Correlation Analysis

This example demonstrates the application of cross-correlation analysis to two nearly identical synthetic 1D signals. The signals share the same base frequencies and amplitudes but have slight phase differences introduced between them. This simulates a scenario where similar wave signals are observed at different locations or with a time delay.

By analyzing the cross-correlation between these signals, we can identify common frequencies, quantify the strength of their relationship, and determine the phase or time lag between their oscillations. This provides valuable insights into the potential connections or shared drivers influencing the signals.

!!! walsa-example "Analysis and Figure"

    The figure below presents a comparative analysis of cross-correlation techniques applied to the two synthetic 1D signals.

    **Methods used:**

    *   Fast Fourier Transform (FFT)
    *   Wavelet Transform (with Morlet wavelet)

    **WaLSAtools version:** 1.0

    These particular analyses generate the figure below (Figure 6 in *Nature Reviews Methods Primers*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article. See the source code at the bottom of this page (or <a href="https://github.com/WaLSAteam/WaLSAtools/blob/main/examples/python/Worked_examples__NRMP/FIG6__cross_correlation.ipynb" target="_blank">here</a> on Github) for a complete analyses and the plotting routines used to generate this figure.

    ![jpg](/python/converted_notebooks_nrmp/Figures_jpg/Fig6_cross-correlations_FFT_Wavelet.jpg)

    **Figure Caption:** Cross-correlation analysis of two synthetic 1D time series using FFT and wavelet techniques. **(a)** and **(b)** display the first and second time series, respectively. **(c)** compares their FFT power spectra (blue: time series 1, red: time series 2). **(d)-(f)** present the FFT-derived co-spectrum, coherence spectrum, and phase differences. **(g)** and **(h)** show individual wavelet power spectra (Morlet mother wavelet). **(i)** and **(j)** depict the wavelet co-spectrum and coherence map. Cross-hatched areas in wavelet panels mark the cone of influence (COI); black contours indicate the 95% confidence level. Power is represented in log-scale in panels **(g)-(i)**, while colors in panel **(j)** map coherence levels. Phase differences in **(i)** and **(j)** are visualized as arrows (right: in-phase, up: 90-degree lead for time series 1).

    ??? source-code "Source code"
        {% include-markdown "python/converted_notebooks_nrmp/FIG6__cross_correlation.md" %}

<br>
