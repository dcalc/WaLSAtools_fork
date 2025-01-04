---
template: main.html
---

# Worked Example - NRMP: POD Eigenvalues and Explained Variance

This example delves deeper into the analysis of Proper Orthogonal Decomposition (POD) results, focusing on the eigenvalues and explained variance. By examining the eigenvalues and their corresponding spatial modes, we can gain a better understanding of the dominant patterns and their contributions to the overall variability in the data.

!!! walsa-example "Analysis and Figure"

    The figure below summarizes the POD analysis results, including the normalized eigenvalues, combined power spectrum, and cumulative explained variance.

    **Methods used:**

    *   Proper Orthogonal Decomposition (POD)
    *   Power spectrum analysis
    *   Variance analysis

    **WaLSAtools version:** 1.0

    These particular analyses generate the figure below (Supplementary Figure S6 in *Nature Reviews Methods Primers*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article. See the source code at the bottom of this page (or <a href="https://github.com/WaLSAteam/WaLSAtools/blob/main/examples/python/Worked_examples__NRMP/FigS6__POD_eigenvalues_powerspectrum.ipynb" target="_blank">here</a> on Github) for a complete analyses and the plotting routines used to generate this figure.

    ![jpg](/python/converted_notebooks_nrmp/Figures_jpg/FigS6_POD_eigenvalues_powerspectrum.jpg)

    **Figure Caption:** POD mode analysis. **Top left:** Normalized squared singular values (eigenvalues) of the first ten POD modes, demonstrating their relative contributions to the total variance. **Top middle:** Combined power spectrum of the first ten POD modes, revealing the dominant frequencies captured by these ten modes. The vertical dotted lines mark the ten base frequencies used to construct the synthetic data; the red dashed line identifies the 95% confidence level (estimated from 1000 bootstrap resamples). **Top right:** Cumulative explained variance as a function of the number of POD modes included, with vertical lines indicating the cumulative variance captured by 2 (blue), 10 (green), and 22 (red) modes. **Bottom left:** Reconstructed image (130×130 pixels<sup>2</sup>) of the first frame of the time series using the first 22 modes. **Bottom middle:** Original image (130×130 pixels<sup>2</sup>; first frame) of the datacube. **Bottom right:** Scatter plot of the reconstructed and original image.

    ??? source-code "Source code"
        {% include-markdown "python/converted_notebooks_nrmp/FigS6__POD_eigenvalues_powerspectrum.md" %}
