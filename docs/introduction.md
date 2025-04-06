---
template: main.html
title: Introduction
---

# Introduction

## Overview :material-telescope:

**WaLSAtools** is an open-source library for analysing a wide variety of wave phenomena in time series data &ndash; including 1D signals, images, and multi-dimensional datasets. It provides tools to extract meaningful insights from complex datasets and is applicable across diverse fields, including astrophysics, engineering, life, physical and environmental sciences, and biomedical studies, among others. The library is continuously expanding with new features and functionalities, ensuring it remains a valuable resource for wave analysis.

The core of **WaLSAtools** is built upon [Python](https://www.python.org). This ensures accessibility and ease of use for a broad audience. We are actively developing versions in other popular languages to further enhance accessibility, enabling researchers from various backgrounds to leverage the power of **WaLSAtools** for their wave analysis needs. Currently, **WaLSAtools** is partially implemented in IDL, with plans to expand its functionality and extend to other programming languages in the future.

**WaLSAtools** provides a suite of both fundamental and advanced tools, but it remains the user's responsibility to choose the method that best fits the nature of their dataset and the scientific questions being addressed. Selecting the appropriate analysis method is essential for ensuring reliable and scientifically valid results. The use of unsuitable or overly simplified techniques &ndash; without consideration of the data's properties or the research goals &ndash; can lead to incomplete or incorrect conclusions, and potentially to misinterpretation. This principle is central to our accompanying [Primer](https://www.nature.com/articles/s43586-025-00392-0), which emphasises the importance of methodological awareness in wave analysis across all disciplines.

Developed by the [WaLSA Team](https://WaLSA.team), **WaLSAtools** was initially inspired by the intricate wave dynamics observed in the Sun's atmosphere. However, its applications extend far beyond solar physics, offering a versatile toolkit for anyone working with oscillatory signals.

**WaLSAtools** promotes reproducibility and transparency in wave analysis. Its robust implementations of validated techniques ensure consistent and trustworthy results, empowering researchers to delve deeper into the complexities of their data. Through its interactive interface, **WaLSAtools** guides users through the analysis process, providing the necessary information and tools to perform various types of wave analysis with ease.

This repository is associated with a primer article titled **Wave analysis tools** in **[Nature Reviews Methods Primers](https://www.nature.com/articles/s43586-025-00392-0)** (NRMP; Free access to [view-only Primer](https://WaLSA.tools/nrmp) and its [Supplementary Information](https://WaLSA.tools/nrmp-si)), showcasing its capabilities through detailed analyses of synthetic datasets. The `Analysis Tools/Examples/Worked examples - NRMP` contain reproducible codes for generating all figures presented in the NRMP article, serving as a practical guide for applying **WaLSAtools** to real-world analyses.

!!! walsa-code "To switch between Python and IDL documentation, click the current programming language name at the top of the page."

## Key Features :material-white-balance-sunny:

* **Wide Range of Wave Analysis Techniques:** From foundational methods like FFT and wavelet analysis to advanced techniques such as EMD, k-ω, and POD analysis.
* **Cross-Disciplinary Applicability:** Suitable for signal processing, oscillation studies, and multi-dimensional analysis in various fields.
* **Interactive Interfaces:** Simplified workflows through interactive menus for both Python and IDL.
* **Open Science Principles:** Promotes reproducibility and transparency in data analysis.

!!! walsa-contribute "[Contributions][3] are welcome to improve the codes, methods, or documentation."

## Analysis Methods 

**WaLSAtools** offers a variety of spectral analysis techniques, each tailored to specific types of data and research questions. These methods are broadly categorised into:

* **Single Time Series Analysis:** Includes methods for analysing individual time series, such as:
    * **1D Signals:** Fast Fourier Transform (FFT), Lomb-Scargle, Wavelet Transform, Welch, Hilbert-Huang Transform (HHT) and Empirical Mode Decomposition (EMD)
    * **3D Cubes:** k-ω Analysis, Dominant Frequency, Mean Power Spectrum, and Proper Orthogonal Decomposition (POD)
* **Cross-Correlation Analysis:** Includes methods for analysing correlations between two time series, resulting in cross-spectrum, coherence, and phase relationships.

All time series are pre-processed to mitigate unwanted effects, such as long-term trends and edge effects, prior to spectral analysis. This includes detrending and apodization.

### Detailed Descriptions of Analysis Methods

 The choice of the most appropriate wave analysis technique depends not only on the nature of the data but also on the specific research goals and the desired insights. **WaLSAtools** offers a variety of methods, each with its own strengths and limitations, allowing researchers to tailor their analysis to their specific needs. This section provides detailed descriptions of the individual methods available in **WaLSAtools**, empowering users to make informed decisions about the most suitable techniques for their research.

#### Single time series analysis: 1D signal

!!! walsa-waveform "One Dimensional (1D) Signal"
    **WaLSAtools** provides a variety of methods for analysing 1D signals (time series). Each method uses a different approach to decompose the signal into its constituent frequencies, making them suitable for various scenarios. Selecting the appropriate technique depends on the specific characteristics of the data and the research goals.

    === "FFT"
        The Fast Fourier Transform (FFT; *Cooley and Tukey 1965*) is an efficient algorithm that computes the discrete Fourier transform (DFT; *Fourier 1824*) of a sequence, or its inverse. Fourier analysis converts a signal from its original domain (often time or space) to a representation in the frequency domain and vice versa. The DFT is obtained by decomposing a sequence of values into components of different frequencies. 

        The FFT is widely used in many fields due to its computational efficiency. This makes it significantly faster than directly computing the DFT, especially for large datasets. The FFT algorithm estimates the frequency spectrum by decomposing the signal into a set of sinusoidal oscillations at distinct frequencies, each with its own amplitude and phase.

        **Advantages:**

        * Computationally efficient, especially for large datasets.
        * Provides a clear and easily interpretable frequency spectrum.
        * Well-suited for analysing stationary signals with evenly spaced samples.

        **Limitations:**
        
        * Assumes the signal is stationary (frequency content does not change over time).
        * Requires evenly spaced data points.
        * Can be sensitive to edge effects in finite signals.

        **FFT is often the prime choice of method for spectral analysis, unless the science case and/or data properties require the use of other techniques.**

    === "Lomb-Scargle"
        The Lomb–Scargle periodogram is a method of estimating a frequency spectrum, based on a least-squares fit of sinusoids to data samples, irrespective of whether the sampling is regularly or irregularly spaced in time. 

        **Advantages:**

        * Can handle irregularly sampled data without the need for interpolation.
        * Provides accurate frequency estimates even with missing data points.

        **Limitations:**

        * Can be computationally expensive for very large datasets.
        * May not be as efficient as FFT for evenly spaced data.

        **Lomb–Scargle should be the method of choice when the data points are unequally spaced in time** (e.g., when there are gaps or missing data points). 

        **Note:** While interpolation can sometimes be used to fill gaps in data and enable the use of other methods like FFT, selecting an appropriate interpolation method and mitigating potential artifacts can be challenging.

    === "Wavelet"
        A wavelet transform is a time-frequency representation of a signal. It allows a signal to be decomposed into its constituent wavelets, which are localised in both time and frequency. The Wavelet Transform is a powerful tool for analysing time series data that exhibit non-stationary behaviors, meaning their frequency content changes over time. Unlike the Fourier Transform, which provides a global frequency spectrum, the Wavelet Transform allows for localised analysis in both time and frequency, revealing how different frequencies contribute to the signal at different times.

        **Key Concepts:**

        * **Mother Wavelet:** The Wavelet Transform uses a function called a "mother wavelet" to analyse the signal. Different mother wavelets have different shapes and properties, making them suitable for different types of signals and analysis goals. The choice of mother wavelet is crucial for optimal results.
        * **Scales:** The Wavelet Transform analyses the signal at different scales, which correspond to different frequency ranges. This multi-resolution analysis allows for the detection of both short-lived, high-frequency features and long-lasting, low-frequency trends.
        * **Cone of Influence (COI):** The COI is a region in the time-frequency plane where edge effects can influence the results of the Wavelet Transform. It is important to be aware of the COI when interpreting the results.

        **WaLSAtools** provides a versatile implementation of the Wavelet Transform, allowing users to choose from various mother wavelets and customize the analysis parameters. In addition to the standard 2D time-frequency spectrum, it offers two types of 1D spectra:

        * **Global Wavelet Spectrum (GWS):**  Obtained by averaging the wavelet power over time.
        * **Refined Global Wavelet Spectrum (RGWS):**  A novel approach that excludes the COI and regions below a given confidence level from the time-integral of wavelet power, providing a more robust representation of the significant frequency components.

        **Advantages:**

        * Suitable for analysing non-stationary signals.
        * Provides both time and frequency localisation.
        * Offers a multi-resolution view of the signal.

        **Limitations:**

        * The choice of mother wavelet can influence the results.
        * Frequency resolution is limited, especially at higher frequencies.
        * Edge effects can influence the analysis near the boundaries of the time series.

        **Wavelet transform is particularly suitable for studying transient oscillations, weak signals, or quasi-periodic signatures.**

    === "EMD/HHT"

        Empirical Mode Decomposition (EMD) is a data-driven technique for analysing nonlinear and non-stationary signals. It decomposes a signal into a set of Intrinsic Mode Functions (IMFs), each representing a distinct oscillatory mode with its own time-varying amplitude and frequency.

        The Hilbert-Huang Transform (HHT) combines EMD with the Hilbert Transform to calculate the instantaneous frequency and amplitude of each IMF. This provides a detailed view of how the signal's frequency content evolves over time.

        **WaLSAtools Implementation:**

        WaLSAtools provides implementations of both EMD and HHT, allowing users to:

        *   Decompose signals into IMFs using EMD.
        *   Calculate instantaneous frequencies and amplitudes using HHT.
        *   Visualise the results with time-frequency plots and marginal spectra.

        **Advantages:**

        *   Suitable for analysing nonlinear and non-stationary signals.
        *   Adaptively extracts IMFs based on the signal's local characteristics.
        *   Provides time-varying frequency and amplitude information.

        **Limitations:**

        *   Can be sensitive to noise and parameter choices.
        *   Mode mixing can occur, where a single IMF contains components from different oscillatory modes.
        *   Requires careful selection of stopping criteria and spline fitting parameters.

        **Key Considerations:**

        *   **Ensemble EMD (EEMD):**  WaLSAtools also includes EEMD, an ensemble-based approach that reduces the impact of noise and improves mode separation.
        *   **Significance Testing:**  It is essential to assess the statistical significance of the extracted IMFs to distinguish genuine oscillations from noise-induced artifacts.
        *   **Parameter Selection:**  Carefully choose the EMD and HHT parameters based on the specific characteristics of the data and the research goals.

        **EMD and HHT are valuable tools for analysing complex signals that exhibit non-stationary and nonlinear behaviors, providing insights into the time-varying dynamics of oscillatory phenomena.**

    === "Welch"
        Welch's method is a technique for estimating the power spectral density (PSD) of a signal. It is particularly useful when dealing with noisy data or signals that have time-varying frequency content.

        **How it works:**

        1.  The signal is divided into overlapping segments.
        2.  Each segment is windowed (e.g., using a Hann or Hamming window) to reduce spectral leakage.
        3.  The periodogram (a basic estimate of the PSD) is computed for each segment.
        4.  The periodograms are averaged to obtain a smoother and more robust estimate of the PSD.

        **Advantages:**

        * Reduces noise in the PSD estimate.
        * Can handle signals with time-varying frequency content.
        * Provides a more robust estimate of the PSD compared to a single periodogram.

        **Limitations:**

        * Reduces frequency resolution due to the use of shorter segments.
        * The choice of window function and segment length can affect the results.

        **Welch's method is a valuable tool for analysing signals where noise reduction is a priority or when the frequency content of the signal changes over time.**

!!! walsa-info "Info"
    *  **Power Spectral Density (PSD):** The analysis methods compute wave amplitudes at different frequencies, resulting in a frequency spectrum. The Power Spectral Density (PSD) can further be calculated, which represents the power (amplitude squared) per unit frequency. This  normalisation allows for meaningful comparisons between different signals, regardless of their frequency resolution. Additionally, WaLSAtools outputs single-sided PSDs, where the power at negative frequencies is folded into the positive frequencies, divided by two since the folding effectively doubles the PSD values.
    *  **Confidence Levels:** WaLSAtools can estimate the statistical significance of the computed power using a randomisation test. This helps distinguish between genuine signals and those arising from noise or spurious effects. For example, a 95% confidence level indicates that the detected power is significant with a 5% probability of being due to random fluctuations.

#### Single time series analysis: 3D Datacube

!!! walsa-wavecube "Three Dimensional (3D) Datacube"
    Analysing the distribution of oscillation power over a spatial extent is often crucial to identify wave modes and understand their behaviour. **WaLSAtools** offers several methods for analysing 3D datacubes (time series of 2D images), each providing unique insights into the spatio-temporal characteristics of waves.

    === "k-&omega;"
        k-&omega; analysis is a powerful technique for investigating wave phenomena in spatio-temporal datasets. It involves calculating the power spectrum of the data in both spatial (wavenumber, k) and temporal (frequency, &omega;) domains. The resulting k-&omega; diagram reveals the relationship between spatial and temporal scales of oscillations, providing insights into wave dispersion relations and identifying different wave modes.

        **WaLSAtools** provides a comprehensive k-&omega; analysis tool that allows for:

        *   Generating k-&omega; diagrams from 3D datacubes.
        *   Filtering of the data in k-space and/or &omega;-space.
        *   Reconstructing filtered datacubes to isolate specific wave modes or features.

        **Fourier filtering** is a key component of k-&omega; analysis, enabling the isolation of wave signatures with specific wavenumber and frequency characteristics. This is particularly useful for identifying weak wave modes that might be masked by stronger signals or background trends.

        **Advantages:**

        *   Reveals wave dispersion relations.
        *   Enables isolation of specific wave modes through filtering.
        *   Provides insights into the spatio-temporal characteristics of waves.

        **Limitations:**

        *   Assumes the wave field is statistically homogeneous and stationary.
        *   Can be sensitive to edge effects and noise.

        For a detailed description of the Fourier filtering technique, refer to the [step-by-step guide](https://walsa.tools/pdf/QUEEFF_manual.pdf){target=_blank} of the original (QUEEFF) code integrated into **WaLSAtools**.

    === "Mean Power"
        The mean power spectrum provides a global view of the oscillatory behaviour within a region of interest. It is calculated by averaging the power spectra of individual pixels across the spatial domain.

        WaLSAtools allows for calculating the mean power spectrum using various 1D analysis methods (FFT, Lomb-Scargle, Wavelet, HHT, Welch, etc.).

        **Advantages:**

        *   Highlights the dominant (mean) oscillatory modes in a region.
        *   Provides a baseline for filtering out global contributions.
        *   Can be used to compare oscillatory behaviour across different regions or datasets.

        **Limitations:**

        *   May not capture localised or subtle variations in oscillatory behaviour.

    === "Dominant Frequency"
        The dominant frequency is the frequency with the highest power in a spectrum. **WaLSAtools** can calculate the dominant frequency for each pixel in a 3D datacube, generating a map that visualises the spatial distribution of dominant frequencies.

        **Advantages:**

        *   Provides a visual representation of the dominant oscillatory modes in a region.
        *   Can reveal spatial patterns and correlations with other physical properties.

        **Limitations:**

        *   Can be biased in signals with multiple strong spectral peaks.
        *   May not capture the full complexity of oscillatory behaviour.

    === "POD"
        Proper Orthogonal Decomposition (POD) is a powerful data-driven technique for analysing multi-dimensional data. It identifies dominant spatial patterns, or modes, that capture the most significant variations in the data. POD is particularly useful for reducing the dimensionality of complex datasets and extracting coherent structures.

        **WaLSAtools** provides a POD analysis tool that:

        *   Calculates the POD modes and their corresponding eigenvalues.
        *   Reconstructs the original data using a reduced number of modes.
        *   Visualises the spatial patterns and temporal evolution of the dominant modes.

        **Advantages:**

        *   Effectively reduces the dimensionality of complex datasets.
        *   Identifies coherent spatial patterns and their temporal behaviour.
        *   Can be used for feature extraction and pattern recognition.

        **Limitations:**

        *   Assumes the data is statistically stationary.
        *   May not capture highly localised or transient phenomena.


#### Cross-correlation Analysis

!!! walsa-wavecross "Cross-Correlation Analysis"

    Investigating the relationships between two time series is essential for understanding the interplay of different phenomena across various scientific disciplines. **WaLSAtools** provides a comprehensive suite of tools for cross-correlation analysis, enabling researchers to:

    *   Uncover shared frequencies and correlated power between two signals.
    *   Quantify the strength of the relationship between two time series at different frequencies.
    *   Determine the relative timing (phase or time lag) between oscillations.

    These tools are valuable for uncovering hidden connections, tracking wave propagation, and exploring the underlying drivers of oscillatory behaviour in diverse fields.

    === "Cross-Spectrum"
        The cross-spectrum, also known as the cross-power spectrum, is a complex-valued function that describes the correlation between two time series in the frequency domain. It is calculated by multiplying the frequency representation of one signal by the complex conjugate of the frequency representation of the other one.

        The magnitude of the cross-spectrum, often called the co-spectrum, represents the shared power between the two signals at each frequency. High values in the co-spectrum indicate strong correlations between the oscillations at those frequencies.

        **Applications:**

        *   Identifying common frequencies and shared power between two signals.
        *   Detecting potential connections or shared influences affecting the signals.

        **Limitations:**

        *   May not reveal correlations if the individual power spectra lack prominent peaks.
        *   Can be sensitive to noise and potential biases in the data.

    === "Coherence"
        Coherence is a normalised measure of the linear correlation between two time series at each frequency. It ranges from 0 (no correlation) to 1 (perfect correlation). High coherence values indicate that the oscillations in the two time series are strongly related at that frequency, even if their individual power spectra do not exhibit strong peaks.

        **Applications:**

        *   Uncovering hidden relationships between signals.
        *   Tracing wave propagation across different locations or systems.
        *   Investigating connections between oscillations in different physical parameters or measurements.

        **Limitations:**

        *   Only measures linear relationships between signals.
        *   Can be sensitive to noise and potential biases in the data.

    === "Phase Difference"
        Phase difference, or phase lag, measures the relative timing of oscillations in two time series. It is calculated from the phase angle of the complex cross-spectrum and indicates whether the oscillations are in phase, or if one signal leads or lags the other.

        **Applications:**

        *   Determining the direction and speed of wave propagation.
        *   Exploring potential cause-and-effect connections between phenomena.
        *   Investigating the degree of synchronization between oscillating systems.

        **Limitations:**

        *   Can be challenging to interpret in complex systems with multiple interacting oscillations.
        *   Sensitive to noise and potential biases in the data.

        
	!!! walsa-info "Note"
        The co-spectrum, coherence, and phase lag are one-dimensional for 1D power spectra (FFT, Lomb-Scargle, HHT, GWS, RGWS, Welch) and two-dimensional for the 2D Wavelet spectrum.

!!! walsa-hint "Info"
    Check out the documentation on the **Analysis Tools** to learn how to run **WaLSAtools** and more about all inputs, parameters, and outputs.


## Under Development

WaLSAtools is constantly evolving with new features and improvements. Here are some of the ongoing developments:

*   **Expanding Language Support:** Further development in IDL (for full consistency between the Python and IDL versions), with potential expansion to MATLAB and other programming languages.
*   **Enhancing Existing Methods:** Improving the Dominant Frequency method to handle cases with multiple strong power peaks and provide uncertainty estimations.
*   **Adding New Methods:** Implementing new analysis techniques, such as Adaptive Local Iterative Filtering (ALIF) and Synchrosqueezing Transform (SST).

We welcome contributions from the community to help us expand and improve **WaLSAtools**. If you are interested in contributing, please see the [Contribution Guidelines][3].

<br>

*[WaLSA]: Waves in the Lower Solar Atmosphere
*[IDL]: Interactive Data Language

  [1]: https://www.nv5geospatialsoftware.com/Products/IDL
  [2]: https://WaLSA.team
  [3]: https://walsa.tools/contribution/
  [6]: https://walsa.tools/pdf/QUEEFF_manual.pdf
  [7]: https://iopscience.iop.org/article/10.3847/1538-4357/aa73d6/pdf
  [8]: https://arxiv.org/pdf/2103.11639.pdf
  [9]: https://www.python.org/about/
  
