---
template: overrides/mainat.html
---

# Cross Correlations

Here is an example of the **WaLSAtools** application on calculating cross correlations between oscillations in two time series, i.e., two random pixels in a sunspot's umbra from observations with SDO/AIA 170 nm. In this example, the 1D power spectra and their cross-correlation parameters, namely, co-spectrum (i.e., absolute values of cross-power spectrum), coherence spectrum, as well as phase lag are calculated (through FFT analysis) and plotted as a function of frequency. In addition, a similar analysis is performed using Wavelet, thus all spectra are computed and plotted in 2D (in time-frequency space).

  [1]: introduction.md 

!!! walsa-example "Co-spectrum, coherence, and phase difference for two pixels at `[233,231]` and `[231,238]` of the AIA 170 nm sample datacube" 

	To learn how **WaLSAtools** is employed to compute and plot the Co-spectrum, coherence, and phase difference (using both FFT and Wavelet) in this example, please go through its source code accessible at the bottom of this page. 
	The example IDL procedure can also be found under the `example` directory of the package. The sample datacubes are located in the `sample_data` folder under the `example` directory. 
	To run the example code, simply type the following command (while in the `example` directory, which can be placed anywhere in your machine, also outside your `IDL PATH`) and press ++enter++ 

	```sh
	IDL> .r example_cross_correlation
	```
	 
	Below are some examples of the information begin printed in terminal. For simplicity, `% Compiled module:` messages and repeated information are not shown below.

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
	 
	The input datacubes are of size: [610]
	
	Temporally, the important values are:
	    2-element duration (Nyquist period) = 24.000000 seconds
	    Time series duration = 7320.0000 seconds
	    Nyquist frequency = 41.666667 mHz
		
	-- Detrend and apodize the cube .....
	
	-- Perform FFT (Fast Fourier Transform) .....
	
	-- Perform Wavelet Transform .....	 
	
    ...... output Wavelet Spectra

    Wavelet (mother) function: Morlet
    dj: 0.0250000
	 
	>>> % Running Monte Carlo (significance): 100.

	COMPLETED! 
	```
	
	Figure below illustrates the output of the first analysis of this example, i.e., FFT analysis of the two signals, and their cross-correlation parameters. 
	Top row, from left to right: first time series, second time series, and their FFT power spectra plotted in blue and red, respectively.
	Bottom row, from left to right: the co-spectrum, coherence spectrum, and phase differences between the two time series.
	
    ![CCfft]
	
	Results of the Wavelet analysis on the same time series are shown below. Panels (**a**) and (**b**) respectively illustrate the wavelet power spectra of the first and second time series, while panels (**c**) and (**d**) represent their co-spectrum and coherence maps.
	In all four wavelet panels, the cross-hashed areas mark the CoI (subject to edge effect) and the black contours identifies regions with a 95% confidence level. 
	The background colours show the power in panels (**a**)-(**c**), in logarithmic scale (base 10), and the coherence levels in panel (**d**). 
	Phase differences between the two time series are depicted as arrows on panels (**c**) and (**d**). Arrows pointing right imply in-phase oscillations, those pointing straight up specify time series (1) leads time series (2) by 90 degrees.
	
	![wavelet1]{class="twoimg-responsive" align=left}
	![wavelet2]{class="twoimg-responsive" align=right}
	
	![wavelet-cospectrum]{class="twoimg-responsive" align=left}
	![wavelet-coherence]{class="twoimg-responsive" align=right}
	
	Although the co-spectrum identifies all regions where both oscillations pose strong power, they are coherent only in small areas. 
	
	See [here][1] to learn about all keywords available to this analysis tool.
  
  [CCfft]: assets/screenshots/example_cross-correlations_FFT.jpg
  [wavelet1]: assets/screenshots/example_wavelet_data1.jpg
  [wavelet2]: assets/screenshots/example_wavelet_data2.jpg
  [wavelet-cospectrum]: assets/screenshots/example_wavelet_cospectrum.jpg
  [wavelet-coherence]: assets/screenshots/example_wavelet_coherence.jpg
  [1]: WaLSAtools.md
  
	??? source-code "Source code"
	    ``` python linenums="1" hl_lines="16 17 18 94 95 99 100 104 105 106 112 113 114"
	    --8<-- "examples/example_cross_correlation.pro"
	    ```

<br>