; -----------------------------------------------------------------------------------------------------
; WaLSAtools: Wave analysis tools
; Copyright (C) 2025 WaLSA Team - Shahin Jafarzadeh et al.
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
; http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.
;
; Note: If you use WaLSAtools for research, please consider citing:
; Jafarzadeh, S., Jess, D. B., Stangalini, M. et al. 2025, Nature Reviews Methods Primers, in press.
; -----------------------------------------------------------------------------------------------------

;+
; NAME: WaLSAtools
;
; PURPOSE:
;   Performing various wave analysis techniques on
;           (a) Single time series (1D signal or [x,y,t] cube)
;               Methods:
;               (1) 1D analysis with: FFT (Fast Fourier Transform), Wavelet, Lomb-Scargle,
;                                     HHT (Hilbert-Huang Transform), or Welch
;               (2) 3D analysis: k-ω (with optional Fourier filtering) or B-ω diagrams
;
;           (b) Two time series (cross correlations between two signals)
;               With: FFT (Fast Fourier Transform), ,
;                     Lomb-Scargle, HHT (Hilbert-Huang Transform, or Welch
;
; CALLING SEQUENCE:
;   IDL> WaLSAtools
;   Type WaLSAtools in IDL for further information (and all keywords)
;
; Documentation and info: www.WaLSA.tools
; GitHub repository: www.github.com/WaLSAteam/WaLSAtools
; © WaLSA Team (www.WaLSA.team)
; Please see www.WaLSA.tools/license & www.WaLSA.tools/citation if you use WaLSAtools
;-

pro walsatools, $
  ; (1) 1D analysis with: FFT, Wavelet, Long-Scargle, EMD, or HHT:
  signal = signal, time = time, $ ; main inputs
  power = power, frequencies = frequencies, significance = significance, coi = coi, averagedpower = averagedpower, $ ; main (additional) outputs
  fft = fft, lombscargle = lombscargle, welch = welch, wavelet = wavelet, hht = hht, $ ; type of analysis
  padding = padding, apod = apod, nodetrendapod = nodetrendapod, pxdetrend = pxdetrend, meandetrend = meandetrend, $ ; padding and apodization parameters
  polyfit = polyfit, meantemporal = meantemporal, recon = recon, resample_original = resample_original, psd = psd, $
  siglevel = siglevel, nperm = nperm, nosignificance = nosignificance, $ ; significance-level parameters
  mother = mother, param = param, dj = dj, global = global, oglobal = oglobal, rgws = rgws, colornoise = colornoise, $ ; Wavelet parameters/options
  stdlimit = stdlimit, nfilter = nfilter, emd = emd, imf = imf, instantfreq = instantfreq, $ ; HHT parameters/options
  window_size = window_size, overlap = overlap, wfft_size = wfft_size, $ ; Welch parameters
  mode = mode, $ ; power calibration
  dominantfreq = dominantfreq, rangefreq = rangefreq, nodominantfreq = nodominantfreq, dominantpower = dominantpower, $ ; dominant frequency
  ; + keywords/options for
  ; (2) 2D analysis: k-omega diagram:
  arcsecpx = arcsecpx, cadence = cadence, $ ; additional main input
  wavenumber = wavenumber, filtered_cube = filtered_cube, $ ; main (additional) outputs
  filtering = filtering, f1 = f1, f2 = f2, k1 = k1, k2 = k2, spatial_torus = spatial_torus, temporal_torus = temporal_torus, $ ; filtering options
  no_spatial_filt = no_spatial_filt, no_temporal_filt = no_temporal_filt, $
  clt = clt, koclt = koclt, threemin = threemin, fivemin = fivemin, xlog = xlog, ylog = ylog, xrange = xrange, yrange = yrange, $ ; plotting keywords
  epsfilename = epsfilename, noy2 = noy2, nox2 = nox2, smooth = smooth, savefits = savefits, filename = filename, $
  ; (2) 2D analysis: B-omega diagram:
  bmap = Bmap, binsize = binsize, barray = Barray, silent = silent, bomega = bomega, komega = komega, help = help, $
  normalizedbins = normalizedbins, xtickinterval = xtickinterval, version = version, plot = plot, log = log, removespace = removespace, $
  data1 = data1, data2 = data2, phase_angle = phase_angle, coherence = coherence, cospectrum = cospectrum, amplitude = amplitude, $ ; cross spectra analysis
  signif_coh = signif_coh, signif_cross = signif_cross, coh_global = coh_global, phase_global = phase_global, cross_global = cross_global, $
  coh_oglobal = coh_oglobal, phase_oglobal = phase_oglobal, cross_oglobal = cross_oglobal, $
  pownormal = pownormal, arrowdensity = arrowdensity, arrowsize = arrowsize, arrowheadsize = arrowheadsize, noarrow = noarrow, $
  n_segments = n_segments, d1_power = d1_power, d2_power = d2_power, period = period
  compile_opt idl2
  ; -----------------------------------------------------------------------------------------------------------------------------------
  print, ' '
  print, '    __          __          _          _____            '
  print, '    \ \        / /         | |        / ____|     /\    '
  print, '     \ \  /\  / /  ▄▄▄▄▄   | |       | (___      /  \   '
  print, '      \ \/  \/ /   ▀▀▀▀██  | |        \___ \    / /\ \  '
  print, '       \  /\  /   ▄██▀▀██  | |____    ____) |  / ____ \ '
  print, '        \/  \/    ▀██▄▄██  |______|  |_____/  /_/    \_\'
  print, ' '
  print, ' '
  print, '  © WaLSA Team (www.WaLSA.team)'
  print, ' -----------------------------------------------------------------------------------'
  print, '  WaLSAtools v1.0.0'
  print, '  Documentation: www.WaLSA.tools'
  print, '  GitHub repository: www.github.com/WaLSAteam/WaLSAtools'
  print, ' -----------------------------------------------------------------------------------'

  if keyword_set(cadence) or keyword_set(time) then temporalinfo = 1 else temporalinfo = 0
  if keyword_set(signal) and temporalinfo then begin
    if keyword_set(fft) or keyword_set(wavelet) or keyword_set(lombscargle) or keyword_set(welch) or $
      keyword_set(hht) or keyword_set(komega) or keyword_set(bomega) $
    then help = 0 else help = 1
  endif else help = 1
  if keyword_set(signal) eq 0 then begin
    if keyword_set(data1) and keyword_set(data2) and temporalinfo then begin
      if keyword_set(fft) or keyword_set(wavelet) or keyword_set(lombscargle) or keyword_set(welch) $
      or keyword_set(hht) then help = 0 else help = 1
    endif else help = 1
  endif

  if help then begin
    print, '  Performing various wave analysis techniques on '
    print, '  (a) Single time series (1D signal or [x,y,t] cube)'
    print, '      Methods: '
    print, '      (1) 1D analysis with: FFT (Fast Fourier Transform), Wavelet, Lomb-Scargle,'
    print, '                            HHT (Hilbert-Huang Transform), or Welch'
    print, '      (2) 3D analysis: k-ω (with optional Fourier filtering) or B-ω diagrams'
    print
    print, '  (b) Two time series (cross correlations between two signals)'
    print, '      With: FFT (Fast Fourier Transform), Wavelet,'
    print, '            Lomb-Scargle, HHT (Hilbert-Huang Transform) or Welch'
    print, ' ----------------------------------------------------------------------------'
    if keyword_set(version) then begin
      print
      return
    endif
    category = ' '
    read, category, prompt = ' -- Category -- (enter the option a or b): '
    if category eq 'a' or category eq 'b' then goto, categories else begin
      ask:
      read, category, prompt = ' -- Please enter a or b (i.e., one of the categories (a) or (b) listed above): '
      if category eq 'a' or category eq 'b' then goto, categories else goto, ask
    endelse
    categories:
    print
    if category eq 'a' then begin
      print, ' ------------------------------------------------'
      print, ' --- Single time-series analysis: (1) 1D, (2) 3D'
      print, ' ------------------------------------------------'
      type = ' '
      read, type, prompt = ' -- Method (enter the option 1 or 2): '
      while type lt 1 or type gt 2 do begin
        read, type, prompt = ' -- Please enter 1 or 2 (i.e., one of the methods listed above): '
        if type eq 1 or type eq 2 then break
      endwhile
      print
      if type eq 1 then begin
        print, ' ---------------------------------------------------------------------------------'
        print, ' --- 1D analysis with: (1) FFT, (2) Wavelet, (3) Lomb-Scargle, (4) HHT, (5) Welch'
        print, ' ---------------------------------------------------------------------------------'
        m1type = ' '
        read, m1type, prompt = ' --- Type of analysis (enter the option 1-4): '
        while m1type lt 1 or m1type gt 4 do begin
          read, m1type, prompt = ' --- Please enter a number between 1 and 4: '
          if m1type eq 1 or m1type eq 2 or m1type eq 3 or m1type eq 4 then break
        endwhile
        print
        if m1type eq 1 then begin
          print, ' ---------------------------'
          print, ' ---- 1D analysis with FFT:'
          print, ' ---------------------------'
          print, ' + CALLING SEQUENCE:'
          print, '   walsatools, /fft, signal=signal, time=time, power=p, frequencies=f, significance=signif'
        endif
        if m1type eq 2 then begin
          print, ' -------------------------------'
          print, ' ---- 1D analysis with Wavelet:'
          print, ' -------------------------------'
          print, ' + CALLING SEQUENCE:'
          print, '   walsatools, /wavelet, signal=signal, time=time, power=p, frequencies=f, significance=signif'
        endif
        if m1type eq 3 then begin
          print, ' ------------------------------------'
          print, ' ---- 1D analysis with Lomb-Scargle:'
          print, ' ------------------------------------'
          print, ' + CALLING SEQUENCE:'
          print, '   walsatools, /lomb, signal=signal, time=time, power=p, frequencies=f, significance=signif'
        endif
        if m1type eq 4 then begin
          print, ' ---------------------------'
          print, ' ---- 1D analysis with HHT:'
          print, ' ---------------------------'
          print, ' + CALLING SEQUENCE:'
          print, '   walsatools, /hht, signal=signal, time=time, power=p, frequencies=f, significance=signif'
        endif
        if m1type eq 5 then begin
          print, ' ----------------------------'
          print, ' ---- 1D analysis with Welch:'
          print, ' ----------------------------'
          print, ' + CALLING SEQUENCE:'
          print, '   walsatools, /welch, signal=signal, time=time, power=p, frequencies=f, significance=signif'
        endif
        print
        print, ' + INPUTS:'
        print, '   signal:          1D time series, or [x,y,t] datacube'
        print, '   time:            observing times in seconds (1D array)'
        print
        print, ' + OPTIONAL KEYWORDS:'
        ; ----padding, detrending, and apodization parameters----
        print, '   padding:         oversampling factor: zero padding (default: 1)'
        print, '   apod:            extent of apodization edges (of a Tukey window); default 0.1'
        print, '   nodetrendapod:   if set, neither detrending nor apodization is performed!'
        print, '   pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2'
        print, '   polyfit:         the degree of polynomial fit to the data to detrend it'
        print, '                    if set, instead of linear fit this polynomial fit is performed'
        print, '   meantemporal:    if set, only a very simple temporal detrending is performed by'
        print, '                    subtracting the mean signal from the signal'
        print, '                    i.e., the fitting procedure (linear or higher polynomial degrees) is omitted'
        print, '   meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)'
        print, '   recon:           optional keyword that will Fourier reconstruct the input timeseries'
        print, '                    note: this does not preserve the amplitudes and is only useful when attempting'
        print, '                    to examine frequencies that are far away from the -untrustworthy- low frequencies'
        print, '   resample         if recon is set, then by setting resample, amplitudes are scaled to approximate actual values.'
        ; ----significance-level parameters----
        print, '   siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)'
        print, '   nperm:           number of random permutations for the significance test (default: 1000)'
        print, '   nosignificance:  if set, no significance level is calculated'
        ; ----power calibration----
        print, '   mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude'
        if m1type eq 2 then begin
          print, '   mother:          wavelet function (also depends on param). default: Morlet'
          print, '                    other available functions: Paul and DOG are available'
          print, '   param:           optional mother wavelet parameter'
          print, '                    (default: 6 (for Morlet), 4 (for Paul), 2 (for DOG; i.e., Mexican-hat)'
          print, '   dj:              spacing between discrete scales. default: 0.025'
          print, '   global:          returns global wavelet spectrum (time-averaged wavelet power)'
          print, '   oglobal:         global wavelet spectrum excluding regions affected by CoI'
          print, '   rgws:        time-integral of wavelet power excluding regions influenced by cone-of-influence'
          print, '                    and only for those above the significance level'
          print, '                    i.e., power-weighted frequency distribution (with significant power & unaffected by CoI)'
          print, '                    Note: this is likely the most correct spectrum!'
          print, '   colornoise:      if set, noise background is based on Auchère+2017, ApJ, 838, 166'
        endif
        if m1type eq 4 then begin
          print, '   stdlimit:        standard deviation to be achieved before accepting an IMF (default: 0.2)'
          print, '   nfilter:         Hanning window width for two dimensional spectrum smoothing (default: 3)'
          print, '                    (an odd integer equal to or larger than 3; 0: to avoid the windowing)'
          print, '   emd:             if set, intrinsic mode functions (IMFs) and their associated frequencies'
          print, '                    (i.e., instantaneous frequencies) can be outputted'
        endif
        if m1type eq 5 then begin
          ; ----Welch parameters/options----
          print, '   window_size:     size of Hann window. This code currently uses a Hann window (e.g., 256)'
          print, '   overlap:         commonly, the overlap is set to half the window size.'
          print, '   wfft_size:        generally, a window_size*2 is used for the FFT size to optimize the FFT performance.'
        endif
        ; ----dominant frequency----
        print, '   nodominantfreq:  if set, dominant frequency and dominant power are not calculated'
        print, '                    (to, e.g., save computational time for large datasets)'
        print
        print, ' + OUTPUTS:'
        print, '   power:           1D (or 3D; same dimension as input data) array of power'
        print, '                    2D (or 4D) array for wavelet spectrum'
        print, '                    (in DN^2/mHz, i.e., normalised to frequency resolution)'
        print, '   frequencies:     1D array of frequencies (in mHz)'
        print, '   period:          1D array of periods (in seconds)'
        print, '   significance:    significance array (same size and units as power)'
        if m1type eq 4 then begin
          print, '   imf:             intrinsic mode functions (IMFs) from EMD analysis, if emd is set'
          print, '   instantfreq:     instantaneous frequencies of each component time series, if emd is set'
        endif
        if m1type eq 2 then begin
          print, '   coi:             cone-of-influence cube (when global, oglobal, or rgws are not set)'
        endif
        print, '   dominantfreq:    dominant frequency, i.e., frequency corresponding to the maximum power (in mHz)'
        print, '                    same spatial size as input data (i.e., 1D or 2D)'
        print, '                    if there are multiple peaks with the same power, the lowest dominant frequency is returned!'
        print, '   dominantpower:   power (in DN^2/mHz) corresponding to the dominant frequency'
        print, '                    same spatial size as input data (i.e., 1D or 2D)'
        print, '   rangefreq:       frequency range over which the dominant frequency is computed. default: full frequency range'
        print, '   averagedpower:   spatially averaged power spectrum (of multiple 1D power spectra)'
        print, '   amplitude:       1D array of oscillation amplitude (or a 3D array if the input is a 3D cube)'
        if m1type eq 2 then begin
          print, '                    note: only for global (traditional, oglobal, or rgws) wavelet'
        endif
        print, ' -----------------------------------------------------------------------------------------'
        if m1type eq 1 then m1typecite = 'WaLSAtools: 1D analysis with FFT'
        if m1type eq 2 then m1typecite = 'WaLSAtools: 1D analysis with Wavelet'
        if m1type eq 3 then m1typecite = 'WaLSAtools: 1D analysis with Lomb-Scargle'
        if m1type eq 4 then m1typecite = 'WaLSAtools: 1D analysis with HHT'
        if m1type eq 5 then m1typecite = 'WaLSAtools: 1D analysis with Welch'
        print, ' * CITATION:'
        print, '   Please cite the following article if you use ' + m1typecite
        print, '   -- Jess et al. 2023, Living Reviews in Solar Physics, 20, 1'
        print, '      (see www.WaLSA.tools/citation)'
        print, ' -----------------------------------------------------------------------------------------'
        print
      endif
      if type eq 2 then begin
        print, ' -----------------------------------'
        print, ' --- 3D analysis: (1) k-ω, (2) B-ω'
        print, ' -----------------------------------'
        m2type = ' '
        read, m2type, prompt = ' --- Type of analysis (enter the option 1 or 2): '
        while m2type lt 1 or m2type gt 2 do begin
          read, m2type, prompt = ' --- Please enter 1 or 2: '
          if m2type eq 1 or m2type eq 2 then break
        endwhile
        print
        if m2type eq 1 then begin
          print, ' -----------------------'
          print, ' ---- 3D analysis: k-ω'
          print, ' -----------------------'
          print, ' + CALLING SEQUENCE:'
          print, '   walsatools, /komega, signal=signal, time=time, arcsecpx=arcsecpx, power=p, frequencies=f, wavenumber=k'
          print
          print, ' + INPUTS:'
          print, '   signal:          [x,y,t] datacube'
          print, '                    [!] note: at present the input datacube needs to have identical x and y dimensions.'
          print, '                    if not supplied like this the datacube will be cropped accordingly.'
          print, '   cadence:         delta time between successive frames (in seconds)'
          print, '   time:            observing times in seconds (1D array). It is ignored if cadence is provided'
          print, '   arcsecpx:        pixel size (spatial sampling) in arcsec; a float number'
          print
          print, ' + OPTIONAL KEYWORDS:'
          ; ----filtering options----
          print, '   filtering:       if set, filtering is proceeded'
          print, '   f1:              lower frequency to filter - given in mHz'
          print, '   f2:              upper frequency to filter - given in mHz'
          print, '   k1:              lower wavenumber to filter - given in mHz'
          print, '   k2:              upper wavenumber to filter - given in arcsec^-1'
          print, '   spatial_torus:   if equal to zero, the annulus used for spatial filtering will not have a Gaussian-shaped profile'
          print, '   temporal_torus:  if equal to zero, the temporal filter will not have a Gaussian-shaped profile'
          print, '   no_spatial:      if set, no spatial filtering is performed'
          print, '   no_temporal:     if set, no temporal filtering is performed'
          ; ----plotting parameters----
          print, '   silent:          if set, the k-ω diagram is not plotted'
          print, '   clt:             colour table number (IDL ctload)'
          print, '   koclt:           custom colour tables for k-ω diagram (currently available: 1 and 2)'
          print, '   threemin:        if set, a horizontal line marks the three-minute periodicity'
          print, '   fivemin:         if set, a horizontal line marks the five-minute periodicity'
          print, '   xlog:            if set, x-axis (wavenumber) is plotted in logarithmic scale'
          print, '   ylog:            if set, y-axis (frequency) is plotted in logarithmic scale'
          print, '   xrange:          x-axis (wavenumber) range'
          print, '   yrange:          y-axis (frequency) range'
          print, '   nox2:            if set, 2nd x-axis (spatial size, in arcsec) is not plotted'
          print, '                    (spatial size (i.e., wavelength) = (2*!pi)/wavenumber)'
          print, '   noy2:            if set, 2nd y-axis (period, in sec) is not plotted'
          print, '                    (p = 1000/frequency)'
          print, '   smooth:          if set, power is smoothed'
          ; ----power calibration----
          print, '   mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude'
          ; ----output options----
          print, '   epsfilename:     if provided (as a string), an eps file of the k-ω diagram is made'
          print
          print, ' + OUTPUTS:'
          print, '   power:           2D array of power in log10 scale'
          print, '                    (in DN^2/mHz, i.e., normalised to frequency resolution)'
          print, '   frequencies:     1D array of frequencies (in mHz)'
          print, '   wavenumber:      1D array of wavenumber (in arcsec^-1)'
          print, '   filtered_cube:   3D array of filtered datacube (if filtering is set)'
        endif
        if m2type eq 2 then begin
          print, ' -----------------------'
          print, ' ---- 3D analysis: B-ω'
          print, ' -----------------------'
          print, ' + CALLING SEQUENCE:'
          print, '   walsatools, /bomega, signal=signal, time=time, bmap=bmap, power=p, frequencies=f, barray=b'
          print
          print, ' + INPUTS:'
          print, '   signal:          [x,y,t] datacube'
          print, '   time:            observing times in seconds (1D array)'
          print, '   bmap:            a map of magnetic fields (in G), same [x,y] size as in datacube'
          print
          print, ' + OPTIONAL KEYWORDS:'
          print, '   binsize:         size of magnetic-field bins, over which power spectra are averaged'
          print, '                    (default: 50 G)'
          print, '   silent:          if set, the B-ω diagram is not plotted'
          print, '   clt:             colour table number (IDL ctload)'
          print, '   koclt:           custom colour tables for k-ω diagram (currently available: 1 and 2)'
          print, '   threemin:        if set, a horizontal line marks the three-minute periodicity'
          print, '   fivemin:         if set, a horizontal line marks the five-minute periodicity'
          print, '   xlog:            if set, x-axis (magnetic field) is plotted in logarithmic scale'
          print, '   ylog:            if set, y-axis (frequency) is plotted in logarithmic scale'
          print, '   xrange:          x-axis (wavenumber) range'
          print, '   yrange:          y-axis (frequency) range'
          print, '   noy2:            if set, 2nd y-axis (period, in sec) is not plotted'
          print, '                    (p = 1000/frequency)'
          print, '   smooth:          if set, power is smoothed'
          print, '   normalizedbins   if set, power at each bin is normalised to its maximum value'
          print, '                    (this facilitates visibility of relatively small power)'
          print, '   xtickinterval    x-asis (i.e., magnetic fields) tick intervals in G (default: 400 G)'
          ; ----power calibration----
          print, '   mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude'
          ; ----output options----
          print, '   epsfilename:     if provided (as a string), an eps file of the k-ω diagram is made'
          print
          print, ' + OUTPUTS:'
          print, '   power:           2D array of power'
          print, '                    (in DN^2/mHz, i.e., normalised to frequency resolution)'
          print, '   frequencies:     1D array of frequencies (y-axis) in mHz'
          print, '   barray:          1D array of magnetic fields (x-axis) in G'
        endif
        print, ' -----------------------------------------------------------------------------------------'
        if m2type eq 1 then m2typecite = 'WaLSAtools: k-ω analysis'
        if m2type eq 2 then m2typecite = 'WaLSAtools: B-ω analysis'
        print, ' * CITATION:'
        print, '   Please cite the following articles if you use ' + m2typecite
        print, '   -- Jess et al. 2023, Living Reviews in Solar Physics, 20, 1'
        if m2type eq 1 then $
          print, '   -- Jess et al. 2017, ApJ, 842, 59'
        if m2type eq 2 then $
          print, '   -- Stangalini et al. 2021, A&A, in press'
        print, '      (see www.WaLSA.tools/citation)'
        print, ' -----------------------------------------------------------------------------------------'
        print
      endif
    endif
    if category eq 'b' then begin
      print, ' ----------------------------------------------------------------------------------------------'
      print, ' --- Two time-series analysis with: (1) FFT, (2) Wavelet, (3) Lomb-Scargle, (4) HHT, (5) Welch'
      print, ' ----------------------------------------------------------------------------------------------'
      c1type = ' '
      read, c1type, prompt = ' --- Type of analysis (enter the option 1-4): '
      while c1type lt 1 or c1type gt 4 do begin
        read, c1type, prompt = ' --- Please enter a number between 1 and 4: '
        if c1type eq 1 or c1type eq 2 or c1type eq 3 or c1type eq 4 then break
      endwhile
      print
      if c1type eq 1 then begin
        print, ' ------------------------------------'
        print, ' ---- cross-power analysis with FFT:'
        print, ' ------------------------------------'
        print, ' + CALLING SEQUENCE:'
        print, '   walsatools, /fft, data1=data1, data2=data2, time=time, $'
        print, '               cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f'
      endif
      if c1type eq 2 then begin
        print, ' ----------------------------------------'
        print, ' ---- cross-power analysis with Wavelet:'
        print, ' ----------------------------------------'
        print, ' + CALLING SEQUENCE:'
        print, '   walsatools, /wavelet, data1=data1, data2=data2, time=time, $'
        print, '               cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f'
      endif
      if c1type eq 3 then begin
        print, ' ---------------------------------------------'
        print, ' ---- cross-power analysis with Lomb-Scargle:'
        print, ' ---------------------------------------------'
        print, ' + CALLING SEQUENCE:'
        print, '   walsatools, /lomb, data1=data1, data2=data2, time=time, $'
        print, '               cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f'
      endif
      if c1type eq 4 then begin
        print, ' -------------------------------------'
        print, ' ---- cross-power analysis with HHT:'
        print, ' -------------------------------------'
        print, ' + CALLING SEQUENCE:'
        print, '   walsatools, /hht, data1=data1, data2=data2, time=time, $'
        print, '               cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f'
      endif
      if c1type eq 5 then begin
        print, ' ---------------------------------------------'
        print, ' ---- cross-power analysis with Welch:'
        print, ' ---------------------------------------------'
        print, ' + CALLING SEQUENCE:'
        print, '   walsatools, /welch, data1=data1, data2=data2, time=time, $'
        print, '               cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f'
      endif
      print
      print, ' + INPUTS:'
      print, '   data1:           first (1D) time series'
      print, '   data2:           second (1D) time series, co-aligned with data1'
      print, '   time:            observing times in seconds (1D array)'
      print
      print, ' + OPTIONAL KEYWORDS:'
      ; ----padding, detrending, and apodization parameters----
      print, '   padding:         oversampling factor: zero padding (default: 1)'
      print, '   apod:            extent of apodization edges (of a Tukey window); default 0.1'
      print, '   nodetrendapod:   if set, neither detrending nor apodization is performed!'
      print, '   pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2'
      print, '   polyfit:         the degree of polynomial fit to the data to detrend it'
      print, '                    if set, instead of linear fit this polynomial fit is performed'
      print, '   meantemporal:    if set, only a very simple temporal detrending is performed by'
      print, '                    subtracting the mean signal from the signal'
      print, '                    i.e., the fitting procedure (linear or higher polynomial degrees) is omitted'
      print, '   meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)'
      if c1type ne 2 then begin
        print, '   recon:           optional keyword that will Fourier reconstruct the input timeseries'
        print, '                    note: this does not preserve the amplitudes and is only useful when attempting'
        print, '                    to examine frequencies that are far away from the -untrustworthy- low frequencies'
        print, '   resample         if recon is set, then by setting resample, amplitudes are scaled to approximate actual values.'
        print, '   n_segments:      number of euqal segments (to which both datasets are broken prior to the analyses; default: 1)'
        print, '                    Each of these segments is considered an independent realisation of the underlying process.'
        print, '                    The cross spectrum for each segement are averaged together to provide phase and coherence '
        print, '                    estimates at each frequency.'
      endif
      if c1type eq 4 then begin
        ; ----HHT parameters/options----
        print, '   stdlimit:        standard deviation to be achieved before accepting an IMF'
        print, '                    (recommended value between 0.2 and 0.3; perhaps even smaller); default: 0.2'
        print, '   nfilter:         Hanning window width for two dimensional smoothing of the Hilbert spectrum. default: 3 '
        print, '                    (an odd integer, preferably equal to or larger than 3; equal to 0 to avoid the windowing)'
      endif
      if c1type eq 5 then begin
        ; ----Welch parameters/options----
        print, '   window_size:     size of Hann window. This code currently uses a Hann window (e.g., 256)'
        print, '   overlap:         commonly, the overlap is set to half the window size.'
        print, '   wfft_size:        generally, a window_size*2 is used for the FFT size to optimize the FFT performance.'
      endif
      ; ----significance-level parameters----
      print, '   siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)'
      print, '   nperm:           number of random permutations for the significance test (default: 50)'
      print, '                    note: the default value is set for quick tests. Choose a large number'
      print, '                    (e.g., 2000 or larger) for a better statistical result'
      print, '   nosignificance:  if set, no significance level is calculated'
      if c1type eq 2 then begin
        ; ----wavelet parameters/options----
        print, '   mother:          wavelet function (also depends on param). default: Morlet'
        print, '                    other available functions: Paul and DOG are available'
        print, '   param:           optional mother wavelet parameter'
        print, '                    (default: 6 (for Morlet), 4 (for Paul), 2 (for DOG; i.e., Mexican-hat)'
        print, '   dj:              spacing between discrete scales. default: 0.025'
        print, '   colornoise:      if set, noise background is based on Auchère+2017, ApJ, 838, 166'
      endif
      if c1type eq 2 then begin
        ; ----plotting----
        print, '   plot:            if set, wavelet power spectra of the two time series as well as'
        print, '                    their wavelet cospectrum (cross-spectrum) and coherence, along with the'
        print, '                    significance levels as contours, are plotted'
        print, '                    The phase angles between the two time series are also depicted by default'
        print, '                    Arrows pointing right mark zero phase (meaning in-phase oscillations),'
        print, '                    arrows pointing straight up indicate data2 lags behind data1 by 90 degrees'
        print, '   noarrow:         if set, the phase angles are not overplotted as arrows'
        print, '   arrowdensity:    number of arrows (illustrating phase angles) in x and y directions (default: [30,18])'
        print, '   arrowsize:       size of the arrows (default: 1)'
        print, '   arrowheadsize:   size of the arrows head (default: 1)'
        print, '   pownormal:       if set, the power is normalised to its maximum value'
        print, '   log:             if set, the power spectra and the cospectrum are plotted in log10 scale'
        print, '   removespace:     if set, the time-period areas affected by the CoI over the entire time range are not plotted'
        print, '   clt:             colour table number (idl ctload)'
        print, '   koclt:           custom colour tables (currently available: 1 and 2)'
      endif
      print
      print, ' + OUTPUTS:'
      if c1type eq 2 then begin
        print, '   cospectrum:      absolute values of the cross power'
        print, '                    (2D array for wavelet spectrum; 1D for global, oglobal, or rgws spectrum)'
        print, '   coherence:       wavelet coherence (same size as cospectrum)'
        print, '   phase_angle:     phase angles in degrees (same size as cospectrum)'
        print, '   frequency:       1D array of frequencies (in mHz)'
        print, '   signif_cross:    significance map for the cospectrum (same size as cospectrum)'
        print, '   scale:           the scale vector of scale indices, given by the overlap of scale1 and scale2'
        print, '                    cospectrum/signif_coh indicates regions above the siglevel'
        print, '   signif_coh:      significance map for the coherence (same size as cospectrum)'
        print, '                    coherence/signif_coh indicates regions above the siglevel'
        print, '   coi:             the vector of the cone-of-influence'
        print, '   coh_global:      global coherence averaged over all times'
        print, '   phase_global:    global phase averaged over all times'
        print, '   cross_global:    global cross wavelet averaged over all times'
        print, '   coh_oglobal:     global coherence averaged over all times excluding areas affected by CoI'
        print, '   phase_oglobal:   global phase averaged over all times excluding areas affected by CoI'
        print, '   cross_oglobal:   global cross wavelet averaged over all times excluding areas affected by CoI'
      endif
      if c1type ne 2 then begin
        print, '   cospectrum:      absolute values of the cross power (1D array)'
        print, '   coherence:       coherence (1D array)'
        print, '   phase_angle:     phase angles in degrees (1D array)'
        print, '   frequency:       1D array of frequencies (in mHz)'
        print, '   signif_cross:    significance levels for the cospectrum (1D array)'
        print, '   signif_coh:      significance levels for the coherence (1D array)'
      endif
      print, ' -----------------------------------------------------------------------------------------'
      if c1type eq 1 then c1typecite = 'WaLSAtools: cross-correlation analysis with FFT'
      if c1type eq 2 then c1typecite = 'WaLSAtools: cross-correlation analysis with Wavelet'
      if c1type eq 3 then c1typecite = 'WaLSAtools: cross-correlation analysis with Lomb-Scargle'
      if c1type eq 4 then c1typecite = 'WaLSAtools: cross-correlation analysis with HHT'
      if c1type eq 5 then c1typecite = 'WaLSAtools: cross-correlation analysis with Welch'
      print, ' * CITATION:'
      print, '   Please cite the following article if you use ' + c1typecite
      print, '   -- Jess et al. 2023, Living Reviews in Solar Physics, 20, 1'
      print, '      (see www.WaLSA.tools/citation)'
      print, ' -----------------------------------------------------------------------------------------'
      print
    endif
    return
  endif else print
  ; -----------------------------------------------------------------------
  if keyword_set(signal) then begin
    ii = where(~finite(signal), /null, cnull)
    if cnull gt 0 then signal[ii] = median(signal)
    if min(signal) ge max(signal) then begin
      print, ' [!] The signal does not have any (temporal) variation.'
      print
      return
    endif
    ; -----------------------------------------------------------------------
    if keyword_set(fft) or keyword_set(wavelet) or keyword_set(lombscargle) or keyword_set(hht) or keyword_set(welch) then $
      power = walsa_speclizer(signal, time, $ ; main inputs
        frequencies = frequencies, significance = significance, imf = imf, instantfreq = instantfreq, averagedpower = averagedpower, period = period, $ ; main (additional) outputs
        fft = fft, lombscargle = lombscargle, wavelet = wavelet, hht = hht, welch = welch, $ ; type of analysis
        padding = padding, apod = apod, nodetrendapod = nodetrendapod, pxdetrend = pxdetrend, meandetrend = meandetrend, $ ; padding and apodization parameters
        polyfit = polyfit, meantemporal = meantemporal, recon = recon, resample_original = resample_original, psd = psd, $
        siglevel = siglevel, nperm = nperm, nosignificance = nosignificance, $ ; significance-level parameters
        mother = mother, param = param, dj = dj, global = global, coi = coi, oglobal = oglobal, rgws = rgws, colornoise = colornoise, $ ; Wavelet parameters/options
        stdlimit = stdlimit, nfilter = nfilter, emd = emd, $ ; HHT parameters/options
        window_size = window_size, overlap = overlap, wfft_size = wfft_size, $ ; Welch parameters
        mode = mode, silent = silent, $ ; power calibration
        dominantfreq = dominantfreq, rangefreq = rangefreq, nodominantfreq = nodominantfreq, dominantpower = dominantpower, amplitude = amplitude) ; dominant frequency
    ; -----------------------------------------------------------------------
    if keyword_set(komega) then $
      walsa_qub_queeff, signal, arcsecpx, cadence = cadence, time = time, $
      power = power, wavenumber = wavenumber, frequencies = frequencies, filtered_cube = filtered_cube, $ ; main (additional) outputs
      filtering = filtering, f1 = f1, f2 = f2, k1 = k1, k2 = k2, spatial_torus = spatial_torus, temporal_torus = temporal_torus, $ ; filtering options
      no_spatial_filt = no_spatial_filt, no_temporal_filt = no_temporal_filt, $
      clt = clt, koclt = koclt, threemin = threemin, fivemin = fivemin, xlog = xlog, ylog = ylog, xrange = xrange, yrange = yrange, $ ; plotting keywords
      epsfilename = epsfilename, noy2 = noy2, nox2 = nox2, smooth = smooth, silent = silent, mode = mode
    ; -----------------------------------------------------------------------
    if keyword_set(bomega) then $
      walsa_bomega, signal, Bmap, cadence = cadence, time = time, binsize = binsize, power = power, frequencies = frequencies, barray = Barray, $
      silent = silent, clt = clt, koclt = koclt, threemin = threemin, fivemin = fivemin, xlog = xlog, ylog = ylog, $ ; plotting keywords
      xrange = xrange, yrange = yrange, epsfilename = epsfilename, noy2 = noy2, smooth = smooth, normalizedbins = normalizedbins, $
      xtickinterval = xtickinterval, mode = mode
  endif
  ; -----------------------------------------------------------------------
  if keyword_set(data1) and keyword_set(data2) then begin
    ii = where(~finite(data1), /null, cnull)
    if cnull gt 0 then data1[ii] = median(data1)
    ii = where(~finite(data2), /null, cnull)
    if cnull gt 0 then data2[ii] = median(data2)
    if keyword_set(fft) or keyword_set(lombscargle) or keyword_set(hht) or keyword_set(welch) then $
      walsa_cross_spectrum, data1 = data1, data2 = data2, time = time, phase_angle = phase_angle, coherence = coherence, frequencies = frequencies, cospectrum = cospectrum, $
      fft = fft, lombscargle = lombscargle, hht = hht, welch = welch, $ ; type of analysis
      padding = padding, apod = apod, nodetrendapod = nodetrendapod, pxdetrend = pxdetrend, meandetrend = meandetrend, $ ; padding and apodization parameters
      polyfit = polyfit, meantemporal = meantemporal, recon = recon, resample_original = resample_original, $
      stdlimit = stdlimit, nfilter = nfilter, $ ; HHT parameters/options
      nosignificance = nosignificance, signif_coh = signif_coh, signif_cross = signif_cross, n_segments = n_segments, d1_power = d1_power, d2_power = d2_power
    if keyword_set(wavelet) then $
      walsa_wavelet_cross_spectrum, data1, data2, time, $ ; main inputs
      mother = mother, param = param, dj = dj, colornoise = colornoise, $
      coherence = coherence, phase_angle = phase_angle, $
      scale = scale, coi = coi, $
      coh_global = coh_global, phase_global = phase_global, cross_global = cross_global, $
      coh_oglobal = coh_oglobal, phase_oglobal = phase_oglobal, cross_oglobal = cross_oglobal, $
      cospectrum = cospectrum, period = period, $
      frequency = frequency, signif_coh = signif_coh, signif_cross = signif_cross, $
      padding = padding, apod = apod, nodetrendapod = nodetrendapod, pxdetrend = pxdetrend, meandetrend = meandetrend, $
      polyfit = polyfit, meantemporal = meantemporal, $
      nosignificance = nosignificance, pownormal = pownormal, siglevel = siglevel, $
      plot = plot, clt = clt, log = log, nperm = nperm, removespace = removespace, koclt = koclt, $
      arrowdensity = arrowdensity, arrowsize = arrowsize, arrowheadsize = arrowheadsize, noarrow = noarrow
    return
  endif
  ; ----------------------------------------------------------------------
end
