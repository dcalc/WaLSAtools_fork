---
template: main.html
---

# Worked Example - NRMP: Synthetic Datasets

This page provides detailed information about the synthetic datasets used in the worked examples presented in the *Nature Reviews Methods Primers* article. These datasets were carefully crafted to evaluate the performance of various wave analysis techniques in a controlled environment. They comprise a 1D time series and a spatio-temporal datacube, each containing a variety of oscillatory signals with known parameters.

## Synthetic 1D Time Series

The synthetic 1D time series is constructed by combining five sinusoidal waves with distinct frequencies (5, 12, 15, 18, and 25 Hz) and amplitudes. To introduce realistic variability, the amplitudes of these waves are modulated with an envelope function. Additional features, such as a short-lived transient oscillation, a weak high-frequency signal, and a quasi-periodic signature, are also incorporated. Non-linearity is introduced through a mathematical transformation, and random noise is added to simulate measurement imperfections.

A second, nearly identical time series is also generated with adjusted phases for some of the wave components. This simulates observing the signal at a different location or time, enabling the evaluation of cross-correlation techniques.

## Synthetic Spatio-Temporal Datacube

The synthetic spatio-temporal datacube comprises a time series of 2D images, representing the evolution of wave patterns over both space and time. The datacube contains 50 concentric circular regions, each with ten sinusoidal waves of distinct frequencies, amplitudes, and phases. Additional complexities, such as a transient cubic polynomial signal, simulated transverse motion, a fluting-like instability, a quasi-periodic signal, and noise, are also incorporated.

## Detailed Parameters

The tables below provide detailed parameter specifications for the synthetic datasets.

[Image of Supplementary Table S1 from NRMP article]

**Table Caption:** Parameters for the synthetic 1D time series.

[Image of Supplementary Table S2 from NRMP article]

**Table Caption:** Parameters for the synthetic spatio-temporal datacube.

These synthetic datasets serve as valuable benchmarks for assessing the capabilities and limitations of different wave analysis techniques. By comparing the analysis results against the known ground truth, researchers can gain insights into the appropriate use cases for each method and improve the reliability of their interpretations when analysing real-world data.
