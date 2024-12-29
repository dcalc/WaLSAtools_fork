---
template: main.html
title: Installation
---

# Installation

## Prerequisites

Before installing WaLSAtools, ensure you have the following prerequisites:

* **Python:** WaLSAtools requires Python 3.7 or later. You can download the latest version of Python from the official website: [https://www.python.org/downloads/](https://www.python.org/downloads/)
* **pip:** pip is the package installer for Python. It is usually included with Python installations. You can check if you have pip installed by running `pip --version` in your terminal. If you don't have pip, you can install it by following the instructions on the official website: [https://pip.pypa.io/en/stable/installation/](https://pip.pypa.io/en/stable/installation/)

## Installation using pip

The easiest way to install WaLSAtools is using pip:

1. Open your terminal or command prompt.
2. Run the following command:

```bash
pip install WaLSAtools
```

This will download and install the latest stable version of WaLSAtools from the Python Package Index (PyPI).

## Installation from source

If you prefer to install WaLSAtools from source, you can follow these steps:

1.  Clone (or Download) the WaLSAtools repository from GitHub:

```bash
git clone https://github.com/WaLSAteam/WaLSAtools.git
```
   
2.  Navigate to the `codes/python` directory:

```bash
cd WaLSAtools/codes/python
```

3.  Run the setup script:

```bash
python setup.py install
```
Alternatively, you can install via pip:

```bash
pip install .
```

This will install WaLSAtools in your Python environment.

## Verifying the installation

To verify that WaLSAtools is installed correctly, you can run the following Python code, either in terminal (in Python) or in a Jupyter notebook:

```python
from WaLSAtools import WaLSAtools
WaLSAtools
```

This will display the WaLSAtools logo and credits information and launch the interactive WaLSAtools interface, confirming that the library is installed and functioning properly.

## Troubleshooting

If you encounter any issues during the installation process, please refer to the [Troubleshooting][15] section for common problems and solutions.

[15]: https://walsa.tools/python/troubleshooting/
 
 