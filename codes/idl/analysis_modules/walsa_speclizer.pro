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
; NAME: WaLSA_speclizer: WaLSA Spectral Analyzer
;       part of -- WaLSAtools --
;
; PURPOSE:
;   Compute power spectrum and its statistical significance level for a 1D signal 
;           (or all pixels of an image sequence, i.e., a 3D cube) using 
;           FFT (Fast Fourier Transform), Lomb-Scargle, Wavelet, or 
;           HHT (Hilbert-Huang Transform) analyses.
;           -- Signals are detrended (linearly or using higher-order polynomial fits) and 
;              apodized (using a Tukey window) prior to the spectral analysis (unless otherwise it is omitted).
;           -- Power (and significance levels) are returned in DN^2/mHz, frequencies in mHz.
;
; CALLING SEQUENCE:
;   EXAMPLES:
;   power = walsa_speclizer(cube,time,mode=1,/fft,frequency=frequency,significance=significance,siglevel=0.01)
;   power = walsa_speclizer(cube,time,mode=1,/wavelet,/global,frequency=frequency,significance=significance)
;
; + INPUTS:
;   data:           1D time series, or (x,y,t) datacube, any type
;                   (an ordered sequence of data points, typically some variable quantity measured at successive times.)
;   time:           observing times of the time series in seconds
;
; + OPTIONAL KEYWORDS:
; ----type of analysis----
;   fft:            if set, Fast Fourier Transform (FFT) power spectrum is computed: for regular (evenly sampled) time series.
;   lombscargle:    if set, Lomb-Scargle power spectrum is computed: for irregular (unevenly sampled) time series.
;   hht:            if set, a power spectrum associated to EMD + Hilbert Transform is computed: for regular (evenly sampled) time series.
;   wavelet:        if set, Wavelet power spectrum is computed (default: Morlet function with omega=6): for regular (evenly sampled) time series.
;   welch:          if set, Welch power spectrum is computed
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
;   resample         if recon is set, then by setting resample, amplitudes are scaled to approximate actual values.
; ----significance-level parameters----
;   siglevel:       significance level (default: 0.05 = 5% significance level = 95% confidence level)
;   nperm:          number of random permutations for the significance test -- the larger the better (default: 1000)
;   nosignificance: if set, no significance level is calculated.
; ----power calibration----
;   mode:           outputted power mode: 0 = log(power), 1 = linear power (default), 2 = sqrt(power) = amplitude
; ----wavelet parameters/options----
;   mother:         wavelet function, providing different localisation/resolution in frequency and in time (also depends on param, m).
;                   currently, 'Morlet','Paul','DOG' (derivative of Gaussian) are available. default: 'Morlet'.
;   param:          optional mother wavelet parameter. 
;                   For 'Morlet' this is k0 (wavenumber), default is 6. 
;                   For 'Paul' this is m (order), default is 4.
;                   For 'DOG' this is m (m-th derivative), default is 2 (i.e., the real-valued Mexican-hat wavelet)
;   dj:             spacing between discrete scales. default: 0.025
;   global:         only if wavelet is set: returns global wavelet spectrum (averaged over time domain)
;   oglobal:        global wavelet spectrum excluding regions influenced by cone-of-influence (CoI; regions subject to edge effect)
;   rgws:       time-integral of wavelet power excluding regions influenced by cone-of-influence and only for those above the confidence level
;                   this returns power-weighted frequency distribution (with significant power & unaffected by CoI)
;                   Note: this is likely the most correct spectrum!
;   colornoise:     if set, noise background is based on Auchère et al. 2017, ApJ, 838, 166 / 2016, ApJ, 825, 110
; ----HHT parameters/options----
;   stdlimit:       standard deviation to be achieved before accepting an IMF (recommended value between 0.2 and 0.3; perhaps even smaller); default: 0.2
;   nfilter:        Hanning window width for two dimensional smoothing of the Hilbert spectrum. default: 3 
;                   (an odd integer, prefrabely equal to or larger than 3; equal to 0 to avoid the windowing)
;   emd:            if set, intrinsic mode functions (IMFs) and their associated frequencies (i.e., instantaneous frequencies) are outputted
; ----dominant frequency----
;   nodominantfreq: if set, dominant frequency and dominant power are not calculated (to, e.g., save computational time for large datasets)
;
; + OUTPUTS:
;   power:          a 1D array of power (or a 3D array if the input is a 3D cube).
;                   the only exception is for wavelet (where global is not set).
;                   power is divided by the first (non-zero) frequency. unit: DN^2/mHz
;   significance:   significance levels, with the same dimension as the power. unit: DN^2/mHz
;   frequency:      an array of frequencies, with the same size as the power. unit: mHz
;   period:         1D array of periods (in seconds)
;   coicube:        cone-of-influence cube, only when wavelet analysis is performed --> if wavelet is set
;   imf:            the intrinsic mode functions (IMFs) from EMD alalysis within the HHT --> if hht and emd are set
;   instantfreq:    instantaneous frequencies of each component time series --> if hht and emd are set
;   dominantfreq:   dominant frequency, i.e., frequency corresponding to the maximum power (in mHz): same saptial size as input data (i.e., 1D or 2D)
;                   note: if there are multiple peaks with the exact same power, the lowest dominant frequency is returned!
;   dominantpower:  power (in DN^2/mHz) corresponding to the dominant frequency: same saptial size as input data (i.e., 1D or 2D)
;   rangefreq:      frequency range over which the dominant frequency is computed. default: full frequency range
;   averagedpower:  spatially averaged power spectrum (of multiple 1D power spectra). unit: DN^2/mHz
;   amplitude:      a 1D array of oscillation amplitude (or a 3D array if the input is a 3D cube).
;
; MODIFICATION HISTORY
;
;  2010 plotpowermap: Rob Rutten, assembly of Alfred de Wijn's routines 
;                     (https://webspace.science.uu.nl/~rutte101/rridl/cubelib/plotpowermap.pro)
;  2014-2021 Extensively modified/extended by Shahin Jafarzadeh, with contributions from Marco Stangalini and David B. Jess
;-

;---------------------------- HHT (EMD + Hilbert) -----------------------------
function getpowerHHT,cube,cadence,stdlimit,nfilter=nfilter,significance=significance,siglevel=siglevel,nperm=nperm,padding=padding,$
                     frequencies=frequencies,nosignificance=nosignificance,emd=emd,imf=imf,instantfreq=instantfreq,averagedpower=averagedpower,$
                     dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,amplitude=amplitude,$
                     originalcube=originalcube,apod=apod,nodetrendapod=nodetrendapod,pxdetrend=pxdetrend,meandetrend=meandetrend,polyfit=polyfit,$
                     meantemporal=meantemporal,recon=recon,resample_original=resample_original,silent=silent
  ; Hilbert-Huang Transform (HHT) power spectra
  
  if padding gt 1 then begin ; zero padding (optional): to increase frequency resolution
	  if silent eq 0 then begin
	      print, ' '
	      print, ' -- Zero Padding (oversampling factor: '+strtrim(padding,2)+') .....'
	      print, ' '
	  endif
      nx = n_elements(cube[*,0,0])
      ny = n_elements(cube[0,*,0])
      nt = n_elements(cube[0,0,*])      
      padded=fltarr(nx,ny,padding*nt)
      mid_point = ROUND((padding*nt)/2.)
      lower_point = mid_point-nt/2.
      upper_point = mid_point+nt/2.-1
      padded[*,*,mid_point-nt/2.:mid_point+nt/2.-1] = cube
      cube = padded
  endif
  sizecube=size(cube)
  nx=sizecube[1]
  ny=sizecube[2]
  nt=sizecube[3]
  
  if silent eq 0 then begin
	  print, ' '
	  print, ' ...... output Marginal HHT Spectra '
	  print, ' '
  endif
  
  dt = cadence
  IMFcal = walsa_emd_function(reform(cube[0,0,*]),stdlimit,dt=dt)
  hhs = walsa_hilbert_spec(IMFcal,dt,freq=frequencies, marginal=pm, nfilter=nfilter)
  nff= n_elements(frequencies)
  if frequencies[0] eq 0 then begin
    frequencies = frequencies[1:nff-1]
    pm = pm[1:nff-1]
    f0 = 1
  endif else f0 = 0
  nf= n_elements(frequencies)
  frequencies = frequencies*1000. ; in mHz
  
  powermap=fltarr(nx,ny,nf) ; HHT power spectra
  amplitude=fltarr(nx,ny,nf)
  
  if emd then begin
      imf = fltarr(nx,ny,nt,20) ; 20: maximum number of IMFs that can be created
      instantfreq = fltarr(nx,ny,nt,20)
  endif
  if nosignificance eq 0 then significance=fltarr(nx,ny,nf) ; significancec cube
  if nodominantfreq eq 0 then begin
      dominantfreq=fltarr(nx,ny) ; dominant-frequency map
      dominantpower=fltarr(nx,ny) ; dominant-power map (i.e., powers corresponding to dominant frequencies)
  endif
  averagedpower = fltarr(nf)
  for ix=0, nx-1 do begin
      for iy=0, ny-1 do begin
          signal=reform(cube[ix,iy,*])
          IMFcal = walsa_emd_function(signal,stdlimit,dt=dt)
          hhs = walsa_hilbert_spec(IMFcal,dt, marginal=pm, nfilter=nfilter, instfreq=instfreq, amplitudemarginal=amplitudemarginal)
          nimimf = n_elements(IMFcal[0,*])
          if emd then begin
              imf[ix,iy,*,0:nimimf-1] = IMFcal
              instantfreq[ix,iy,*,0:nimimf-1] = instfreq*1000. ; instantaneous frequencies in mHz
          end
          if f0 then powermap[ix,iy,*] = (pm[1:nff-1]*padding)/frequencies[0] else powermap[ix,iy,*] = (pm*padding)/frequencies[0] ; in DN^2/mHz
          amplitude[ix,iy,*] = amplitudemarginal[1:nff-1]*padding
          
          if nodominantfreq eq 0 then begin
              dominantfreq[ix,iy] = walsa_dominant_frequency(reform(powermap[ix,iy,*]),frequencies,rangefreq,dominantpower=dompm)
              dominantpower[ix,iy] = dompm
          endif
          
          if nosignificance eq 0 then begin
              Nsig = n_elements(signal)
              ps_perm = fltarr(nf,nperm)
              for ip=0L, nperm-1 do begin
                  permutation = walsa_randperm(Nsig)
                  signalo=reform(originalcube[ix,iy,*]) 
                  y_perm = signalo(permutation)
                  if nodetrendapod eq 0 then $
                     y_perm=walsa_detrend_apod(y_perm,apod,meandetrend,pxdetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original,cadence=cadence,/silent) 
                  IMFcal = walsa_emd_function(y_perm,stdlimit,dt=dt)
                  hhs = walsa_hilbert_spec(IMFcal,dt, marginal=pstmp, nfilter=nfilter)
                  ps_perm[*,ip] = pstmp[1:nff-1]
                  if silent eq 0 then print,string(13b)+' >>> % Running Monte Carlo (significance test): ',(ip*100.)/(nperm-1),format='(a,f4.0,$)'
              endfor
              signif = walsa_confidencelevel(ps_perm, siglevel=siglevel, nf=nf)
              significance[ix,iy,*] = (signif*padding)/frequencies[0] ; in DN^2/mHz
          endif
          averagedpower = averagedpower+reform(powermap[ix,iy,*])
      endfor
      if long(nx) gt 1 then $ 
         writeu,-1,string(format='(%"\r == HHT next row... ",i5,"/",i5)',ix,nx)
  endfor
  powermap = reform(powermap)
  frequencies = reform(frequencies)
  amplitude = reform(amplitude)
  averagedpower = reform(averagedpower/float(nx)/float(ny))
  if emd then begin
      imf = reform(imf)
      instantfreq = reform(instantfreq)
  endif
  if nodominantfreq eq 0 then begin
      dominantfreq = reform(dominantfreq)
      dominantpower = reform(dominantpower)
  endif
  if nosignificance eq 0 then significance = reform(significance)
  
  return, powermap
end
;--------------------------------- Lomb-Scargle -------------------------------
function getpowerLS,cube,time,OFAC=OFAC,siglevel=siglevel,frequencies=frequencies,significance=significance,nperm=nperm,$
                    nosignificance=nosignificance,averagedpower=averagedpower,amplitude=amplitude,originalcube=originalcube,$
                    dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,$
                    apod=apod,nodetrendapod=nodetrendapod,pxdetrend=pxdetrend,meandetrend=meandetrend,polyfit=polyfit,$
                    meantemporal=meantemporal,recon=recon,resample_original=resample_original,silent=silent
  ; Lomb-scargle power spectra
  ; The periodogram values (from LNP_TEST) are converted to power (comparable to FFT values) by myltiplying
  ; with 2.*variance(signal,/double)/nt (see Numerical Recipes in C: The Art of Scientific Computing; Press at al. 2007)
  
  sizecube=size(cube)
  nx=sizecube[1]
  ny=sizecube[2]
  nt=sizecube[3]
  
  if OFAC gt 1 then begin
	  if silent eq 0 then begin
		  print, ' '
		  print, ' -- Zero Padding (oversampling factor: '+strtrim(OFAC,2)+') .....'
		  print, ' '
	  endif
  endif
  
  r = LNP_TEST(reform(time), reform(cube[0,0,*]), /DOUBLE, WK1=frequencies, WK2=pm, OFAC=OFAC)
  frequencies = frequencies*1000. ; in mHz
  nf=n_elements(frequencies)
  powermap=fltarr(nx,ny,nf) ; Lomb-scargle power spectra
  amplitude=fltarr(nx,ny,nf)
  if nosignificance eq 0 then significance=fltarr(nx,ny,nf) ; significancec cube
  if nodominantfreq eq 0 then begin
      dominantfreq=fltarr(nx,ny) ; dominant-frequency map
      dominantpower=fltarr(nx,ny) ; dominant-power map (i.e., powers corresponding to dominant frequencies)
  endif
  averagedpower = fltarr(nf)
  for ix=0, nx-1 do begin
      for iy=0, ny-1 do begin
          signal = reform(cube[ix,iy,*])
          r = LNP_TEST(reform(time), signal, /DOUBLE, WK1=freq, WK2=pm, OFAC=OFAC)
          powermap[ix,iy,*] = ((pm*(2.*variance(signal,/double)/nt))*OFAC)/frequencies[0] ; in DN^2/mHz
          
          amplitude[ix,iy,*] = sqrt(((2.*pm*(2.*variance(signal,/double)/nt))*OFAC)) ; K. Hocke 1998, Ann. Geophysics, 16, 356
          
          if nodominantfreq eq 0 then begin
              dominantfreq[ix,iy] = walsa_dominant_frequency(reform(powermap[ix,iy,*]),frequencies,rangefreq,dominantpower=dompm)
              dominantpower[ix,iy] = dompm
          endif
          
          if nosignificance eq 0 then begin
              Nsig = n_elements(signal)
              ps_perm = fltarr(nf,nperm)
              for ip=0L, nperm-1 do begin
                  permutation = walsa_randperm(Nsig)
                  signalo=reform(originalcube[ix,iy,*]) 
                  y_perm = signalo(permutation)
                  if nodetrendapod eq 0 then $
                     y_perm=walsa_detrend_apod(y_perm,apod,meandetrend,pxdetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original,cadence=cadence,/silent)
                  results = LNP_TEST(time, y_perm, /DOUBLE, WK1=freq, WK2=psp, OFAC=OFAC)
                  ps_perm[*,ip] = psp*(2.*variance(y_perm,/double)/nt)
                  if silent eq 0 then print,string(13b)+' >>> % Running Monte Carlo (significance test): ',(ip*100.)/(nperm-1),format='(a,f4.0,$)'
              endfor
              signif = walsa_confidencelevel(ps_perm, siglevel=siglevel, nf=nf)
              significance[ix,iy,*] = (signif*OFAC)/frequencies[0] ; in DN^2/mHz
          endif
          averagedpower = averagedpower+reform(powermap[ix,iy,*])
      endfor
      if long(nx) gt 1 then $ 
         writeu,-1,string(format='(%"\r == Lomb-Scargle next row... ",i5,"/",i5)',ix,nx)
  endfor
  powermap = reform(powermap)
  frequencies = reform(frequencies)
  amplitude = reform(amplitude)
  averagedpower = reform(averagedpower/float(nx)/float(ny))
  if nodominantfreq eq 0 then begin
      dominantfreq = reform(dominantfreq)
      dominantpower = reform(dominantpower)
  endif
  if nosignificance eq 0 then significance = reform(significance)
  
  return, powermap
end
;----------------------------------- Welch ---------------------------------
function welch_psd,cube,cadence,frequencies=frequencies,window_size=window_size,overlap=overlap,wfft_size=wfft_size, significance=significance,$
                     nperm=nperm,nosignificance=nosignificance,averagedpower=averagedpower, originalcube=originalcube,siglevel=siglevel, $
                     dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,apod=apod,silent=silent,$
                     nodetrendapod=nodetrendapod,pxdetrend=pxdetrend,meandetrend=meandetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original

    ; Initialize variables
    sizecube=size(cube)
    nx=sizecube[1]
    ny=sizecube[2]
    nt=sizecube[3]

    ; Assume wfft_size (nfft) is equal to window_size for simplicity and clarity
    wfft_size = window_size

    step_size = window_size-overlap
    num_segments = fix((nt-overlap)/step_size)
    if num_segments le 0 then begin
		PRINT, ' Number of segments: '+strtrim(num_segments, 2)+' (!)'
        PRINT, ' Error: Overlap or window size too large.'
        stop
	endif
	
    ; Create a Hann window (this should be a changable option in future versions)
    window = (1.0-cos(2 *!pi*findgen(window_size)/(window_size-1)))/2.0
	
	frequencies = 1./(cadence*2)*findgen(window_size/2+1)/(window_size/2)
	nff=n_elements(frequencies)
	frequencies = frequencies[1:nff-1]
	frequencies = frequencies*1000. ; in mHz
	nf=n_elements(frequencies)
    powermap=fltarr(nx,ny,nf) ; Welch power spectra
    if nosignificance eq 0 then significance=fltarr(nx,ny,nf) ; significance cube
    if nodominantfreq eq 0 then begin
        dominantfreq=fltarr(nx,ny) ; dominant-frequency map
        dominantpower=fltarr(nx,ny) ; dominant-power map (i.e., powers corresponding to dominant frequencies)
    endif
    averagedpower = fltarr(nf)

    for ix=0, nx-1 do begin
        for iy=0, ny-1 do begin
            signal = reform(cube[ix,iy,*])
		    ; Process each segment
			psd = FLTARR(window_size / 2 + 1)
		    for segment = 0L, num_segments-1 do begin
		        start_index = segment * step_size
		        end_index = start_index + window_size
		        if end_index gt nt then continue
		        ; Extract the segment and apply the window
		        segment_data = signal[start_index:end_index]*window
		        ; Compute the FFT
		        segment_fft = FFT(segment_data, wfft_size)
		        ; Compute power spectral density
		        segment_psd = (ABS(segment_fft))^2/(window_size*wfft_size)
		        psd = psd + segment_psd[0:window_size / 2]

			endfor
		    ; Normalize the averaged PSD
			psd = psd / num_segments
		    powermap[ix,iy,*] = psd[1:nff-1] / frequencies[0] ; in DN^2/mHz

  		    if nodominantfreq eq 0 then begin
                dominantfreq[ix,iy] = walsa_dominant_frequency(reform(powermap[ix,iy,*]),frequencies,rangefreq,dominantpower=dompm)
                dominantpower[ix,iy] = dompm
            endif
          
            if nosignificance eq 0 then begin
                Nsig = n_elements(signal)
                ps_perm = fltarr(nf,nperm)
                for ip=0L, nperm-1 do begin
                    permutation = walsa_randperm(Nsig)
                    signalo=reform(originalcube[ix,iy,*]) 
                    y_perm = signalo(permutation)
                    if nodetrendapod eq 0 then $
                       y_perm=walsa_detrend_apod(y_perm,apod,meandetrend,pxdetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original,cadence=cadence,/silent)
                    
				    ; Process each segment
					psd = FLTARR(window_size / 2 + 1)
				    for segment = 0L, num_segments-1 do begin
				        start_index = segment * step_size
				        end_index = start_index + window_size
				        if end_index gt nt then continue
				        ; Extract the segment and apply the window
				        segment_data = y_perm[start_index:end_index]*window
				        ; Compute the FFT
				        segment_fft = FFT(segment_data, wfft_size)
				        ; Compute power spectral density
				        segment_psd = (ABS(segment_fft))^2/(window_size*wfft_size)
				        psd = psd + segment_psd[0:window_size / 2]

					endfor
				    ; Normalize the averaged PSD
					psd = psd / num_segments
                    ps_perm[*,ip] = psd[1:nff-1]
                    if silent eq 0 then print,string(13b)+' >>> % Running Monte Carlo (significance test): ',(ip*100.)/(nperm-1),format='(a,f4.0,$)'
                endfor
                signif = walsa_confidencelevel(ps_perm, siglevel=siglevel, nf=nf)
                significance[ix,iy,*] = signif/frequencies[0] ; in DN^2/mHz
            endif
            averagedpower = averagedpower+reform(powermap[ix,iy,*])
        endfor
        if long(nx) gt 1 then $ 
           writeu,-1,string(format='(%"\r == FFT next row... ",i5,"/",i5)',ix,nx)
	endfor

    powermap = reform(powermap)
    frequencies = reform(frequencies)
    averagedpower = reform(averagedpower/float(nx)/float(ny))
    if nodominantfreq eq 0 then begin
        dominantfreq = reform(dominantfreq)
        dominantpower = reform(dominantpower)
    endif
    if nosignificance eq 0 then significance = reform(significance)
	
	return, powermap
end
;----------------------------------- FOURIER ----------------------------------
function getpowerFFT,cube,cadence,siglevel=siglevel,padding=padding,frequencies=frequencies,significance=significance,$
                     nperm=nperm,nosignificance=nosignificance,averagedpower=averagedpower,amplitude=amplitude,originalcube=originalcube,$
                     dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,apod=apod,silent=silent,$
                     nodetrendapod=nodetrendapod,pxdetrend=pxdetrend,meandetrend=meandetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original
  ; Fast Fourier Transform (FFT) power spectra
  
  if padding gt 1 then begin ; zero padding (optional): to increase frequency resolution
	  if silent eq 0 then begin
	      print, ' '
	      print, ' -- Zero Padding (oversampling factor: '+strtrim(padding,2)+') .....'
	      print, ' '
	  endif
      nx = n_elements(cube[*,0,0])
      ny = n_elements(cube[0,*,0])
      nt = n_elements(cube[0,0,*])        
      padded=fltarr(nx,ny,padding*nt)
      mid_point = ROUND((padding*nt)/2.)
      lower_point = mid_point-nt/2.
      upper_point = mid_point+nt/2.-1
      padded[*,*,mid_point-nt/2.:mid_point+nt/2.-1] = cube
      cube = padded
  endif
  sizecube=size(cube)
  nx=sizecube[1]
  ny=sizecube[2]
  nt=sizecube[3]
  
  frequencies = 1./(cadence*2)*findgen(nt/2+1)/(nt/2)
  nff=n_elements(frequencies)
  frequencies = frequencies[1:nff-1]
  frequencies = frequencies*1000. ; in mHz
  nf=n_elements(frequencies)
  powermap=fltarr(nx,ny,nf) ; FFT power spectra
  amplitude=complexarr(nx,ny,nf) ; FFT amplitudes
  if nosignificance eq 0 then significance=fltarr(nx,ny,nf) ; significance cube
  if nodominantfreq eq 0 then begin
      dominantfreq=fltarr(nx,ny) ; dominant-frequency map
      dominantpower=fltarr(nx,ny) ; dominant-power map (i.e., powers corresponding to dominant frequencies)
  endif
  averagedpower = fltarr(nf)
  for ix=0, nx-1 do begin
      for iy=0, ny-1 do begin
          signal = reform(cube[ix,iy,*])
          ; single-sided power is doubled (compared to double-sided power), assuming P(−f) = P(f):
          spec = (fft(signal,-1,/double))[0:nt/2.]
          pm = 2.*(ABS(spec)^2)
          powermap[ix,iy,*] = (pm[1:nff-1]*padding)/frequencies[0] ; in DN^2/mHz
          amplitude[ix,iy,*] = spec[1:nff-1]*padding
          
		  if nodominantfreq eq 0 then begin
              dominantfreq[ix,iy] = walsa_dominant_frequency(reform(powermap[ix,iy,*]),frequencies,rangefreq,dominantpower=dompm)
              dominantpower[ix,iy] = dompm
          endif
          
          if nosignificance eq 0 then begin
              Nsig = n_elements(signal)
              ps_perm = fltarr(nf,nperm)
              for ip=0L, nperm-1 do begin
                  permutation = walsa_randperm(Nsig)
                  signalo=reform(originalcube[ix,iy,*])
                  y_perm = signalo(permutation)
                  if nodetrendapod eq 0 then $
                     y_perm=walsa_detrend_apod(y_perm,apod,meandetrend,pxdetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original,cadence=cadence,/silent)
                  pstmp = 2.*(ABS((fft(y_perm,-1,/double))[0:nt/2.])^2.) 
                  ps_perm[*,ip] = pstmp[1:nff-1]
                  if silent eq 0 then print,string(13b)+' >>> % Running Monte Carlo (significance test): ',(ip*100.)/(nperm-1),format='(a,f4.0,$)'
              endfor
              signif = walsa_confidencelevel(ps_perm, siglevel=siglevel, nf=nf)
              significance[ix,iy,*] = (signif*padding)/frequencies[0] ; in DN^2/mHz
          endif
          averagedpower = averagedpower+reform(powermap[ix,iy,*])
      endfor
      if long(nx) gt 1 then $ 
         writeu,-1,string(format='(%"\r == FFT next row... ",i5,"/",i5)',ix,nx)
  endfor
  powermap = reform(powermap)
  frequencies = reform(frequencies)
  averagedpower = reform(averagedpower/float(nx)/float(ny))
  amplitude = reform(amplitude)
  if nodominantfreq eq 0 then begin
      dominantfreq = reform(dominantfreq)
      dominantpower = reform(dominantpower)
  endif
  if nosignificance eq 0 then significance = reform(significance)
  
  return, powermap
end
;------------------------------------ WAVELET ---------------------------------
function getpowerWAVELET,cube,cadence,dj=dj,mother=mother,siglevel=siglevel,global=global,frequencies=frequencies,$
                         significance=significance,coicube=coicube,oglobal=oglobal,colornoise=colornoise,param=param,$
                         padding=padding,nosignificance=nosignificance,averagedpower=averagedpower,psd=psd,$
                         dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,$
                         originalcube=originalcube,apod=apod,nodetrendapod=nodetrendapod,pxdetrend=pxdetrend,meandetrend=meandetrend,$
                         polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original, nperm=nperm, rgws=rgws, silent=silent
  ; Wavelet power spectra: either wavelet spectra, or global wavelet spectra (traditional or improved versions)
  
  input_data = cube ; to prevent the input data be modified by functions unintentionally
  
  if padding gt 1 then begin ; zero padding (optional): to increase frequency resolution
	  if silent eq 0 then begin
	      print, ' '
	      print, ' -- Zero Padding (oversampling factor: '+strtrim(padding,2)+') .....'
	      print, ' '
	  endif
      nx = n_elements(input_data[*,0,0])
      ny = n_elements(input_data[0,*,0])
      nt = n_elements(input_data[0,0,*])        
      padded=fltarr(nx,ny,padding*nt)
      mid_point = ROUND((padding*nt)/2.)
      lower_point = mid_point-nt/2.
      upper_point = mid_point+nt/2.-1
      padded[*,*,mid_point-nt/2.:mid_point+nt/2.-1] = input_data
      input_data = padded
  endif
  
  siglevel=1.0-siglevel ; different convention

  sizecube=size(input_data)
  nx=sizecube[1]
  ny=sizecube[2]
  nt=sizecube[3]
  col=reform(input_data[0,0,*])
  col = (col - TOTAL(col)/nt)
  ; lag1 = (A_CORRELATE(col,1) + SQRT(A_CORRELATE(col,2)))/2.
  ; Wavelet transform:
  wave = walsa_wavelet(reform(col),cadence,PERIOD=period,PAD=1,COI=coi,MOTHER=mother,/RECON,dj=dj,param=param,J=J,/nodetrendapod)
  
  frequencies = 1./period
  frequencies = frequencies*1000. ; in mHz
  
  nf = n_elements(frequencies)
  
  if (global+oglobal+rgws) gt 1 then begin
	  print
	  print, ' --- [!] Only one of the /global, /oglobal, or /rgws can be flagged at a time!'
	  print
	  stop
  endif
  
  if silent eq 0 then print, ' '
  if global eq 1 then begin
      if silent eq 0 then print, ' ...... global: output "Traditional" Global Wavelet Spectrum'
      ftcube=fltarr(nx,ny,nf)
  endif
  if oglobal eq 1 then begin
      if silent eq 0 then print, ' ...... oglobal: output Global Wavelet Spectrum excluding CoI regions'
      ftcube = fltarr(nx,ny,nf) ; power
  endif
  if rgws eq 1 then begin
      if silent eq 0 then print, ' ...... rgws: output rgws Wavelet Spectrum '
      if silent eq 0 then print, ' ...... (power-weighted significant frequency distribution, unaffected by CoI)'
      ftcube = fltarr(nx,ny,nf) ; power
  endif
  if global eq 0 and oglobal eq 0 and rgws eq 0 then begin
      if silent eq 0 then print, ' ...... output Wavelet Spectra '
      ftcube=fltarr(nx,ny,nt,nf)
  endif
  
  if silent eq 0 then begin
	  print, ' '
	  print, ' Wavelet (mother) function: '+mother
	  print, ' dj: '+strtrim(dj,2)
	  print, ' '
  endif
  
  iloop = 0
  numm = nx*float(ny)

  if nosignificance eq 0 then significance=fltarr(nx,ny,nf)
  if nodominantfreq eq 0 then begin
      dominantfreq=fltarr(nx,ny) ; dominant-frequency map
      dominantpower=fltarr(nx,ny) ; dominant-power map (i.e., powers corresponding to dominant frequencies)
  endif
  coicube = fltarr(nx,ny,nt)
  averagedpower = fltarr(nf)
  for ix=0, nx-1 do begin
      for iy=0, ny-1 do begin
        col=reform(input_data[ix,iy,*])
        col = (col - TOTAL(col)/nt)
		col_copy = col
        ; lag1 = (A_CORRELATE(col,1) + SQRT(A_CORRELATE(col,2)))/2.
        ; Wavelet transform:
        wave = walsa_wavelet(col_copy,cadence,PERIOD=period,PAD=1,COI=coi,MOTHER=mother,param=param,/RECON,dj=dj,scale=scale,$
                                                    SIGNIF=SIGNIF,SIGLVL=siglevel,/nodetrendapod,colornoise=colornoise,power=power)
		 
        if global eq 1 then begin
            global_ws = TOTAL(power,1,/nan)/nt  ; global wavelet spectrum (GWS)
            ftcube[ix,iy,*] = (reform(global_ws)*padding);/frequencies[nf-1]
            
            global_amp = TOTAL(wave,1,/nan)/nt
            
            if nodominantfreq eq 0 then begin
                dominantfreq[ix,iy] = walsa_dominant_frequency(reform(ftcube[ix,iy,*]),frequencies,rangefreq,dominantpower=dompm)
                dominantpower[ix,iy] = dompm
            endif
          
            ; GWS significance levels:
            if nosignificance eq 0 then begin
                dof = nt - scale   ; the -scale corrects for padding at edges
                global_signif = walsa_wave_signif(col,cadence,scale,1, LAG1=0.0,DOF=dof,MOTHER=mother,CDELTA=Cdelta,PSI0=psi0,siglvl=siglevel)
                significance[ix,iy,*] = (reform(global_signif)*padding);/frequencies[nf-1]
            endif
            averagedpower = averagedpower+reform(ftcube[ix,iy,*])
        endif
        
        if global eq 0 and oglobal eq 0 and rgws eq 0 then begin
            ftcube[ix,iy,*,*] = (reform(power)*padding); /frequencies[nf-1]
            if nosignificance eq 0 then significance[ix,iy,*] = (reform(SIGNIF)*padding); /frequencies[nf-1] ; in DN^2/mHz
            coicube[ix,iy,*] = reform(coi)
        endif
        
        ; oglobal: time-average wavelet power only over the areas not affected by CoI
        if oglobal eq 1 then begin
            opower = fltarr(nt,nf)+!VALUES.F_NAN
            for i=0L, nt-1 do begin
                pcol = reform(power[i,*])
                ii = where(reform(period) lt coi[i], pnum)
                if pnum gt 0 then opower(i,ii) = pcol(ii)
            endfor
            opower = mean(opower,dimension=1,/nan)
            ftcube[ix,iy,*] = (opower*padding); /frequencies[nf-1] ; in DN^2
            
            if nodominantfreq eq 0 then begin
                dominantfreq[ix,iy] = walsa_dominant_frequency(reform(ftcube[ix,iy,*]),frequencies,rangefreq,dominantpower=dompm)
                dominantpower[ix,iy] = dompm
            endif
            
            ; GWS significance levels:
            if nosignificance eq 0 then begin
                ; dof = nt - scale   ; the -scale corrects for padding at edges
                ; global_signif = walsa_wave_signif(col,cadence,scale,1, LAG1=0.0,DOF=dof,MOTHER=mother,CDELTA=Cdelta,PSI0=psi0,siglvl=siglevel)
                ; significance[ix,iy,*] = (reform(global_signif)*padding); /frequencies[nf-1] ; in DN^2
                Nsig = n_elements(col)
                ps_perm = fltarr(nf,nperm)
                for ip=0L, nperm-1 do begin
                    permutation = walsa_randperm(Nsig)
                    signalo=reform(originalcube[ix,iy,*]) 
                    y_perm = signalo(permutation)
                    if nodetrendapod eq 0 then $
                       y_perm=walsa_detrend_apod(y_perm,apod,meandetrend,pxdetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original,cadence=cadence,/silent)
                    
                    y_perm = (y_perm - TOTAL(y_perm)/nt)
                    wave = walsa_wavelet(y_perm,cadence,PERIOD=period,PAD=1,COI=coi,MOTHER=mother,param=param,/RECON,dj=dj,scale=scale,$
                                         /nodetrendapod,colornoise=colornoise,power=powertemp)

                    opower = fltarr(nt,nf)+!VALUES.F_NAN
                    for i=0L, nt-1 do begin
                        pcol = reform(powertemp[i,*])
                        ii = where(reform(period) lt coi[i], pnum)
                        if pnum gt 0 then opower(i,ii) = pcol(ii)
                    endfor
                    ps_perm = mean(opower,dimension=1,/nan) ; time average only over the areas not affected by CoI
                    if silent eq 0 then print,string(13b)+' >>> % Running Monte Carlo (significance): ',(ip*100.)/(nperm-1),format='(a,f4.0,$)'
                endfor
                signif = walsa_confidencelevel(ps_perm, siglevel=siglevel, nf=nf)
                significance[ix,iy,*] = (signif*padding); /frequencies[nf-1] ; in DN^2
            endif
            averagedpower = averagedpower+reform(ftcube[ix,iy,*])
        endif
        
        ; rgws: time-integral of wavelet power only over the areas not affected by CoI and only for those above the significance level.
        ; i.e., 'distribution' of significant frequencies (unaffected by CoI) weighted by power.
        if rgws eq 1 then begin
            isig = REBIN(TRANSPOSE(signif),nt,nf)
            istest = where(power/isig lt 1.0, numtest)
            if numtest gt 0 then power[istest]=!VALUES.F_NAN
            ipower = fltarr(nt,nf)+!VALUES.F_NAN
            for i=0L, nt-1 do begin
                pcol = reform(power[i,*])
                ii = where(reform(period) lt coi[i], pnum)
                if pnum gt 0 then ipower[i,ii] = pcol[ii]
            endfor
			;ipower = mean(ipower,dimension=1,/nan)
            ipower = total(ipower,1,/nan)
			
            ftcube[ix,iy,*] = (ipower*padding); /frequencies[nf-1] ; in DN^2
            
            if nodominantfreq eq 0 then begin
                dominantfreq[ix,iy] = walsa_dominant_frequency(reform(ftcube[ix,iy,*]),frequencies,rangefreq,dominantpower=dompm)
                dominantpower[ix,iy] = dompm
            endif
            averagedpower = averagedpower+reform(ftcube[ix,iy,*])
        endif
        
      endfor
      iloop = long(iloop+1.)
      if silent eq 0 then if nx gt 1 or ny gt 1 then print,string(13b)+' >>> % finished: ',(iloop*100.)/nx,format='(a,f4.0,$)'
  endfor
  
  powermap = reform(ftcube)
  frequencies = reform(frequencies)
  averagedpower = reform(averagedpower/float(nx)/float(ny))
  if nodominantfreq eq 0 then begin
      dominantfreq = reform(dominantfreq)
      dominantpower = reform(dominantpower)
  endif
  if nosignificance eq 0 then significance = reform(significance)
  coicube = reform(coicube)
  
  ; if (global+oglobal+rgws) gt 0 AND psd eq 1 then begin
  ; 	  ; Interpolate the power spectrum to a uniform frequency array (Wavelet's frequency resolution changes with frequency)
  ; 	  uniform_freqs = findgen(n_elements(frequencies)) * (max(frequencies) - min(frequencies)) / (n_elements(frequencies) - 1) + min(frequencies)
  ;
  ; 	  powermap = interpol(powermap, frequencies, uniform_freqs, /SPLINE)
  ;
  ; 	  frequencies = uniform_freqs
  ; 	  delta_freq = ABS(frequencies[1] - frequencies[0])
  ;
  ; 	  powermap = powermap / delta_freq
  ;
  ; 	  averagedpower = averagedpower / delta_freq
  ; 	  if nodominantfreq eq 0 then dominantpower = dominantpower / delta_freq
  ; 	  significance = significance / delta_freq
  ; endif
  
  return, powermap
end
;==================================================== MAIN ROUTINE ====================================================
function walsa_speclizer,data,time,$ ; main inputs
                        frequencies=frequencies, significance=significance, coicube=coicube, imf=imf, instantfreq=instantfreq,$ ; main (additional) outputs
                        averagedpower=averagedpower,amplitude=amplitude, period=period, $
                        fft=fft, lombscargle=lombscargle, wavelet=wavelet, hht=hht, welch=welch,$ ; type of analysis
                        padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
                        polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original, psd=psd,$
                        siglevel=siglevel, nperm=nperm, nosignificance=nosignificance,$ ; significance-level parameters
                        mother=mother, param=param, dj=dj, global=global, oglobal=oglobal, rgws=rgws, colornoise=colornoise,$ ; Wavelet parameters/options
                        stdlimit=stdlimit, nfilter=nfilter, emd=emd,$ ; HHT parameters/options
                        mode=mode, silent=silent, $
                        dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower, $ ; dominant frequency
						window_size=window_size, overlap=overlap, wfft_size=wfft_size ; Welch parameters

cube = reform(data)
sizecube = size(cube)
if sizecube[0] ne 3 then begin
    if sizecube[0] eq 1 then begin
        blablacube = fltarr(1,1,sizecube[1])
        blablacube[0,0,*] = cube
        cube = blablacube
    endif else begin
        print, ' '
        print, ' [!] The datacube must have either 1 or 3 dimension(s).'
        print, ' '
        stop
    endelse
endif

ii = where(~finite(cube),/null,cnull)
if cnull gt 0 then cube(ii) = median(cube)

cadence=walsa_mode(walsa_diff(time))
temporal_Nyquist = 1. / (cadence * 2.)

if n_elements(silent) eq 0 then silent=0

if silent eq 0 then begin
	print,' '
	if sizecube[0] eq 1 then print,'The input datacube is of size: ['+ARR2STR(sizecube[1],/trim)+']'
	if sizecube[0] eq 3 then $
	print,'The input datacube is of size: ['+ARR2STR(sizecube[1],/trim)+', '+ARR2STR(sizecube[2],/trim)+', '+ARR2STR(sizecube[3],/trim)+']'
	print,' '
	print,'Temporally, the important values are:'
	print,'    2-element duration (Nyquist period) = '+ARR2STR((cadence * 2.),/trim)+' seconds'
	if sizecube[0] eq 1 then print,'    Time series duration = '+ARR2STR(cadence*sizecube[1],/trim)+' seconds'
	if sizecube[0] eq 3 then print,'    Time series duration = '+ARR2STR(cadence*sizecube[3],/trim)+' seconds'
	print,'    Nyquist frequency = '+ARR2STR(temporal_Nyquist*1000.,/trim)+' mHz'
	print, ' '
endif

if n_elements(global) eq 0 then global=0 ; if set, global wavelet will be returned; otherwsie wavelet 2D power spectra (default)
if n_elements(dj) eq 0 then dj=0.025

if n_elements(fft) eq 0 then fft=0
if n_elements(psd) eq 0 then psd=0
if n_elements(lombscargle) eq 0 then lombscargle=0
if n_elements(hht) eq 0 then hht=0
if n_elements(welch) eq 0 then welch=0
if n_elements(wavelet) eq 0 then wavelet=0
if n_elements(nosignificance) eq 0 then nosignificance=0
if n_elements(nodominantfreq) eq 0 then nodominantfreq=0

if n_elements(siglevel) eq 0 then siglevel=0.05 ; 5% significance level = 95% confidence level
if n_elements(nperm) eq 0 then nperm=1000
if n_elements(oglobal) eq 0 then oglobal=0
if n_elements(rgws) eq 0 then rgws=0

if n_elements(padding) eq 0 then padding=1
if n_elements(stdlimit) eq 0 then stdlimit=0.2
if n_elements(nfilter) eq 0 then nfilter=3
if n_elements(emd) eq 0 then emd=0
if n_elements(colornoise) eq 0 then colornoise=0 ; if set, noise background based on Auchère et al. 2017, ApJ, 838, 166 / 2016, ApJ, 825, 110

if n_elements(mode) eq 0 then mode=1

if n_elements(apod) eq 0 then apod=0.1 ; width of Tukey window (for apodization)
if n_elements(nodetrendapod) eq 0 then nodetrendapod=0 ; detrend the signal and apodize it
if n_elements(pxdetrend) eq 0 then pxdetrend=2 ; do proper linear detrending
if n_elements(meandetrend) eq 0 then meandetrend=0 ; no spatial detrending
if n_elements(mother) eq 0 then mother='Morlet' ; possible functions: 'Morlet', 'DOG', 'Paul'

if n_elements(NFFT) eq 0 then NFFT=256

; detrend and apodize the cube
if nodetrendapod eq 0 then begin
    apocube=walsa_detrend_apod(cube,apod,meandetrend,pxdetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,cadence=cadence,resample_original=resample_original,silent=silent) 
endif else apocube=cube

sizecube = size(apocube)
if sizecube[0] ne 3 then begin
    if sizecube[0] eq 1 then begin
        blablacube = fltarr(1,1,sizecube[1])
        blablacube[0,0,*] = apocube
        apocube = blablacube
    endif
endif

if fft then begin
	if silent eq 0 then begin
	    print, ' '
	    print, ' -- Perform FFT (Fast Fourier Transform) .....'
	    print, ' '
	endif
    power=getpowerFFT(apocube,cadence,siglevel=siglevel,padding=padding,frequencies=frequencies,significance=significance,averagedpower=averagedpower,$
        nperm=nperm,nosignificance=nosignificance,dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,$
        amplitude=amplitude,originalcube=cube,apod=apod,nodetrendapod=nodetrendapod,pxdetrend=pxdetrend,meandetrend=meandetrend,polyfit=polyfit,$
        meantemporal=meantemporal,recon=recon,resample_original=resample_original,silent=silent)
endif

if lombscargle then begin
	if silent eq 0 then begin
	    print, ' '
	    print, ' -- Perform Lomb-Scargle Transform .....'
	    print, ' '
	endif
    power=getpowerLS(apocube,time,OFAC=padding,siglevel=siglevel,frequencies=frequencies,significance=significance,averagedpower=averagedpower,amplitude=amplitude,$
        nperm=nperm,nosignificance=nosignificance,dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,originalcube=cube,$
        apod=apod,nodetrendapod=nodetrendapod,pxdetrend=pxdetrend,meandetrend=meandetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original,silent=silent)
endif

if welch then begin
	if silent eq 0 then begin
	    print, ' '
	    print, ' -- Perform Welch method .....'
	    print, ' '
	endif
    power=welch_psd(apocube, cadence, frequencies=frequencies, window_size=window_size, overlap=overlap, wfft_size=wfft_size, significance=significance,$
                     nperm=nperm,nosignificance=nosignificance,averagedpower=averagedpower, originalcube=cube,siglevel=siglevel,$
                     dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,apod=apod,silent=silent,$
                     nodetrendapod=nodetrendapod,pxdetrend=pxdetrend,meandetrend=meandetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original)
endif


if wavelet then begin
	if silent eq 0 then begin
	    print, ' '
	    print, ' -- Perform Wavelet Transform .....'
	    print, ' '
	endif
    power=getpowerWAVELET(apocube,cadence,dj=dj,mother=mother,siglevel=siglevel,global=global,frequencies=frequencies,averagedpower=averagedpower,rgws=rgws,$
        significance=significance,coicube=coicube,oglobal=oglobal,colornoise=colornoise,padding=padding,nosignificance=nosignificance,originalcube=cube,$
        dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,param=param,nperm=nperm,psd=psd,$
        apod=apod,nodetrendapod=nodetrendapod,pxdetrend=pxdetrend,meandetrend=meandetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,resample_original=resample_original,silent=silent)
endif

if hht then begin
	if silent eq 0 then begin
	    print, ' '
	    print, ' -- Perform HHT (Hilbert-Huang Transform) .....'
	    print, ' '
	endif
    power=getpowerHHT(apocube,cadence,stdlimit,nfilter=nfilter,significance=significance,siglevel=siglevel,nperm=nperm,originalcube=cube,$
        padding=padding,frequencies=frequencies,nosignificance=nosignificance,emd=emd,imf=imf,instantfreq=instantfreq,amplitude=amplitude,$
        dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,averagedpower=averagedpower,$
        apod=apod,nodetrendapod=nodetrendapod,pxdetrend=pxdetrend,meandetrend=meandetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,$
        resample_original=resample_original,silent=silent)
endif

period = 1000./frequencies

sizecube=size(power)
dim=sizecube[0]
nx=sizecube[1]
ny=sizecube[2]

if dim le 2 then begin ; wavelet power spectrum
    if (mode eq 0) then begin
        power=alog10(power)
        if nosignificance eq 0 then significance=alog10(significance)
    endif
    if (mode eq 2) then begin
        power=sqrt(power)
        if nosignificance eq 0 then significance=sqrt(significance)
    endif
endif

if dim eq 3 then begin ; power spectra at multiple pixels
    nf=sizecube[3]
    if (mode eq 0) then begin 
        for jnn=0L, nf-1 do power[*,*,jnn]=alog10(power[*,*,jnn])
        if nosignificance eq 0 then for jnn=0L, nf-1 do significance[*,*,jnn]=alog10(significance[*,*,jnn])
    endif
    if (mode eq 2) then begin
        for jnn=0L, nf-1 do power[*,*,jnn]=sqrt(power[*,*,jnn])
        if nosignificance eq 0 then for jnn=0L, nf-1 do significance[*,*,jnn]=sqrt(significance[*,*,jnn])
    endif
endif

if dim eq 4 then begin ; wavelet power spectra at multiple pixels
    if (mode eq 0) then begin
        for jx=0L, nx-1 do for jy=0L, ny-1 do power[jx,jy,*,*]=alog10(power[jx,jy,*,*])
        if nosignificance eq 0 then for jx=0L, nx-1 do for jy=0L, ny-1 do significance[jx,jy,*,*]=alog10(significance[jx,jy,*,*])
    endif
    if (mode eq 2) then begin
        for jx=0L, nx-1 do for jy=0L, ny-1 do power[jx,jy,*,*]=sqrt(power[jx,jy,*,*])
        if nosignificance eq 0 then for jx=0L, nx-1 do for jy=0L, ny-1 do significance[jx,jy,*,*]=sqrt(significance[jx,jy,*,*])
    endif
endif

if silent eq 0 then begin
	PRINT
	if (mode eq 0) then print,' mode = 0: log(power)'
	if (mode eq 1) then print,' mode = 1: linear power' 
	if (mode eq 2) then print,' mode = 2: sqrt(power)'

	print, ''
	print, 'COMPLETED!'
	print,''
endif

return, power
end