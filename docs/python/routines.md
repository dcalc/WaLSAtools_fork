---
template: main.html
title: Under the Hood
---

# Under the Hood

We strongly recommend everyone to follow the procedure as instructed [here](walsa_tools.md) when using **WaLSAtools** — a user-friendly tool — which gives you all information you need to do your analysis. 
However, for experts who want to make themselves familiar with the techniques and codes under the hood, inspect them and modify/develop/improve them, some of the main codes are also provided below. Please note that all codes and their dependencies are available in the [GitHub repository](https://github.com/WaLSAteam/WaLSAtools){target=_blank}.

## Analysis Modules

WaLSAtools is built upon a collection of analysis modules, each designed for a specific aspect of wave analysis. These modules are combined and accessed through the main `WaLSAtools` interface, providing a streamlined and user-friendly experience.

Here's a brief overview of the core analysis modules:

!!! walsa-code1 "PyEMD"

    This module provides an implementation of Empirical Mode Decomposition (EMD) for analyzing nonlinear and non-stationary signals.

    ??? source-code "PyEMD"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/PyEMD"
        ```

!!! walsa-code2 "WaLSA_cross_spectra.py"

    This module implements cross-correlation analysis techniques, including cross-spectrum, coherence, and phase relationships, for investigating correlations between two time series.

    ??? source-code "WaLSA_cross_spectra.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/WaLSA_cross_spectra.py"
        ```

!!! walsa-code1 "WaLSA_detrend_apod.py"

    This module provides functions for detrending and apodizing time series data to mitigate edge effects and trends.

    ??? source-code "WaLSA_detrend_apod.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/WaLSA_detrend_apod.py"
        ```

!!! walsa-code2 "WaLSA_interactive.py"

    This module implements the interactive interface of WaLSAtools, guiding users through the analysis process.

    ??? source-code "WaLSA_interactive.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/WaLSA_interactive.py"
        ```

!!! walsa-code1 "WaLSA_k_omega.py"

    This module provides functions for performing k-ω analysis and filtering in spatio-temporal datasets.

    ??? source-code "WaLSA_k_omega.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/WaLSA_k_omega.py"
        ```

!!! walsa-code2 "WaLSA_pod.py"

    This module implements Proper Orthogonal Decomposition (POD) for analyzing multi-dimensional data and extracting dominant spatial patterns.

    ??? source-code "WaLSA_pod.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/WaLSA_pod.py"
        ```

!!! walsa-code1 "WaLSA_speclizer.py"

    This module provides a collection of spectral analysis techniques, including FFT, Lomb-Scargle Periodogram, Wavelet Transform, and HHT.

    ??? source-code "WaLSA_speclizer.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/WaLSA_speclizer.py"
        ```

!!! walsa-code2 "parameter_definitions.py"

    This module defines the input parameters and their default values for the various analysis methods.

    ??? source-code "parameter_definitions.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/parameter_definitions.py"
        ```

!!! walsa-code1 "walsa_confidence.py"

    This module implements statistical significance testing for the spectral analysis results.

    ??? source-code "walsa_confidence.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/walsa_confidence.py"
        ```

!!! walsa-code2 "walsa_io.py"

    This module provides functions for input/output operations, such as loading and saving data.

    ??? source-code "walsa_io.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/walsa_io.py"
        ```

!!! walsa-code1 "walsa_plot_k_omega.py"

    This module provides functions for plotting k-ω diagrams and filtered datacubes.

    ??? source-code "walsa_plot_k_omega.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/walsa_plot_k_omega.py"
        ```

!!! walsa-code2 "walsa_plot_wavelet_spectrum.py"

    This module provides functions for plotting wavelet power spectra and related visualizations.

    ??? source-code "walsa_plot_wavelet_spectrum.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/walsa_plot_wavelet_spectrum.py"
        ```

!!! walsa-code1 "walsa_wavelet.py"

    This module implements the Wavelet Transform and related functionalities.

    ??? source-code "walsa_wavelet.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/walsa_wavelet.py"
        ```

!!! walsa-code2 "walsa_wavelet_confidence.py"

    This module implements statistical significance testing for the wavelet analysis results.

    ??? source-code "walsa_wavelet_confidence.py"
        ``` python
        --8<-- "codes/python/WaLSAtools/analysis_modules/walsa_wavelet_confidence.py"
        ```