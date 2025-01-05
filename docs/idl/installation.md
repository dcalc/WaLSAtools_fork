---
template: main.html
---

# Installation - IDL version

The IDL version of the **WaLSAtools** package requires the [Interactive Data Language (**IDL**)][3]{target=_blank}. The package has primarily been tested with IDL version 8.5 and later, but should work with earlier versions as well. The package includes all third-party dependencies, so no other libraries are required.

## Installation with Git :octicons-mark-github-16:

The preferred method for installing **WaLSAtools** is through Git. This allows you to easily update to the latest version and track changes.

1.  Clone the WaLSAtools repository from GitHub:

```
git clone https://github.com/WaLSAteam/WaLSAtools
```

2.  Add the WaLSAtools directory to your IDL path by navigating to the idl directory, starting IDL and running:

```
.run setup.pro
```

See [Setting your IDL PATH][4] for further instructions.

To update an existing installation to the latest version, navigate to the WaLSAtools directory in your terminal and run:

```
git pull
```

## Installation via Direct Download :octicons-download-16:

Alternatively, you can download the WaLSAtools package as a [zip file][5]{target=_blank}. After downloading, extract the contents of the zip file to a location of your choice and add that location to your IDL path (by simply navigating to the idl directory, starting IDL and running `.run setup.pro`).

## Hints :octicons-milestone-16:

!!! walsa-info "IDL PATH"
    Add **`WaLSAtools`** to your [IDL PATH][4].

!!! walsa-test "Verifying the Installation"
	To verify that WaLSAtools is installed correctly, start IDL and run the following command (preferably, anywhere ==outside== the WaLSAtools directory):

    ```sh
    IDL> WaLSAtools, /version
    ```

    This should print the WaLSAtools version and a brief overview of its functionalities:

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
    ```

!!! walsa-question "Troubleshooting"
	If you encounter any problems during the installation process, please refer to the [Troubleshooting][1] section for common issues and solutions.

<br>

  [1]: troubleshooting.md
  [2]: https://github.com/WaLSAteam/WaLSAtools
  [3]: https://www.nv5geospatialsoftware.com/Products/IDL
  [4]: setting-idl-path.md
  [5]: https://github.com/WaLSAteam/WaLSAtools/zipball/master/
  [6]: https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls
