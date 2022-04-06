---
template: main.html
---

# k-&#969; Diagram and Filtering

Below are two examples for plotting a k-&#969; diagram using **WaLSAtools**, as well as an example of Fourier filtering in the k-&#969;, space employed on times series of images from observations with SDO/AIA 170 nm, sampling heights approximately corresponding to temperature minimum of the solar atmosphere.

!!! walsa-example "k-&#969; diagram and Fourier filtering for the entire field of view (i.e., `282x282` arcsec^2^) of the AIA 170 nm sample datacube"

    To learn how the datacube is read, and how the keywords are set, please check out the example source code at the bottom of this page.
    Please note that we are not using all optional keywords in this example. See [here][1] to learn about all keywords.
    If you, as an expert, are interested to see how the diagram is calculated and plotted see the `WaLSA_qub_queeff.pro` [source code][3]. 
    The example IDL procedure can also be found under the `examples/idl/` directory of the package. 
    The sample datacube is located in the `sample_data` folder under the `examples` directory.
    To run the example code, simply type the following command (while in the `examples/idl/` directory, which can be placed anywhere in your machine, also outside your `IDL_PATH`) and press ++enter++ 

    ```sh
    IDL> .r example_komega
    ```

    Within this example, we call **WaLSAtools** three times; twice to plot k-&#969; diagram only (for two specific wavenumber and frequency ranges of interest), and once to do Fourier filtering (interactively).
    Below are some examples of the information printed in terminal. For simplicity, `%Compiled module:` messages and repeated information are not shown below.

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
     
     The input datacube is of size: [470, 470, 610]

     Spatially, the important values are:
         2-pixel size = 1.20000 arcsec
         Field of view size = 282.000 arcsec
         Nyquist wavenumber = 5.23599 arcsec^-1

     Temporally, the important values are:
         2-element duration (Nyquist period) = 24.0000 seconds
         Time series duration = 7320 seconds
         Nyquist frequency = 41.6667 mHz

     Constructing a k-omega diagram of the input datacube..........
    ```
    
    Figures below are the outputs of the first two calls of **WaLSAtools** in this example. 
    Panel (**a**) illustrates the k-&#969; diagram for specific wavenumbers and frequencies of interest ranging 1-4 arcsec^-1^ and 1-15 mHz, respectively; panel (**b**) shows that for 0.2-3.1 arcsec^-1^ and 30-38 mHz (see panel (**c**) for the k-&#969; diagram with full wavenumber and frequency ranges).
    
    ![komega1]{class="twoimg-responsive" align=left}
    ![komega2]{class="twoimg-responsive" align=right}
    
    In these figures, the background colour represents the azimuthally averaged power (plotted in a base 10 logarithmic scale). Periods and spatial sizes (or wavelengths) are also shown on the second *x* and *y* axes.
    Several ridges are visible in both k-&#969; diagrams, i.e., in both low and high frequency ranges.
    
    In continue, **WaLSAtools** is called once again, this time, no specific range (for wavenumber or frequency) is chosen, and, the `/filtering` keyword is set.
    ```
    ..... start filtering (in k-ω space)
    ```
    Panel (**c**) is displayed at this point, with the following sequential steps requested in terminal: 
    ```
    Please click on the LOWEST frequency/wavenumber value you wish to preserve.....
    Please click on the HIGHEST frequency/wavenumber value you wish to preserve.....
    ```
    The selected k-&#969; region, for which the dataset is being filtered, is marked with the dashed-line rectangle on panel (**d**).
    
    ![filtering21]{class="twoimg-responsive" align=left}
    ![filtering22]{class="twoimg-responsive" align=right}
    
    Whilst the Fourier filtering is being progressed, the following information is printed and the figure below is displayed.
    ```
    The preserved wavenumbers are [0.31810485, 2.1640723] arcsec^-1
    The preserved spatial sizes are [2.9034083, 19.751932] arcsec

    The preserved frequencies are [2.3317721, 6.9000783] mHz
    The preserved periods are [144, 428] seconds

    Making a 3D Fourier transform of the input datacube..........
    
     mode = 0: log(power)

    COMPLETED!
    ```
    
    ![filtering]
    
    Top row of the figure above illustrates the spatial power spectra: from left to right, the time-averaged spatial power spectrum of the dataset, the chosen spatial filter, and the averaged power spectrum of the filtered datacube, respectively.
    At the bottom, the spatially-averaged temporal power of the original dataset (black line) as well as the preserved Fourier power after filtering (red line) are plotted. The dashed blue lines show the temporal filter mask.
    Note the the code, by default, makes use of Gaussian smoothing windows for both temporal and spatial filtering (to reduce aliasing at the edges of the chosen ranges). 
    These could, however, be disabled if one would prefer sharp edges (i.e., step functions instead of the Gaussian-shaped profiles).
    
    Finally, the `filtered_cube` is returned and can be inspected as a new datacube which includes the selected spatial and frequency ranges only.
    The figures below illustrate one image (from to the middle of the observations) before (**f**) and after (**g**) Fourier filtering
    
    ![image1]{class="twoimg-responsive" align=left}
    ![image2]{class="twoimg-responsive" align=right}
    
    As a guide, see [this scientific article][2]{target=_blank} where such Fourier filtering could help revealing a particular MHD wave mode in a sunspot.

  [komega1]: ../images/idl/WaLSAtools_k-omega_1.jpg
  [komega2]: ../images/idl/WaLSAtools_k-omega_2.jpg
  [filtering]: ../images/idl/WaLSAtools_Fourier_filtring.jpg
  [filtering21]: ../images/idl/WaLSAtools_k-omega_fig2_1.jpg
  [filtering22]: ../images/idl/WaLSAtools_k-omega_fig2_2.jpg
  [image1]: ../images/idl/original_image.jpg
  [image2]: ../images/idl/filtered_image.jpg
  [1]: WaLSAtools.md
  [2]: https://iopscience.iop.org/article/10.3847/1538-4357/aa73d6/pdf
  [3]: routines.md#k-diagram-and-filtering
  
    ??? source-code "Source code"
        ``` python linenums="1" hl_lines="17 18 21 22 25 26"
        --8<-- "examples/idl/example_komega.pro"
        ```

<br>