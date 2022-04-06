---
template: main.html
---

# WaLSAtools

Below you can find information on how to use **WaLSAtools**. Please first read [description of the analysis methods][1] performed by **WaLSAtools**. Work examples of various analysis techniques are also provided (see the left menu), along with some hints on plotting the results.

We strongly encourage all users to perform their analyses by running **WaLSAtools** directly, instead of calling individual routines used within **WaLSAtools**. Please check out the [license and credits][7] as well as the [acknowledgements][8], and if you use **WaLSAtools** in your research, please [cite][9] it as instructed.

  [1]: introduction.md
  [7]: ../license.md
  [8]: ../acknowledgements.md
  [9]: ../citation.md

!!! walsa-gear "How to use WaLSAtools"

    **WaLSAtools** is a wrapper of several analysis methods. It is written in a self-explanatory fashion, so one can get calling sequence and information about all inputs, keywords, and outputs for a specific analysis by simply typing **WaLSAtools** in IDL (press ++enter++ after typing each command/choice):

    ```sh
    IDL> WaLSAtools
    ```

    Various chain of information printed in terminal, based on choices of the user, are shown below. The code follows a *dynamic select option* scenario, in which each step is according to the previous selection.

    ```
	% Compiled module: WALSATOOLS.

	    __          __          _          _____
	    \ \        / /         | |        / ____|     /\
	     \ \  /\  / /  ▄▄▄▄▄   | |       | (___      /  \
	      \ \/  \/ /   ▀▀▀▀██  | |        \___ \    / /\ \
	       \  /\  /   ▄██▀▀██  | |____    ____) |  / ____ \
	        \/  \/    ▀██▄▄██  |______|  |_____/  /_/    \_\


	  © WaLSA Team (www.WaLSA.team)
	 -----------------------------------------------------------------------------------
	  WaLSAtools v1.0
	  Documentation: www.WaLSA.tools
	  GitHub repository: www.github.com/WaLSAteam/WaLSAtools
	 -----------------------------------------------------------------------------------
	  Performing various wave analysis techniques on
	  (a) Single time series (1D signal or [x,y,t] cube)
	      Methods:
	      (1) 1D analysis with: FFT (Fast Fourier Transform), Wavelet,
	                            Lomb-Scargle, or HHT (Hilbert-Huang Transform)
	      (2) 3D analysis: k-ω (with optional Fourier filtering) or B-ω diagrams

	  (b) Two time series (cross correlations between two signals)
	      With: FFT (Fast Fourier Transform), Wavelet,
	            Lomb-Scargle, or HHT (Hilbert-Huang Transform)
	 ----------------------------------------------------------------------------
	 -- Category -- (enter the option a or b):
    ```
	=== "a"
		```
	    ------------------------------------------------
	    --- Single time-series analysis: (1) 1D, (2) 3D
	    ------------------------------------------------
	    -- Method (enter the option 1 or 2):
		```
	    === "1"
	        ```
		    ----------------------------------------------------------------------
		    --- 1D analysis with: (1) FFT, (2) Wavelet, (3) Lomb-Scargle, (4) HHT
		    ----------------------------------------------------------------------
		    --- Type of analysis (enter the option 1-4):
	        ```
	        === "1"
	            ```
			    ---------------------------
			    ---- 1D analysis with FFT:
			    ---------------------------
			    + CALLING SEQUENCE:
			      walsatools, /fft, signal=signal, time=time, power=p, frequencies=f, significance=signif

			    + INPUTS:
			      signal:          1D time series, or [x,y,t] datacube
			      time:            observing times in seconds (1D array)

			    + OPTIONAL KEYWORDS:
			      padding:         oversampling factor: zero padding (default: 1)
			      apod:            extent of apodization edges (of a Tukey window); default 0.1
			      nodetrendapod:   if set, neither detrending nor apodization is performed!
			      pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2
			      polyfit:         the degree of polynomial fit to the data to detrend it
			                       if set, instead of linear fit this polynomial fit is performed
			      meantemporal:    if set, only a very simple temporal detrending is performed by
			                       subtracting the mean signal from the signal
			                       i.e., the fitting procedure (linear or higher polynomial degrees) is omitted
			      meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)
			      recon:           optional keyword that will Fourier reconstruct the input timeseries
			                       note: this does not preserve the amplitudes and is only useful when attempting
			                       to examine frequencies that are far away from the -untrustworthy- low frequencies
			      siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)
			      nperm:           number of random permutations for the significance test (default: 1000)
			      nosignificance:  if set, no significance level is calculated
			      mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
			      nodominantfreq:  if set, dominant frequency and dominant power are not calculated
			                       (to, e.g., save computational time for large datasets)

			    + OUTPUTS:
			      power:           1D (or 3D; same dimension as input data) array of power
			                       2D (or 4D) array for wavelet spectrum
			                       (in DN^2/mHz, i.e., normalised to frequency resolution)
			      frequencies:     1D array of frequencies (in mHz)
			      significance:    significance array (same size and units as power)
			      dominantfreq:    dominant frequency, i.e., frequency corresponding to the maximum power (in mHz)
			                       same spatial size as input data (i.e., 1D or 2D)
			                       if there are multiple peaks with the same power, the lowest dominant frequency is returned!
			      dominantpower:   power (in DN^2/mHz) corresponding to the dominant frequency
			                       same spatial size as input data (i.e., 1D or 2D)
			      rangefreq:       frequency range over which the dominant frequency is computed. default: full frequency range
			      averagedpower:   spatially averaged power spectrum (of multiple 1D power spectra)
			      amplitude:       1D array of oscillation amplitude (or a 3D array if the input is a 3D cube)
			    -----------------------------------------------------------------------------------------
			    * CITATION:
			      Please cite the following article if you use WaLSAtools: 1D analysis with FFT
			      -- Jess et al. 2021, LRSP, in preparation
			         (see www.WaLSA.tools/citation)
			    -----------------------------------------------------------------------------------------
	            ```
	        === "2"
	            ```
			    -------------------------------
			    ---- 1D analysis with Wavelet:
			    -------------------------------
			    + CALLING SEQUENCE:
			      walsatools, /wavelet, signal=signal, time=time, power=p, frequencies=f, significance=signif

			    + INPUTS:
			      signal:          1D time series, or [x,y,t] datacube
			      time:            observing times in seconds (1D array)

			    + OPTIONAL KEYWORDS:
			      padding:         oversampling factor: zero padding (default: 1)
			      apod:            extent of apodization edges (of a Tukey window); default 0.1
			      nodetrendapod:   if set, neither detrending nor apodization is performed!
			      pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2
			      polyfit:         the degree of polynomial fit to the data to detrend it
			                       if set, instead of linear fit this polynomial fit is performed
			      meantemporal:    if set, only a very simple temporal detrending is performed by
			                       subtracting the mean signal from the signal
			                       i.e., the fitting procedure (linear or higher polynomial degrees) is omitted
			      meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)
			      recon:           optional keyword that will Fourier reconstruct the input timeseries
			                       note: this does not preserve the amplitudes and is only useful when attempting
			                       to examine frequencies that are far away from the -untrustworthy- low frequencies
			      siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)
			      nperm:           number of random permutations for the significance test (default: 1000)
			      nosignificance:  if set, no significance level is calculated
			      mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
			      mother:          wavelet function (also depends on param). default: Morlet
			                       other available functions: Paul and DOG are available
			      param:           optional mother wavelet parameter
			                       (default: 6 (for Morlet), 4 (for Paul), 2 (for DOG; i.e., Mexican-hat)
			      dj:              spacing between discrete scales. default: 0.025
			      global:          returns global wavelet spectrum (integrated over frequency domain)
			      oglobal:         global wavelet spectrum excluding regions influenced by CoI
			      cglobal:         global wavelet spectrum excluding regions influenced by (1) CoI and (2) insignificant power
			      colornoise:      if set, noise background is based on Auchère+2017, ApJ, 838, 166
			      nodominantfreq:  if set, dominant frequency and dominant power are not calculated
			                       (to, e.g., save computational time for large datasets)

			    + OUTPUTS:
			      power:           1D (or 3D; same dimension as input data) array of power
			                       2D (or 4D) array for wavelet spectrum
			                       (in DN^2/mHz, i.e., normalised to frequency resolution)
			      frequencies:     1D array of frequencies (in mHz)
			      significance:    significance array (same size and units as power)
			      coi:             cone-of-influence cube (when global, oglobal, or cglobal are not set)
			      dominantfreq:    dominant frequency, i.e., frequency corresponding to the maximum power (in mHz)
			                       same spatial size as input data (i.e., 1D or 2D)
			                       if there are multiple peaks with the same power, the lowest dominant frequency is returned!
			      dominantpower:   power (in DN^2/mHz) corresponding to the dominant frequency
			                       same spatial size as input data (i.e., 1D or 2D)
			      rangefreq:       frequency range over which the dominant frequency is computed. default: full frequency range
			      averagedpower:   spatially averaged power spectrum (of multiple 1D power spectra)
			      amplitude:       1D array of oscillation amplitude (or a 3D array if the input is a 3D cube)
			                       note: only for global (traditional, oglobal, or cglobal) wavelet
			    -----------------------------------------------------------------------------------------
			    * CITATION:
			      Please cite the following article if you use WaLSAtools: 1D analysis with Wavelet
			      -- Jess et al. 2021, LRSP, in preparation
			         (see www.WaLSA.tools/citation)
			    -----------------------------------------------------------------------------------------
	            ```
	        === "3"
	            ```
			    ------------------------------------
			    ---- 1D analysis with Lomb-Scargle:
			    ------------------------------------
			    + CALLING SEQUENCE:
			      walsatools, /lomb, signal=signal, time=time, power=p, frequencies=f, significance=signif

			    + INPUTS:
			      signal:          1D time series, or [x,y,t] datacube
			      time:            observing times in seconds (1D array)

			    + OPTIONAL KEYWORDS:
			      padding:         oversampling factor: zero padding (default: 1)
			      apod:            extent of apodization edges (of a Tukey window); default 0.1
			      nodetrendapod:   if set, neither detrending nor apodization is performed!
			      pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2
			      polyfit:         the degree of polynomial fit to the data to detrend it
			                       if set, instead of linear fit this polynomial fit is performed
			      meantemporal:    if set, only a very simple temporal detrending is performed by
			                       subtracting the mean signal from the signal
			                       i.e., the fitting procedure (linear or higher polynomial degrees) is omitted
			      meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)
			      recon:           optional keyword that will Fourier reconstruct the input timeseries
			                       note: this does not preserve the amplitudes and is only useful when attempting
			                       to examine frequencies that are far away from the -untrustworthy- low frequencies
			      siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)
			      nperm:           number of random permutations for the significance test (default: 1000)
			      nosignificance:  if set, no significance level is calculated
			      mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
			      nodominantfreq:  if set, dominant frequency and dominant power are not calculated
			                       (to, e.g., save computational time for large datasets)

			    + OUTPUTS:
			      power:           1D (or 3D; same dimension as input data) array of power
			                       2D (or 4D) array for wavelet spectrum
			                       (in DN^2/mHz, i.e., normalised to frequency resolution)
			      frequencies:     1D array of frequencies (in mHz)
			      significance:    significance array (same size and units as power)
			      dominantfreq:    dominant frequency, i.e., frequency corresponding to the maximum power (in mHz)
			                       same spatial size as input data (i.e., 1D or 2D)
			                       if there are multiple peaks with the same power, the lowest dominant frequency is returned!
			      dominantpower:   power (in DN^2/mHz) corresponding to the dominant frequency
			                       same spatial size as input data (i.e., 1D or 2D)
			      rangefreq:       frequency range over which the dominant frequency is computed. default: full frequency range
			      averagedpower:   spatially averaged power spectrum (of multiple 1D power spectra)
			      amplitude:       1D array of oscillation amplitude (or a 3D array if the input is a 3D cube)
			    -----------------------------------------------------------------------------------------
			    * CITATION:
			      Please cite the following article if you use WaLSAtools: 1D analysis with Lomb-Scargle
			      -- Jess et al. 2021, LRSP, in preparation
			         (see www.WaLSA.tools/citation)
			    -----------------------------------------------------------------------------------------
	            ```
	        === "4"
	            ```
			    ---------------------------
			    ---- 1D analysis with HHT:
			    ---------------------------
			    + CALLING SEQUENCE:
			      walsatools, /hht, signal=signal, time=time, power=p, frequencies=f, significance=signif

			    + INPUTS:
			      signal:          1D time series, or [x,y,t] datacube
			      time:            observing times in seconds (1D array)

			    + OPTIONAL KEYWORDS:
			      padding:         oversampling factor: zero padding (default: 1)
			      apod:            extent of apodization edges (of a Tukey window); default 0.1
			      nodetrendapod:   if set, neither detrending nor apodization is performed!
			      pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2
			      polyfit:         the degree of polynomial fit to the data to detrend it
			                       if set, instead of linear fit this polynomial fit is performed
			      meantemporal:    if set, only a very simple temporal detrending is performed by
			                       subtracting the mean signal from the signal
			                       i.e., the fitting procedure (linear or higher polynomial degrees) is omitted
			      meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)
			      recon:           optional keyword that will Fourier reconstruct the input timeseries
			                       note: this does not preserve the amplitudes and is only useful when attempting
			                       to examine frequencies that are far away from the -untrustworthy- low frequencies
			      siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)
			      nperm:           number of random permutations for the significance test (default: 1000)
			      nosignificance:  if set, no significance level is calculated
			      mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
			      stdlimit:        standard deviation to be achieved before accepting an IMF (default: 0.2)
			      nfilter:         Hanning window width for two dimensional spectrum smoothing (default: 3)
			                       (an odd integer equal to or larger than 3; 0: to avoid the windowing)
			      emd:             if set, intrinsic mode functions (IMFs) and their associated frequencies
			                       (i.e., instantaneous frequencies) can be outputted
			      nodominantfreq:  if set, dominant frequency and dominant power are not calculated
			                       (to, e.g., save computational time for large datasets)

			    + OUTPUTS:
			      power:           1D (or 3D; same dimension as input data) array of power
			                       2D (or 4D) array for wavelet spectrum
			                       (in DN^2/mHz, i.e., normalised to frequency resolution)
			      frequencies:     1D array of frequencies (in mHz)
			      significance:    significance array (same size and units as power)
			      imf:             intrinsic mode functions (IMFs) from EMD analysis, if emd is set
			      instantfreq:     instantaneous frequencies of each component time series, if emd is set
			      dominantfreq:    dominant frequency, i.e., frequency corresponding to the maximum power (in mHz)
			                       same spatial size as input data (i.e., 1D or 2D)
			                       if there are multiple peaks with the same power, the lowest dominant frequency is returned!
			      dominantpower:   power (in DN^2/mHz) corresponding to the dominant frequency
			                       same spatial size as input data (i.e., 1D or 2D)
			      rangefreq:       frequency range over which the dominant frequency is computed. default: full frequency range
			      averagedpower:   spatially averaged power spectrum (of multiple 1D power spectra)
			      amplitude:       1D array of oscillation amplitude (or a 3D array if the input is a 3D cube)
			    -----------------------------------------------------------------------------------------
			    * CITATION:
			      Please cite the following article if you use WaLSAtools: 1D analysis with HHT
			      -- Jess et al. 2021, LRSP, in preparation
			         (see www.WaLSA.tools/citation)
			    -----------------------------------------------------------------------------------------
	            ```
	    === "2"
	        ```
		    -----------------------------------
		    --- 3D analysis: (1) k-ω, (2) B-ω
		    -----------------------------------
		    --- Type of analysis (enter the option 1 or 2):
	        ```
	        === "1"
	            ```
			    -----------------------
			    ---- 3D analysis: k-ω
			    -----------------------
			    + CALLING SEQUENCE:
			      walsatools, /komega, signal=signal, time=time, arcsecpx=arcsecpx, power=p, frequencies=f, wavenumber=k

			    + INPUTS:
			      signal:          [x,y,t] datacube
			                       [!] note: at present the input datacube needs to have identical x and y dimensions.
			                       if not supplied like this the datacube will be cropped accordingly.
			      cadence:         delta time between successive frames (in seconds)
			      time:            observing times in seconds (1D array). It is ignored if cadence is provided
			      arcsecpx:        pixel size (spatial sampling) in arcsec; a float number

			    + OPTIONAL KEYWORDS:
			      filtering:       if set, filtering is proceeded
			      f1:              lower frequency to filter - given in mHz
			      f2:              upper frequency to filter - given in mHz
			      k1:              lower wavenumber to filter - given in mHz
			      k2:              upper wavenumber to filter - given in arcsec^-1
			      spatial_torus:   if equal to zero, the annulus used for spatial filtering will not have a Gaussian-shaped profile
			      temporal_torus:  if equal to zero, the temporal filter will not have a Gaussian-shaped profile
			      no_spatial:      if set, no spatial filtering is performed
			      no_temporal:     if set, no temporal filtering is performed
			      silent:          if set, the k-ω diagram is not plotted
			      clt:             colour table number (IDL ctload)
			      koclt:           custom colour tables for k-ω diagram (currently available: 1 and 2)
			      threemin:        if set, a horizontal line marks the three-minute periodicity
			      fivemin:         if set, a horizontal line marks the five-minute periodicity
			      xlog:            if set, x-axis (wavenumber) is plotted in logarithmic scale
			      ylog:            if set, y-axis (frequency) is plotted in logarithmic scale
			      xrange:          x-axis (wavenumber) range
			      yrange:          y-axis (frequency) range
			      nox2:            if set, 2nd x-axis (spatial size, in arcsec) is not plotted
			                       (spatial size (i.e., wavelength) = (2*!pi)/wavenumber)
			      noy2:            if set, 2nd y-axis (period, in sec) is not plotted
			                       (p = 1000/frequency)
			      smooth:          if set, power is smoothed
			      mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
			      epsfilename:     if provided (as a string), an eps file of the k-ω diagram is made

			    + OUTPUTS:
			      power:           2D array of power in log10 scale
			                       (in DN^2/mHz, i.e., normalised to frequency resolution)
			      frequencies:     1D array of frequencies (in mHz)
			      wavenumber:      1D array of wavenumber (in arcsec^-1)
			      filtered_cube:   3D array of filtered datacube (if filtering is set)
			    -----------------------------------------------------------------------------------------
			    * CITATION:
			      Please cite the following articles if you use WaLSAtools: k-ω analysis
			      -- Jess et al. 2021, LRSP, in preparation
			      -- Jess et al. 2017, ApJ, 842, 59
			         (see www.WaLSA.tools/citation)
			    -----------------------------------------------------------------------------------------
	            ```
	        === "2"
	            ```
			    -----------------------
			    ---- 3D analysis: B-ω
			    -----------------------
			    + CALLING SEQUENCE:
			      walsatools, /bomega, signal=signal, time=time, bmap=bmap, power=p, frequencies=f, barray=b

			    + INPUTS:
			      signal:          [x,y,t] datacube
			      time:            observing times in seconds (1D array)
			      bmap:            a map of magnetic fields (in G), same [x,y] size as in datacube

			    + OPTIONAL KEYWORDS:
			      binsize:         size of magnetic-field bins, over which power spectra are averaged
			                       (default: 50 G)
			      silent:          if set, the B-ω diagram is not plotted
			      clt:             colour table number (IDL ctload)
			      koclt:           custom colour tables for k-ω diagram (currently available: 1 and 2)
			      threemin:        if set, a horizontal line marks the three-minute periodicity
			      fivemin:         if set, a horizontal line marks the five-minute periodicity
			      xlog:            if set, x-axis (wavenumber) is plotted in logarithmic scale
			      ylog:            if set, y-axis (frequency) is plotted in logarithmic scale
			      xrange:          x-axis (wavenumber) range
			      yrange:          y-axis (frequency) range
			      noy2:            if set, 2nd y-axis (period, in sec) is not plotted
			                       (p = 1000/frequency)
			      smooth:          if set, power is smoothed
			      normalizedbins   if set, power at each bin is normalised to its maximum value
			                       (this facilitates visibility of relatively small power)
			      xtickinterval    x-asis (i.e., magnetic fields) tick intervals in G (default: 400 G)
			      mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
			      epsfilename:     if provided (as a string), an eps file of the k-ω diagram is made

			    + OUTPUTS:
			      power:           2D array of power
			                       (in DN^2/mHz, i.e., normalised to frequency resolution)
			      frequencies:     1D array of frequencies (y-axis) in mHz
			      barray:          1D array of magnetic fields (x-axis) in G
			    -----------------------------------------------------------------------------------------
			    * CITATION:
			      Please cite the following articles if you use WaLSAtools: B-ω analysis
			      -- Jess et al. 2021, LRSP, in preparation
			      -- Stangalini et al. 2021, A&A, in press
			         (see www.WaLSA.tools/citation)
			    -----------------------------------------------------------------------------------------
	            ```
	=== "b"
		```
	    -----------------------------------------------------------------------------------
	    --- Two time-series analysis with: (1) FFT, (2) Wavelet, (3) Lomb-Scargle, (4) HHT
	    -----------------------------------------------------------------------------------
	    --- Type of analysis (enter the option 1-4):
		```
	    === "1"
	        ```
		    ------------------------------------
		    ---- cross-power analysis with FFT:
		    ------------------------------------
		    + CALLING SEQUENCE:
		      walsatools, /fft, data1=data1, data2=data2, time=time, $
		                  cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f, significance=signif

		    + INPUTS:
		      data1:           first (1D) time series
		      data2:           second (1D) time series, co-aligned with data1
		      time:            observing times in seconds (1D array)

		    + OPTIONAL KEYWORDS:
		      padding:         oversampling factor: zero padding (default: 1)
		      apod:            extent of apodization edges (of a Tukey window); default 0.1
		      nodetrendapod:   if set, neither detrending nor apodization is performed!
		      pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2
		      polyfit:         the degree of polynomial fit to the data to detrend it
		                       if set, instead of linear fit this polynomial fit is performed
		      meantemporal:    if set, only a very simple temporal detrending is performed by
		                       subtracting the mean signal from the signal
		                       i.e., the fitting procedure (linear or higher polynomial degrees) is omitted
		      meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)
		      recon:           optional keyword that will Fourier reconstruct the input timeseries
		                       note: this does not preserve the amplitudes and is only useful when attempting
		                       to examine frequencies that are far away from the -untrustworthy- low frequencies
		      n_segments:      number of euqal segments (to which both datasets are broken prior to the analyses; default: 1)
		                       Each of these segments is considered an independent realisation of the underlying process.
		                       The cross spectrum for each segement are averaged together to provide phase and coherence
		                       estimates at each frequency.
		      siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)
		      nperm:           number of random permutations for the significance test (default: 50)
		                       note: the default value is set for quick tests. Choose a large number
		                       (e.g., 2000 or larger) for a better statistical result
		      nosignificance:  if set, no significance level is calculated

		    + OUTPUTS:
		      cospectrum:      absolute values of the cross power (1D array)
		      coherence:       coherence (1D array)
		      phase_angle:     phase angles in degrees (1D array)
		      frequency:       1D array of frequencies (in mHz)
		      signif_cross:    significance levels for the cospectrum (1D array)
		      signif_coh:      significance levels for the coherence (1D array)
		    -----------------------------------------------------------------------------------------
		    * CITATION:
		      Please cite the following article if you use WaLSAtools: cross-correlation analysis with FFT
		      -- Jess et al. 2021, LRSP, in preparation
		         (see www.WaLSA.tools/citation)
		    -----------------------------------------------------------------------------------------
	        ```
	    === "2"
	        ```
		    ----------------------------------------
		    ---- cross-power analysis with Wavelet:
		    ----------------------------------------
		    + CALLING SEQUENCE:
		      walsatools, /wavelet, data1=data1, data2=data2, time=time, $
		                  cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f, significance=signif

		    + INPUTS:
		      data1:           first (1D) time series
		      data2:           second (1D) time series, co-aligned with data1
		      time:            observing times in seconds (1D array)

		    + OPTIONAL KEYWORDS:
		      padding:         oversampling factor: zero padding (default: 1)
		      apod:            extent of apodization edges (of a Tukey window); default 0.1
		      nodetrendapod:   if set, neither detrending nor apodization is performed!
		      pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2
		      polyfit:         the degree of polynomial fit to the data to detrend it
		                       if set, instead of linear fit this polynomial fit is performed
		      meantemporal:    if set, only a very simple temporal detrending is performed by
		                       subtracting the mean signal from the signal
		                       i.e., the fitting procedure (linear or higher polynomial degrees) is omitted
		      meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)
		      siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)
		      nperm:           number of random permutations for the significance test (default: 50)
		                       note: the default value is set for quick tests. Choose a large number
		                       (e.g., 2000 or larger) for a better statistical result
		      nosignificance:  if set, no significance level is calculated
		      mother:          wavelet function (also depends on param). default: Morlet
		                       other available functions: Paul and DOG are available
		      param:           optional mother wavelet parameter
		                       (default: 6 (for Morlet), 4 (for Paul), 2 (for DOG; i.e., Mexican-hat)
		      dj:              spacing between discrete scales. default: 0.025
		      colornoise:      if set, noise background is based on Auchère+2017, ApJ, 838, 166
		      plot:            if set, wavelet power spectra of the two time series as well as
		                       their wavelet cospectrum (cross-spectrum) and coherence, along with the
		                       significance levels as contours, are plotted
		                       The phase angles between the two time series are also depicted by default
		                       Arrows pointing right mark zero phase (meaning in-phase oscillations),
		                       arrows pointing straight up indicate data2 lags behind data1 by 90 degrees
		      noarrow:         if set, the phase angles are not overplotted as arrows
		      arrowdensity:    number of arrows (illustrating phase angles) in x and y directions (default: [30,18])
		      arrowsize:       size of the arrows (default: 1)
		      arrowheadsize:   size of the arrows head (default: 1)
		      pownormal:       if set, the power is normalised to its maximum value
		      log:             if set, the power spectra and the cospectrum are plotted in log10 scale
		      removespace:     if set, the time-period areas affected by the CoI over the entire time range are not plotted
		      clt:             colour table number (idl ctload)
		      koclt:           custom colour tables (currently available: 1 and 2)

		    + OUTPUTS:
		      cospectrum:      absolute values of the cross power
		                       (2D array for wavelet spectrum; 1D for global, oglobal, or cglobal spectrum)
		      coherence:       wavelet coherence (same size as cospectrum)
		      phase_angle:     phase angles in degrees (same size as cospectrum)
		      frequency:       1D array of frequencies (in mHz)
		      signif_cross:    significance map for the cospectrum (same size as cospectrum)
		      scale:           the scale vector of scale indices, given by the overlap of scale1 and scale2
		                       cospectrum/signif_coh indicates regions above the siglevel
		      signif_coh:      significance map for the coherence (same size as cospectrum)
		                       coherence/signif_coh indicates regions above the siglevel
		      coi:             the vector of the cone-of-influence
		      coh_global:      global coherence averaged over all times
		      phase_global:    global phase averaged over all times
		      cross_global:    global cross wavelet averaged over all times
		      coh_oglobal:     global coherence averaged over all times excluding areas affected by CoI
		      phase_oglobal:   global phase averaged over all times excluding areas affected by CoI
		      cross_oglobal:   global cross wavelet averaged over all times excluding areas affected by CoI
		    -----------------------------------------------------------------------------------------
		    * CITATION:
		      Please cite the following article if you use WaLSAtools: cross-correlation analysis with Wavelet
		      -- Jess et al. 2021, LRSP, in preparation
		         (see www.WaLSA.tools/citation)
		    -----------------------------------------------------------------------------------------
			```
	    === "3"
	        ```
		    ---------------------------------------------
		    ---- cross-power analysis with Lomb-Scargle:
		    ---------------------------------------------
		    + CALLING SEQUENCE:
		      walsatools, /lomb, data1=data1, data2=data2, time=time, $
		                  cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f, significance=signif

		    + INPUTS:
		      data1:           first (1D) time series
		      data2:           second (1D) time series, co-aligned with data1
		      time:            observing times in seconds (1D array)

		    + OPTIONAL KEYWORDS:
		      padding:         oversampling factor: zero padding (default: 1)
		      apod:            extent of apodization edges (of a Tukey window); default 0.1
		      nodetrendapod:   if set, neither detrending nor apodization is performed!
		      pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2
		      polyfit:         the degree of polynomial fit to the data to detrend it
		                       if set, instead of linear fit this polynomial fit is performed
		      meantemporal:    if set, only a very simple temporal detrending is performed by
		                       subtracting the mean signal from the signal
		                       i.e., the fitting procedure (linear or higher polynomial degrees) is omitted
		      meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)
		      recon:           optional keyword that will Fourier reconstruct the input timeseries
		                       note: this does not preserve the amplitudes and is only useful when attempting
		                       to examine frequencies that are far away from the -untrustworthy- low frequencies
		      n_segments:      number of euqal segments (to which both datasets are broken prior to the analyses; default: 1)
		                       Each of these segments is considered an independent realisation of the underlying process.
		                       The cross spectrum for each segement are averaged together to provide phase and coherence
		                       estimates at each frequency.
		      siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)
		      nperm:           number of random permutations for the significance test (default: 50)
		                       note: the default value is set for quick tests. Choose a large number
		                       (e.g., 2000 or larger) for a better statistical result
		      nosignificance:  if set, no significance level is calculated

		    + OUTPUTS:
		      cospectrum:      absolute values of the cross power (1D array)
		      coherence:       coherence (1D array)
		      phase_angle:     phase angles in degrees (1D array)
		      frequency:       1D array of frequencies (in mHz)
		      signif_cross:    significance levels for the cospectrum (1D array)
		      signif_coh:      significance levels for the coherence (1D array)
		    -----------------------------------------------------------------------------------------
		    * CITATION:
		      Please cite the following article if you use WaLSAtools: cross-correlation analysis with Lomb-Scargle
		      -- Jess et al. 2021, LRSP, in preparation
		         (see www.WaLSA.tools/citation)
		    -----------------------------------------------------------------------------------------
			```
	    === "4"
	        ```
		    -------------------------------------
		    ---- cross-powerD analysis with HHT:
		    -------------------------------------
		    + CALLING SEQUENCE:
		      walsatools, /hht, data1=data1, data2=data2, time=time, $
		                  cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f, significance=signif

		    + INPUTS:
		      data1:           first (1D) time series
		      data2:           second (1D) time series, co-aligned with data1
		      time:            observing times in seconds (1D array)

		    + OPTIONAL KEYWORDS:
		      padding:         oversampling factor: zero padding (default: 1)
		      apod:            extent of apodization edges (of a Tukey window); default 0.1
		      nodetrendapod:   if set, neither detrending nor apodization is performed!
		      pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2
		      polyfit:         the degree of polynomial fit to the data to detrend it
		                       if set, instead of linear fit this polynomial fit is performed
		      meantemporal:    if set, only a very simple temporal detrending is performed by
		                       subtracting the mean signal from the signal
		                       i.e., the fitting procedure (linear or higher polynomial degrees) is omitted
		      meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)
		      recon:           optional keyword that will Fourier reconstruct the input timeseries
		                       note: this does not preserve the amplitudes and is only useful when attempting
		                       to examine frequencies that are far away from the -untrustworthy- low frequencies
		      n_segments:      number of euqal segments (to which both datasets are broken prior to the analyses; default: 1)
		                       Each of these segments is considered an independent realisation of the underlying process.
		                       The cross spectrum for each segement are averaged together to provide phase and coherence
		                       estimates at each frequency.
		      stdlimit:        standard deviation to be achieved before accepting an IMF
		                       (recommended value between 0.2 and 0.3; perhaps even smaller); default: 0.2
		      nfilter:         Hanning window width for two dimensional smoothing of the Hilbert spectrum. default: 3
		                       (an odd integer, preferably equal to or larger than 3; equal to 0 to avoid the windowing)
		      siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)
		      nperm:           number of random permutations for the significance test (default: 50)
		                       note: the default value is set for quick tests. Choose a large number
		                       (e.g., 2000 or larger) for a better statistical result
		      nosignificance:  if set, no significance level is calculated

		    + OUTPUTS:
		      cospectrum:      absolute values of the cross power (1D array)
		      coherence:       coherence (1D array)
		      phase_angle:     phase angles in degrees (1D array)
		      frequency:       1D array of frequencies (in mHz)
		      signif_cross:    significance levels for the cospectrum (1D array)
		      signif_coh:      significance levels for the coherence (1D array)
		    -----------------------------------------------------------------------------------------
		    * CITATION:
		      Please cite the following article if you use WaLSAtools: cross-correlation analysis with HHT
		      -- Jess et al. 2021, LRSP, in preparation
		         (see www.WaLSA.tools/citation)
		    -----------------------------------------------------------------------------------------
			```
	
    If data, time or cadence, and the type of analysis are not provided, then the code returns the sequential information as documented above. 
    
    Running **WaLSAtools** is relatively painless, and easy to understand, if you follow the instruction printed in the terminal. 
    Please note the format and unit of the input, keyword, and output parameters.

    ??? source-code "Source code"
        ``` python linenums="1" hl_lines="17"
        --8<-- "codes/idl/walsatools.pro"
        ```

<br>
