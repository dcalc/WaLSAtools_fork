---
template: main.html
---

# Worked Example - NRMP: Empirical Mode Decomposition (EMD)

This example demonstrates the application of Empirical Mode Decomposition (EMD) to a synthetic 1D signal. EMD is a data-driven technique that decomposes a signal into a set of Intrinsic Mode Functions (IMFs), each representing a distinct oscillatory mode with its own time-varying amplitude and frequency.

!!! walsa-example "Analysis and Figure"

    The figure below shows the results of applying EMD to the synthetic 1D signal.

    **Methods used:**

    *   Empirical Mode Decomposition (EMD)
    *   Hilbert Transform (to calculate instantaneous frequencies)
    *   Fast Fourier Transform (FFT) (to analyze the frequency content of the IMFs)

    **WaLSAtools version:** 1.0

    These particular analyses generate the figure below (Supplementary Figure S2 in *[Nature Reviews Methods Primers](https://www.nature.com/articles/s43586-025-00392-0)*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article. See the source code at the bottom of this page (or <a href="https://github.com/WaLSAteam/WaLSAtools/blob/main/examples/python/Worked_examples__NRMP/FIGS2__EMD.ipynb" target="_blank">here</a> on Github) for a complete analyses and the plotting routines used to generate this figure.

    ![jpg](/python/converted_notebooks_nrmp/Figures_jpg/FigS2_EMD_analysis.jpg)

    **Figure Caption:** EMD analysis of the synthetic 1D signal. **(a)** IMFs extracted from the synthetic signal using EMD. IMFs 4, 5, and 6 are marked with the grey background as non-significant (at 5%) based on a significance test. **(b)** Instantaneous frequencies of each IMF. **(c)** HHT marginal spectrum. **(d)** FFT power spectra of individual IMFs. The dashed lines in both panels **(c)** and **(d)** indicate the 95% confidence levels. Note that the powers in panels **(c)** and **(d)** are shown in arbitrary units. The dotted vertical lines mark the oscillation frequencies of the synthetic signal.

    ??? source-code "Source code"
        {% include-markdown "python/converted_notebooks_nrmp/FIGS2__EMD.md" %}
