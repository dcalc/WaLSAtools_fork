---
template: main.html
---

# Worked Example - NRMP: Spectral Proper Orthogonal Decomposition (SPOD) Analysis

This example demonstrates the application of Spectral Proper Orthogonal Decomposition (SPOD) to a synthetic spatio-temporal dataset. SPOD is an extension of the traditional Proper Orthogonal Decomposition (POD) method that incorporates frequency filtering to isolate specific modes associated with particular frequencies. This allows for a more refined analysis of the dominant spatial patterns and their temporal evolution, particularly in complex datasets with multiple superimposed oscillations.

!!! walsa-example "Analysis and Figure"

    The figure below shows the results of applying SPOD to the synthetic spatio-temporal dataset.

    **Methods used:**

    *   Spectral Proper Orthogonal Decomposition (SPOD)
    *   Welch's method (to analyze the frequency content of the temporal coefficients)

    **WaLSAtools version:** 1.0

    These particular analyses generate the figure below (Supplementary Figure S8 in *Nature Reviews Methods Primers*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article. See the source code at the bottom of this page (or <a href="https://github.com/WaLSAteam/WaLSAtools/blob/main/examples/python/Worked_examples__NRMP/FIGS8__SPOD.ipynb" target="_blank">here</a> on Github) for a complete analyses and the plotting routines used to generate this figure.

    ![jpg](/python/converted_notebooks_nrmp/Figures_jpg/FigS8_SPOD.jpg)

    **Figure Caption:** SPOD analysis. Spatial modes (130×130 pixels<sup>2</sup> each), temporal coefficients, and Welch power spectra of the first six SPOD modes. The SPOD analysis was performed with a Gaussian filter kernel, illustrating the frequency pairing phenomenon, where each frequency is associated with two distinct spatial modes with corresponding temporal coefficients. The shared frequency content is evident in the Welch power spectra. The ten base frequencies are marked with vertical dashed lines.

    ??? source-code "Source code"
        {% include-markdown "python/converted_notebooks_nrmp/FIGS8__SPOD.md" %}

<br>