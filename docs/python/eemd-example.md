---
template: main.html
---

# Worked Example - NRMP: Ensemble Empirical Mode Decomposition (EEMD)

This example demonstrates the application of Ensemble Empirical Mode Decomposition (EEMD) to a synthetic 1D signal. EEMD is an extension of EMD that addresses the issue of mode mixing by adding noise to the signal and performing multiple EMD decompositions. This ensemble approach improves the accuracy and robustness of the analysis, especially for noisy signals.

!!! walsa-example "Analysis and Figure"

    The figure below shows the results of applying EEMD to the synthetic 1D signal.

    **Methods used:**

    *   Ensemble Empirical Mode Decomposition (EEMD)
    *   Hilbert Transform (to calculate instantaneous frequencies)
    *   Fast Fourier Transform (FFT) (to analyze the frequency content of the IMFs)

    **WaLSAtools version:** 1.0

    These particular analyses generate the figure below (Supplementary Figure S3 in *[Nature Reviews Methods Primers](https://www.nature.com/articles/s43586-025-00392-0)*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article. See the source code at the bottom of this page (or <a href="https://github.com/WaLSAteam/WaLSAtools/blob/main/examples/python/Worked_examples__NRMP/FIGS3__EEMD.ipynb" target="_blank">here</a> on Github) for a complete analyses and the plotting routines used to generate this figure.

    ![jpg](/python/converted_notebooks_nrmp/Figures_jpg/FigS3_EEMD_analysis.jpg)

    **Figure Caption:** EEMD analysis of the synthetic 1D signal. **(a)** IMFs extracted from the synthetic signal using EEMD. IMF 1 is marked with the grey background as non-significant (at 5%), based on a significance test. **(b)** Instantaneous frequencies of each IMF in Hz, revealing time-varying frequency content. **(c)** HHT marginal spectrum (solid line) and its 95% confidence level (dashed line). **(d)** FFT power spectra of individual IMFs, with dashed lines indicating 95% confidence levels. The dotted vertical lines mark the oscillation frequencies of the synthetic signal.

    ??? source-code "Source code"
        {% include-markdown "python/converted_notebooks_nrmp/FIGS3__EEMD.md" %}