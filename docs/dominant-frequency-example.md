---
template: overrides/mainat.html
---

# Dominant Frequency

In the following example, **WaLSAtools** is performed to calculate mean power spectrum over a region of interest (from SDO/AIA 170 nm observations). In addition, dominant frequency (i.e., the frequency corresponding to maximum power) at each pixel is also determined, from which, the dominant frequency map for the entire area is plotted. The calculations in this example are carried out using both FFT and Wavelet Sensible analysis methods.

  [1]: introduction.md

!!! walsa-example "Power Spectra at pixel `[10,10]` of the AIA 170 nm sample datacube"

    To learn how the datacube is read, and how the various power spectra are calculated, using **WaLSAtools**, and plotted, please go through the source code of this example accessible at the bottom of this page. 
    The example IDL procedure can also be found under the `example` directory of the package. 
	The sample datacube is located in the `sample_data` folder under the `example` directory. 
	To run the example code, simply type the following command (while in the `example` directory, which can be placed anywhere in your machine, also outside your `IDL_PATH`) and press ++enter++ 

    ```sh
    IDL> .r example_dominant_frequency
    ```

    Within this example, **WaLSAtools** is called twice, to calculate the mean power spectrum and dominant frequency map, once by utilising FFT, once by Wavelet Sensible. 
	Hence, general information about the datacube as well as those about each particular method are printed after each call. 
	Below are some examples of the information begin printed. For simplicity, `% Compiled module:` messages and repeated information are not shown below.

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
     
	 The input datacube is of size: [71, 71, 610]

	 Temporally, the important values are:
	     2-element duration (Nyquist period) = 24.000000 seconds
	     Time series duration = 7320.0000 seconds
	     Nyquist frequency = 41.666667 mHz

      -- Detrend and apodize the cube .....
      
      == detrend next row...    71/ 71
	  
	  -- Perform FFT (Fast Fourier Transform) .....
	  == FFT next row...    70/   71
	   mode = 1: linear power
	  
	  -- Perform Wavelet Transform .....
	  
	  ...... sensible: output Sensible Wavelet Spectrum
	  ...... (power-weighted significant frequency distribution, unaffected by CoI)

	  Wavelet (mother) function: Morlet
	  dj: 0.0250000

	  >>> % finished: 100.

     COMPLETED!
    ```
    
    The figure below displays the results of the **FFT** analysis. The left panel shows the average power spectrum (averaged over all power spectra calculated at individual pixels), the right panel illustrates the dominant frequency map (i.e., the dominant frequency at all pixels of the field of view).
	The average power spectrum is plotted with a frequency range from the lowest detectable frequency (i.e., fundamental frequency) to 10 mHz (above which no power was found), and the power is normalised to its maximum value.
	The dominant frequency maps are calculated within the 0.4 and 10 mHz frequency range (i.e., slow variations, which are likely due to intrinsic evolution of the magnetic fields and not oscillations, do not enter our calculations).
    
    ![dfFFT]

    Similar results to those shown above are illustrated in the figure below, this time using **Sensible Wavelet** analysis.
    
    ![dfwavelet]
	
	The results of the two analysis methods are somewhat similar. However, a careful comparison can reveal important differences between the two average power spectra and the dominant frequency maps.
	In particular, both average power spectra show a clear power peak at around 4 mHz, however the one from Sensible Wavelet has a considerably larger power compared to that from FFT. 
	In addition, the largest peak occurs at lower frequencies from FFT analysis, compared to that from Sensible Wavelet.
	The dominant frequency maps show a somewhat similar distribution over the entire field of view, though they are not identical when closely compared.
	Both maps also reveal relatively high dominant frequencies beyond 5 mHz, though those from FFT extend to slightly higher values. 
	It is worth noting that the Sensible Wavelet power spectra only include power above the 95% confidence level and have excluded those subject to edge effect (those affected by the Wavelet's cone of influence), thus, may be regarded as a more reliable analysis method, particularly for quasi-periodic oscillations like those from these observations. 
	
    ??? source-code "Source code"
        ``` python linenums="1" hl_lines="34 35 36 76 77 78"
        --8<-- "examples/example_dominant_frequency.pro"
        ```

  [dfFFT]: assets/screenshots/example_dominant_frequency_FFT.jpg
  [dfwavelet]: assets/screenshots/example_dominant_frequency_sensible_wavelet.jpg

<br>