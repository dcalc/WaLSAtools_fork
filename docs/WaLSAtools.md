---
template: overrides/mainat.html
---

# Analysis Tools

Below you can find information on how to use **WaLSAtools**. Please first read [**description of the analysis methods**][1] performed by **WaLSAtools**. Work examples of various analysis techniques are also provided (see the left menu), along with some hints on plotting the results.

We strongly encourage all users to perform their analyses by running **WaLSAtools** directly, instead of calling individual routines used within **WaLSAtools**. 

  [1]: introduction.md

!!! walsa-gear "How to use WaLSAtools"

    **WaLSAtools** is a wrapper of several analysis methods. It is written in a self-explanatory fashion, so one can get calling sequence and information about all inputs, keywords, and outputs for a specific analysis by simply typing **WaLSAtools** in IDL (press ++enter++ after typing each command/choice):

    ```sh
    IDL> WaLSAtools
    ```

    Various chain of information printed in terminal, based on choices of the user, are provided below.

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
      Performing various analysis techniques on time-series (1D signal or [x,y,t] cube)
      Methods:
      (1) 1D analysis with: FFT (Fast Fourier Transform), Lomb-Scargle,
                            Wavelet, or HHT (Hilbert-Huang Transform)
      (2) 3D analysis: k-ω (with optional Fourier filtering) or B-ω diagrams
     -----------------------------------------------------------------------------------
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
              walsatools, /fft, data=data, time=time, power=p, frequencies=f, significance=signif
              
            + INPUTS:
              data:            1D time series, or [x,y,t] datacube
              time:            observing times in seconds (1D array)
              
            + OPTIONAL KEYWORDS:
              padding:         oversampling factor: zero padding (default: 1)
              apod:            extent of apodization edges of a Tukey window (default: 0.1)
              noapod:          if set, neither detrending nor apodization is performed!
              pxdetrend:       subtract linear trend with time per pixel. options: 1 = , 2 =
              meandetrend:     if set, subtract linear trend with time for the image means
              siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)
              nperm:           number of random permutations for the significance test (default: 1000)
              nosignificance:  if set, no significance level is calculated
              mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
              
            + OUTPUTS:
              power:           1D (or 3D; same dimension as input data) array of power
                               2D (or 4D) array for wavelet spectrum
                               (in DN^2/mHz, i.e., normalized to frequency resolution)
              frequencies:     1D array of frequencies (in mHz)
              significance:    significance array (same size and units as power)
            ---------------------------------------------------------------------------------
            ```
        === "2"
            ```
            -------------------------------
            ---- 1D analysis with Wavelet:
            -------------------------------
            + CALLING SEQUENCE:
              walsatools, /wavelet, data=data, time=time, power=p, frequencies=f, significance=signif
              
            + INPUTS:
              data:            1D time series, or [x,y,t] datacube
              time:            observing times in seconds (1D array)
              
            + OPTIONAL KEYWORDS:
              padding:         oversampling factor: zero padding (default: 1)
              apod:            extent of apodization edges of a Tukey window (default: 0.1)
              noapod:          if set, neither detrending nor apodization is performed!
              pxdetrend:       subtract linear trend with time per pixel. options: 1 = , 2 =
              meandetrend:     if set, subtract linear trend with time for the image means
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
              insideCOI:       global wavelet spectrum excluding regions influenced by COI
              colornoise:      if set, noise background is based on Auchère+2017, ApJ, 838, 166
              
            + OUTPUTS:
              power:           1D (or 3D; same dimension as input data) array of power
                               2D (or 4D) array for wavelet spectrum
                               (in DN^2/mHz, i.e., normalized to frequency resolution)
              frequencies:     1D array of frequencies (in mHz)
              significance:    significance array (same size and units as power)
              coicube:         cone-of-influence cube (when global or insideCOI are not set)
            ---------------------------------------------------------------------------------
            ```
        === "3"
            ```
            ------------------------------------
            ---- 1D analysis with Lomb-Scargle:
            ------------------------------------
            + CALLING SEQUENCE:
              walsatools, /lomb, data=data, time=time, power=p, frequencies=f, significance=signif
              
            + INPUTS:
              data:            1D time series, or [x,y,t] datacube
              time:            observing times in seconds (1D array)
              
            + OPTIONAL KEYWORDS:
              padding:         oversampling factor: zero padding (default: 1)
              apod:            extent of apodization edges of a Tukey window (default: 0.1)
              noapod:          if set, neither detrending nor apodization is performed!
              pxdetrend:       subtract linear trend with time per pixel. options: 1 = , 2 =
              meandetrend:     if set, subtract linear trend with time for the image means
              siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)
              nperm:           number of random permutations for the significance test (default: 1000)
              nosignificance:  if set, no significance level is calculated
              mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
              
            + OUTPUTS:
              power:           1D (or 3D; same dimension as input data) array of power
                               2D (or 4D) array for wavelet spectrum
                               (in DN^2/mHz, i.e., normalized to frequency resolution)
              frequencies:     1D array of frequencies (in mHz)
              significance:    significance array (same size and units as power)
            ---------------------------------------------------------------------------------
            ```
        === "4"
            ```
            ---------------------------
            ---- 1D analysis with HHT:
            ---------------------------
            + CALLING SEQUENCE:
              walsatools, /hht, data=data, time=time, power=p, frequencies=f, significance=signif
              
            + INPUTS:
              data:            1D time series, or [x,y,t] datacube
              time:            observing times in seconds (1D array)
              
            + OPTIONAL KEYWORDS:
              padding:         oversampling factor: zero padding (default: 1)
              apod:            extent of apodization edges of a Tukey window (default: 0.1)
              noapod:          if set, neither detrending nor apodization is performed!
              pxdetrend:       subtract linear trend with time per pixel. options: 1 = , 2 =
              meandetrend:     if set, subtract linear trend with time for the image means
              siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)
              nperm:           number of random permutations for the significance test (default: 1000)
              nosignificance:  if set, no significance level is calculated
              mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
              stdlimit:        standard deviation to be achieved before accepting an IMF (default: 0.2)
              nfilter:         Hanning window width for two dimensional spectrum smoothing (default: 3)
                               (an odd integer equal to or larger than 3; 0: to avoid the windowing)
              emd:             if set, intrinsic mode functions (IMFs) and their associated frequencies
                               (i.e., instantaneous frequencies) can be outputted
              
            + OUTPUTS:
              power:           1D (or 3D; same dimension as input data) array of power
                               2D (or 4D) array for wavelet spectrum
                               (in DN^2/mHz, i.e., normalized to frequency resolution)
              frequencies:     1D array of frequencies (in mHz)
              significance:    significance array (same size and units as power)
              imf:             intrinsic mode functions (IMFs) from EMD alalysis, if emd is set
              instantfreq:     instantaneous frequencies of each component time series, if emd is set
            ---------------------------------------------------------------------------------
            ```
    === "2"
        ```
        ----------------------------------
        --- 3D analysis: (1) k-ω, (2) B-ω
        ----------------------------------
        --- Type of analysis (enter the option 1 or 2):
        ```
        === "1"
            ```
            ----------------------
            ---- 3D analysis: k-ω
            ----------------------
            + CALLING SEQUENCE:
              walsatools, /komega, data=data, time=time, arcsecpx=arcsecpx, power=p, frequencies=f, wavenumber=k
              
            + INPUTS:
              data:            [x,y,t] datacube
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
              clt:             color table number (IDL ctload)
              koclt:           custom color tables for k-ω diagram (currently available: 1 and 2)
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
                               (in DN^2/mHz, i.e., normalized to frequency resolution)
              frequencies:     1D array of frequencies (in mHz)
              wavenumber:      1D array of wavenumber (in arcsec^-1)
              filtered_cube:   3D array of filtered datacube (if filtering is set)
            ---------------------------------------------------------------------------------
            ```
        === "2"
            ```
            ----------------------
            ---- 3D analysis: B-ω
            ----------------------
            + CALLING SEQUENCE:
              walsatools, /bomega, data=data, time=time, bmap=bmap, power=p, frequencies=f, barray=b
              
            + INPUTS:
              data:            [x,y,t] datacube
              time:            observing times in seconds (1D array)
              bmap:            a map of magnetic fields (in G), same [x,y] size as in datacube
              
            + OPTIONAL KEYWORDS:
              binsize:         size of magnetic-field bins, over which power spectra are averaged
                               (default: 50 G)
              silent:          if set, the B-ω diagram is not plotted
              clt:             color table number (IDL ctload)
              koclt:           custom color tables for k-ω diagram (currently available: 1 and 2)
              threemin:        if set, a horizontal line marks the three-minute periodicity
              fivemin:         if set, a horizontal line marks the five-minute periodicity
              xlog:            if set, x-axis (wavenumber) is plotted in logarithmic scale
              ylog:            if set, y-axis (frequency) is plotted in logarithmic scale
              xrange:          x-axis (wavenumber) range
              yrange:          y-axis (frequency) range
              noy2:            if set, 2nd y-axis (period, in sec) is not plotted
                               (p = 1000/frequency)
              smooth:          if set, power is smoothed
              normalizedbins   if set, power at each bin is normalized to its maximum value
                               (this facilitates visibility of relatively small power)
              xtickinterval    x-asis (i.e., magnetic fields) tick intervals in G (default: 400 G)
              mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
              epsfilename:     if provided (as a string), an eps file of the k-ω diagram is made
              
            + OUTPUTS:
              power:           2D array of power
                               (in DN^2/mHz, i.e., normalized to frequency resolution)
              frequencies:     1D array of frequencies (y-axis) in mHz
              barray:          1D array of magnetic fields (x-axis) in G
            ---------------------------------------------------------------------------------
            ```

    If data, time or cadence, and the type of analysis are not provided, then the code returns the sequential information as documented above. 
    
    Running **WaLSAtools** is relatively painless, and easy to understand, if you follow the instruction printed in terminal. 
    Please note the format and unit of the input, keyword, and output parameters.

    ??? source-code "Source code"
        ``` python linenums="1" hl_lines="12"
        --8<-- "walsatools.pro"
        ```

<br>