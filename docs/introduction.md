---
template: overrides/main.html
title: Introduction
---

# Introduction

## Overview :material-telescope:

**WaLSAtools** is a collection of analysis routines (in both [IDL][1]{target=_blank} and [Python][9]{target=_blank} programming languages), collected and/or developed by the [**WaLSA team**][2]{target=_blank}, for studying waves and oscillations, with a particular emphasis on such phenomena occurring in the lower atmosphere of the Sun.

!!! walsa-code "To switch between IDL and Python documentations, click on name of the current programming language on top of the webpages on this site."

The main goal is to develop suitable techniques for various aspects of wave studies in the lower solar atmosphere (and beyond) &#8212; facilitating reliability and reproducibility of such analyses.

!!! walsa-contribute "[Contributions][3] are welcome &#8212; to improve both codes and methods."

## Analysis Methods :material-white-balance-sunny:

The various spectral analysis techniques, performed by **WaLSAtools**, are briefly introduced below. For detailed descriptions see **this review article**. 


The analysis tools are currently divided into two categories linked to: (a) wave characteristics of single time series, and (b) correlations between oscillations of two time series.
Analyses of single time series also fall into two sections, one related to those dealing with one-dimensional (1D) signals (*in time domain*), and one applied to three-dimensional (3D) cubes (*in both spatial and time domains*). All time series (from, e.g., solar observations) are treated against their finite length as well as their nonlinear and nonstationary nature prior to the analyses (i.e., they are detrended and apodized by default).

!!! walsa-waveform "One Dimensional (1D) Signal"
    The following analysis methods decompose a signal (i.e., 1D time series) into its frequency components, resulting in the so-called *frequency spectrum*. They employ slightly different approaches, thus making them suitable for specific situations. Therefore, choosing the right technique is an essential step before start applying it to your data.

    === "Fast Fourier Transform (FFT)"
        Fast Fourier Transform (FFT; *Cooley and Tukey 1965*) is an optimised approach for the implementation of the Fourier analysis (*Fourier 1824*; or strictly speaking, of the Discrete Fourier Transformation) by reducing the number of computations required.
        The algorithm estimates the frequency spectrum by decomposing the signal into a set of sinusoidal/cosinusoidal oscillations at distinct frequencies with their own amplitudes and phases.

        **FFT is often the prime choice of method for spectral analysis, unless the science case and/or data properties require the use of other techniques.**
    
    === "Lomb-Scargle"
        Lomb–Scargle transform is a statistical approach for detecting oscillation frequencies in irregularly sampled signals. 
        Note that all other analysis methods, such as FFT, require the time series to be regularly and evenly sampled.
        Lomb–Scargle calculates the frequency spectrum based on least-squares analysis techniques.
        
        **Lomb–Scargle should be the method of choice when the data points are unequally spaced in time** (e.g., when there are gaps or missing data points). 
        When duration of gaps are relatively short, one may decide to fill in them using interpolation and perform, e.g., FFT, instead. 
        However, the right choice of interpolation (e.g., linear, cubic, etc.) is always challenging and may lead to spurious results if not chosen correctly.
        
    === "Wavelet"
        Wavelet analysis (*Daubechies 1990; Torrence & Compo 1998*) localises the spectral power in both time and frequency domains simultaneously. 
        In principle, it reveals the frequency components just like FFT, but it also identifies when certain frequencies occur in temporal domain. 
        To this end, the time series is convolved with a wavelet (called *mother function*) whose variable width and amplitude result in capturing both low/high frequencies and long/short durations simultaneously. 
        Note that the choice of wavelet function is very important (i.e., various functions may result in different resolution in time and/or frequency). 
        The Morlet mother function is often found a good choice in analysing waves and oscillations in the solar atmosphere, as it satisfies a good balance between frequency and time localisations.
        Wavelet analysis also identifies areas in the time-frequency space that are subject to edge effect (that is introduced due to the convolution of the wavelet function close to the edges of the finite time series). 
        Such regions are marked with the so-called Cone of Influence (CoI) and mark unreliable areas of the 2D power spectrum.
        
        **Wavelet transform is particularly suitable for studying transient oscillations, weak signals, or quasi-periodic signatures.** 
        In addition to the 2D time-frequency spectrum, *traditionally*, a 1D spectrum (so-called *global wavelet*) can also be computed by averaging the power along the entire time domain, which, however, also includes the power subject to the edge effect.
        Thus, **WaLSAtools** also introduces an **improved** 1D wavelet spectrum (named ***sensible***) which is the time-integral of wavelet power *excluding those affected by the CoI and those below the confidence level* (i.e., power-weighted frequency distribution with significant power unaffected by CoI).
        
    === "Hilbert-Huang Transform (HHT)"
        Hilbert-Huang Transform (HHT; *Huang et al. 1996*) first decomposes the time series into the so-called Intrinsic Mode Functions (IMFs) through the application of the Empirical Mode Decomposition (EMD) technique. 
        Instantaneous frequencies of the decomposed signal are then computed by means of the Hilbert spectral analysis. Finally, the *marginal* power spectrum is computed by integrating over time.
        Therefore, HHT is more like an empirical approach rather than a theoretical tool like FFT.
        
        **HHT is by nature suitable for nonlinear and nonstationary signals.** Although such signals are treated, to some extent, by detrending and apodising steps, such corrections are never perfect, hence, make the HHT's application important. 
        ***However, the right choice of parameters for EMD (hence correct decomposition) requires great care (i.e., the default parameters may not necessarily work for all datasets).*** 
        The instantaneous frequencies can reveal dominant frequencies of the oscillations, but be aware that their uncertainties can be large at particular times.
        The marginal HHT spectrum may particularly be useful for low-amplitude fast frequency oscillations.

