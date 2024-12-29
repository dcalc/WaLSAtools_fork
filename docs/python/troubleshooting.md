---
template: main.html
title: Troubleshooting
---

# Troubleshooting

This page provides solutions to common issues encountered during the installation or usage of **WaLSAtools**. If you encounter a problem not listed here, please refer to instructions provided in [Contribution](https://WaLSA.tools/contribution/) or [Contact Us](mailto:WaLSAtools@WaLSA.team) for assistance.

## Installation Issues

### 1. `pip` fails to install WaLSAtools

* **Check your internet connection:** Ensure you have a stable internet connection.
* **Upgrade `pip`:** Run `pip install --upgrade pip` to update to the latest version.
* **Use a virtual environment:** Consider using a virtual environment to avoid conflicts with other packages. You can create a virtual environment using, e.g., `venv` or `conda`.
* **Check for firewalls or proxies:** If you are behind a firewall or proxy, you may need to configure `pip` to use the appropriate settings.
* **Specify Python version**: Ensure that you are using Python 3.7 or later, as older versions may not support WaLSAtools.

### 2. Installation from source fails

* **Check dependencies:** Ensure you have all the required dependencies installed. You can find the list of dependencies in the `setup.py` file under `codes/python/`. Installing **WaLSAtools** via `pip install .` ensures all dependencies are installed.
* **Compiler issues:** If you are compiling WaLSAtools from source, ensure that you have a compatible C++ compiler installed.
	•	On Linux: Install build-essential or similar packages.
	•	On macOS: Install Xcode and its command-line tools.
	•	On Windows: Install a C++ compiler like MinGW or Visual Studio.
* **Permissions:** Ensure you have the necessary permissions to write to the installation directory. Try running the installation command with sudo (Linux/macOS) or as an administrator (Windows), if needed.

## Usage Issues

### 1. WaLSAtools crashes or produces unexpected results

* **Check input data:** Ensure your input data is in the correct format and meets the requirements of the analysis method you are using.
* **Update WaLSAtools:** Try updating to the latest version of WaLSAtools (e.g., y running `pip install --upgrade WaLSAtools`).
* **Check for conflicting packages:** If you are using other packages that might conflict with WaLSAtools, try temporarily disabling or removing them, or consider creating a clean virtual environment and reinstalling WaLSAtools there.
* **Bug Report:** If you are unable to resolve the issue, please report the issue. See [Bug Report][16]. 
* **Contact Us:** If the problem persists, please [Contact Us](mailto:WaLSAtools@WaLSA.team) with a detailed description of the problem and your code.

### 2. Interactive interface does not launch

* **Check your Python environment:** Ensure you have activated the correct Python environment where WaLSAtools is installed.
* **Run from the terminal:** Try launching WaLSAtools from the terminal, or a Jupyter notebook, using the command `from WaLSAtools import WaLSAtools; WaLSAtools`.
* **Check for conflicting packages:** If you are using other packages that might conflict with WaLSAtools, try temporarily disabling or removing them.

## Contributing to Troubleshooting

If you have encountered and resolved an issue not listed here, please consider contributing to this troubleshooting guide by submitting a [Pull Request][17] on GitHub. Your contribution will help other users overcome similar problems.

## Final Notes

* **Error logs:** Always check error messages carefully, as they often point to the exact issue.
* **Documentation:** Refer to the WaLSAtools Documentation for detailed guidance on installation, usage, and analysis techniques.

[16]: https://walsa.tools/contribution/#bug-report 
[17]: https://walsa.tools/contribution/#pull-requests
 
  