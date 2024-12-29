---
template: main.html
title: Introduction
---

# Introduction

## Overview :material-telescope:

**WaLSAtools** is an open-source library designed for analysing a wide variety of wave phenomena in time series data, including images and multi-dimensional datasets. It provides tools to extract meaningful insights from complex datasets and is applicable across diverse fields, including astrophysics, engineering, physical and environmental science, and biomedical studies, among others. The library is continuously expanding with new features and functionalities, ensuring it remains a valuable resource for the wave analysis research.

The core of **WaLSAtools** is built upon [Python][9]{target=_blank}, one of the most widely-used programming languages in science and engineering. This ensures accessibility and ease of use for a broad audience. We are actively developing versions in other popular languages to further enhance accessibility, enabling researchers from various backgrounds to leverage the power of **WaLSAtools** for their wave analysis needs. Currently, **WaLSAtools** is also available in [IDL][1]{target=_blank}, with plans to expand to other languages in the future.

Developed by the [WaLSA Team](https://WaLSA.team), **WaLSAtools** was initially inspired by the intricate wave dynamics observed in the Sun's atmosphere. However, its applications extend far beyond solar physics, offering a versatile toolkit for anyone working with oscillatory signals.

**WaLSAtools** promotes reproducibility and transparency in wave analysis. Its robust implementations of both fundamental and advanced techniques ensure consistent and trustworthy results, empowering researchers to delve deeper into the complexities of their data. Through its interactive interface (see `Analysis Tools`), **WaLSAtools** guides users through the analysis process, providing the necessary information and tools to perform various types of wave analysis with ease.

This repository is associated with a primer article titled **Wave analysis tools** in [**Nature Reviews Methods Primers**](https://www.nature.com/nrmp/) (NRMP; in press), showcasing its capabilities through detailed analyses of synthetic datasets. The `Analysis Tools/Examples/Worked examples - NRMP` contain reproducible codes for generating all figures presented in the NRMP article, serving as a practical guide for applying **WaLSAtools** to real-world analyses.

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

#### 1D Signal Analysis

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


!!! walsa-wavecube "Three Dimensional (3D) Cube"
    Distribution of oscillations power over a spatial extent is often crucial to identify wave modes. 
    One way is to average the temporal power over similar spatial scales, thus localisation of power at particular frequencies and spatial scales can be realised.
    Another approach is to average the power over pixels with similar underlying magnetic fields (within a field of view of interest) rather than similar spatial scales. 
    In addition, a science case may require the spatially-averaged power spectrum over a large field of view (irrespective of spatial scales and/or underlying magnetic fields), or the spatial distribution of dominant frequencies (i.e., frequencies corresponding to maximum power at each pixel).
    These are introduced in the following analysis tools.

    === "k-&omega; Analysis and Fourier Filtering"
        k-&omega; diagram represents the azimuthally averaged (FFT) power spectra of a 3D datacube (time series of 2D images) in the wavenumber-frequency space (i.e., in both spatial and temporal frequencies, respectively). 
        The relationship between the two domains can reveal dispersion relations of various waves / wave modes. 
        Furthermore, power in spatial or temporal domains, or a combination of both, can be filtered (either interactively, or by providing the ranges) within the k-&omega; analysis.
        The process can then be reversed (by utilising an inverse FFT) to reconstruct a new time series of images which contain only the wavenumbers and frequencies of interest.

        **Fourier filtering helps identify wave signatures with, e.g., relatively small amplitudes, against macroscopic flows and/or dominant MHD wave modes (with often considerably larger power).** 
        For further description on the Fourier filtering, check out the [step-by-step guide][6]{target=_blank} of the original (QUEEFF) code integrated into **WaLSAtools**.
        The code was first used in [this publication][7]{target=_blank}.
        For running the code through **WaLSAtools**, see the example **k-&omega; Diagram and Filtering**.
    
    === "B-&omega; Analysis"
        B-&omega; diagram is a novel approach which combines averaged (FFT) power spectra in various magnetic-field bins (within the field of view of observations) in one plot. 
        Thus, each vertical column in the diagram represents the average power spectrum at a certain magnetic-field strength (with a range defining the bin size) on the horizontal axis. 
        Therefore, this analysis method requires a magnetic-field map associated to the field of view of observations (for the 3D datacube). 
        Here, individual pixels are analysed separately (i.e., only in the temporal domain) but the power spectra with field strengths lying in each bin are averaged.
        
        **B-&omega; diagram prevents mixing wave signatures from structures with different magnetic-field strength, thus facilitates identification of MHD wave modes.**
        The analysis method was first introduced in [this publication][8]{target=_blank}.

    === "Mean Power"
        Spatially-averaged power spectrum is obtained by averaging all power spectra determined at individual pixels over an entire field of view of interest. 
        Note that the average is performed in the frequency space not in the spatial domain (i.e., we first calculate power spectra at all individual pixels, then average the power spectra).
        The mean power can be determined for 1D power spectra calculated from any of the analysis methods described above (i.e., FFT, Lomb-Scargle, Wavelet, and HHT).

        **The mean power represents the average (most pronounced) behaviour of a region of interest**, irrespective of individual oscillations at particular pixels/regions within the same area.

    === "Dominant Frequency"
        It is often important to find the dominant frequency at a particular pixel, or at all pixels over a region of interest. 
        The latter can illustrate the spatial distribution of dominant frequency of the region.
        However, this is worth noting that such dominant frequencies should be interpreted with great caution because multiple high-power peaks (with equal or comparable powers) may occur in a power spectrum.
        If there exist more than one peak with the exact same power, then the peak corresponding to the lowest frequency is returned.
        The dominant frequency can be determined for 1D power spectra calculated from any of the analysis methods described above (i.e., FFT, Lomb-Scargle, Wavelet, and HHT).

        **The dominant-frequency map shows the statistical distribution of oscillations frequency over the region of interest**, though it may be biased to some extent.

!!! walsa-wavecross "Cross Correlations between two datasets"
    Correlations between any two (aligned) time series (e.g., two different parameters, or one parameter at, e.g., two different heights/locations in the solar atmosphere) can be explored by calculating the so-called **cross-spectrum** (also known as co-spectrum or cross-power), **coherence** levels, and **phase relationships**. These parameters can be determined for all the different analysis methods described above (i.e., FFT, Lomb-Scargle, Wavelet, and HHT).

    === "Cross Spectrum"
        Cross spectrum identifies common oscillations power between two time series (i.e., high power in the same spectral frequency, or time-frequency, regions of the two power spectra).
        The cross spectrum is computed by multiplying power spectrum of a signal by the complex conjugate of the other, which hence, is a complex-valued function. 

        **The co-spectrum (i.e., absolute value of the complex cross spectrum) is a measure of the relationship between the two time series as a function of frequency.**
    
    === "Coherence"
        When both or one of the power spectra (of two time series) do not show strong peaks (e.g., indistinguishable from red noise), then the &lsquo;cross spectrum&rsquo; may not be able to reveal any correlation, if should exist.
		If so, such (hidden) coherent modes at particular frequencies can be identified in the coherency spectrum.
		The coherence is the squared of the absolute value of the complex cross spectrum, normalised by the individual power spectra of the two time series. 
		Thus, the coherence level varies between &lsquo;0&rsquo; and &lsquo;1&rsquo;, where one shows a perfect coherency and zero means no coherency between the two oscillations.
		
		**The coherence spectrum identifies regions where the two time series co-move, but not necessarily pose high power.** 
		This approach is particularly important for finding correlations between waves observed at, e.g., various atmospheric heights, or different physical parameters.
		
	=== "Phase Difference"
		Phase difference is a measure of correlation between two time series.
		It provides information on phase and time lags between the two oscillations. The phase lag is the phase of the complex cross spectrum (i.e. calculated from the complex and real arguments of the cross spectrum).
		
		Two oscillations are well correlated if they have zero phase difference (i.e., in-phase relationship), otherwise, one fluctuation may lag behind (or lead) the other one by a certain amount of degrees (ranging -180 to 180 degrees; &plusmn;180 degrees indicates anti-phase relationship).
		
		The phase lag (*&phi;*), in radians, can be simply converted into a time lag (*&tau;*), in seconds, at any particular frequency (*f*), in Hz, as $&tau; = \frac{&phi;}{2 \pi f}$
        
	!!! walsa-info "Note"
	    The co-spectrum, coherence, and phase lag have one dimension for the 1D power spectra (i.e., for FFT, Lomb-Scargle, HHT, GWS, RGWS, Welch), whereas they have two dimensions for the 2D Wavelet spectrum.

!!! walsa-hint "Info"
    Check out documentation on the **Analysis Tools** to learn how to run **WaLSAtools** and more about all inputs, keywords, and outputs.

## Under Development :material-text-box-plus:

Further analysis and visualising methods are being added to **WaLSAtools** over time. In particular, the following tools are currently under development:

- Collecting and developing the Python codes, and make the two languages equivalent.

- Improving the **Dominant Frequency** method for cases with multiple strong power peaks (also, by adding uncertainty approximation), in IDL.

- Adding other analysis methods, such as **Welch** and **ALIF**, in IDL.

- Implementing other techniques in to the **k-&omega;** and **B-&omega;** analyses (currently FFT is the only spectral analysis method in those tools), in IDL.

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
  
