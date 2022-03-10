---
template: overrides/mainat.html
---

# Power-Spectra Examples

Here is an example where all various power spectra, currently available through **WaLSAtools**, are calculated and plotted for a times series (i.e., at a pixel of time series of images) from observations with SDO/AIA 170 nm, sampling heights approximately corresponding to temperature minimum of the solar atmosphere.

  [1]: introduction.md

!!! walsa-example "Power Spectra at pixel `[10,10]` of the AIA 170 nm sample datacube"

    To learn how the datacube is read, and how the various power spectra are calculated, using **WaLSAtools**, and plotted, please go through the source code of this example accessible at the bottom of this page. 
    The example IDL procedure can also be found under the `example` directory of the package. 
	The sample datacube is located in the `sample_data` folder under the `example` directory. 
	To run the example code, simply type the following command (while in the `example` directory, which can be placed anywhere in your machine, also outside your `IDL_PATH`) and press ++enter++ 

    ```sh
    IDL> .r example_wave_power_spectra
    ```

    Within this example, we call **WaLSAtools** several times to calculate the various power spectra (those lines are highlighted in the example code), hence general information about the datacube as well as those about each particular method are printed after each call. Below are some examples of the information begin printed. For simplicity, `% Compiled module:` messages and repeated information are not shown below.

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
     
     The input datacube is of size: [610]

     Temporally, the important values are:
         2-element duration (Nyquist period) = 24.0000 seconds
         Time series duration = 7320 seconds
         Nyquist frequency = 41.6667 mHz

      -- Detrend and apodize the cube .....
      
      -- Perform Wavelet Transform ..... 
      ...... output Wavelet Spectra
     
      -- Perform FFT (Fast Fourier Transform) .....
      
      -- Perform Wavelet Transform .....
      ...... output Global Wavelet Spectra
      
      -- Perform Lomb-Scargle Transform .....
      
      -- Perform Wavelet Transform .....
      ...... output Global Wavelet Spectra: inside COI only
      
      -- Perform HHT (Hilbert-Huang Transform) .....
	  ...... output Marginal HHT Spectra 
      
      mode = 1: linear power

     COMPLETED!
    ```
    
    The output figure of this example is shown below.
    
    ![logos]
      [logos]: ../assets/screenshots/example_power_spectra.jpg

    The 1D signal (i.e., temporal variation of intensity at pixel [10,10] of the AIA 170 nm sample datacube) is illustrated in panel (**c**) after the application of linear detrending and apodisation (with a Tukey window).
    Panels (**a**) and (**b**) display wavelet power spectra of the signal using the Morlet and Mexican-Hat wavelets, respectively. 
    In both panels, CoIs are marked with the cross-hatched area. The background colour displays the normalised power (i.e., PSD), and the contours indicate the 95% confidence levels.
    Global and Sensible wavelets of the two wavelet transforms (i.e., Morlet and Mexican-Hat) are respectively shown with the red solid lines and green dashed lines in both panels (**d**) and (**e**). 
    The difference is that in panel (**d**) the *traditional* global wavelets are plotted (i.e., where the power is averaged over the entire time domain), whereas in panel (**e**) the so-called sensible wavelets represent time-integral of wavelet power excluding those affected by the CoI and those below the 95% confidence level (i.e., power-weighted frequency distribution with significant power unaffected by CoI).
    In panel (**d**), the 95% confidence levels (i.e., the 5% significance levels) of the two global wavelets (i.e., Morlet and Mexican-Hat) are depicted with the black dotted-dashed lines and blue triple-dotted-dashed lines, respectively.
    Panels (**f**), (**g**), and (**h**) illustrate PSDs determined using FFT, Lomb-Scargle, and HHT (marginal PSD) approaches, respectively (all shown with red solid lines). 
	The black dotted-dashed lines in these three panels indicate the 95% confidence levels. Note that all power (PSD) are normalised to their maximum value to facilitate the comparison.
    The purple and yellow stripes have been depicted to mark frequency ranges corresponding to the 3 and 5 min period windows (each with a width of 1 min), respectively.
    Also, on the top of the 1D power spectra, panels (**d**-**h**), frequency resolutions are depicted. Note the irregular spacing of the frequency resolution of the wavelet transforms. 
	Also note that some analysis techniques such as wavelet transform does padding by default. The time series could additionally be padded (by zeros) to (further) increase the frequency resolution, if desired.

    ??? source-code "Source code"
        ``` python linenums="1" hl_lines="49 50 87 88 136 137 156 157 172 173 187 188 203 204 219 220 227 228"
        --8<-- "examples/example_wave_power_spectra.pro"
        ```

<br>