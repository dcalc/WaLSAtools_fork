---
template: main.html
---

# Worked Example - NRMP: k-ω Analysis and Filtering

This example demonstrates the application of k-ω analysis and filtering to a synthetic spatio-temporal dataset. The dataset consists of a time series of 2D images, representing the evolution of wave patterns over both space and time. By analyzing this dataset in the k-ω domain, we can gain insights into the relationship between spatial and temporal scales of oscillations, identify different wave modes, and isolate specific wave features through filtering.

!!! walsa-example "Analysis and Figure"

    The figure below provides a comprehensive illustration of k-ω analysis and filtering applied to the synthetic spatio-temporal dataset.

    **Methods used:**

    *   k-ω analysis
    *   Fourier filtering in the wavenumber and frequency domains

    **WaLSAtools version:** 1.0

    These particular analyses generate the figure below (Supplementary Figure S4 in *Nature Reviews Methods Primers*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article. See the source code at the bottom of this page (or <a href="https://github.com/WaLSAteam/WaLSAtools/blob/main/examples/python/Worked_examples__NRMP/FIGS4__komega_analysis.ipynb" target="_blank">here</a> on Github) for a complete analyses and the plotting routines used to generate this figure.

    ![jpg](/python/converted_notebooks_nrmp/Figures_jpg/FigS4_k-omega_analysis.jpg)

    **Figure Caption:** Illustration of k-ω analysis and filtering applied to a synthetic spatio-temporal dataset. **(a)** The k-ω power diagram, with dashed lines outlining the targeted filtering region. **(b)** A six-frame sequence from the filtered datacube, showcasing the spatial and temporal evolution of the isolated wave features. **(c)-(e)** Step-by-step visualization of the spatial filtering process: **(c)** The time-averaged spatial power spectrum of the original dataset. **(d)** The spatial filter mask. **(e)** The result of applying the mask to the spatial Fourier transform. **(f)** The spatially-averaged temporal power spectrum, with the temporal filter masks (dashed lines) and the preserved oscillatory power (solid red curves).

    ??? source-code "Source code"
        {% include-markdown "python/converted_notebooks_nrmp/FIGS4__komega_analysis.md" %}

<br>
