# WaLSAtools: Python Implementation

WaLSAtools is an open-source library designed for advanced wave analysis in time series and imaging data. The Python implementation supports a variety of spectral and spatio-temporal analysis techniques, including:

- **Fast Fourier Transform (FFT)**
- **Wavelet Analysis**
- **Lomb-Scargle Periodogram**
- **Welch Power Spectral Density**
- **Empirical Mode Decomposition (EMD)**
- **k-omega Analysis**
- **Proper Orthogonal Decomposition (POD)**
- **Cross-Spectra Analysis**

WaLSAtools provides an interactive interface in both **terminal** and **Jupyter notebooks** for ease of use. For detailed information on installation, methods, and usage examples, please refer to the [WaLSAtools Documentation](https://WaLSA.tools/).

---

## **Quick Start**

### **Installation**

To set up WaLSAtools for Python, follow these steps:

1. Clone or Download WaLSAtools Repository
```bash
git clone https://github.com/WaLSAteam/WaLSAtools.git
```
   
2. Navigate to the *python* directory and run:
```bash
pip install .
```
or
```bash
python setup.py install
```
Alternatively, you can install via pip:

```bash
pip install WaLSAtools
```

**NOTE**: This option will become available once the repository is public.

### **Interactive Usage**

WaLSAtools includes an interactive interface to simplify usage. After installation, in a terminal (within Python) or in a Jupyter notebook, run:

```python
from WaLSAtools import WaLSAtools
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

**Jafarzadeh, S., Jess, D. B., Stangalini, M. et al. 2025, Nature Reviews Methods Primers, in press.**
