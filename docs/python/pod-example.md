---
template: main.html
---

# Worked Example - NRMP: Proper Orthogonal Decomposition (POD) Analysis

This example demonstrates the application of Proper Orthogonal Decomposition (POD) to a synthetic spatio-temporal dataset. POD is a powerful technique for analysing multi-dimensional data, identifying dominant spatial patterns (modes) that capture the most significant variations in the data. It is particularly useful for reducing the dimensionality of complex datasets and extracting coherent structures.

!!! walsa-example "Analysis and Figure"

    The figure below shows the results of applying POD to the synthetic spatio-temporal dataset.

    **Methods used:**

    *   Proper Orthogonal Decomposition (POD)
    *   Welch's method (to analyze the frequency content of the temporal coefficients)

    **WaLSAtools version:** 1.0

    These particular analyses generate the figure below (Supplementary Figure S5 in *Nature Reviews Methods Primers*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article. See the source code at the bottom of this page (or <a href="https://github.com/WaLSAteam/WaLSAtools/blob/main/examples/python/Worked_examples__NRMP/FigS5__POD_analysis.ipynb" target="_blank">here</a> on Github) for a complete analyses and the plotting routines used to generate this figure.

    ![jpg](/python/converted_notebooks_nrmp/Figures_jpg/FigS5_POD_analysis.jpg)

    **Figure Caption:** POD analysis results. The first six spatial modes (130×130 pixels<sup>2</sup> each), along with their temporal coefficients and Welch power spectra of the temporal coefficients.

    ??? source-code "Source code"
        {% include-markdown "python/converted_notebooks_nrmp/FigS5__POD_analysis.md" %}
