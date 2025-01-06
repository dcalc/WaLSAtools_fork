---
template: main.html
---

# Worked Example - NRMP: POD with Frequency Filtering

This example demonstrates the application of frequency filtering to the temporal coefficients of POD modes. By isolating specific frequencies in the temporal evolution of each mode, we can extract spatial patterns associated with those frequencies, revealing more detailed information about the wave behaviour.

!!! walsa-example "Analysis and Figure"

    The figure below shows the frequency-filtered spatial modes for the ten dominant frequencies in the synthetic spatio-temporal dataset.

    **Methods used:**

    *   Proper Orthogonal Decomposition (POD)
    *   Frequency filtering of temporal coefficients

    **WaLSAtools version:** 1.0

    These particular analyses generate the figure below (Supplementary Figure S7 in *Nature Reviews Methods Primers*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article. See the source code at the bottom of this page (or <a href="https://github.com/WaLSAteam/WaLSAtools/blob/main/examples/python/Worked_examples__NRMP/FigS7__POD_frequency_filtered_spatial_modes.ipynb" target="_blank">here</a> on Github) for a complete analyses and the plotting routines used to generate this figure.

    ![jpg](/python/converted_notebooks_nrmp/Figures_jpg/FigS7_POD_frequency_filtered_spatial_modes.jpg)

    **Figure Caption:** Frequency-filtered spatial modes for the ten dominant frequencies. The spatial patterns associated with each frequency are shown for the first three time steps of the series, with each image covering 130×130 pixels<sup>2</sup>.

    ??? source-code "Source code"
        {% include-markdown "python/converted_notebooks_nrmp/FigS7__POD_frequency_filtered_spatial_modes.md" %}

