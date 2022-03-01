---
template: overrides/main.html
title: Installation
---

# Installation

=== "IDL"
	The IDL variant of the **WaLSAtools** package requires the [Interactive Data Language (**IDL**)][3]{target=_blank}. The package has primarily been tested with IDL version 8.5, but should, in principle, work with earlier or later versions too. The packages includes all dependencies (i.e., no third-party libraries are required).

	## With git :octicons-mark-github-16:

	**WaLSAtools** should preferably be used from [GitHub][2] by cloning the repository into your IDL library, or a location of your preference (that requires [setting your IDL PATH][4] by pointing to that location).

	```
	git clone https://github.com/WaLSAteam/WaLSAtools
	```

	Update an existing installation to the **latest version** via:

	```
	cd PATH-TO-THE-DIRECTORY/WaLSAtools
	git pull
	```

	where `PATH-TO-THE-DIRECTORY` is the location in where you have cloned the `WaLSAtools` (in your computer).

	## Direct Download :octicons-download-16:

	Alternatively, the **WaLSAtools** package can be downloaded as a [zip file][5]. This way, the latest version should be downloaded and replaced with the older one manually.

	## Hints :octicons-milestone-16:

	!!! walsa-info "IDL PATH"
		Add the **`WaLSAtools`** location to your **IDL PATH**. See [**here**][4] for instructions.

	!!! walsa-test "Test installation"
		To test a successful installation, start **IDL** in, e.g., your home directory (or anywhere ==outside== the WaLSAtools directory):
		```sh
		IDL> WaLSAtools, /version
		```

		The package is successfully installed if the results will look like this:

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

	!!! walsa-question "Installation issues"
		In case you're running into problems, consult the [**troubleshooting**][1] section.

=== "Python"
	The Python variant of the **WaLSAtools** package has been tested on Python 3.7.3.

<br>

  [1]: troubleshooting.md
  [2]: https://github.com/WaLSAteam/WaLSAtools
  [3]: https://www.l3harrisgeospatial.com/Software-Technology/IDL
  [4]: setting-idl-path.md
  [5]: https://github.com/WaLSAteam/WaLSAtools/zipball/master/
  