!!! walsa-info "Info"
    - **Power Spectral Density (PSD):** The analysis methods described here initially output wave amplitudes at different frequencies &#8212; the frequency spectrum. 
      **WaLSAtools** will then return Power Spectral Density (PSD; *Stull 1988*) which is the square of wave amplitude (i.e., power spectrum) normalised by frequency resolution. 
      This helps ensure that different signals can be compared independently of their frequency resolution (which is determined by length of the time series). 
      In addition, single-sided power is outputted (i.e., the *identical* power at negative frequencies are wrapped into positive frequencies), thus the PSD values are doubled.
      Throughout this documentation, the terms *power*, *power spectrum*, and *PSD* may be used interchangeably, but they convey the same meaning (i.e., PSD).
    - **Confidence levels:** To pinpoint significant power (i.e., to disentangle power produced by real signals from that by noise and spurious signals) **WaLSAtools** can perform a   statistical randomisation test (optional) to estimate significance/confidence levels.
      Note that, e.g., a 95% confidence level means that the power is significant to the 5% level.


!!! walsa-wavecube "Three Dimensional (3D) Cube"
    Distribution of oscillations power over a spatial extent is often crucial to identify wave modes. 
    One way is to average the temporal power over similar spatial scales, thus localisation of power at particular frequencies and spatial scales can be realised.
    Another approach is to average the power over pixels with similar underlying magnetic fields (within a field of view of interest) rather than similar spatial scales. 
    In addition, a science case may require the spatially-averaged power spectrum over a large field of view (irrespective of spatial scales and/or underlying magnetic fields), or the spatial distribution of dominant frequencies (i.e., frequencies corresponding to maximum power at each pixel).
    These are introduced in the following analysis tools.

    === "k-&#969; Analysis and Fourier Filtering"
        k-&#969; diagram represents the azimuthally averaged (FFT) power spectra of a 3D datacube (time series of 2D images) in the wavenumber-frequency space (i.e., in both spatial and temporal frequencies, respectively). 
        The relationship between the two domains can reveal dispersion relations of various waves / wave modes. 
        Furthermore, power in spatial or temporal domains, or a combination of both, can be filtered (either interactively, or by providing the ranges) within the k-&#969; analysis.
        The process can then be reversed (by utilising an inverse FFT) to reconstruct a new time series of images which contain only the wavenumbers and frequencies of interest.

        **Fourier filtering helps identify wave signatures with, e.g., relatively small amplitudes, against macroscopic flows and/or dominant MHD wave modes (with often considerably larger power).** 
        For further description on the Fourier filtering, check out the [step-by-step guide][6]{target=_blank} of the original (QUEEFF) code integrated in **WaLSAtools**.
        The code was first used in [this publication][7]{target=_blank}.
        For running the code through **WaLSAtools**, see the example **k-&#969; Diagram and Filtering**.
    
    === "B-&#969; Analysis"
        B-&#969; diagram is a novel approach which combines averaged (FFT) power spectra in various magnetic-field bins (within the field of view of observations) in one plot. 
        Thus, each vertical column in the diagram represents the average power spectrum at a certain magnetic-field strength (with a range defining the bin size) on the horizontal axis. 
        Therefore, this analysis method requires a magnetic-field map associated to the field of view of observations (for the 3D datacube). 
        Here, individual pixels are analysed separately (i.e., only in the temporal domain) but the power spectra with field strengths lying in each bin are averaged.
        
        **B-&#969; diagram prevents mixing wave signatures from structures with different magnetic-field strength, thus facilitates identification of MHD wave modes.**
        The analysis method was first introduced in [this publication][8]{target=_blank}.

    === "Mean Power"
        Spatially-averaged power spectrum is obtained by avrageing all power spectra determined at individual pixels over an entire field of view of interest. 
        Note that the average is performed in the frequency space not in the spatial domin (i.e., we first calculate power spectra at all individual pixels, then average the power spectra).
        The mean power can be determined for 1D power spectra calculated from any of the analysis methods described above (i.e., FFT, Lomb-Scargle, Wavelet, and HHT).

        **The mean power represents the average (most pronounced) behaviour of a region of interest**, irrespective of individual oscilaltions at particular pixels/regions within the same area.

    === "Dominant Frequency"
        It is often important to find the dominant frequency at a particular pixel, or at all pixels over a region of interest. 
        The latter can iluustrate the spatial distribution of dominant frequency of the region.
        However, this is worth noting that such dominant frequencies should be interpreted with great caution because multiple high-power peaks (with equal or comparable powers) may occur in a power spectrum.
        If there exist more than one peak with the exact same power, then the peak corresponding to the lowest frequency is returned.
        The dominant frequency can be determined for 1D power spectra calculated from any of the analysis methods described above (i.e., FFT, Lomb-Scargle, Wavelet, and HHT).

        **The dominant-frequeny map shows the statistical distribution of osillations frequency over the region of interest**, though it may be biased to some extent.

