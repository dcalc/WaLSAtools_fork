# WaLSAtools: Wave Analysis Tools

<p align="left">
    <a href="#"><img src="https://img.shields.io/badge/WaLSAtools-v1.0-0066cc"></a> 
    <a href="https://walsa.team" target="_blank"><img src="https://img.shields.io/badge/copyright-WaLSA%20Team-000d1a"></a>
    <a href="https://walsa.tools/license"><img src="https://img.shields.io/badge/license-Apache%202.0-green"></a>
    <a href="#"><img src="https://zenodo.org/badge/DOI/zenodo:%20tbd.svg"></a> 
    <a href="https://github.com/WaLSAteam/WaLSAtools/actions/workflows/ci.yml"><img src="https://github.com/WaLSAteam/WaLSAtools/workflows/docs/badge.svg"></a>
</p>

**WaLSAtools** is an open-source library for advanced wave analysis in time series and imaging data, applicable to a wide range of disciplines, including, but not limited to, astrophysics, physics, engineering, environmental science, and biomedical research. It provides a diverse set of tools for analyzing oscillatory signals in one-dimensional and multi-dimensional datasets.

The package, currently available in both Python and IDL, is designed to ensure reliability, reproducibility, and transparency in wave analysis, offering researchers robust methods for extracting meaningful insights from complex datasets.

This repository is referenced in an article in [**Nature Reviews Methods Primers**](https://www.nature.com/nrmp/) (in press), where it is described and applied to synthetic datasets as a foundational toolkit for wave analysis.

---

## **Key Features**

- **Fundamental and Advanced Analysis Techniques**:
  - Fast Fourier Transform (FFT)
  - Wavelet Analysis
  - Lomb-Scargle Periodogram
  - Welch Power Spectral Density
  - Empirical Mode Decomposition (EMD)
  - k-omega Analysis
  - Proper Orthogonal Decomposition (POD)
  - Cross-Spectra Analysis

- **Cross-Disciplinary Applicability**:
  - Signal processing in engineering and physics.
  - Oscillation studies in environmental and biomedical datasets.
  - Multi-dimensional analysis of complex data structures.
  - and more

- **Interactive Interfaces**:
  - Simplified workflows through interactive menus for both Python and IDL implementations.

- **Open Science Principles**:
  - Encourages reproducibility and transparency in data analysis.

---

## **Documentation**

The complete documentation for WaLSAtools, including installation guides, method descriptions, and usage examples, is available online:

📖 **[WaLSAtools Documentation](https://WaLSA.tools)**

The documentation includes:
- Step-by-step installation instructions.
- Descriptions of implemented methods.
- Examples applied to synthetic datasets.

<a href="https://WaLSA.tools" target="_blank"><img align="right" src="docs/images/misc/WaLSAtool_documentation_screenshot.jpg" alt="WaLSAtools Documentation Screenshot" width="485" height="auto" /></a>

---

## **Repository Structure**

The repository is organized into the following key components:
WaLSAtools/
├── codes/
│   ├── python/             # Python implementation of WaLSAtools
│   │   ├── WaLSAtools/     # Core library
│   │   ├── setup.py        # Setup script for Python
│   │   └── README.md       # Python-specific README
│   ├── idl/                # IDL implementation of WaLSAtools
│   │   ├── WaLSAtools/     # Core library
│   │   ├── setup.pro       # Setup script for IDL
│   │   └── README.md       # IDL-specific README
├── docs/                   # Documentation for WaLSAtools
├── examples/               # Worked examples directory
│   ├── python/             # Python-specific examples
│   │   └── Worked_examples__NRMP/
│   ├── idl/                # IDL-specific examples
│   │   └── Worked_examples__NRMP/
├── LICENSE                 # License information
└── README.md               # Main repository README

---

## **Installation**

Refer to the `README.md` files in the respective `python` and `idl` directories for installation instructions specific to each language. Further details are provided in the [Online Documentation](https://WaLSA.tools).

For a quick start:
- **Python**: Install using `setup.py` or `pip`.
- **IDL**: Configure using the provided `setup.pro` script.

---

## **Interactive Usage**

WaLSAtools includes an interactive interface to simplify its usage:
- **Python**: Launch the interactive interface by typing `WaLSAtools` in a terminal or Jupyter notebook as
  ```python
    from WaLSAtools import WaLSAtools
    WaLSAtools
  ```
- **IDL**: Start the interface by running the command:
  ```idl
    WaLSAtools
  ```

Both interfaces guide you through:
    1.	Selecting a category of analysis.
	2.	Choosing the data type (e.g., 1D signal, 3D datacube).
	3.	Picking a specific analysis method.

The interface provides hints on calling sequences and parameter definitions for the selected method.

## **Citing WaLSAtools**

If you use WaLSAtools in your research, please consider citing:

**Jafarzadeh, S., Jess, D. B., Stangalini, M. et al. 2025, Nature Reviews Methods Primers, in press.**

## **License**

WaLSAtools is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
Please see the LICENSE file for detailed terms and conditions.
