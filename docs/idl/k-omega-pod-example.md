---
template: main.html
---

# Worked Example - NRMP: k-ω and POD Analysis

This example demonstrates the application of k-ω filtering and Proper Orthogonal Decomposition (POD) to a synthetic spatio-temporal dataset. The dataset consists of a time series of 2D images, representing the evolution of wave patterns over both space and time. By analysing this dataset with k-ω and POD, we can identify and isolate specific wave modes, revealing their spatial structures and temporal dynamics.

## k-ω Analysis

k-ω analysis is a technique used to study wave phenomena in spatio-temporal datasets. It involves calculating the power spectrum of the data in both the spatial domain (wavenumber, k) and the temporal domain (frequency, ω). The resulting k-ω diagram shows how wave power is distributed across different spatial and temporal scales, providing insights into wave dispersion relations and the characteristics of different wave modes.

In this example, we apply k-ω analysis to the synthetic spatio-temporal dataset to identify and isolate a specific wave mode with a frequency of 500 mHz and wavenumbers between 0.05 and 0.25 pixel<sup>-1</sup>. We then use Fourier filtering to extract this wave mode from the dataset, revealing its spatial structure and temporal evolution.

## Proper Orthogonal Decomposition (POD)

Proper Orthogonal Decomposition (POD) is a powerful technique for analysing multi-dimensional data. It identifies dominant spatial patterns, or modes, that capture the most significant variations in the data. POD is particularly useful for reducing the dimensionality of complex datasets and extracting coherent structures.

In this example, we apply POD to the synthetic spatio-temporal dataset to identify the dominant spatial modes of oscillation. We then apply frequency filtering to the temporal coefficients of these modes to isolate the 500 mHz wave mode. This allows us to compare the results of k-ω filtering and POD-based filtering, highlighting their respective strengths and limitations.

!!! walsa-example "Analysis and Figure"

    The figure below shows a comparison of k-ω filtering and POD analysis applied to the synthetic spatio-temporal dataset.

    **Methods used:**

    *   k-ω analysis with Fourier filtering
    *   Proper Orthogonal Decomposition (POD) with frequency filtering

    **WaLSAtools version:** 1.0

    These particular analyses generate the figure below (the IDL version of Figure 5 in *Nature Reviews Methods Primers*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article. See the source code at the bottom of this page (or <a href="https://github.com/WaLSAteam/WaLSAtools/blob/main/examples/python/Worked_examples__NRMP/FIG5__komega_POD_analyses.ipynb" target="_blank">here</a> on Github) for a complete analyses and the plotting routines used to generate this figure.

    ![jpg](/idl/Figures_nrmp_jpg/Fig5_k-omega_and_pod_analyses.jpg)

    **Figure Caption:** Comparison of k-ω filtering and POD analysis. **(a)** k-ω power diagram of the synthetic spatio-temporal dataset with a targeted filtering region (dashed lines). **(b)** First six spatial modes from POD analysis (each 130×130 pixels<sup>2</sup>). **(c)** First six frames of the k-ω filtered datacube centred at 500 mHz (±30 mHz) and wavenumbers 0.05−0.25 pixel<sup>-1</sup>. **(d)** First six frames of the frequency-filtered POD reconstruction at 500 mHz using the first 22 POD modes (99% of total variance). All images and spatial modes are plotted with their own minimum and maximum values to highlight detailed structures within them.


    ??? source-code "Source code"
	    ``` python linenums="1"
	    --8<-- "examples/idl/Worked_examples__NRMP/FIG5__komega_POD_analyses.pro"
	    ```