!!! walsa-wavecross "Cross Correlations between two datasets"
    Correlations between any two (aligned) time series (e.g., two different parameters, or one parameter at, e.g., two different heights/locations in the solar atmosphere) can be explored by calculating the so-called **cross-spectrum** (also known as co-spectrum or cross-power), **coherence** levels, and **phase relationships**. These parameters can be determined for all the different analysis methods described above (i.e., FFT, Lomb-Scargle, Wavelet, and HHT).

    === "Cross Spectrum"
        Cross spectrum identifies common oscillations power between two time series (i.e., high power in the same spectral frequency, or time-frequency, regions of the two power spectra).
        The cross spectrum is computed by multiplying power spectrum of a signal by the complex conjugate of the other, which hence, is a complex-valued function. 

        **The co-spectrum (i.e., absolute value of the complex cross spectrum) is a measure of the relationship between the two time series as a function of frequency.**
    
    === "Coherence"
        When both or one of the power spectra (of two time series) do not show strong peaks (e.g., indistinguishable from red noise), then the 'cross spectrum' may not be able to reveal any correllation, if should exist.
		If so, such (hidden) coherent modes at particular frequencies can be identified in the coherency spectrum.
		The coherence is the squared of the absolute value of the complex cross spectrum, normalised by the individual power spectra of the two time series. 
		Thus, the coherence level varieas between '0' and '1', where one shows a perfect coherency and zero means no coherency between the two oscillations.
		
		**The coherence spectrum identifis regions where the two time series co-move, but not necessarily pose high power.** 
		This approach is particularly important for finding correllations between waves observed at, e.g., various atmospheric heights, or different physical parameters.
		
	=== "Phase Difference"
		Phase difference is a measure of correlation between two time series.
		It provides information on phase and time lags between the two oscillations. The phase lag is the phase of the complex cross spectrum (i.e. calculated from the complex and real arguments of the cross spectrum).
		
		Two oscillations are well correlated if they have zero phase difference (i.e., in-phase relationship), otherwise, one fluctuation may lag behind (or lead) the other one by a certain amount of degrees (ranging -180 to 180 degrees; &plusmn;180 degress indicates anti-phase relationship).
		
		The phase lag can be simply converted into a time lag as 
		$$
		time_lag(i)=\frac{phase_lag(i)}{2 \pi f(i)}
		$$
        
	!!! walsa-info "Note"
	    The co-spectrum, coherence, and phase lag have one dimension for the 1D power spectra (i.e., for FFT, Lomb-Scargle, HHT, as well as Wavelet Global and Sensible power spectra), whereas they have two dimensions for the 2D Wavelet spectrum.

!!! walsa-hint "Info"
    Check out documentation on the **Analysis Tools** to learn how to run **WaLSAtools** and more about all inputs, keywords, and outputs.

## Under Development :material-text-box-plus:

Further analysis and visualising methods are being added to **WaLSAtools** over time. In particular, the following tools are currently under development:

- Collecting and developing the Python codes, and make the two languages equivalent.

- Improving the **Dominant Frequency** method for cases with multiple strong power peaks (also, by adding uncertainty approximation), in IDL.

- Adding other analysis methods, such as **Welch** and **ALIF**, in IDL.

- Implementing other techniques in to the **k-&#969;** and **B-&#969;** analyses (currently FFT is the only spectral analysis method in those tools), in IDL.

<br>

*[WaLSA]: Waves in the Lower Solar Atmosphere
*[IDL]: Interactive Data Language

  [1]: https://www.l3harrisgeospatial.com/Software-Technology/IDL
  [2]: https://WaLSA.team
  [3]: https://walsa.tools/contribution/
  [6]: https://walsa.tools/pdf/QUEEFF_manual.pdf
  [7]: https://iopscience.iop.org/article/10.3847/1538-4357/aa73d6/pdf
  [8]: https://arxiv.org/pdf/2103.11639.pdf
  [9]: https://www.python.org/about/
  
