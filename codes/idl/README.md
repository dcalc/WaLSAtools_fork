# WaLSAtools: IDL Implementation

WaLSAtools is an open-source library designed for advanced wave analysis in time series and imaging data. The IDL implementation supports a variety of spectral and spatio-temporal analysis techniques, including:

- **Fast Fourier Transform (FFT)**
- **Wavelet Analysis**
- **Lomb-Scargle Periodogram**
- **Welch Power Spectral Density**
- **Empirical Mode Decomposition (EMD)**
- **Hilbert and Hilbert-Huang Transforms**
- **k-omega Analysis**
- **Proper Orthogonal Decomposition (POD)**
- **Cross-Spectra Analysis**

WaLSAtools provides a set of tools for performing complex analyses in IDL, along with interactive options to guide the user. For detailed information on methods and usage examples, please refer to the [WaLSAtools Documentation](https://WaLSA.tools/).

---

## 🚀 **Installation**

To set up WaLSAtools for IDL, follow these steps:

1. Clone or Download WaLSAtools Repository
```bash
git clone https://github.com/WaLSAteam/WaLSAtools.git
```
   
2. Navigate to the *idl* directory, start IDL and run:
```bash
.run setup.pro
```

This script automatically adds WaLSAtools to your IDL path and saves it in your IDL resource file for future sessions.

### **Interactive Usage**

WaLSAtools includes an interactive interface to simplify usage. After installation, in a terminal (within IDL) type:

```bash
WaLSAtools
```

This will launch an interactive menu with options for:

- Selecting a category of analysis.
- Choosing the data type (e.g., 1D time series or 3D data cube).
- Picking an analysis method (e.g., FFT, wavelet, k-omega).

The interface provides instructions and hints on calling sequences and parameter details for your chosen analysis.

## **License**

WaLSAtools is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

If you use WaLSAtools in your research, please cite:

**[Jafarzadeh, S., Jess, D. B., Stangalini, M. et al. 2025, Nature Reviews Methods Primers, 5, 21](https://www.nature.com/articles/s43586-025-00392-0)**
