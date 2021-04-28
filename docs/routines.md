---
template: overrides/mainat.html
---

# Under the Hood

We strongly recommend everyone to follow the procedure as instructed [here][1] when using **WaLSAtools** &#8212; a user-friendly tool &#8212; which gives you all information you need to do your analysis. 
However, for experts who want to make themselves familiar with the techniques and codes under the hood, inspect them and modify/develop/improve them, some of the main codes are also provided below. Please note that all codes and their dependencies are available in the [GitHub repository][2]{target=_blank}.

  [1]: WaLSAtools.md
  [2]: https://github.com/WaLSAteam/WaLSAtools

## WaLSA Spectral Analyzer

!!! walsa-code1 "WaLSA_speclizer"

	This code computes power spectrum and its statistical significance level for a 1D signal (or all pixels of an image sequence, i.e., a 3D cube) using FFT (Fast Fourier Transform),
	Lomb-Scargle, Wavelet, and HHT (Hilbert-Huang Transform) analysis techniques.

	??? source-code "WaLSA_speclizer.pro"
	    ``` python linenums="1" hl_lines="76 77 78 168 169 170 226 227 228 295 296 297 298 423 424 425 426 427 428 429 430 431"
	    --8<-- "codes/walsa_speclizer.pro"
	    ```
		
## k-&#969; Diagram and Fourier Filtering

!!! walsa-code2 "WaLSA_QUB_QUEEFF"

	A variant of the [QUEEns Fourier Filtering (QUEEFF) code][3]{target=_blank}, to compute k-&#969; diagram and perform Fourier filtering in the k-&#969; space.

	??? source-code "WaLSA_qub_queeff.pro"
	    ``` python linenums="1" hl_lines="133 134 208 209 210 230"
	    --8<-- "codes/walsa_qub_queeff.pro"
	    ```
	
	This code uses the following routine (originanly from Rob Rutten) to compute the k-&#969; power.
	
	??? source-code "WaLSA_plotkopower_funct.pro"
	    ``` python linenums="1"
	    --8<-- "codes/dependencies/walsa_plotkopower_funct.pro"
	    ```
		
## B-&#969; Diagram

!!! walsa-code1 "WaLSA_bomega"

    This routine computes and plots B-&#969; diagram, based on the approach introduced in [this scientific article][4]{target=_blank}.

	??? source-code "WaLSA_bomega.pro"
	    ``` python linenums="1" hl_lines="120 131 132 219 220 221"
	    --8<-- "codes/walsa_bomega.pro"
	    ```

## Detrending and Apodisation

!!! walsa-code2 "WaLSA_apodcube"

	All signals are detrended (linearly or using higher-order polynomial fits) and apodised (using a Tukey window) prior to all spectral analyses (unless otherwise it is omitted).
	Here is the code used for detrending and apodising the signals. The spatial apodisation for the k-&#969; diagram, are performed inside the `WaLSA_plotkopower_funct.pro` code.

	??? source-code "WaLSA_apodcube.pro"
	    ``` python linenums="1"
	    --8<-- "codes/dependencies/walsa_apodcube.pro"
	    ```

  [3]: https://bit.ly/37mx9ic
  [4]: https://arxiv.org/pdf/2103.11639.pdf

<br>