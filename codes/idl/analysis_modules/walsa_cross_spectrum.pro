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
; NAME: WaLSA_cross_spectrum
;       part of -- WaLSAtools --
;
; PURPOSE:
; 
;   Calculate cross-spectral relationships of two time series whose amplitudes and powers
;             are computed using the WaLSA_speclizer routine.
;             The cross-spectrum is complex valued, thus its magnitude is returned as the
;             co-spectrum. The phase lags between the two time series are are estimated 
;             from the imaginary and real arguments of the complex cross spectrum.
;             The coherence is calculated from the normalized square of the amplitude 
;             of the complex cross-spectrum
;
; CALLING SEQUENCE:
;   walsa_cross_spectrum(data1=data1,data2=data2,time=time,phase_angle=phase_angle,coherence=coherence,cospectrum=cospectrum,frequencies=frequencies)
;
; + INPUTS:
;           
;   data1:    first (1D) time series
;   data2:    second (1D) time series, co-aligned with data1
;   time:     observing times in seconds (1D array)
;
; + OPTIONAL KEYWORDS:
; ----type of analysis----
;   fft:            if set, Fast Fourier Transform (FFT) power spectrum is computed: for regular (evenly sampled) time series.
;   lombscargle:    if set, Lomb-Scargle power spectrum is computed: for irregular (unevenly sampled) time series.
;   hht:            if set, a power spectrum associated to EMD + Hilbert Transform is computed: for regular (evenly sampled) time series.
; ----padding, detrending, and apodization parameters----
;   padding:        oversampling factor: zero padding (increasing timespan) to increase frequency resolution (NOTE: doesn't add information)
;   apod:           extent of apodization edges (of a Tukey window); default 0.1
;   nodetrendapod:  if set, neither detrending nor apodization is performed!
;   pxdetrend:      subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2
;   polyfit:        the degree of polynomial fit to the data to detrend it.
;                   if set, instead of linear fit this polynomial fit is performed.
;   meantemporal:   if set, only a very simple temporal detrending is performed by subtracting the mean signal from the signal.
;                   i.e., the fitting procedure (linear or higher polynomial degrees) is omitted.
;   meandetrend:    if set, subtract linear trend with time for the image means (i.e., spatial detrending)
;   recon:          optional keyword that will Fourier reconstruct the input timeseries.
;                   note: this does not preserve the amplitudes and is only useful when attempting 
;                   to examine frequencies that are far away from the 'untrustworthy' low frequencies.
; ----significance-level parameters----
;   siglevel:       significance level (default: 0.05 = 5% significance level = 95% confidence level)
;   nperm:          number of random permutations for the significance test -- the larger the better (default: 1000)
;   nosignificance: if set, no significance level is calculated.
; ----HHT parameters/options----
;   stdlimit:       standard deviation to be achieved before accepting an IMF (recommended value between 0.2 and 0.3; perhaps even smaller); default: 0.2
;   nfilter:        Hanning window width for two dimensional smoothing of the Hilbert spectrum. default: 3 
;                   (an odd integer, prefrabely equal to or larger than 3; equal to 0 to avoid the windowing)
;
;	n_segments:     number of euqal segments (to which both datasets are broken prior to the analyses; default: 1)
;					Each of these segments is considered an independent realisation of the underlying process. 
;					The cross spectrum for each segement are averaged together to provide phase and coherence estimates at each frequency.
;
; + OUTPUTS:
;
;   cospectrum:     co-spectrum, i.e., magnitude of the complex cross spectrum
;   frequencies:    an array of frequencies. unit: mHz
;   phase_angle:    phase angles
;   coherence:      coherence of two series
;   signif_cross:   significance levels for the cospectrum (1D array)
;   signif_coh:     significance levels for the coherence (1D array)
;	d1_power:		power spectrum of data1
;	d2_power:		power spectrum of data2
;
;  Shahin Jafarzadeh & David B. Jess | WaLSA Team
;  + some routines/recipe from CROSS_SPECTRUM.pro of Simon Vaughan
;-

function walsa_getcross_spectrum, data1, data2, time, phase_angle=phase_angle, coherence=coherence, frequencies=frequencies, $
                                     fft=fft, lombscargle=lombscargle, hht=hht,$ ; type of analysis
                                     padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
                                     polyfit=polyfit, meantemporal=meantemporal, recon=recon,$
                                     stdlimit=stdlimit, nfilter=nfilter, n_segments=n_segments, d1_power=d1_power, d2_power=d2_power

  cadence=walsa_mode(walsa_diff(time))
  nt = n_elements(data1)
  ; number of segments
  if (n_elements(n_segments) eq 0) then n_segments=1 ; number of segments to break the time series into.
  mn = nt/n_segments
  n_cut = mn*n_segments
  x_1 = reform(data1[0:n_cut-1],mn,n_segments)
  x_2 = reform(data2[0:n_cut-1],mn,n_segments)
  xtime = reform(time[0:n_cut-1],mn,n_segments)
 
  
  frequencies = 1./(cadence*2)*findgen(mn/2+1)/(mn/2)
  nff=n_elements(frequencies)
  frequencies = frequencies[1:nff-1]
  frequencies = frequencies*1000. ; in mHz
  nf=n_elements(frequencies)

  amplitude1 = complexarr(nf,n_segments)
  amplitude2 = complexarr(nf,n_segments)

  for iseg=0L, n_segments-1 do begin

  	  power1s = walsa_speclizer(reform(x_1[*,iseg]),reform(xtime[*,iseg]),$ ; main inputs
  	                          frequencies=frequencies,amplitude=amplitude1s,$ ; main (additional) outputs
  	                          fft=fft, lombscargle=lombscargle, hht=hht,$ ; type of analysis
  	                          padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
  	                          polyfit=polyfit,meantemporal=meantemporal,recon=recon,$
  	                          nosignificance=1,$ ; significance-level parameters
  	                          stdlimit=stdlimit, nfilter=nfilter, $ ; HHT parameters/options
  	                          mode=1, /silent) ; power calibration

  	  power2s = walsa_speclizer(reform(x_2[*,iseg]),reform(xtime[*,iseg]),$ ; main inputs
  	                          frequencies=frequencies,amplitude=amplitude2s,$ ; main (additional) outputs
  	                          fft=fft, lombscargle=lombscargle, hht=hht,$ ; type of analysis
  	                          padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
  	                          polyfit=polyfit,meantemporal=meantemporal,recon=recon,$
  	                          nosignificance=1,$ ; significance-level parameters
  	                          stdlimit=stdlimit, nfilter=nfilter, $ ; HHT parameters/options
  	                          mode=1, /silent) ; power calibration

  	  amplitude1[*,iseg] = amplitude1s
  	  amplitude2[*,iseg] = amplitude2s
  endfor
  amplitude1 = reform(amplitude1)
  amplitude2 = reform(amplitude2)
  
  power1 = abs(amplitude1)^2
  power2 = abs(amplitude2)^2
  
  ; complex cross-power spectrum
  cross_power = amplitude1 * CONJ(amplitude2)
  ; co-spectrum (real parts of cross-power spectrum)
  cospectrum = ABS(cross_power)
; ----------------------------------------------------------
; Average over the ensamble of time series segments and adjacent frequencies
; average the second-order quantities: C, P_1, P_2 over the ensemble of M segments
  if (n_segments gt 1) then begin
      binC = total(cross_power,2)/float(n_segments)
      binP_1 = total(power1,2)/float(n_segments)
      binP_2 = total(power2,2)/float(n_segments)
  endif else begin
      binC = cross_power
      binP_1 = power1
      binP_2 = power2
  endelse
; ----------------------------------------------------------
; calculate coherence
  coherence = abs(binC)^2 / (binP_1 * binP_2)
; calculate the phase lag (phase of complex cross spectrum)
  phase_angle = atan(binC,/phase)*(180./!pi)
; ----------------------------------------------------------
  cospectrum = abs(binC)
  
  d1_power=binP_1
  d2_power=binP_2

return, cospectrum
end
;==================================================== MAIN ROUTINE ====================================================
pro walsa_cross_spectrum, data1=data1, data2=data2, time=time, phase_angle=phase_angle, coherence=coherence, frequencies=frequencies, cospectrum=cospectrum, $
                             fft=fft, lombscargle=lombscargle, hht=hht, welch=welch,$ ; type of analysis
                             padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
                             polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original,nperm=nperm,siglevel=siglevel,$
                             stdlimit=stdlimit, nfilter=nfilter, $ ; HHT parameters/options
                             nosignificance=nosignificance, signif_coh=signif_coh, signif_cross=signif_cross, n_segments=n_segments, d1_power=d1_power, d2_power=d2_power

 if n_elements(nosignificance) eq 0 then nosignificance = 0 
 if n_elements(nperm) eq 0 then nperm = 50 
 if n_elements(siglevel) eq 0 then siglevel=0.05 ; 5% significance level = 95% confidence level
 
 time1 = time & time2 = time
 
 if n_elements(silent) eq 0 then silent=0

 sizecube1 = size(reform(data1))
 sizecube2 = size(reform(data2))

 givewarning = 0
 if sizecube1[0] eq 1 and sizecube1[0] eq 1 then begin 
     if sizecube1[1] ne sizecube1[1] then givewarning = 1
     if n_elements(time) ne sizecube1[1] then givewarning = 1
     if n_elements(time) ne sizecube2[1] then givewarning = 1
 endif else givewarning = 1
 if givewarning eq 1 then begin
      print, ' '
      print, ' [!] data1, data2, and time must be one diemnsional and have identical lengths.'
      print, ' '
      stop
 endif

 if silent eq 0 then begin
     cadence=walsa_mode(walsa_diff(time))
     temporal_Nyquist = 1. / (cadence * 2.)
     print,' '
     print,'The input datacubes are of size: ['+ARR2STR(sizecube1[1],/trim)+']'
     print,'Temporally, the important values are:'
     print,'    2-element duration (Nyquist period) = '+ARR2STR((cadence * 2.),/trim)+' seconds'
     print,'    Time series duration = '+ARR2STR(cadence*sizecube1[1],/trim)+' seconds'
     print,'    Nyquist frequency = '+ARR2STR(temporal_Nyquist*1000.,/trim)+' mHz'
     print, ' '
 endif

 cospectrum = walsa_getcross_spectrum(data1, data2, time, phase_angle=phase_angle, coherence=coherence, frequencies=frequencies, $
                                     fft=fft, lombscargle=lombscargle, hht=hht,$ ; type of analysis
                                     padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
                                     polyfit=polyfit, meantemporal=meantemporal, recon=recon,$
                                     stdlimit=stdlimit, nfilter=nfilter, n_segments=n_segments, d1_power=d1_power, d2_power=d2_power)
 
 d1_power = d1_power/frequencies[0] ; in DN^2/mHz
 d2_power = d2_power/frequencies[0] ; in DN^2/mHz

 if nosignificance eq 0 then begin
     nf = n_elements(frequencies)
     ndata1 = n_elements(data1)
     dt1 = walsa_mode(walsa_diff(time1))
     ndata2 = n_elements(data2)
     dt2 = round(walsa_mode(walsa_diff(time2)))

     coh_perm = fltarr(nf,nperm)
     cross_perm = fltarr(nf,nperm)
     for ip=0L, nperm-1 do begin
         permutation1 = walsa_randperm(ndata1)
         y_perm1 = data1(permutation1)
         permutation2 = walsa_randperm(ndata2)
         y_perm2 = data2(permutation2)
         cospectrumsig = walsa_getcross_spectrum(y_perm1, y_perm2, time, coherence=cohsig, $
                                     fft=fft, lombscargle=lombscargle, hht=hht,$ ; type of analysis
                                     padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
                                     polyfit=polyfit, meantemporal=meantemporal, recon=recon,$
                                     stdlimit=stdlimit, nfilter=nfilter, n_segments=n_segments)

         coh_perm[*,ip] = cohsig
         cross_perm[*,ip] = cospectrumsig
         if ip eq 0 then PRINT
         print,string(13b)+' >>> % Running Monte Carlo (significance): ',(ip*100.)/(nperm-1),format='(a,f4.0,$)'
     endfor
     PRINT
     PRINT
     signif_coh = walsa_confidencelevel(coh_perm, siglevel=siglevel, nf=nf)
     signif_cross = walsa_confidencelevel(cross_perm, siglevel=siglevel, nf=nf)
 endif
 
 print, ''
 print, 'COMPLETED!'
 print,''

end