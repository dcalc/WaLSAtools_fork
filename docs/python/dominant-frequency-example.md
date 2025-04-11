---
template: main.html
---

# Worked Example - NRMP: Dominant Frequency

This example demonstrates the application of dominant frequency analysis to a synthetic spatio-temporal dataset. The dataset comprises a time series of 2D images, representing the evolution of wave patterns over both space and time. By analysing the dominant frequencies at each spatial location, we can gain insights into the spatial distribution of oscillatory behaviour and identify potential wave modes.

!!! walsa-example "Analysis and Figure"

    The figure below shows the dominant frequency maps calculated using different spectral analysis methods. The maps reveal the spatial distribution of the most prominent oscillation frequencies in the dataset.

    **Methods used:**

    *   Fast Fourier Transform (FFT)
    *   Refined Global Wavelet Spectrum (RGWS) with Morlet wavelet
    *   Refined Global Wavelet Spectrum (RGWS) with Paul wavelet

    **WaLSAtools version:** 1.0

    These particular analyses generate the figure below (Figure 4 in *[Nature Reviews Methods Primers](https://www.nature.com/articles/s43586-025-00392-0)*; copyrighted). For a full description of the datasets and the analyses performed, see the associated article. See the source code at the bottom of this page (or <a href="https://github.com/WaLSAteam/WaLSAtools/blob/main/examples/python/Worked_examples__NRMP/FIG4__dominant_frequency__mean_spectra.ipynb" target="_blank">here</a> on Github) for a complete analyses and the plotting routines used to generate this figure.

    ![jpg](/python/converted_notebooks_nrmp/Figures_jpg/Fig4_dominant_frequency_mean_power_spectra.jpg)

    **Figure Caption:** Dominant frequency maps and mean power spectra. Top row: Dominant frequency maps derived using FFT (left), Morlet-based RGWS (middle), and Paul-based RGWS (right). Bottom panel: Normalized mean power spectra for FFT (blue), Morlet-based RGWS (red), and Paul-based RGWS (black).

    !!! walsa-info "Important Notes on Interpreting the Dominant Frequencies"
        The dominant frequency at each pixel corresponds to the frequency with the highest spectral power. While a **linear detrending** and **Tukey apodization** (with 0.1 tapering fraction) have been applied to reduce **long-term trends** and **edge effects**, the **lowest frequency bin** may still appear dominant — especially in regions without strong higher-frequency oscillations.

        This is a common outcome in time series with broad, low-frequency variability, where power is not concentrated at narrow peaks, or limited by frequency resolution. However, this **does not necessarily reflect meaningful or coherent low-frequency wave activity**.

        In the figure, **white regions** indicate pixels where the dominant frequency falls into the **lowest frequency bin**, which is explicitly mapped to white in the color table (see line 23 of the plotting routine). These are only visible in the **FFT** and **Morlet-based RGWS** maps.

        The **Paul-based RGWS** map, on the other hand, does **not show white regions**. This is because, for this method, the dominant frequencies tend to fall slightly above the lowest bin (around **100-120 mHz**), even though the method includes lower frequencies. This behavior reflects the fundamental differences among the analysis techniques used:

        📌 **FFT (Fast Fourier Transform)**   
            ◍ Provides relatively high **frequency resolution** at all frequencies, with fixed, global basis functions.  
            ◍ Sensitive to **any persistent oscillatory signal**, but often returns **low-frequency peaks** if stronger high-frequency signals are absent.  
            ◍ In the averaged power spectrum, the dominant peak lies at **100 mHz** — the lowest available frequency bin.  

        📌 **Morlet-based RGWS**   
            ◍ Uses the **Morlet wavelet**, which offers **good frequency resolution** but **less precise time localization**, particularly well-suited to capturing persistent oscillations with quasi-stationary frequencies.  
            ◍ As with all RGWS methods, the frequency resolution is **non-uniform**, leading to **narrower and more pronounced peaks at lower frequencies**, and **broader, smoother features at higher frequencies** in the power spectrum.   
            ◍ This causes the spectrum to **mirror FFT’s tendency** to favor the lowest bin as dominant when no strong high-frequency signals are present, but with **less detail in the dominant frequency map**, compared to FFT, due to smoothing at high frequencies.  

        📌 **Paul-based RGWS**   
            ◍ Employs the **Paul wavelet**, which has **excellent time localization** but **poorer frequency resolution**, particularly at low frequencies. This causes the lowest frequency bin to appear more diffuse, with power spread across a broader range, making sharp low-frequency peaks less distinguishable.  
            ◍ It responds strongly to **short-lived or localized features** in the data, but tends to **underrepresent broad, slowly varying components**. As a result, power in the lowest frequency bin is often **weakened or distributed**, making it less likely to be selected as dominant.  
            ◍ Consequently, the **mean power spectrum peaks around 120 mHz**, and **white regions do not appear** in the dominant frequency map, since the **100 mHz bin is rarely the strongest** in this method.  

        These differences emphasize that **dominant frequency maps depend strongly on the method used**, and should always be interpreted in tandem with the full power spectra (see bottom panel of Figure 4) and with awareness of each method's strengths and limitations.
    
    ??? source-code "Source code"
        {% include-markdown "python/converted_notebooks_nrmp/FIG4__dominant_frequency__mean_spectra.md" %}
