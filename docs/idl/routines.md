---
template: overrides/main.html
---

# Under the Hood

We strongly recommend everyone to follow the procedure as instructed [here][1] when using **WaLSAtools** &#8212; a user-friendly tool &#8212; which gives you all information you need to do your analysis. 
However, for experts who want to make themselves familiar with the techniques and codes under the hood, inspect them and modify/develop/improve them, some of the main codes are also provided below. Please note that all codes and their dependencies are available in the [GitHub repository][2]{target=_blank}.

  [1]: WaLSAtools.md
  [2]: https://github.com/WaLSAteam/WaLSAtools

## Spectral Analyzer

!!! walsa-code1 "WaLSA_speclizer"

	This code computes power spectrum and its statistical significance level for a 1D signal (or all pixels of an image sequence, i.e., a 3D cube) using FFT (Fast Fourier Transform),
	Lomb-Scargle, Wavelet, and HHT (Hilbert-Huang Transform) analysis techniques. 
	In addition, the code can output mean power spectrum (averaged over power spectra of several pixels) as well as dominant frequency and power using the above-mentioned analysis methods.

	??? source-code "WaLSA_speclizer.pro"
	    ``` python linenums="1" hl_lines="95 96 97 98 99 100 211 212 213 214 215 216 291 292 293 294 295 379 380 381 382 383 384 385 588 589 590 591 592 593 594 595 596 597 598 599"
	    --8<-- "codes/idl/dependencies_level1/walsa_speclizer.pro"
	    ```
		
## k-&#969; Analysis and Fourier Filtering

!!! walsa-code2 "WaLSA_QUB_QUEEFF"

	A variant of the [QUEEns Fourier Filtering (QUEEFF) code][3]{target=_blank}, to compute k-&#969; diagram and perform Fourier filtering in the k-&#969; space.

	??? source-code "WaLSA_qub_queeff.pro"
	    ``` python linenums="1" hl_lines="133 134 208 209 210 230"
	    --8<-- "codes/idl/dependencies_level1/walsa_qub_queeff.pro"
	    ```
	
	This code uses the following routine (originanly from Rob Rutten) to compute the k-&#969; power.
	
	??? source-code "WaLSA_plotkopower_funct.pro"
	    ``` python linenums="1"
	    --8<-- "codes/idl/dependencies_level2/walsa_plotkopower_funct.pro"
	    ```
		
## B-&#969; Analysis

!!! walsa-code1 "WaLSA_bomega"

    This routine computes and plots B-&#969; diagram, based on the approach introduced in [this scientific article][4]{target=_blank}.

	??? source-code "WaLSA_bomega.pro"
	    ``` python linenums="1" hl_lines="239 240 241"
	    --8<-- "codes/idl/dependencies_level1/walsa_bomega.pro"
	    ```

## Detrending and Apodisation

!!! walsa-code2 "WaLSA_detrend_apod"

	All signals are detrended (linearly, or using higher-order polynomial fits if desired) and apodised (using a Tukey window, i.e., tapered cosine) prior to all spectral analyses (unless otherwise it is omitted).
	Here is the code used for detrending and apodising the signals. The spatial apodisation for the k-&#969; diagram, are performed inside the `WaLSA_plotkopower_funct.pro`.

	??? source-code "WaLSA_detrend_apod.pro"
	    ``` python linenums="1"
	    --8<-- "codes/idl/dependencies_level2/walsa_detrend_apod.pro"
	    ```
		
## Wavelet Analysis

!!! walsa-code1 "WaLSA_wavelet"

	A modified/extended variant of `wavelet.pro` (of Torrence & Compo) to compute wavelet power spectrum and its related parameters.

	??? source-code "WaLSA_wavelet.pro"
	    ``` python linenums="1" hl_lines="162 184 205 233 234 235 236 237 238 239 240 241 242 243 244 245 246"
	    --8<-- "codes/idl/dependencies_level2/walsa_wavelet.pro"
	    ```
	
	This code also uses the following routine to plot the wavelet power spectrum (along with confidence levels and cone-of-influence regions).
	
	??? source-code "WaLSA_plot_wavelet_spectrum.pro"
	    ``` python linenums="1" hl_lines="1 2"
	    --8<-- "codes/idl/dependencies_level2/walsa_plot_wavelet_spectrum.pro"
	    ```

## Cross Correlations: 1D power spectra

!!! walsa-code2 "WaLSA_cross_spectrum"

	Calculating cross-spectrum (also known as co-spectrum or cross-power), coherence, and phase relationships between two time series, where the 1D power spectra are obtained with FFT (Fast Fourier Transform),
	Lomb-Scargle, Wavelet (global, oglobal, and sensible), and HHT (Hilbert-Huang Transform), using the `WaLSA_speclizer.pro`.

	??? source-code "WaLSA_cross_spectrum.pro"
	    ``` python linenums="1" hl_lines="152 153 154 155 156 157 158"
	    --8<-- "codes/idl/dependencies_level2/walsa_cross_spectrum.pro"
	    ```

## Cross Correlations: Wavelet power spectra

!!! walsa-code1 "WaLSA_wavelet_cross_spectrum"

	As a largely modified/extended variant of the `wave_coherency.pro` (of Torrence), this code calculates co-spectrum, coherence, and phase relationships between two time series, where the wavelet power spectra are obtained, thus cross-correlation parameters also have two dimensions.

	??? source-code "WaLSA_wavelet_cross_spectrum.pro"
	    ``` python linenums="1" hl_lines="237 238 239 240 241 242 243 244 245 246 247 248 249 250 251"
	    --8<-- "codes/idl/dependencies_level2/walsa_wavelet_cross_spectrum.pro"
	    ```
	
	This code also uses the following routine to plot the wavelet co-spectrum and coherence spectrum (along with confidence levels, cone-of-influence regions, and phase lags).
	
	??? source-code "WaLSA_plot_wavelet_cross_spectrum.pro"
	    ``` python linenums="1" hl_lines="184 185 186 187"
	    --8<-- "codes/idl/dependencies_level2/walsa_plot_wavelet_cross_spectrum.pro"
	    ```

  [3]: https://bit.ly/37mx9ic
  [4]: https://arxiv.org/pdf/2103.11639.pdf

<br>